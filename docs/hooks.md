# Hooks

Claude Code fires hooks at lifecycle events. `.claude/settings.template.json` wires a handful of them to the bundled `terminal-notify.js` script, which recolors the current Windows Terminal tab based on session state.

## States & colors

| State         | Trigger                                  | Color                |
|---------------|------------------------------------------|----------------------|
| `working`     | `UserPromptSubmit`, `PreToolUse`         | blue  `#0a1a3d`      |
| `needs-input` | `Notification` (permission prompt, elicitation) | pink  `#3d0a2e` |
| `finished`    | `Stop`, `Notification: idle_prompt`      | green `#0a3d1a`      |
| `idle`        | `SessionStart`                           | reset to default     |

Background color is written directly into Windows Terminal's `settings.json`, which hot-reloads.

## Platform support

- **Windows + Windows Terminal:** fully supported. Requires Node.js on `$PATH` (`node --version` should work).
- **macOS / Linux:** the script exits silently (`$WT_PROFILE_ID` won't be set) — no harm, no effect. If you want a macOS iTerm / Terminal equivalent, swap the command in `settings.json` for your own script.

## Scoping to specific profiles

By default the script acts on whichever Windows Terminal profile Claude Code is running inside. If you don't want your default terminal profile to change colors, set an allowlist:

```bash
export CLAUDE_KIT_WT_PROFILES="{guid-1},{guid-2}"
```

Find a profile's GUID in WT settings → your profile → "More" → Copy GUID.

## PowerShell variant

`terminal-notify.ps1` does the same thing in PowerShell, with `Console.Beep` sound cues on state changes. Swap into `settings.json` if you prefer it:

```json
"command": "pwsh -NoProfile -File \"$HOME/.claude/terminal-notify.ps1\" needs-input"
```

## Disabling

Delete the `hooks` block in `~/.claude/settings.json`, or comment out individual matchers. Hooks never block Claude's main flow — they run async with a 5s timeout.

## Adding more

The official Claude Code hook docs cover every lifecycle event (`PostToolUse`, `SessionEnd`, `PermissionRequest`, `Elicitation`, …). Wire any of them the same way:

```json
"PostToolUse": [
  {
    "hooks": [
      {
        "type": "command",
        "command": "node \"$HOME/.claude/terminal-notify.js\" working",
        "timeout": 5,
        "async": true
      }
    ]
  }
]
```
