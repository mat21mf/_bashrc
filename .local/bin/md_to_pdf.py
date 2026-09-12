#!/usr/bin/env python3
"""
md_to_pdf.py - convert a Markdown file to PDF using headless Chromium, aiming
for parity with (or better than) VS Code's "Markdown PDF" extension
(yzane.markdown-pdf), which does the same thing via Node/puppeteer-core.

Usage:
  ./md_to_pdf.py FILE.md [OUTPUT.pdf]

Examples:
  ./md_to_pdf.py notes.md
      -> notes.pdf, A4, VS Code-like light theme, header (filename + date)
         and footer (page N / total) - all matching the extension's defaults.

  ./md_to_pdf.py notes.md report.pdf --theme dark --highlight-style monokai
      -> report.pdf, dark theme, dark-friendly Pygments code highlighting.

  ./md_to_pdf.py notes.md --no-header-footer --format letter
      -> plain letter-size PDF, no header/footer bar.

  ./md_to_pdf.py notes.md --css custom.css --no-highlight
      -> fully custom stylesheet, no syntax highlighting CSS injected.

Requirements:
  pip install markdown pymdown-extensions pygments selenium webdriver-manager
  A Chrome/Chromium binary installed on the machine. The script looks for
  common binary names on PATH (google-chrome, chromium, etc.) and lets
  Selenium fall back to its own discovery if none are found; override with
  --chrome-binary if it still picks the wrong one.

What this replicates from the extension, and how:
  - Page format/margins: A4 by default, margins 1.5cm top / 1cm the other
    three sides - the extension's own defaults (`markdown-pdf.format`,
    `markdown-pdf.margin.*` in its package.json).
  - Header/footer: filename top-left, ISO date top-right, "page / total"
    bottom-center - same layout as the extension's default headerTemplate/
    footerTemplate. This needs Chrome's raw DevTools command
    (`Page.printToPDF` via `driver.execute_cdp_cmd`), NOT Selenium's
    higher-level `print_page()`/`PrintOptions` API, which has no
    header/footer support at all - an easy trap since print_page() looks
    like it should cover everything.
  - Syntax highlighting: Pygments (via `pymdownx.superfences` +
    `pymdownx.highlight`) instead of the extension's highlight.js. Visually
    similar but not pixel-identical; pick a theme with --highlight-style
    (any Pygments style name - see `pygmentize -L styles`).
  - GFM-ish extras the extension turns on by default: task-list checkboxes,
    strikethrough (`~~text~~`), emoji (`:tada:`), bare-URL autolinking -
    via `pymdown-extensions`, which covers this ground for Python-Markdown
    much like the extension's own `sanitize: gfm` + `emoji: true` do.
  - Manual page breaks: same trick as the extension - drop a raw
    `<div class="page"></div>` in the Markdown source; both built-in
    themes below style `.page { page-break-after: always; }`.

Deliberately NOT replicated (out of scope for this pass - flag if wanted):
  KaTeX math, Mermaid diagrams, PlantUML diagrams. All three are things the
  extension renders by embedding extra JS/services in the page; feasible
  to add later (Chrome here also executes JS) but skipped for now to keep
  the dependency list and render time down.

Notes:
  - CDP's Page.printToPDF takes paper size and margins in INCHES, unlike
    Selenium's own PrintOptions class (cm) - this script does the cm-to-inch
    conversion internally so every user-facing flag stays in cm.
  - The intermediate HTML is written next to the output PDF and removed
    afterwards unless --keep-html is given.
"""

import argparse
import base64
import html
import shutil
import sys
from datetime import date
from pathlib import Path
from typing import Optional

import markdown
from pygments.formatters import HtmlFormatter

CM_PER_INCH = 2.54

# Paper sizes in inches (portrait: width, height). Matches the extension's
# `markdown-pdf.format` choices closely enough for everyday use.
PAPER_SIZES_IN = {
    "a4": (8.27, 11.69),
    "letter": (8.5, 11.0),
    "legal": (8.5, 14.0),
    "a3": (11.69, 16.54),
}

