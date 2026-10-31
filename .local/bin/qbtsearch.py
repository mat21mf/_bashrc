#!/usr/bin/env python3
"""qbtsearch - compact console front-end for qBittorrent search plugins.

Runs qBittorrent's own nova2.py (same plugins as the Search tab), hides the
magnet links, filters names with a regex and prints a short table. Results
of the last search are cached so a link can be picked by its number later.

Works on Windows (py) and on WSL (python3 against the Windows nova3 dir).

Examples:
    qbtsearch.py ceram -c books -r 'ceram.*\\.epub$'
    qbtsearch.py ubuntu -e knaben -n 10
    qbtsearch.py -m 3              # print magnet of result 3 (last search)
    qbtsearch.py -m 3 | clip.exe   # copy it to the Windows clipboard
    qbtsearch.py -o 3              # open result 3 in qBittorrent

Environment:
    QBT_NOVA3   path to the nova3 directory (autodetected if unset)
"""

import argparse
import glob
import json
import os
import re
import shutil
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from urllib.parse import urlsplit

CACHE = os.path.join(os.path.expanduser("~"), ".cache", "qbtsearch", "last.json")
CATEGORIES = ["all", "anime", "books", "games", "movies", "music", "pictures", "software", "tv"]


def is_wsl():
    try:
        with open("/proc/version") as fh:
            return "microsoft" in fh.read().lower()
    except OSError:
        return False


def find_nova3():
    env = os.environ.get("QBT_NOVA3")
    if env:
        return env
    candidates = []
    if os.name == "nt":
        candidates.append(os.path.join(os.environ.get("LOCALAPPDATA", ""), "qBittorrent", "nova3"))
    else:
        data = os.environ.get("XDG_DATA_HOME", os.path.expanduser("~/.local/share"))
        candidates.append(os.path.join(data, "qBittorrent", "nova3"))
        if is_wsl():
            candidates += sorted(glob.glob("/mnt/c/Users/*/AppData/Local/qBittorrent/nova3"))
    for path in candidates:
        if os.path.isfile(os.path.join(path, "nova2.py")):
            return path
    sys.exit("qbtsearch: nova3 directory not found, set QBT_NOVA3")


def human(size):
    try:
        size = float(size)
    except ValueError:
        return "?"
    if size < 0:
        return "?"
    for unit in ("B", "KB", "MB", "GB", "TB"):
        if size < 1024 or unit == "TB":
            return "{0:.0f} {1}".format(size, unit) if unit == "B" else "{0:.1f} {1}".format(size, unit)
        size /= 1024.0


def to_int(value):
    try:
        return int(value)
    except ValueError:
        return -1


def btih(link):
    m = re.search(r"btih:([0-9a-zA-Z]+)", link)
    return m.group(1).lower() if m else None


def qbt_ini(nova3):
    """qBittorrent.ini that belongs to this nova3 dir (Local -> Roaming on Windows)."""
    root = os.path.dirname(os.path.dirname(os.path.abspath(nova3)))  # .../AppData/Local
    cands = [os.path.join(os.path.dirname(root), "Roaming", "qBittorrent", "qBittorrent.ini"),
             os.path.join(os.environ.get("APPDATA", ""), "qBittorrent", "qBittorrent.ini"),
             os.path.expanduser("~/.config/qBittorrent/qBittorrent.conf")]
    for path in cands:
        if os.path.isfile(path):
            return path
    return None


def disabled_engines(nova3):
    """Engines disabled in the GUI (SearchEngines/disabledEngines)."""
    path = qbt_ini(nova3)
    if not path:
        return set()
    section = None
    with open(path, encoding="utf-8", errors="replace") as fh:
        for line in fh:
            line = line.strip()
            if line.startswith("[") and line.endswith("]"):
                section = line[1:-1]
            elif section == "SearchEngines" and line.startswith("disabledEngines="):
                value = line.split("=", 1)[1]
                if value.startswith("@"):
                    return set()
                return {e.strip().strip('"') for e in value.split(",") if e.strip()}
    return set()


def nova_env():
    return dict(os.environ, PYTHONDONTWRITEBYTECODE="1", PYTHONIOENCODING="utf-8")


def list_engines(nova3, wanted):
    if wanted != "all":
        return [e.strip() for e in wanted.split(",") if e.strip()]
    out = subprocess.run([sys.executable, "nova2.py", "--capabilities", "--names"], cwd=nova3, env=nova_env(),
                         stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, timeout=60).stdout
    names = [e for e in out.decode("utf-8", "replace").strip().split(",") if e]
    off = disabled_engines(nova3)
    return [e for e in names if e not in off]


def run_engine(nova3, engine, category, query):
    try:
        proc = subprocess.run([sys.executable, "nova2.py", engine, category] + query, cwd=nova3,
                              env=nova_env(), stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                              timeout=120)
    except subprocess.TimeoutExpired:
        return engine, "", "timeout"
    return (engine, proc.stdout.decode("utf-8", "replace"),
            proc.stderr.decode("utf-8", "replace").strip())


