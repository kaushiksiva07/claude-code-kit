# superpowers — full inventory

Descriptions are copied verbatim from each component's frontmatter in the [official superpowers plugin](https://github.com/anthropics/claude-code) (version 5.0.7 at the time of writing).

## Skills (14)

| Skill | Description |
|---|---|
| `brainstorming` | You MUST use this before any creative work — creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation. |
| `dispatching-parallel-agents` | Use when facing 2+ independent tasks that can be worked on without shared state or sequential dependencies. |
| `executing-plans` | Use when you have a written implementation plan to execute in a separate session with review checkpoints. |
| `finishing-a-development-branch` | Use when implementation is complete, all tests pass, and you need to decide how to integrate the work — guides completion of development work by presenting structured options for merge, PR, or cleanup. |
| `receiving-code-review` | Use when receiving code review feedback, before implementing suggestions, especially if feedback seems unclear or technically questionable — requires technical rigor and verification, not performative agreement or blind implementation. |
| `requesting-code-review` | Use when completing tasks, implementing major features, or before merging to verify work meets requirements. |
| `subagent-driven-development` | Use when executing implementation plans with independent tasks in the current session. |
| `systematic-debugging` | Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes. |
| `test-driven-development` | Use when implementing any feature or bugfix, before writing implementation code. |
| `using-git-worktrees` | Use when starting feature work that needs isolation from current workspace or before executing implementation plans — creates isolated git worktrees with smart directory selection and safety verification. |
| `using-superpowers` | Use when starting any conversation — establishes how to find and use skills, requiring Skill tool invocation before ANY response including clarifying questions. |
| `verification-before-completion` | Use when about to claim work is complete, fixed, or passing, before committing or creating PRs — requires running verification commands and confirming output before making any success claims; evidence before assertions always. |
| `writing-plans` | Use when you have a spec or requirements for a multi-step task, before touching code. |
| `writing-skills` | Use when creating new skills, editing existing skills, or verifying skills work before deployment. |

## Agents (1)

| Agent | Description |
|---|---|
| `code-reviewer` | Use when a major project step has been completed and needs to be reviewed against the original plan and coding standards. Senior Code Reviewer specializing in software architecture, design patterns, and best practices. |

## Commands (3)

The slash commands are kept for compatibility but are **deprecated** — the plugin routes them to the corresponding skills.

| Command | Status | Replaced by |
|---|---|---|
| `/brainstorm` | Deprecated | `superpowers:brainstorming` |
| `/write-plan` | Deprecated | `superpowers:writing-plans` |
| `/execute-plan` | Deprecated | `superpowers:executing-plans` |

## How this kit composes with superpowers

The 9 `gstack` skills and 2 `gsd` agents bundled in this repo extend the superpowers workflow rather than replace it. For example:

- `gstack:investigate` is a heavier-weight forensic pass that escalates when `superpowers:systematic-debugging` hasn't closed a bug.
- `gstack:ship` runs after `superpowers:finishing-a-development-branch` has decided on an integration approach — it handles the actual pre-flight for merges, deploys, and releases.
- `gsd:codebase-mapper` and `gsd:pattern-mapper` are delegated research passes that feed into `superpowers:writing-plans` and `superpowers:executing-plans`.

See the lifecycle diagram in the [README](../README.md) for the full composition.