VSCODE_LIGHT_CSS = """
body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe WPC", "Segoe UI",
        HelveticaNeue-Light, Ubuntu, "Droid Sans", sans-serif;
    font-size: 14px;
    line-height: 1.6;
    padding: 0 12px;
    color: #333;
}
h1, h2, h3, h4, h5, h6 {
    font-weight: 600;
    border-bottom: 1px solid #eaecef;
    padding-bottom: 0.3em;
}
code {
    font-family: Consolas, "Courier New", monospace;
    font-size: 14px;
    background-color: rgba(220, 220, 220, 0.5);
    padding: 0.2rem 0.4rem;
    border-radius: 3px;
}
pre {
    background-color: #f8f8f8;
    border: 1px solid #cccccc;
    border-radius: 3px;
    overflow-x: auto;
}
pre code, .highlight pre {
    background-color: transparent;
    display: block;
    padding: 1rem;
    border: none;
}
blockquote {
    background: rgba(127, 127, 127, 0.1);
    border-left: 4px solid rgba(0, 122, 204, 0.5);
    color: #6a737d;
    padding: 0.2rem 1rem;
    margin-left: 0;
}
table {
    border-collapse: collapse;
    width: 100%;
    margin-bottom: 1rem;
}
table th, table td {
    border: 1px solid #dfe2e5;
    padding: 6px 13px;
}
table tr:nth-child(2n) {
    background-color: #f6f8fa;
}
a {
    color: #0366d6;
}
.task-list-item input[type="checkbox"] {
    margin-right: 0.4em;
}
img.emoji {
    height: 1.2em;
    width: 1.2em;
    vertical-align: -0.2em;
}
.page {
    page-break-after: always;
}
"""

VSCODE_DARK_CSS = """
body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe WPC", "Segoe UI",
        HelveticaNeue-Light, Ubuntu, "Droid Sans", sans-serif;
    font-size: 14px;
    line-height: 1.6;
    padding: 0 12px;
    color: #cccccc;
    background-color: #1e1e1e;
}
h1, h2, h3, h4, h5, h6 {
    font-weight: 600;
    color: #ffffff;
    border-bottom: 1px solid #3c3c3c;
    padding-bottom: 0.3em;
}
code {
    font-family: Consolas, "Courier New", monospace;
    font-size: 14px;
    background-color: rgba(255, 255, 255, 0.1);
    padding: 0.2rem 0.4rem;
    border-radius: 3px;
}
pre {
    background-color: #2d2d2d;
    border: 1px solid #3c3c3c;
    border-radius: 3px;
    overflow-x: auto;
}
pre code, .highlight pre {
    background-color: transparent;
    display: block;
    padding: 1rem;
    border: none;
}
blockquote {
    background: rgba(255, 255, 255, 0.05);
    border-left: 4px solid #3c3c3c;
    color: #9d9d9d;
    padding: 0.2rem 1rem;
    margin-left: 0;
}
table {
    border-collapse: collapse;
    width: 100%;
    margin-bottom: 1rem;
}
table th, table td {
    border: 1px solid #3c3c3c;
    padding: 6px 13px;
}
table tr:nth-child(2n) {
    background-color: #2a2a2a;
}
a {
    color: #3794ff;
}
.task-list-item input[type="checkbox"] {
    margin-right: 0.4em;
}
img.emoji {
    height: 1.2em;
    width: 1.2em;
    vertical-align: -0.2em;
}
.page {
    page-break-after: always;
}
"""

CHROME_BINARY_CANDIDATES = [
    "google-chrome",
    "google-chrome-stable",
    "chromium-browser",
    "chromium",
    "chrome",
]

MD_EXTENSIONS = [
    "tables",
    "toc",
    "attr_list",
    "sane_lists",
    "footnotes",
    "def_list",
    "abbr",
    "pymdownx.superfences",
    "pymdownx.highlight",
    "pymdownx.tasklist",
    "pymdownx.tilde",
    "pymdownx.magiclink",
    "pymdownx.emoji",
]

MD_EXTENSION_CONFIGS = {
    "pymdownx.highlight": {"css_class": "highlight", "guess_lang": False},
    "pymdownx.tasklist": {"custom_checkbox": True},
    "pymdownx.emoji": {"options": {"classes": "emoji"}},
}

