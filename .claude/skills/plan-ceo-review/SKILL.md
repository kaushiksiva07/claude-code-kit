---
name: plan-ceo-review
description: Use when a plan needs strategic challenge before the engineering pass — "is this the right problem?", "what's the 10x version?", "what silent failures are we building in?". 11-section deep review with mode selection (expansion / selective-expansion / hold / reduction). Heavier than plan-eng-review; run first when scope is still mushy.
---

# Plan CEO Review

Rigorous, opinionated plan review with a strategic lens. Challenges premise, maps shadow paths, surfaces expansion opportunities, and forces visibility on failure modes, observability, and rollout.

Your posture depends on the mode the user picks. Always present the mode choice first — don't silently drift.

## Philosophy

Not rubber-stamping. Make the plan extraordinary, catch the landmines before they explode, and ensure what ships is at the highest standard.

- **EXPANSION**: build the cathedral. Push scope up. "What would make this 10x better for 2x effort?" Every expansion is an explicit user opt-in via AskUserQuestion.
- **SELECTIVE EXPANSION**: rigorous reviewer with taste. Current scope is the baseline — make it bulletproof. Surface expansion candidates separately, one AskUserQuestion each. Neutral recommendation posture.
- **HOLD SCOPE**: rigorous reviewer, scope is fixed. Make it bulletproof — every failure mode, every edge, every observability gap.
- **SCOPE REDUCTION**: surgeon. Find the minimum viable version that achieves the core outcome. Cut everything else.

**Completeness is cheap** — with CC, the 70-line delta between "full" and "90% shortcut" costs seconds. Default to the full version (boil the lake). "Ship the shortcut" is legacy thinking from when human engineer-hours were the bottleneck.

Once mode is selected, commit. Don't silently drift toward a different mode.

**No code changes. Review only.**

## Prime directives

1. **Zero silent failures.** Every failure mode must be visible — to the system, to the team, to the user.
2. **Every error has a name.** Don't say "handle errors." Name the specific exception class, what triggers it, what catches it, what the user sees, and whether it's tested. Catch-all (`catch (e: Exception)`, bare `except:`) is a code smell.
3. **Data flows have shadow paths.** Every flow has: happy, null input, empty input, upstream error. Trace all four.
4. **Interactions have edge cases.** Double-tap, navigate-away, slow connection, stale state, back-button. Map them.
5. **Observability is scope, not afterthought.** New logs, metrics, alerts, runbooks are first-class deliverables.
6. **Diagrams are mandatory.** ASCII for every non-trivial data flow, state machine, decision tree.
7. **Everything deferred is written down.** Vague intentions are lies. TODOS.md or it doesn't exist.
8. **Optimize for 6-month future, not today.** If this solves now but creates next-quarter's nightmare, say so.
9. **Permission to scrap.** If there's a fundamentally better approach, say "scrap it and do this instead." I'd rather hear it now.

## Engineering preferences