def run_nova(nova3, engines, category, query, verbose):
    names = list_engines(nova3, engines)
    if not names:
        sys.exit("qbtsearch: no engines to run")
    with ThreadPoolExecutor(max_workers=len(names)) as pool:
        results = list(pool.map(lambda e: run_engine(nova3, e, category, query), names))
    rows, seen, failed = [], set(), []
    for engine, out, err in results:
        count = 0
        for line in out.splitlines():
            parts = line.split("|")
            if len(parts) < 6:
                continue
            count += 1
            link, name, size, seeds, leech, origin = parts[:6]
            key = btih(link) or link
            if key in seen:
                continue
            seen.add(key)
            rows.append({"link": link, "name": name, "size": size, "seeds": to_int(seeds),
                         "leech": to_int(leech), "engine": origin,
                         "desc": parts[6] if len(parts) > 6 else ""})
        if err:
            failed.append(engine)
        if verbose:
            print("[{0}] {1} results{2}".format(engine, count, (": " + err.splitlines()[-1]) if err else ""),
                  file=sys.stderr)
    if failed and not verbose:
        print("qbtsearch: errors in {0} (use -v)".format(", ".join(failed)), file=sys.stderr)
    return rows


def save(rows):
    os.makedirs(os.path.dirname(CACHE), exist_ok=True)
    with open(CACHE, "w", encoding="utf-8") as fh:
        json.dump(rows, fh)


def load():
    try:
        with open(CACHE, encoding="utf-8") as fh:
            return json.load(fh)
    except (OSError, ValueError):
        sys.exit("qbtsearch: no cached search, run a search first")


def pick(rows, number):
    if not 1 <= number <= len(rows):
        sys.exit("qbtsearch: result {0} out of range 1..{1}".format(number, len(rows)))
    return rows[number - 1]["link"]


def open_link(link):
    if os.name == "nt":
        os.startfile(link)
    elif is_wsl():
        # Start-Process hands the magnet to the Windows protocol handler.
        subprocess.run(["powershell.exe", "-NoProfile", "-Command",
                        "Start-Process '{0}'".format(link.replace("'", "''"))], check=False)
    elif shutil.which("xdg-open"):
        subprocess.run(["xdg-open", link], check=False)
    else:
        print(link)


def short_engine(label):
    """'Knaben Database(1337x)' -> '1337x', 'https://www.site.com/x' -> 'site.com'."""
    if "(" in label:
        label = label.split("(")[-1].rstrip(")")
    host = urlsplit(label).hostname if "://" in label else None
    if host:
        label = host[4:] if host.startswith("www.") else host
    return label


def show(rows, wide):
    width = shutil.get_terminal_size((120, 20)).columns
    name_w = max(20, width - 32) if not wide else 10000
    print("{0:>3} {1:>6} {2:>9}  {3}".format("#", "seeds", "size", "name [engine]"))
    for i, r in enumerate(rows, 1):
        engine = short_engine(r["engine"])
        label = "{0} [{1}]".format(r["name"], engine)
        if len(label) > name_w:
            label = label[:name_w - 3] + "..."
        print("{0:>3} {1:>6} {2:>9}  {3}".format(i, r["seeds"], human(r["size"]), label))


def main():
    ap = argparse.ArgumentParser(description="Compact qBittorrent plugin search.",
                                 formatter_class=argparse.RawDescriptionHelpFormatter,
                                 epilog=__doc__.split("Examples:")[1])
    ap.add_argument("query", nargs="*", help="search terms")
    ap.add_argument("-e", "--engines", default="all", help="engine(s), comma separated (default: all enabled in the GUI)")
    ap.add_argument("-c", "--category", default="all", choices=CATEGORIES)
    ap.add_argument("-r", "--regex", help="case-insensitive regex the name must match")
    ap.add_argument("-x", "--exclude", help="case-insensitive regex the name must NOT match")
    ap.add_argument("-s", "--min-seeds", type=int, default=0)
    ap.add_argument("-n", "--limit", type=int, default=30, help="max rows shown (0 = all)")
    ap.add_argument("-v", "--verbose", action="store_true", help="per-engine counts and errors")
    ap.add_argument("-w", "--wide", action="store_true", help="do not truncate names")
    ap.add_argument("-m", "--magnet", type=int, metavar="N", help="print link of result N")
    ap.add_argument("-o", "--open", type=int, metavar="N", help="open result N in qBittorrent")
    args = ap.parse_args()

    if args.query:
        rows = run_nova(find_nova3(), args.engines, args.category, args.query, args.verbose)
        if args.regex:
            rx = re.compile(args.regex, re.I)
            rows = [r for r in rows if rx.search(r["name"])]
        if args.exclude:
            rx = re.compile(args.exclude, re.I)
            rows = [r for r in rows if not rx.search(r["name"])]
        rows = [r for r in rows if r["seeds"] >= args.min_seeds]
        rows.sort(key=lambda r: r["seeds"], reverse=True)
        if args.limit:
            rows = rows[:args.limit]
        save(rows)
        if args.magnet is None and args.open is None:
            show(rows, args.wide)
            return
    elif args.magnet is None and args.open is None:
        ap.error("give search terms, or -m/-o N to use the last search")
    else:
        rows = load()

    if args.magnet is not None:
        print(pick(rows, args.magnet))
    if args.open is not None:
        open_link(pick(rows, args.open))


if __name__ == "__main__":
    main()
