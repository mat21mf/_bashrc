#!/usr/bin/env python3
"""
deploy_sync.py - apply this repo's tracked files, whose content differs
from what's currently deployed, to where they're actually deployed on
this machine.

This relies on the convention this repo already documents in its own
README ("cp -p -u .bashrc ~/.bashrc", etc.): a tracked file's path
relative to the repo root IS its intended path relative to the deploy
root (default $HOME). So .bashrc -> $HOME/.bashrc,
.local/bin/rename_timestamp.py -> $HOME/.local/bin/rename_timestamp.py,
and so on - no separate mapping config needed, the repo layout IS the map.

Usage:
  ./deploy_sync.py [--since REF] [--root PATH] [options]

Deploy root resolution (highest priority first): --root on the command
line, then .deploysyncroot at the repo root, then $HOME as the final
default.

.deploysyncroot has two line forms, freely mixed:
  PATH              A default root for anything not covered by a rule
                     below. "~" is expanded. This is the whole file for
                     the simple case (e.g. a vim-config repo whose real
                     root is "~/.vim" instead of "$HOME") - one line, no
                     "=", exactly the original format, unchanged.
  PREFIX=PATH       Scope PATH to only the subtree at PREFIX (a directory
                     relative to the repo root). Files under PREFIX get
                     PREFIX stripped before joining onto PATH - so
                     "tools/=~/.local/bin" deploys "tools/foo.py" to
                     "~/.local/bin/foo.py", not "~/.local/bin/tools/foo.py".
                     More specific (longer) prefixes win over shorter
                     ones regardless of line order.
If the file has PREFIX= rules but no bare default line, anything outside
every listed prefix is simply out of scope - not deployed anywhere, not
counted as pending or up to date, and doesn't need a .deploysyncignore
entry to be kept out. This suits a repo that mixes a deployable tools/
subtree with large non-deployable data alongside it: point .deploysyncroot
at just "tools/=~/.local/bin" and the rest of the repo is automatically
left alone.

Every git-tracked, non-ignored, in-scope file's actual content is compared
against its deployed counterpart on every run - not commit history. A
file is "pending" for exactly as long as its content differs from what's
deployed, full stop. Answering [n] to skip it just means "not this run" -
it stays pending and gets offered again next time, and the time after
that, until you either apply it or add it to .deploysyncignore. There is
no memory of past skip decisions and nothing advances silently; the only
way a file stops being offered is if its content actually matches, it's
out of scope per .deploysyncroot, or you choose to ignore it.

  --since REF   Optional extra narrowing: only consider files touched by
                a commit since REF (any commit/tag/branch), in addition
                to the content-diff check above. Rarely needed - mostly
                useful on a very large repo where you specifically want
                to review only this week's commits, say. Leave it off and
                every in-scope tracked file gets checked; already-matching
                ones are silently counted as up to date and never shown.

Only git-tracked files are considered (git ls-files), and repo bookkeeping
files are skipped by default: README*, LICENSE*, CHANGELOG*, .gitattributes,
.gitignore, *.patch. Use --include-meta to consider them too, or drop a
.deploysyncignore file (one glob per line, matched against the path
relative to repo root) at the repo root for per-repo customization.

Options:
  --dry-run     List what would be reviewed, apply/prompt nothing
  -y, --yes     Apply every pending file without prompting
  --no-backup   Don't back up a deployed file before overwriting it
  --exclude PAT Extra glob to skip, repeatable

For each pending file you get a colored unified diff against the deployed
copy and a prompt:
  [y] apply this one   [n] skip it (offered again next run)   [d] show diff again
  [a] apply this and everything remaining   [q] quit, nothing further applied

Before overwriting a file that's already deployed, its current content is
backed up in place. If rename_timestamp.py is available (next to this
script, or on PATH) it's used, so the backup follows the same
mtime-stamped naming convention already used elsewhere in this repo
(e.g. via RenombrarTimestamps); that's an opportunistic convenience, not a
hard dependency - if it's not available, a plain ".bak.<epoch>" copy is
made instead so a backup always happens unless --no-backup is passed.
Either way, the backup's executable bits are stripped (rename_timestamp.py
via --no-exec, or a manual chmod in the plain-fallback case) - a runnable
duplicate of a live command sitting in a PATH directory is a hazard, not
a convenience.
"""

import argparse
import filecmp
import shutil
import stat
import subprocess
import sys
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