DRY · tested · engineered-enough · more edges > fewer · explicit > clever · right-sized diff (but don't compress a necessary rewrite into a patch) · observability not optional · security not optional · deployments not atomic (plan for partial states, rollbacks, feature flags) · ASCII diagrams in code comments for complex flows · native rewrites over override stacks · narrow patches over rewrites for hot paths (Ask-AI planner has regressed twice).

## Pre-review system audit

Before Step 0, establish context:

```bash
git log --oneline -30
git diff <base> --stat
git stash list
```

Then read `CLAUDE.md`, `docs/architecture.md`, and any `TODOS.md` / existing plan or design doc.

Map:
- Current system state
- What's in flight (other branches, stashed changes, open PRs)
- Existing pain points relevant to this plan
- FIXME/TODO comments in files this plan will touch

**Retrospective check**: if prior commits on this branch show a previous review cycle (review-driven refactors, reverted changes), note it. Recurring problem areas are architectural smells — escalate to architectural concerns.

**Frontend/UI scope detection**: if the plan touches UI, flag DESIGN_SCOPE for Section 11.

## Step 0 — Nuclear scope challenge + mode selection

### 0A. Premise challenge
1. Is this the right problem? Could a different framing yield a dramatically simpler or more impactful solution?
2. What's the actual user outcome? Is the plan the most direct path, or a proxy problem?
3. What happens if we do nothing? Real pain or hypothetical?

### 0B. Existing code leverage
Map every sub-problem to existing code (DAOs, Repositories, ViewModels, Lambda handlers, Workers). Rebuilding parallel paths is the #1 scope smell.

### 0C. Dream state mapping
```
  CURRENT STATE              THIS PLAN             12-MONTH IDEAL
  [describe]        --->    [describe delta]  --->  [describe target]
```
Does this plan move toward the ideal or away from it?

### 0C-bis. Implementation alternatives (mandatory)

At least 2 approaches. 3 preferred for non-trivial plans. One "minimal viable", one "ideal architecture" — equal weight, don't default to minimal just because it's smaller.

```
APPROACH A: [name]
  Summary:  [1-2 sentences]
  Effort:   [S/M/L/XL]
  Risk:     [Low/Med/High]
  Pros:     [2-3 bullets]
  Cons:     [2-3 bullets]
  Reuses:   [existing code/patterns]
```

**RECOMMENDATION**: choose [X] because [one-line reason mapped to an engineering preference].

If only one approach exists, explain concretely why the others were eliminated.

### 0D. Mode-specific analysis

**EXPANSION** — 10x check, platonic ideal, 5 delight opportunities (adjacent 30-minute improvements). Then opt-in ceremony: each proposal is its own AskUserQuestion. Recommend enthusiastically. Options: add to scope / defer to TODOS.md / skip.

**SELECTIVE EXPANSION** — run HOLD SCOPE analysis first. Then expansion scan: 10x check, delights, platform potential. Cherry-pick ceremony: each candidate is its own AskUserQuestion. Neutral recommendation posture. Options: add / defer / skip.

**HOLD SCOPE** — complexity check (> 8 files or > 2 new classes/services → challenge) + minimum-set check. Flag deferrable work.

**SCOPE REDUCTION** — ruthless cut: absolute minimum that ships user value. Separate "must ship together" from "nice to ship together."

### 0E. Temporal interrogation
1. What's the 1-week version?
2. What's the 1-month version?
3. What's the 1-year trajectory this unlocks?

### 0F. Mode selection
Present all four modes. User picks one. Commit to it.

## Review sections (11, after scope and mode agreed)

**Anti-skip rule**: never condense or skip. "Strategy doc so implementation doesn't apply" is always wrong — implementation details are where strategy breaks down.

### 1. Architecture
Component boundaries, MVVM + Clean placement (UI/ViewModel/Repository/Decorator/DataSource), Free vs Pro split, dependency graph delta, data flow (all four paths — happy, null, empty, error), state machines (diagrammed), new couplings and whether they're justified, scaling characteristics (10x and 100x load), single points of failure, security architecture (auth, data access, API boundaries), production failure scenarios, rollback posture.

**EXPANSION / SELECTIVE EXPANSION**: what would make this architecture *elegant*? What infrastructure would make this feature a platform other features build on?

Required diagram: full architecture showing new components and their relationships.

**STOP.** One AskUserQuestion per issue.

### 2. Error & rescue map
The section that catches silent failures. Not optional.

```
  METHOD/CODEPATH                     | WHAT CAN GO WRONG           | EXCEPTION CLASS
  ------------------------------------|-----------------------------|------------------
  SyncRepository#syncTransactions     | Network timeout             | SocketTimeoutException
                                      | 429 from Lambda             | HttpException(429)
                                      | Malformed JSON              | JsonSyntaxException
                                      | Token expired               | AuthException
  ------------------------------------|-----------------------------|------------------

  EXCEPTION                | RESCUED? | RESCUE ACTION            | USER SEES
  -------------------------|----------|--------------------------|-----------------
  SocketTimeoutException   | Y        | Retry 2x, backoff        | "Syncing..."
  HttpException(429)       | Y        | Backoff + retry          | Nothing (transparent)
  JsonSyntaxException      | N ← GAP  | —                        | Silent fail ← BAD
  AuthException            | Y        | Force re-login           | Sign-in screen
```

Rules:
- Catch-all (`catch (e: Exception)`, `except Exception`) is a smell. Name specific exceptions.
- Every rescued error must retry-with-backoff, degrade-gracefully, or re-raise with context. "Swallow and continue" is almost never acceptable — cross-ref `silent-failure-hunter` agent.
- For LLM calls: malformed response? empty? invalid JSON? model refusal? Each is distinct.

**STOP.** One question per GAP.

### 3. Security & threat model
Attack surface expansion (new endpoints, new params, new deep-link paths, new exported activities). Input validation (nil / empty / wrong type / too long / unicode / injection). Authorization (IDOR — can user A access user B's data by swapping an ID?). Secrets (env vars, rotatable, not hardcoded; per `feedback_lambda_mysql_host.md` on config boundaries). Dependency risk. Data classification (PII, payment, credentials). Injection vectors (SQL, command, prompt injection on LLM). Audit logging for sensitive ops.

Per finding: threat, likelihood, impact, mitigated?

**STOP.** One question per finding.

### 4. Data flow & interaction edge cases
Per new flow, diagram:
```
  INPUT ──▶ VALIDATION ──▶ TRANSFORM ──▶ PERSIST ──▶ OUTPUT
    │           │              │           │           │
    ▼           ▼              ▼           ▼           ▼
  [nil?]   [invalid?]    [exception?]  [conflict?]  [stale?]
  [empty?] [too long?]   [timeout?]    [dup key?]   [partial?]
```

Per interaction: double-tap, navigate-away, submit-with-stale-state, zero results, 10k results, concurrent actions, background job fails at item 3 of 10, job runs twice (dup), queue backs up 2 hours.

**STOP.** One question per gap.

### 5. Code quality
Organization, DRY (aggressive), naming, error patterns (cross-ref section 2), missing edges (explicit list: "what happens when X is nil?"), over-engineering check, under-engineering check, cyclomatic complexity (> 5 branches → propose refactor).

**STOP.** One question per issue.

### 6. Test review
Diagram every new thing:
```
  NEW UX FLOWS:     [list]
  NEW DATA FLOWS:   [list]
  NEW CODEPATHS:    [list]
  NEW ASYNC WORK:   [list: Workers, coroutines, Flow collectors]
  NEW INTEGRATIONS: [list: Lambda endpoints, Plaid, LLM]
  NEW ERROR PATHS:  [list — cross-ref section 2]
```

Per item: test type (Unit / Integration / UI / E2E / Eval), exists in plan?, happy path, failure path (specific failure), edge case (nil, empty, boundary, concurrent).

Ambition check: what's the test that makes you confident shipping at 2am Friday? What would a hostile QA engineer write?

Flakiness risk: tests depending on time, randomness, external services, ordering.

For LLM/prompt changes (`llm/PromptRespository.kt`): eval suites, new cases, baselines.

**STOP.** One question per gap.

### 7. Performance
N+1 (Room inside forEach, Flow recomputing on every emission), memory (max structure size in production), indexes (new queries, missing indexes), caching (BudgetHealthCache invalidation correctness), Worker/Lambda cold start, Room migrations on large tables (locks), main-thread blocking, Compose recomposition hotspots.

**STOP.** One question per issue.

### 8. Observability & debuggability
Logging (structured lines at entry, exit, significant branch), metrics (what tells you it's working? broken?), tracing (trace IDs across Lambda calls), alerting (what new alerts?), debuggability (bug reported 3 weeks post-ship — can you reconstruct what happened from logs alone?), admin tooling, runbooks per new failure mode.

**EXPANSION / SELECTIVE EXPANSION**: what observability would make this feature a joy to operate?

**STOP.** One question per gap.

### 9. Deployment & rollout
Migration safety (Room: backward-compatible? locks? data loss?), feature flags (per user pattern — Free/Pro decoration point is often the flag), rollout order (migrate first, deploy second), rollback plan (step-by-step), deploy-time risk (old + new code running simultaneously), post-deploy verification (first 5 min? first hour?), smoke tests, Play Store staged rollout %.

**STOP.** One question per issue.

### 10. Long-term trajectory
Technical debt introduced (code, operational, testing, docs), path dependency (does this make future changes harder?), knowledge concentration, reversibility (1-5: 1 = one-way door, 5 = easily reversible), ecosystem fit (aligns with Kotlin/AGP/Compose trajectory?), the 1-year question — read this plan as a new engineer in 12 months, is it obvious what it did and why?

**EXPANSION / SELECTIVE EXPANSION**: what comes after Phase 1? Does the architecture support that trajectory? Platform potential?

**STOP.** One question per issue.

### 11. Design & UX (skip if no UI scope)
Information architecture (user sees first, second, third?). Interaction state coverage:
```
  FEATURE | LOADING | EMPTY | ERROR | SUCCESS | PARTIAL
```
User journey coherence — storyboard the emotional arc. AI slop risk (generic UI patterns?). `docs/ui-design.md` alignment. Responsive intention. Accessibility basics (keyboard nav, screen readers, contrast, touch targets — defer to `a11y-architect` for deep review).

Required diagram: user flow showing screens/states and transitions.

If significant UI scope: recommend a follow-up design-review pass before implementation.

**STOP.** One question per issue.

## Required outputs

- **NOT in scope** — considered and explicitly deferred, one-line rationale each
- **What already exists** — existing code partially solving sub-problems, reused vs rebuilt
- **TODOS** — each new TODO: what / why / pros / cons / context / depends-on. One AskUserQuestion per TODO (add / skip / build now). No batching.
- **Failure modes** — per new codepath: one realistic production failure, (1) test, (2) error handling, (3) user sees clear error or silent? All three no → critical gap.
- **Observability deliverables** — explicit list of logs, metrics, alerts, runbooks added
- **Deployment checklist** — migrations, flags, rollback, smoke tests
- **Completion summary** — per-section issue count, mode selected, critical gaps, parallelization plan (per `feedback_use_worktrees.md`)

## Asking questions

One issue = one AskUserQuestion. File:line references. 2-3 options including "do nothing" when reasonable. Per option: effort (human ~X / CC ~Y), risk, maintenance. Recommendation mapped to a specific engineering preference. Label NUMBER + LETTER (3A, 3B). No question wasted on obvious fixes — state and move on.

## Priority under context pressure

Step 0 > System audit > Error/rescue map (section 2) > Test diagram (section 6) > Failure modes > Architecture > Everything else.

Never skip Step 0, the error/rescue map, the test diagram, or the failure modes output. Highest leverage.

## Rules

- No code changes. Review only.
- No preamble scripts, telemetry, routing, or learnings plumbing. Pure review.
- Mode commitment — once selected, no silent drift.
- For Ask-AI planner changes: default to narrow patch mode. Two prior rewrites regressed (`feedback_ask_ai_rewrites.md`).
