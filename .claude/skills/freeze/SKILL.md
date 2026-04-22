---
name: freeze
description: Use to restrict file edits to a specific directory — prevents "while I'm here" scope creep during debugging or focused work. Advisory by default (Claude respects the boundary per these instructions); becomes mechanically enforced if the PreToolUse hook is wired into settings.json.
---

# Freeze

Lock file edits to a single directory for the session. Everything else becomes read-only from Claude's perspective.

## When to use

- Debugging a bug in a specific module — freeze to that directory so you don't accidentally "fix" adjacent code mid-investigation
- Refactoring one layer (e.g., just the decorator layer in AppAi) without bleeding into ViewModels or DAOs
- Reviewing a PR locally and wanting to confine any suggested edits to the diff's footprint
- Working inside a git worktree and wanting to make sure edits stay within it

## When NOT to use

- Small tasks that naturally fit in one file — overhead isn't worth it
- Exploratory work where the right scope isn't known yet
- When the task legitimately spans layers (feature work across UI + VM + repo)

## How to set a freeze

1. Ask the user for the directory. Accept a relative or absolute path.
2. Resolve to an absolute path:
   ```bash
   FREEZE_DIR=$(cd "<user-path>" 2>/dev/null && pwd -P)
   ```
3. Normalize with a trailing slash (so `/src/auth` doesn't also match `/src/auth-legacy`):
   ```bash
   FREEZE_DIR="${FREEZE_DIR%/}/"
   ```
4. Write to the state file:
   ```bash
   mkdir -p "$HOME/.claude/state"
   echo "$FREEZE_DIR" > "$HOME/.claude/state/freeze-dir.txt"
   echo "Freeze boundary set: $FREEZE_DIR"
   ```
5. Tell the user: "Edits restricted to `<path>/`. Run `/unfreeze` to clear, or re-run `/freeze` to change the boundary. This is advisory unless the hook is wired in settings.json."

## How to respect the boundary (advisory mode)

Read `$HOME/.claude/state/freeze-dir.txt` before every Edit or Write. If the target file path is outside the boundary:

- STOP. Do not edit.
- Tell the user: "Edit to `<path>` blocked by freeze boundary (`<freeze-dir>`). Run `/unfreeze` to clear, or confirm you want to override."
- Only proceed if the user explicitly overrides.

The boundary check:
- Target path must start with the freeze directory (after both paths are resolved to absolute, symlinks followed).
- The trailing slash on the freeze directory is required. `/src/auth/` matches `/src/auth/file.kt` but not `/src/auth-old/file.kt`.

## Hook enforcement (optional)

If you wire the `PreToolUse` hook from `~/.claude/skills/freeze/bin/check-freeze.sh` into `~/.claude/settings.json`, the boundary becomes mechanically enforced — Claude literally cannot write outside it. Add:

```json
{
  "matcher": "Edit|Write",
  "hooks": [
    {
      "type": "command",
      "command": "bash \"$HOME/.claude/skills/freeze/bin/check-freeze.sh\"",
      "timeout": 5
    }
  ]
}
```

…under `hooks.PreToolUse` in settings. When no freeze state file exists, the hook is a no-op (returns `{}`), so it's safe to leave wired full-time.

## Notes

- Freeze covers `Edit` and `Write` only. `Read`, `Grep`, `Glob`, `Bash` are unaffected — you can still investigate freely outside the boundary.
- Freeze is not a security boundary. `Bash` can still run `sed` or `git checkout` on files outside the boundary.
- State persists until `/unfreeze` clears it or you delete `~/.claude/state/freeze-dir.txt`. It does NOT auto-clear on session end.
- The `investigate` skill references freeze at its scope-lock step. If freeze isn't installed, that step is a no-op.
