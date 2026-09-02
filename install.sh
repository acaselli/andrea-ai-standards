#!/usr/bin/env bash
# Wire this clone into Claude Code and Codex on the current machine.
# Safe to re-run: it only creates or updates what is missing or outdated.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Refuse to wire the machine to a linked worktree (e.g. a Conductor workspace); use the main clone.
if [ "${FORCE:-}" != "1" ] && [ "$(git -C "$REPO" rev-parse --git-dir)" != "$(git -C "$REPO" rev-parse --git-common-dir)" ]; then
  echo "This is a linked worktree, not the main clone. Run install.sh from the clone you keep permanently, or set FORCE=1." >&2
  exit 1
fi
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
# Express the path via $HOME when possible so the hook survives a renamed user directory.
case "$REPO" in "$HOME"/*) HOOK_REPO="\$HOME${REPO#"$HOME"}" ;; *) HOOK_REPO="$REPO" ;; esac
HOOK_CMD="git -C \"$HOOK_REPO\" pull --ff-only --quiet >/dev/null 2>&1 || true"

say() { printf '  %s\n' "$*"; }

link() { # link <target> <linkpath>
  local target="$1" link="$2"
  if [ -L "$link" ]; then
    [ "$(readlink "$link")" = "$target" ] && { say "ok      $link"; return; }
    ln -sfn "$target" "$link"; say "updated $link"
  elif [ -e "$link" ]; then
    say "SKIP    $link exists and is not a symlink; remove it and re-run"
  else
    ln -s "$target" "$link"; say "linked  $link"
  fi
}

echo "Skills"
mkdir -p "$CLAUDE_HOME/skills" "$CODEX_HOME/skills"
for skill in "$REPO"/skills/andrea-*/; do
  name="$(basename "$skill")"
  link "${skill%/}" "$CLAUDE_HOME/skills/$name"
  link "${skill%/}" "$CODEX_HOME/skills/$name"
done

echo "Instructions"
link "$REPO/AGENTS.md" "$CODEX_HOME/AGENTS.md"
CLAUDE_MD="$CLAUDE_HOME/CLAUDE.md"
IMPORT="@$REPO/AGENTS.md"
if [ ! -f "$CLAUDE_MD" ]; then
  printf '# Personal standards\n\n%s\n' "$IMPORT" > "$CLAUDE_MD"; say "created $CLAUDE_MD"
elif grep -qxF "$IMPORT" "$CLAUDE_MD"; then
  say "ok      $CLAUDE_MD"
else
  printf '\n%s\n' "$IMPORT" >> "$CLAUDE_MD"; say "updated $CLAUDE_MD (added import)"
fi

echo "SessionStart auto-sync hook"
add_hook() { # add_hook <json file>
  python3 - "$1" "$HOOK_CMD" <<'PY'
import json, os, sys
path, cmd = sys.argv[1], sys.argv[2]
data = json.load(open(path)) if os.path.exists(path) else {}
hooks = data.setdefault("hooks", {})
entries = hooks.setdefault("SessionStart", [])
mine = lambda e: any("andrea-ai-standards" in h.get("command", "") and "pull --ff-only" in h.get("command", "") for h in e.get("hooks", []))
new = {"hooks": [{"type": "command", "command": cmd, "timeout": 15}]}
existing = [e for e in entries if mine(e)]
if existing and existing[0] == new and len(existing) == 1:
    print(f"  ok      {path}"); sys.exit()
entries[:] = [e for e in entries if not mine(e)] + [new]
os.makedirs(os.path.dirname(path), exist_ok=True)
with open(path, "w") as f:
    json.dump(data, f, indent=2); f.write("\n")
print(f"  {'updated' if existing else 'added  '} {path}")
PY
}
add_hook "$CLAUDE_HOME/settings.json"
add_hook "$CODEX_HOME/hooks.json"

echo
echo "Done. Codex asks you to trust changed hooks on its next launch: run 'codex' once and accept."
