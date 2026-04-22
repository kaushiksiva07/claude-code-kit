# Plugins

This kit expects three plugins from the official `claude-plugins-official` marketplace. `.claude/settings.template.json` enables them in `enabledPlugins`, but you still need to install them once.

## Install

In Claude Code, run:

```
/plugin marketplace add https://github.com/anthropics/claude-code
/plugin install superpowers
/plugin install frontend-design
/plugin install code-simplifier
```

(The exact marketplace URL may differ by distribution; check `~/.claude/plugins/known_marketplaces.json` on a working install if unsure.)

## What each one does

### superpowers
The one that matters most. Adds a skill-based workflow on top of Claude Code: `/brainstorm`, `/ultrareview`, a debugging discipline, a bunch of rules skills, and the `using-superpowers` meta-skill that runs at session start.

The 9 skills bundled in this kit (`gstack`) extend superpowers' workflow with a common sprint loop: `investigate` → `plan-eng-review` / `plan-ceo-review` → `ship` → `retro`, plus `context-save` / `context-restore` across sessions and `freeze` / `unfreeze` for pause points.

### frontend-design
Opinionated Compose Material3 and web-frontend guidance. Kicks in when you ask Claude to touch UI components.

### code-simplifier
A subagent that refines code for clarity and consistency without changing behavior. Use after landing a feature when you want cleanup without asking for a full review.

## Disabling

Set any of the three to `false` in `~/.claude/settings.json` → `enabledPlugins`. The skills and agents in this kit don't require the plugins — they stand alone — but the `superpowers:using-superpowers` session-start flow is assumed by `gstack`'s workflow skills.

## Upstream sources

The `gstack` skills (investigate, retro, ship, freeze, unfreeze, context-save, context-restore, plan-eng-review, plan-ceo-review) and `gsd` agents (codebase-mapper, pattern-mapper) were curated from [`affaan-m/everything-claude-code`](https://github.com/affaan-m/everything-claude-code). If you want the full library (36+ agents, 180+ skills), install that repo directly — this kit is a trimmed, opinionated subset.