def load_root_rules(repo_root: Path, cli_root: Path | None) -> tuple[list[tuple[str, Path]], Path | None]:
    """Returns (prefix_rules, default_root).
    prefix_rules: [(prefix_without_trailing_slash, root_path), ...] sorted
    longest-prefix-first, so a more specific rule always wins regardless
    of the order it was written in.
    default_root: the bare-line root for anything not matched by a
    prefix rule, or None if the file only has PREFIX= rules (meaning
    anything unmatched is out of scope, not deployed anywhere).
    --root on the CLI overrides everything: no prefix rules, just that
    single default root, same as before this feature existed.
    """
    if cli_root is not None:
        return [], cli_root.expanduser()

    root_file = repo_root / ".deploysyncroot"
    if not root_file.is_file():
        return [], Path.home()

    prefix_rules: list[tuple[str, Path]] = []
    default_root: Path | None = None
    for line in root_file.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if "=" in line:
            prefix, root = line.split("=", 1)
            prefix = prefix.strip().rstrip("/")
            prefix_rules.append((prefix, Path(root.strip()).expanduser()))
        else:
            default_root = Path(line).expanduser()

    prefix_rules.sort(key=lambda pr: len(pr[0]), reverse=True)
    return prefix_rules, default_root


def resolve_dest(rel: str, prefix_rules: list[tuple[str, Path]], default_root: Path | None) -> Path | None:
    """Returns the deploy path for rel, or None if it's out of scope
    (no rule covers it, and there's no default root)."""
    for prefix, root in prefix_rules:
        if rel == prefix or rel.startswith(prefix + "/"):
            sub = rel[len(prefix):].lstrip("/")
            return root / sub if sub else root
    if default_root is not None:
        return default_root / rel
    return None


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
    import time
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
    """Repo-relative paths (posix) of tracked files to consider. Content
    comparison against the deployed copy (done by the caller) is what
    actually decides pending-ness; --since here is only an optional extra
    narrowing of which tracked files even get considered."""
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
        description="Apply this repo's tracked files, whose content differs, to where they're deployed on this machine."
    )
    parser.add_argument("--since", default=None, help="Only consider files touched by a commit since this ref")
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
    prefix_rules, default_root = load_root_rules(repo_root, args.root)

    rels = candidate_files(repo_root, args.since)
    globs = load_ignore_globs(repo_root, args.include_meta, args.exclude)
    rels = [r for r in rels if not is_ignored(r, globs)]

    pending = []  # (rel, src_path, dest_path, is_new)
    up_to_date = 0
    out_of_scope = 0
    for rel in sorted(rels):
        dest_path = resolve_dest(rel, prefix_rules, default_root)
        if dest_path is None:
            out_of_scope += 1
            continue
        src_path = repo_root / rel
        if not src_path.is_file():
            continue  # deleted in a diff range, nothing to deploy
        if dest_path.exists() and filecmp.cmp(src_path, dest_path, shallow=False):
            up_to_date += 1
            continue
        pending.append((rel, src_path, dest_path, not dest_path.exists()))

    scope = "all tracked files" if args.since is None else f"tracked files changed since {args.since}"
    print(f"Repo: {repo_root}")
    if prefix_rules:
        for prefix, root in prefix_rules:
            print(f"Deploy root: {prefix}/ -> {root}")
        if default_root is not None:
            print(f"Deploy root: (everything else) -> {default_root}")
        else:
            print("Deploy root: (everything else is out of scope)")
    else:
        print(f"Deploy root: {default_root}")
    print(f"Scope: {scope}")
    extra = f", {out_of_scope} out of scope" if out_of_scope else ""
    print(f"  {len(pending)} pending, {up_to_date} already up to date{extra}\n")

    if not pending:
        print("Nothing to apply.")
        return 0

    if args.dry_run:
        for rel, _src, _dest, is_new in pending:
            print(f"[{'NEW' if is_new else 'CHANGED'}] {rel}")
        print("\n(dry run - nothing applied)")
        return 0

    tool = None if args.no_backup else find_backup_tool(repo_root)
    if not args.no_backup and tool is None:
        print("Note: rename_timestamp.py not found; using plain .bak.<epoch> backups instead.\n")

    self_path = Path(__file__).resolve()
    self_updated = False

    apply_all = args.yes
    for rel, src_path, dest_path, is_new in pending:
        if not apply_all:
            show_diff(dest_path, src_path)
            choice = prompt(rel, is_new)
            while choice == "d":
                show_diff(dest_path, src_path)
                choice = prompt(rel, is_new)
            if choice == "q":
                print("Stopping, no further changes applied.")
                break
            if choice == "a":
                apply_all = True
            elif choice != "y":
                print(f"  Skipped: {rel} (will be offered again next run)")
                continue
        apply_change(src_path, dest_path, tool, do_backup=not args.no_backup)
        if dest_path.resolve() == self_path:
            self_updated = True

    if self_updated:
        print(
            "\nNote: deploy_sync.py just updated its own deployed copy. This run "
            "kept using the version that was already loaded in memory the whole "
            "way through (a running script can't hot-reload itself), so anything "
            "behavior-related in that update - not file content, which is already "
            "correct - only takes effect starting with the next run. If this "
            "update changed how backups are made, run this command again once "
            "more so any remaining pending files get the new behavior; a backup "
            "made during *this* run may still reflect the old behavior."
        )

    return 0


if __name__ == "__main__":
    sys.exit(main())
