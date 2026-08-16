#!/usr/bin/env python3
"""
rename_timestamp.py — copy (or rename) a file to <base>_<YYYYMMDD-HHMMSS>.<ext>,
using the file's own last-modification time, not the time the script runs.

Usage:
  ./rename_timestamp.py FILE [BASE_NAME] [--move]

Examples:
  ./rename_timestamp.py cmorization-duties.pptx
      -> cmorization-duties_20260715-142033.pptx   (mtime-based, copy)

  ./rename_timestamp.py draft7.pptx cmorization-duties
      -> cmorization-duties_20260715-142033.pptx

  ./rename_timestamp.py meeting.eml --move
      -> meeting_20260715-142033.eml   (renamed in place, no extra copy)

Notes:
  - Default mode is COPY: source file is left untouched, a new stamped copy
    is created next to it (metadata, including mtime, is preserved on the copy).
  - --move renames in place instead. Useful when you don't want file
    proliferation — e.g. an .eml you convert to .md: timestamp the .md via
    copy, but --move the .eml instead of leaving a duplicate behind.
  - The timestamp is read from the file's mtime (os.stat().st_mtime), so as
    long as you transfer files in ways that preserve timestamps (cp -p,
    rsync -t, scp -p, most "Save As" flows do NOT preserve it, only true
    copies do), the label reflects when the content actually last changed,
    not when you happened to run this tool.
  - Seconds-level precision. If the same file (same mtime) is stamped twice,
    the destination name would collide — the script refuses to overwrite in
    that case rather than silently clobbering, since an identical mtime means
    nothing about the file's content timestamp actually changed.
  - Any existing timestamp suffix (old 4-digit-minute or 6-digit-second form)
    on the source filename is stripped first, so re-runs don't stack suffixes.
"""

import argparse
import re
import shutil
import sys
from datetime import datetime
from pathlib import Path

TIMESTAMP_RE = re.compile(r"_\d{8}-\d{4,6}$")


def strip_existing_timestamp(stem: str) -> str:
    return TIMESTAMP_RE.sub("", stem)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Copy or rename a file, stamped with its own last-modified time."
    )
    parser.add_argument("file", type=Path, help="Source file")
    parser.add_argument(
        "base_name",
        nargs="?",
        default=None,
        help="Override base name (default: source filename, minus extension, minus any existing timestamp)",
    )
    parser.add_argument(
        "--move",
        action="store_true",
        help="Rename in place instead of copying (default: copy, source left untouched)",
    )
    args = parser.parse_args()

    src: Path = args.file
    if not src.is_file():
        print(f"File not found: {src}", file=sys.stderr)
        return 1

    mtime = src.stat().st_mtime
    ts = datetime.fromtimestamp(mtime).strftime("%Y%m%d_%H%M%S")

    base = args.base_name if args.base_name else strip_existing_timestamp(src.stem)
    dest = src.with_name(f"{base}_{ts}{src.suffix}")

    if dest.exists():
        print(f"Refusing to overwrite existing file: {dest}", file=sys.stderr)
        print("(same mtime as an existing stamped copy — nothing to do)", file=sys.stderr)
        return 1

    if args.move:
        src.rename(dest)
        print(f"Renamed to: {dest}")
    else:
        shutil.copy2(src, dest)
        print(f"Copied to: {dest}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
