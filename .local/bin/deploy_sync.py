#!/usr/bin/env python3
"""
deploy_sync.py - after pulling/committing changes in this repo, offer to
apply the files that changed recently to where they're actually deployed
on this machine.

This relies on the convention this repo already documents in its own
README ("cp -p -u .bashrc ~/.bashrc", etc.): a tracked file's path
relative to the repo root IS its intended path relative to the deploy
root (default $HOME). So .bashrc -> $HOME/.bashrc,
.local/bin/rename_timestamp.py -> $HOME/.local/bin/rename_timestamp.py,
and so on - no separate mapping config needed, the repo layout IS the map.

Usage:
  ./deploy_sync.py [--since REF] [--all] [--root PATH] [options]

Deploy root resolution (highest priority first): --root on the command
line, then a .deploysyncroot file at the repo root (single line, a path,
"~" is expanded - e.g. a vim-config repo whose real deploy root is
"~/.vim" rather than "$HOME"), then $HOME as the final default.

Modes (pick one, default is the first):
  (default)   Only files changed since the last time this tool completed a
              full pass in this repo. That pointer is stored locally in
              .git/deploy-sync-state (inside .git, so it's automatically
              untracked/machine-local, never pushed or pulled). First run
              with no state yet behaves like --all.
  --since REF Diff tracked files changed since REF (any commit/tag/branch)
              instead of the stored pointer.
  --all       Ignore stored state; diff every tracked file in the repo
              against its deployed counterpart. Useful on a brand new
              machine, or to force a full re-check.

Only git-tracked files are considered (git ls-files), and repo bookkeeping
files are skipped by default: README*, LICENSE*, CHANGELOG*, .gitattributes,
.gitignore, *.patch. Use --include-meta to consider them too, or drop a
.deploysyncignore file (one glob per line, matched against the path
relative to repo root) at the repo root for per-repo customization.

Options:
  --dry-run     List what would be reviewed, apply/prompt nothing, and
                don't move the stored state pointer
  -y, --yes     Apply every pending file without prompting
  --no-backup   Don't back up a deployed file before overwriting it
  --exclude PAT Extra glob to skip, repeatable

For each pending file you get a colored unified diff against the deployed
copy and a prompt:
  [y] apply this one   [n] skip it   [d] show diff again
  [a] apply this and everything remaining   [q] quit, nothing further applied

Before overwriting a file that's already deployed, its current content is
backed up in place. If rename_timestamp.py is available (next to this
script, or on PATH) it's used, so the backup follows the same
mtime-stamped naming convention already used elsewhere in this repo
(e.g. via RenombrarTimestamps); that's an opportunistic convenience, not a
hard dependency - if it's not available, a plain ".bak.<epoch>" copy is
made instead so a backup always happens unless --no-backup is passed.

The stored state pointer only advances to HEAD if the run reaches the end
without being stopped via [q]. Answering [n] to skip a file still lets the
pointer advance (skipping is a deliberate decision, not "come back later");
quitting does not, so a quit run re-offers everything again next time.
"""

import argparse
import filecmp
import shutil
import stat
import subprocess
import sys
import time
from fnmatch import fnmatch
from pathlib import Path

DEFAULT_META_EXCLUDES = [
    "README*", "LICENSE*", "CHANGELOG*",
    ".gitattributes", ".gitignore", ".deploysyncignore", "*.patch",
]


def run_git(repo_root: Path, *args: str) -> str:
    result = subprocess.run(
        ["git", "-C", str(repo_root), *args],
        capture_output=True, text=True,
    )
    if result.returncode != 0:
        print(f"git {' '.join(args)} failed: {result.stderr.strip()}", file=sys.stderr)
        sys.exit(1)
    return result.stdout


def find_repo_root(start: Path) -> Path:
    result = subprocess.run(
        ["git", "-C", str(start), "rev-parse", "--show-toplevel"],
        capture_output=True, text=True,
    )
    if result.returncode != 0:
        print(f"Not inside a git repo: {start}", file=sys.stderr)
        sys.exit(1)
    return Path(result.stdout.strip())


def state_path(repo_root: Path) -> Path:
    return repo_root / ".git" / "deploy-sync-state"


def read_state(repo_root: Path) -> str | None:
    p = state_path(repo_root)
    return p.read_text().strip() if p.is_file() else None


def write_state(repo_root: Path, sha: str) -> None:
    state_path(repo_root).write_text(sha + "\n")


def find_backup_tool(repo_root: Path) -> str | None:
    here = repo_root / ".local" / "bin" / "rename_timestamp.py"
    if here.is_file():
        return str(here)
    return shutil.which("rename_timestamp.py")


def backup_file(dest_file: Path, tool: str | None) -> str:
    if tool:
        result = subprocess.run(
            [sys.executable, tool, str(dest_file), "--no-exec"],
            capture_output=True, text=True,
        )
        if result.returncode == 0:
            return result.stdout.strip()
        return f"backup skipped ({result.stderr.strip() or result.stdout.strip()})"
    fallback = dest_file.with_name(f"{dest_file.name}.bak.{int(time.time())}")
    shutil.copy2(dest_file, fallback)
    # Plain fallback: strip exec bits too, for the same reason
    # rename_timestamp.py is asked to via --no-exec - a backup sitting in a
    # PATH directory (e.g. ~/.local/bin) shouldn't itself be runnable.
    mode = fallback.stat().st_mode
    fallback.chmod(mode & ~(stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH))
    return f"Backed up to: {fallback} (rename_timestamp.py not found, used plain fallback)"


