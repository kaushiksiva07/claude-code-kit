# claude-code-kit

An opinionated starter kit for [Claude Code](https://docs.anthropic.com/claude-code) — the configuration, the agents, the skills, and the notification hooks — packaged so you can drop it into a fresh machine and have a working setup in under a minute.

The contents were curated from [`affaan-m/everything-claude-code`](https://github.com/affaan-m/everything-claude-code) (an excellent, much larger library) and trimmed to the subset that gets used in day-to-day work.

## What's inside

```
claude-code-kit/
├── .claude/
│   ├── settings.template.json   # Sanitized settings.json — model, hooks, plugins
│   ├── agents/                  # 2 curated subagents (gsd)
│   ├── skills/                  # 9 curated workflow skills (gstack)
│   ├── statusline-command.sh    # Status line: tokens, context %, rate-limit bars
│   ├── terminal-notify.js       # Windows Terminal color-per-state hook
│   └── terminal-notify.ps1      # Same, PowerShell variant
├── docs/
│   ├── plugins.md               # superpowers, frontend-design, code-simplifier
│   ├── hooks.md                 # What each notification hook does
│   └── mcp-servers.md           # How to wire MCP servers (optional)
├── install.sh                   # POSIX installer
├── install.ps1                  # Windows installer
└── LICENSE                      # MIT
```

## Quick start

```bash
git clone https://github.com/kaushiksiva07/claude-code-kit.git
cd claude-code-kit
./install.sh          # or: pwsh -File install.ps1
```

The installer copies everything into `~/.claude/` (respects `$CLAUDE_HOME`) and drops `settings.template.json` at `~/.claude/settings.json` **only if it doesn't already exist** — your existing config is safe.

Then, inside Claude Code, install the three plugins listed in [docs/plugins.md](docs/plugins.md) and restart.

## `gstack` — 9 workflow skills

A sprint loop for non-trivial work:

| Skill             | When to use it                                                           |
|-------------------|--------------------------------------------------------------------------|
| `investigate`     | Disciplined exploration before writing a plan                            |
| `plan-eng-review` | Review a plan for engineering soundness                                  |
| `plan-ceo-review` | Review a plan against product strategy / user value                      |
| `ship`            | Structured release checklist — tests, docs, PR, changelog                |
| `retro`           | Post-ship retrospective that turns lessons into feedback-memory pointers |
| `context-save`    | Snapshot the session's working context into a durable file               |
| `context-restore` | Load a saved context into a new session                                  |
| `freeze`          | Pause point — stash open threads, mark where work left off               |
| `unfreeze`        | Resume from a freeze cleanly                                             |

## `gsd` — 2 subagents

Delegate-and-summarize agents that work hard on a narrow task so the parent session stays lean:

| Agent             | Role                                                                     |
|-------------------|--------------------------------------------------------------------------|
| `codebase-mapper` | One-shot audit of an unfamiliar codebase (stack, architecture, concerns) |
| `pattern-mapper`  | "Which existing files should new files copy patterns from?" pre-implementation |

Both were written with a Kotlin/Android + Python Lambda codebase in mind — their examples reference those stacks. The structure (role/data-flow classification, forbidden-file rules, template-based output) generalizes; edit the role tables in the agent files to match your stack.

## What the settings template gives you

- `model: opus`, `effortLevel: high` — lean into the smartest settings by default.
- `defaultMode: auto` + `skipAutoPermissionPrompt: true` — Claude runs without constant permission prompts. Revert if you want stricter gates.
- `CLAUDE_CODE_DISABLE_1M_CONTEXT=1` — stays on 200K context (cheaper, faster). Remove the env var if you need the long window.
- Status line with tokens / context usage / 5-hour + 7-day rate-limit bars.
- Notification hooks that recolor the current Windows Terminal tab on state changes. See [docs/hooks.md](docs/hooks.md).

## Re-running the installer

Safe. It overwrites agents, skills, and the scripts (that's how you pick up updates from the repo), but never overwrites your `settings.json`.

## Credits

- Agents and workflow skills curated from [`affaan-m/everything-claude-code`](https://github.com/affaan-m/everything-claude-code).
- Built on top of Anthropic's [superpowers](https://github.com/anthropics/claude-code) plugin.

## License

[MIT](LICENSE)
