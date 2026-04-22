#!/usr/bin/env bash
# Installs claude-code-kit into ~/.claude/.
# - Copies agents, skills, statusline, and terminal-notify scripts.
# - Installs settings.template.json as settings.json only if you don't already
#   have one (never overwrites). A merge is up to you.
#
# Re-run anytime to pick up updates from this repo.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${CLAUDE_HOME:-$HOME/.claude}"

mkdir -p "$TARGET/agents" "$TARGET/skills"

echo "Installing into $TARGET"

copy_dir() {
  local src="$1" dst="$2"
  for entry in "$src"/*; do
    [ -e "$entry" ] || continue
    local name
    name="$(basename "$entry")"
    if [ -e "$dst/$name" ]; then
      echo "  = $dst/$name (already exists — overwriting)"
    else
      echo "  + $dst/$name"
    fi
    rm -rf "$dst/$name"
    cp -R "$entry" "$dst/$name"
  done
}

copy_dir "$ROOT/.claude/agents" "$TARGET/agents"
copy_dir "$ROOT/.claude/skills" "$TARGET/skills"

for f in statusline-command.sh terminal-notify.js terminal-notify.ps1; do
  echo "  + $TARGET/$f"
  cp "$ROOT/.claude/$f" "$TARGET/$f"
done
chmod +x "$TARGET/statusline-command.sh" 2>/dev/null || true

if [ -f "$TARGET/settings.json" ]; then
  echo ""
  echo "NOTE: $TARGET/settings.json already exists — skipping template install."
  echo "      Compare against $ROOT/.claude/settings.template.json manually."
else
  cp "$ROOT/.claude/settings.template.json" "$TARGET/settings.json"
  echo "  + $TARGET/settings.json (from template)"
fi

echo ""
echo "Done. Next steps:"
echo "  1. Install plugins listed in docs/plugins.md (superpowers, frontend-design, code-simplifier)."
echo "  2. Restart Claude Code."
