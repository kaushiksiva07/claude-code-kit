---
name: unfreeze
description: Use to clear a freeze boundary previously set by the freeze skill, allowing edits to any directory again. Cheap and safe — delete the state file and that's it.
---

# Unfreeze

Clear the freeze boundary.

## How

```bash
STATE_FILE="$HOME/.claude/state/freeze-dir.txt"
if [ -f "$STATE_FILE" ]; then
  PREV=$(cat "$STATE_FILE")
  rm -f "$STATE_FILE"
  echo "Freeze boundary cleared (was: $PREV). Edits now allowed everywhere."
else
  echo "No freeze boundary was set."
fi
```

## Notes

- This only removes the state file. If the PreToolUse hook is wired into `~/.claude/settings.json`, the hook stays registered — it just falls through to "allow" when no state file exists.
- To re-freeze to a new directory, run `/freeze` again.
- Freeze does not auto-clear on session end. If you want a fresh session with no residual boundary, either run `/unfreeze` or delete `~/.claude/state/freeze-dir.txt` manually.
