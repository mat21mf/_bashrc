#!/usr/bin/env python3
"""
rename_timestamp.py - copy (or rename) a file to <base>_<YYYYMMDD_HHMMSS>.<ext>,
using the file's own last-modification time, not the time the script runs.

Usage:
  ./rename_timestamp.py FILE [BASE_NAME] [--move]

Examples:
  ./rename_timestamp.py cmorization-duties.pptx
      -> cmorization-duties_20260715_142033.pptx   (mtime-based, copy)

  ./rename_timestamp.py draft7.pptx cmorization-duties
      -> cmorization-duties_20260715_142033.pptx

  ./rename_timestamp.py meeting.eml --move
      -> meeting_20260715_142033.eml   (renamed in place, no extra copy)

Notes:
  - Default mode is COPY: source file is left untouched, a new stamped copy
    is created next to it (metadata, including mtime, is preserved on the copy).
  - --move renames in place instead. Useful when you don't want file
    proliferation - e.g. an .eml you convert to .md: timestamp the .md via
    copy, but --move the .eml instead of leaving a duplicate behind.
  - The timestamp is read from the file's mtime (os.stat().st_mtime), so as
    long as you transfer files in ways that preserve timestamps (cp -p,
    rsync -t, scp -p, most "Save As" flows do NOT preserve it, only true
    copies do), the label reflects when the content actually last changed,
    not when you happened to run this tool.
  - Seconds-level precision. If the same file (same mtime) is stamped twice,
    the destination name would collide - the script refuses to overwrite in
    that case rather than silently clobbering, since an identical mtime means
    nothing about the file's content timestamp actually changed.
  - Any existing timestamp suffix on the source filename (current
    "_YYYYMMDD_HHMMSS" form, or the older "_YYYYMMDD-HHMM"/"_YYYYMMDD-HHMMSS"
    hyphen form) is stripped before the new one is added, so re-runs don't
    stack suffixes on top of each other.
  - If stripping the old suffix and re-adding the current mtime-based one
    would produce the exact filename the file already has, nothing is
    written/renamed - the script just reports that the file is already
    correctly stamped. This is the common "ran it twice by habit" case.
  - --no-exec strips the executable bits from the destination after a copy
    (mode is otherwise unchanged: still preserved by copy2, this just
    clears u+x/g+x/o+x afterwards). Meant for stamping backups of scripts
    that live in a PATH directory (e.g. ~/.local/bin) - an executable
    backup sitting there is a stray, runnable near-duplicate of the real
    command. Has no effect in --move mode (the file keeps whatever
    permissions it already had; there's no duplicate to worry about).
"""

import argparse
import re
import shutil
import stat
import sys
from datetime import datetime
from pathlib import Path

# Matches the current stamp format (_YYYYMMDD_HHMMSS) as well as the older
# hyphen-separated formats this script used to produce (_YYYYMMDD-HHMM and
# _YYYYMMDD-HHMMSS), so old stamps get replaced rather than stacked on.
TIMESTAMP_RE = re.compile(r"_\d{8}[-_]\d{4,6}$")


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
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print what would happen without copying/renaming anything",
    )
    parser.add_argument(
        "--no-exec",
        action="store_true",
        help="Strip executable bits from the copy (ignored with --move)",
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

    if dest == src:
        # The name the file would be given is the name it already has: same
        # base, and the timestamp already in the filename matches the
        # timestamp derived from the file's current mtime. Nothing changed
        # since it was last stamped, so there's nothing to do.
        print(f"Already stamped with current mtime ({ts}) - no new file needed: {src}")
        return 0

    if dest.exists():
        print(f"Refusing to overwrite existing file: {dest}", file=sys.stderr)
        print("(a different file already sits at that stamped name)", file=sys.stderr)
        return 1

    verb = "Would rename" if args.dry_run else "Renamed"
    if args.move:
        if not args.dry_run:
            src.rename(dest)
        print(f"{verb} to: {dest}")
    else:
        verb = "Would copy" if args.dry_run else "Copied"
        if not args.dry_run:
            shutil.copy2(src, dest)
            if args.no_exec:
                mode = dest.stat().st_mode
                dest.chmod(mode & ~(stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH))
        print(f"{verb} to: {dest}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
