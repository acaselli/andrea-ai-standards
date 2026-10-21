#!/usr/bin/env bash
# Fast-forward this clone to origin/main. Run at session start by the hook install.sh adds to Claude Code and Codex.
# Silent when up to date or offline; when the clone cannot follow main, prints a warning both tools show to the user.
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 0

warn() { printf '{"systemMessage": "andrea-ai-standards is not updating: %s"}\n' "$1"; exit 0; }

branch="$(git branch --show-current)"
[ "$branch" = main ] || warn "the clone is on branch '$branch'. Run: git -C $PWD switch main"
git fetch --quiet origin main 2>/dev/null || exit 0
git merge --ff-only --quiet origin/main >/dev/null 2>&1 || warn "local changes or commits block it. Check: git -C $PWD status"
