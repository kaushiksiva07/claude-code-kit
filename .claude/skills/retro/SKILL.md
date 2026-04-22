---
name: retro
description: Use after a workstream, feature, or release lands — looks back at the commits in that window, extracts wins, friction, and patterns worth carrying forward. Emits a structured retro artifact and optionally hands off concrete patterns to `continuous-learning` for memory capture.
---

# Retro

Bookend for finished work. Runs against a commit range (a workstream, a merged PR, a release), not a calendar week.

**When to run:**
- A workstream (WS3, WS6b, etc.) is closed
- A feature branch merged to `master`
- A release tag shipped
- After any block of work that took more than a day and produced >5 commits

**When NOT to run:** single-commit fixes, exploratory spikes, incomplete work. Wait until the arc finishes.

## Arguments

One of:
- `from=<ref> to=<ref>` — explicit range (e.g., `from=main to=HEAD`, `from=v1.2.0 to=v1.3.0`)
- `branch=<name>` — all commits on `<name>` not yet in `master`
- `last=<N>d` — last N days
- no args — prompts for the range

## Phase 1 — Define the arc

1. Resolve the commit range. If ambiguous, ask.
2. Name the arc in one sentence. What was this body of work? ("WS6b contract-test fanout", "v2 premium launch prep stage 1", "Ask-AI planner latency fix"). Note it — the retro is framed around this thesis.
3. If the arc has a memory file (e.g., `project_ws6b_closure.md`), read it. That's the stated goal; the retro measures the delivery against it.

## Phase 2 — Enumerate

```bash
git log --oneline --stat <from>..<to>
git log --format='%h %ai %s' <from>..<to>
git diff --stat <from>..<to>
```

Collect:
- Commit count, files changed, LOC added / removed
- Hotspots: files touched 3+ times in the window (candidates for architectural friction)
- Commit-type mix: `feat:` / `fix:` / `refactor:` / `test:` / `docs:` / `chore:` (by convention prefix)
- Fix-chains: consecutive `fix:` commits on the same file(s) — signal that the first fix missed root cause

No need for session detection, streak tracking, or time-of-day analysis. Those are team metrics.

## Phase 3 — Identify wins

2–4 concrete wins. Anchored in specific commits or diffs. What made this arc worth doing?

Good wins:
- "Covered all 11 method-dispatch Lambdas with contract tests in 4 axes (commits abc1234..def5678). Regression surface now catches shape drift before deploy."
- "Ask-AI planner latency cut by inlining the classifier LLM call (commit 1a2b3c4). User-facing p50 response time dropped from ~2.4s to ~1.1s."

Bad wins:
- "Shipped a lot of commits this week."
- "Made progress on X."

## Phase 4 — Identify friction

2–4 friction points. Each must name a specific failure mode, not a vague complaint.

Categories to probe:
- **Rework** — what got fixed more than once? Fix-chains in the commit log are a direct signal.
- **Workarounds** — did anything land with a "do this better later" comment, a hardcoded value, or a skipped test?
- **Dead ends** — were there commits later reverted or rewritten? What cost did that impose?
- **Friction against existing architecture** — did the work fight any layer (DI, decorators, Free/Pro split, Lambda packaging)?
- **Tool failures** — did a reviewer hallucinate? A build break eat an hour? A skill misfire?

Example:
- "Ask-AI planner rewrite regressed latency (commit X) — had to patch narrowly afterwards. Pattern: each added LLM call is a latency tax; rewrites of the planner are net-negative."

## Phase 5 — Patterns to carry forward

0–3 patterns. Each is a rule of the form "when I see X, I should Y." These are the candidates for memory.

For each pattern:
1. State the rule.
2. State the evidence (which commits / files / incidents in this arc support it).
3. Decide whether it's worth memorializing. A pattern is worth a memory if it would save >15 min in a future session.
4. If yes, hand off to `continuous-learning` to write the memory with proper type (`feedback` / `project` / `pattern`).

Example pattern:
- Rule: "For Ask-AI planner changes, patch narrowly — don't rewrite."
- Evidence: large rewrite in this arc regressed latency + produced two follow-up fix commits.
- Memorialize? Yes. Save as feedback memory.
- *(This one is already in memory as `feedback_ask_ai_rewrites.md`.)*

## Phase 6 — Habits for next arc

0–3 small, specific changes for the next workstream. Each must be something you can adopt in <5 minutes.

Good:
- "Before rewriting any LLM-adjacent code, run a timing benchmark on the current version. Anchor the regression check."
- "Add a `git log -S<symbol>` check to investigate Phase 1 when the bug touches a hot file."

Bad:
- "Write better code."
- "Review more carefully."

## Phase 7 — Artifact

Emit this exact block at the end. Keep it terse.

```
RETRO: <arc name>
════════════════════════════════════
Range:      <from>..<to>  (<N> commits, <files> files, +<add>/-<del> LOC)
Thesis:     <one sentence — what this arc was meant to accomplish>
Delivered:  <one sentence — what actually shipped>

Wins:
  - <win 1>
  - <win 2>

Friction:
  - <friction 1>
  - <friction 2>

Hotspots:
  - <file>: <N> touches — <note if concerning>

Patterns carried forward:
  - <rule 1>  [memory: <yes/no> — <reason>]

Habits for next arc:
  - <habit 1>
════════════════════════════════════
```

Write the artifact to `.claude/retros/<YYYY-MM-DD>-<arc-slug>.md` in the project dir if the dir exists; otherwise emit inline only. Don't create the dir unless the user asks.

## Rules

- Anchor every claim in a commit hash, file path, or incident. Never "I think we did well on X."
- If the arc didn't meet its thesis, say so plainly. A retro that whitewashes is worse than no retro.
- No shipping-velocity metrics (commits/day, LOC/hour). They measure typing, not progress.
- Friction ≠ blame. The audience is future-you. Describe the failure mode, not the failure.
- Max 4 items per section. More = unfocused. If there are genuinely 6 wins, the arc was probably two arcs; split it.
- Hand off pattern capture to `continuous-learning`. Don't duplicate the memory-writing logic here.
