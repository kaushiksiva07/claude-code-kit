# Plugins

This kit expects three plugins from the official `claude-plugins-official` marketplace. `.claude/settings.template.json` enables them in `enabledPlugins`, but you still need to install them once.

`superpowers` is the only required one — the gstack skills and gsd agents explicitly compose with superpowers' skills and won't work as designed without it. The other two are quality-of-life.

## Install

In Claude Code, run:

```
/plugin marketplace add claude-plugins-official
/plugin install superpowers
/plugin install frontend-design
/plugin install code-simplifier
```

(The exact marketplace URL or alias may differ by distribution; check `~/.claude/plugins/known_marketplaces.json` on a working install if unsure.)

## What each one does

### superpowers (required)

The foundation. Adds a skill-based workflow on top of Claude Code with a session-start meta-skill (`using-superpowers`) that routes every response through an appropriate skill. Ships with:

- **Skills** — `brainstorming`, `systematic-debugging`, `test-driven-development`, `writing-plans`, `executing-plans`, `using-git-worktrees`, `verification-before-completion`, `subagent-driven-development`, `dispatching-parallel-agents`, `requesting-code-review`, `receiving-code-review`, `finishing-a-development-branch`, `writing-skills`, `using-superpowers`.
- **Agent** — `code-reviewer`.
- **Commands** — `/brainstorm`, `/write-plan`, `/execute-plan`.

The 9 gstack skills bundled in this kit (`investigate`, `retro`, `ship`, `freeze`, `unfreeze`, `context-save`, `context-restore`, `plan-eng-review`, `plan-ceo-review`) are designed to slot *on top of* this — for example, `investigate` is a heavier-weight forensic pass that kicks in when `superpowers:systematic-debugging` hasn't closed a bug, and `ship` runs after `superpowers:finishing-a-development-branch` has decided on an integration approach.

### frontend-design

Opinionated Compose Material3 and web-frontend guidance. Kicks in when you ask Claude to touch UI components.

### code-simplifier

A subagent that refines code for clarity and consistency without changing behavior. Use after landing a feature when you want cleanup without asking for a full review.

## Disabling

Set any of the three to `false` in `~/.claude/settings.json` → `enabledPlugins`. If you disable `superpowers`, the gstack skills and gsd agents technically still load, but they'll reference skills and agents that no longer exist — expect broken composition.

## Going bigger: everything-claude-code

If you want substantially more than what this kit bundles, install [`affaan-m/everything-claude-code`](https://github.com/affaan-m/everything-claude-code) — a community library with 36+ agents and 180+ skills layered on top of superpowers. Cover topics like brand voice, investor materials, market research, eval harnesses, frontend patterns, MCP server patterns, and more.

This kit is the opinionated, trimmed-down version. everything-claude-code is the buffet.