# Same layout as the extension's default headerTemplate/footerTemplate:
# title top-left, date top-right, "page / total" bottom-center. 'title' and
# 'pageNumber'/'totalPages' are special classes Chrome auto-fills at print
# time; the date is substituted here so it's a fixed ISO string rather than
# whatever locale format Chrome's own '.date' class would produce.
HEADER_TEMPLATE = (
    '<div style="font-size: 9px; margin-left: 1cm;">'
    '<span class="title"></span></div>'
    '<div style="font-size: 9px; margin-left: auto; margin-right: 1cm;">'
    "{date}</div>"
)
FOOTER_TEMPLATE = (
    '<div style="font-size: 9px; margin: 0 auto;">'
    '<span class="pageNumber"></span> / <span class="totalPages"></span></div>'
)


def find_chrome_binary(explicit: Optional[str] = None) -> Optional[str]:
    if explicit:
        return explicit
    for name in CHROME_BINARY_CANDIDATES:
        path = shutil.which(name)
        if path:
            return path
    return None  # let Selenium/webdriver-manager try their own discovery


def markdown_to_html(
    md_path: Path,
    css: str,
    title: str,
    highlight_style: Optional[str],
) -> str:
    md_content = md_path.read_text(encoding="utf-8")
    md = markdown.Markdown(
        extensions=MD_EXTENSIONS, extension_configs=MD_EXTENSION_CONFIGS
    )
    html_body = md.convert(md_content)

    highlight_css = ""
    if highlight_style:
        highlight_css = HtmlFormatter(style=highlight_style).get_style_defs(
            ".highlight"
        )

    return (
        "<!DOCTYPE html>\n"
        "<html>\n<head>\n"
        '<meta charset="utf-8">\n'
        f"<title>{html.escape(title)}</title>\n"
        f"<style>{css}\n{highlight_css}</style>\n"
        "</head>\n<body>\n"
        f"{html_body}\n"
        "</body>\n</html>\n"
    )


