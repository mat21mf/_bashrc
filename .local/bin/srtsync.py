#!/usr/bin/env python3
"""
srtsync.py - Resync a subtitle file using another, correctly timed subtitle
file (any language) as the timing reference. Output is always UTF-8 with LF.

Sync is delegated to ffsubsync (constant offset + framerate ratio). This
wrapper adds: encoding fallback, line ending / BOM normalization, and a
before/after overlap score so you can tell at a glance whether it worked.

Requirements:
    pip install ffsubsync

Usage:
    srtsync.py REFERENCE.srt INPUT.srt [-o OUTPUT.srt]

Example:
    srtsync.py movie.en.srt movie.es.srt -o movie.es.synced.srt
"""
import argparse
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

TS = re.compile(r"(\d+):(\d+):(\d+)[,.](\d+)\s*-->\s*(\d+):(\d+):(\d+)[,.](\d+)")


def read_text(path):
    """Read a subtitle file trying common encodings; return normalized str."""
    raw = Path(path).read_bytes()
    for enc in ("utf-8-sig", "cp1252", "latin-1"):
        try:
            text = raw.decode(enc)
            break
        except UnicodeDecodeError:
            continue
    return text.replace("\r\n", "\n").replace("\r", "\n"), enc


def intervals(text):
    """Return a sorted list of (start, end) in seconds for every cue."""
    out = []
    for m in TS.finditer(text):
        g = [int(x) for x in m.groups()]
        s = g[0] * 3600 + g[1] * 60 + g[2] + g[3] / 1000
        e = g[4] * 3600 + g[5] * 60 + g[6] + g[7] / 1000
        if e > s:
            out.append((s, e))
    return sorted(out)


def overlap_score(ref, sub):
    """Fraction of total cue time in sub that overlaps cue time in ref."""
    total = sum(e - s for s, e in sub) or 1.0
    i = hit = 0
    for s, e in sub:
        while i < len(ref) and ref[i][1] <= s:
            i += 1
        j = i
        while j < len(ref) and ref[j][0] < e:
            hit += max(0.0, min(e, ref[j][1]) - max(s, ref[j][0]))
            j += 1
    return hit / total


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("reference", help="correctly timed subtitles (any language)")
    ap.add_argument("input", help="subtitles to resync")
    ap.add_argument("-o", "--output", help="output path (default: INPUT.synced.srt)")
    args = ap.parse_args()

    ffs = shutil.which("ffs") or shutil.which("ffsubsync")
    if not ffs:
        sys.exit("ffsubsync not found: pip install ffsubsync")

    out = Path(args.output) if args.output else Path(args.input).with_suffix(".synced.srt")

    ref_text, ref_enc = read_text(args.reference)
    in_text, in_enc = read_text(args.input)
    print(f"reference encoding: {ref_enc}, input encoding: {in_enc}")

    with tempfile.TemporaryDirectory() as td:
        ref_tmp = Path(td) / "ref.srt"
        in_tmp = Path(td) / "in.srt"
        out_tmp = Path(td) / "out.srt"
        ref_tmp.write_text(ref_text, encoding="utf-8")
        in_tmp.write_text(in_text, encoding="utf-8")
        cmd = [ffs, str(ref_tmp), "-i", str(in_tmp), "-o", str(out_tmp),
               "--encoding", "utf-8", "--reference-encoding", "utf-8",
               "--output-encoding", "utf-8"]
        res = subprocess.run(cmd, capture_output=True, text=True)
        log = res.stdout + res.stderr
        for line in log.splitlines():
            if "offset seconds" in line or "framerate scale" in line:
                print(line.split("INFO")[-1].split("ffsubsync")[0].strip())
        if res.returncode != 0 or not out_tmp.exists():
            sys.exit("ffsubsync failed:\n" + log)
        out_text, _ = read_text(out_tmp)

    out.write_text(out_text, encoding="utf-8", newline="\n")

    ref_iv = intervals(ref_text)
    before = overlap_score(ref_iv, intervals(in_text))
    after = overlap_score(ref_iv, intervals(out_text))
    print(f"overlap with reference: before {before:.0%}, after {after:.0%}")
    if after < 0.5:
        print("WARNING: low overlap, check the result manually "
              "(different cut or edition? try alass)", file=sys.stderr)
    print(f"written: {out}")


if __name__ == "__main__":
    main()