def load_ignore_globs(repo_root: Path, include_meta: bool, extra: list[str]) -> list[str]:
    globs = [] if include_meta else list(DEFAULT_META_EXCLUDES)
    custom = repo_root / ".deploysyncignore"
    if custom.is_file():
        for line in custom.read_text().splitlines():
            line = line.strip()
            if line and not line.startswith("#"):
                globs.append(line)
    return globs + extra


def is_ignored(rel: str, globs: list[str]) -> bool:
    name = Path(rel).name
    return any(fnmatch(rel, g) or fnmatch(name, g) for g in globs)


def candidate_files(repo_root: Path, since_ref: str | None) -> list[str]:
    """Repo-relative paths (posix) of tracked files to consider."""
    if since_ref is None:
        out = run_git(repo_root, "ls-files")
    else:
        out = run_git(repo_root, "diff", "--name-only", "--diff-filter=ACMR", since_ref, "HEAD")
    return [line for line in out.splitlines() if line]


def show_diff(dest_path: Path, src_path: Path):
    if dest_path.exists():
        subprocess.run(["diff", "-u", "--color=always", str(dest_path), str(src_path)])
    else:
        print(f"(not currently deployed - would create {dest_path}, {src_path.stat().st_size} bytes)")


def apply_change(src_path: Path, dest_path: Path, tool: str | None, do_backup: bool):
    if dest_path.exists():
        if do_backup:
            print(f"    {backup_file(dest_path, tool)}")
        shutil.copy2(src_path, dest_path)
        print(f"  Applied (overwritten): {dest_path}")
    else:
        dest_path.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src_path, dest_path)
        print(f"  Applied (new): {dest_path}")


def prompt(rel: str, is_new: bool) -> str:
    label = "NEW" if is_new else "CHANGED"
    while True:
        choice = input(
            f"[{label}] {rel} -- apply? [y]es/[n]o/[d]iff/[a]ll remaining/[q]uit: "
        ).strip().lower()
        if choice in ("y", "n", "d", "a", "q", ""):
            return choice or "n"
        print("Please answer y, n, d, a, or q.")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Apply this repo's recently changed tracked files to where they're deployed on this machine."
    )
    parser.add_argument("--since", default=None, help="Diff since this ref instead of stored state")
    parser.add_argument("--all", action="store_true", help="Diff every tracked file, ignore stored state")
    parser.add_argument(
        "--root", default=None, type=Path,
        help="Deploy root. Default: this repo's .deploysyncroot file if present, else $HOME",
    )
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("-y", "--yes", action="store_true")
    parser.add_argument("--no-backup", action="store_true")
    parser.add_argument("--include-meta", action="store_true", help="Don't skip README/LICENSE/etc.")
    parser.add_argument("--exclude", action="append", default=[], help="Extra glob to skip, repeatable")
    args = parser.parse_args()

    repo_root = find_repo_root(Path.cwd())
    head = run_git(repo_root, "rev-parse", "HEAD").strip()

    if args.root is not None:
        dest_root = args.root.expanduser()
    else:
        root_file = repo_root / ".deploysyncroot"
        if root_file.is_file():
            dest_root = Path(root_file.read_text().strip()).expanduser()
        else:
            dest_root = Path.home()

    if args.all:
        since_ref = None
    elif args.since:
        since_ref = args.since
    else:
        since_ref = read_state(repo_root)  # None on first-ever run -> full scan

    rels = candidate_files(repo_root, since_ref)
    globs = load_ignore_globs(repo_root, args.include_meta, args.exclude)
    rels = [r for r in rels if not is_ignored(r, globs)]

    pending = []  # (rel, src_path, dest_path, is_new)
    up_to_date = 0
    for rel in sorted(rels):
        src_path = repo_root / rel
        if not src_path.is_file():
            continue  # deleted in a diff range, nothing to deploy
        dest_path = dest_root / rel
        if dest_path.exists() and filecmp.cmp(src_path, dest_path, shallow=False):
            up_to_date += 1
            continue
        pending.append((rel, src_path, dest_path, not dest_path.exists()))

    scope = "all tracked files" if since_ref is None else f"changes since {since_ref[:12]}"
    print(f"Repo: {repo_root}")
    print(f"Deploy root: {dest_root}")
    print(f"Scope: {scope}")
    print(f"  {len(pending)} pending, {up_to_date} already up to date\n")

    if not pending:
        print("Nothing to apply.")
        if not args.dry_run and not args.all:
            write_state(repo_root, head)
        return 0

    if args.dry_run:
        for rel, _src, _dest, is_new in pending:
            print(f"[{'NEW' if is_new else 'CHANGED'}] {rel}")
        print("\n(dry run - nothing applied, state not updated)")
        return 0

    tool = None if args.no_backup else find_backup_tool(repo_root)
    if not args.no_backup and tool is None:
        print("Note: rename_timestamp.py not found; using plain .bak.<epoch> backups instead.\n")

    apply_all = args.yes
    quit_early = False
    for rel, src_path, dest_path, is_new in pending:
        if not apply_all:
            show_diff(dest_path, src_path)
            choice = prompt(rel, is_new)
            while choice == "d":
                show_diff(dest_path, src_path)
                choice = prompt(rel, is_new)
            if choice == "q":
                print("Stopping, no further changes applied. State not advanced.")
                quit_early = True
                break
            if choice == "a":
                apply_all = True
            elif choice != "y":
                print(f"  Skipped: {rel}")
                continue
        apply_change(src_path, dest_path, tool, do_backup=not args.no_backup)

    if not quit_early:
        write_state(repo_root, head)

    return 0


if __name__ == "__main__":
    sys.exit(main())