def render_pdf(
    html_path: Path,
    pdf_path: Path,
    chrome_binary: Optional[str],
    paper_format: str,
    landscape: bool,
    margins_cm: "tuple[float, float, float, float]",
    no_background: bool,
    header_footer: bool,
    scale: float,
) -> None:
    from selenium import webdriver
    from selenium.webdriver.chrome.options import Options
    from selenium.webdriver.chrome.service import Service
    from webdriver_manager.chrome import ChromeDriverManager

    options = Options()
    options.add_argument("--headless=new")
    options.add_argument("--disable-gpu")
    options.add_argument("--no-sandbox")
    if chrome_binary:
        options.binary_location = chrome_binary

    service = Service(ChromeDriverManager().install())
    driver = webdriver.Chrome(service=service, options=options)
    try:
        driver.get(html_path.resolve().as_uri())

        width_in, height_in = PAPER_SIZES_IN[paper_format]
        if landscape:
            width_in, height_in = height_in, width_in
        margin_top, margin_bottom, margin_left, margin_right = (
            m / CM_PER_INCH for m in margins_cm
        )

        params = {
            "landscape": landscape,
            "printBackground": not no_background,
            "preferCSSPageSize": False,
            "paperWidth": width_in,
            "paperHeight": height_in,
            "marginTop": margin_top,
            "marginBottom": margin_bottom,
            "marginLeft": margin_left,
            "marginRight": margin_right,
            "scale": scale,
            "displayHeaderFooter": header_footer,
        }
        if header_footer:
            params["headerTemplate"] = HEADER_TEMPLATE.format(
                date=date.today().isoformat()
            )
            params["footerTemplate"] = FOOTER_TEMPLATE

        result = driver.execute_cdp_cmd("Page.printToPDF", params)
        pdf_path.write_bytes(base64.b64decode(result["data"]))
    finally:
        driver.quit()


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Convert Markdown to PDF via headless Chromium "
        "(VS Code Markdown PDF equivalent)."
    )
    parser.add_argument("file", type=Path, help="Source Markdown file")
    parser.add_argument(
        "output",
        nargs="?",
        type=Path,
        default=None,
        help="Output PDF path (default: same basename as input, .pdf extension)",
    )
    parser.add_argument(
        "--theme",
        choices=["light", "dark"],
        default="light",
        help="Built-in VS Code-like theme (default: light)",
    )
    parser.add_argument(
        "--css",
        type=Path,
        default=None,
        help="Path to a custom CSS file, overrides --theme entirely",
    )
    parser.add_argument(
        "--format",
        choices=sorted(PAPER_SIZES_IN),
        default="a4",
        help="Paper size (default: a4, matching the extension's default)",
    )
    parser.add_argument(
        "--landscape", action="store_true", help="Landscape page orientation"
    )
    parser.add_argument(
        "--margin-cm",
        type=float,
        default=None,
        help="Set all four margins (cm) at once; overridden by the "
        "individual --margin-* flags below",
    )
    parser.add_argument("--margin-top-cm", type=float, default=None)
    parser.add_argument("--margin-bottom-cm", type=float, default=None)
    parser.add_argument("--margin-left-cm", type=float, default=None)
    parser.add_argument("--margin-right-cm", type=float, default=None)
    parser.add_argument(
        "--no-background",
        action="store_true",
        help="Don't print background colors (e.g. code block shading)",
    )
    parser.add_argument(
        "--no-header-footer",
        action="store_true",
        help="Disable the filename/date header and page-number footer "
        "(on by default, matching the extension)",
    )
    parser.add_argument(
        "--scale", type=float, default=1.0, help="Print scale factor (default: 1.0)"
    )
    parser.add_argument(
        "--highlight-style",
        default=None,
        help="Pygments style name for code highlighting "
        "(default: 'default' for --theme light, 'monokai' for --theme dark)",
    )
    parser.add_argument(
        "--no-highlight",
        action="store_true",
        help="Don't inject Pygments CSS (code still gets basic <pre>/<code> styling)",
    )
    parser.add_argument(
        "--chrome-binary", default=None, help="Explicit path to a Chrome/Chromium binary"
    )
    parser.add_argument(
        "--keep-html",
        action="store_true",
        help="Keep the intermediate HTML file next to the output PDF",
    )
    args = parser.parse_args()

    if not args.file.is_file():
        print(f"File not found: {args.file}", file=sys.stderr)
        return 1

    pdf_path = args.output if args.output else args.file.with_suffix(".pdf")

    if args.css:
        if not args.css.is_file():
            print(f"CSS file not found: {args.css}", file=sys.stderr)
            return 1
        css = args.css.read_text(encoding="utf-8")
    else:
        css = VSCODE_DARK_CSS if args.theme == "dark" else VSCODE_LIGHT_CSS

    highlight_style = None
    if not args.no_highlight:
        highlight_style = args.highlight_style or (
            "monokai" if args.theme == "dark" else "default"
        )

    html_content = markdown_to_html(args.file, css, title=args.file.stem, highlight_style=highlight_style)
    html_path = pdf_path.with_suffix(".html")
    html_path.write_text(html_content, encoding="utf-8")

    chrome_binary = find_chrome_binary(args.chrome_binary)

    margin_top = args.margin_top_cm if args.margin_top_cm is not None else (args.margin_cm if args.margin_cm is not None else 1.5)
    margin_bottom = args.margin_bottom_cm if args.margin_bottom_cm is not None else (args.margin_cm if args.margin_cm is not None else 1.0)
    margin_left = args.margin_left_cm if args.margin_left_cm is not None else (args.margin_cm if args.margin_cm is not None else 1.0)
    margin_right = args.margin_right_cm if args.margin_right_cm is not None else (args.margin_cm if args.margin_cm is not None else 1.0)

    try:
        render_pdf(
            html_path,
            pdf_path,
            chrome_binary,
            args.format,
            args.landscape,
            (margin_top, margin_bottom, margin_left, margin_right),
            args.no_background,
            not args.no_header_footer,
            args.scale,
        )
    except ImportError as exc:
        print(f"Missing dependency: {exc}", file=sys.stderr)
        print(
            "Install with: pip install markdown pymdown-extensions pygments "
            "selenium webdriver-manager",
            file=sys.stderr,
        )
        return 1
    finally:
        if not args.keep_html and html_path.exists():
            html_path.unlink()

    print(f"Wrote: {pdf_path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
