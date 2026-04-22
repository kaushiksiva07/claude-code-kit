#!/usr/bin/env bash
# check-freeze.sh — PreToolUse hook for the freeze skill.
#
# Reads a tool-call JSON payload from stdin. If file_path is outside the
# freeze boundary, returns a permissionDecision=deny response to block the
# call. Otherwise emits `{}` to allow.
#
# Fail-open philosophy: on any parse failure, missing state file, or empty
# freeze dir, allow the operation. Blocking on our own bugs is worse than
# missing a scope violation.

set -u

INPUT=$(cat)

STATE_FILE="$HOME/.claude/state/freeze-dir.txt"

# No state file = freeze not active = allow everything.
if [ ! -f "$STATE_FILE" ]; then
  echo '{}'
  exit 0
fi

FREEZE_DIR=$(tr -d '[:space:]' < "$STATE_FILE" 2>/dev/null || true)

if [ -z "${FREEZE_DIR:-}" ]; then
  echo '{}'
  exit 0
fi

# Extract file_path from tool_input. Try a crude grep first, then a
# python fallback for payloads with escaped quotes.
FILE_PATH=$(printf '%s' "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*:[[:space:]]*"//;s/"$//' 2>/dev/null || true)

if [ -z "${FILE_PATH:-}" ]; then
  FILE_PATH=$(printf '%s' "$INPUT" | python -c 'import sys,json; d=json.loads(sys.stdin.read()); print(d.get("tool_input",{}).get("file_path",""))' 2>/dev/null || true)
fi

# If we couldn't extract a path, allow. Don't penalize the user for our parse failure.
if [ -z "${FILE_PATH:-}" ]; then
  echo '{}'
  exit 0
fi

# Normalize Windows-style paths (C:\foo\bar) to git-bash-style (/c/foo/bar).
# Only rewrite if the path starts with a drive letter followed by backslash or colon+backslash.
case "$FILE_PATH" in
  [A-Za-z]:\\*|[A-Za-z]:/*)
    _drive=$(printf '%s' "$FILE_PATH" | cut -c1 | tr '[:upper:]' '[:lower:]')
    _rest=$(printf '%s' "$FILE_PATH" | cut -c3- | tr '\\' '/')
    FILE_PATH="/$_drive$_rest"
    ;;
esac

case "$FREEZE_DIR" in
  [A-Za-z]:\\*|[A-Za-z]:/*)
    _drive=$(printf '%s' "$FREEZE_DIR" | cut -c1 | tr '[:upper:]' '[:lower:]')
    _rest=$(printf '%s' "$FREEZE_DIR" | cut -c3- | tr '\\' '/')
    FREEZE_DIR="/$_drive$_rest"
    ;;
esac

# Resolve relative file_path against cwd.
case "$FILE_PATH" in
  /*) ;;
  *) FILE_PATH="$(pwd)/$FILE_PATH" ;;
esac

# Collapse repeated slashes and strip trailing slash from file path.
FILE_PATH=$(printf '%s' "$FILE_PATH" | sed 's|/\{2,\}|/|g;s|/$||')

# Ensure freeze dir has exactly one trailing slash.
FREEZE_DIR=$(printf '%s' "$FREEZE_DIR" | sed 's|/\{2,\}|/|g;s|/*$|/|')

# Case-insensitive prefix match. Windows paths are case-insensitive; on
# Linux/macOS this would rarely cause false positives because the user
# wrote the freeze dir using the real casing.
_lower_file=$(printf '%s' "$FILE_PATH" | tr '[:upper:]' '[:lower:]')
_lower_freeze=$(printf '%s' "$FREEZE_DIR" | tr '[:upper:]' '[:lower:]')

case "$_lower_file/" in
  "$_lower_freeze"*)
    echo '{}'
    ;;
  *)
    printf '{"permissionDecision":"deny","message":"[freeze] Blocked: %s is outside the freeze boundary (%s). Run /unfreeze to clear."}\n' "$FILE_PATH" "$FREEZE_DIR"
    ;;
esac
