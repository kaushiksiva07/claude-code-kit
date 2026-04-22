---
name: plan-eng-review
description: Use before implementation begins to lock the engineering plan — architecture, data flow, diagrams, edge cases, test coverage, performance. Interactive, opinionated, one-issue-at-a-time. Pair with plan-ceo-review for strategic lens, or run standalone when the scope is already agreed.
---

# Plan Engineering Review

Engineering-manager-mode plan review. You have a plan (design doc, PR description, markdown plan, or a conversation summary). You want to catch architecture issues, DRY violations, test gaps, and performance landmines **before** implementation starts.

Runs interactively — one issue, one question, move on when resolved. Do not batch issues into a single wall of text.

## Engineering preferences (drive every recommendation)

- DRY — flag repetition aggressively
- Well-tested — I'd rather have too many tests than too few
- "Engineered enough" — not fragile, not over-abstracted
- Err toward handling more edge cases, not fewer
- Explicit over clever
- Right-sized diff — smallest diff that cleanly expresses the change, but if the foundation is broken, say "scrap it and do this instead"
- Native rewrites over override stacks (per user memory `feedback_native_over_overrides.md`)
- Narrow patches over large rewrites (per `feedback_ask_ai_rewrites.md`) — each added LLM call / new layer is a tax

## Confidence calibration

Every finding includes a confidence score:

| Score | Meaning | Display |
|-------|---------|---------|
| 9-10 | Verified by reading specific code. Concrete bug. | Show |
| 7-8 | High-confidence pattern match. | Show |
| 5-6 | Could be a false positive. | Show with "verify this is actually an issue" |
| 3-4 | Suspicious but may be fine. | Appendix only |
| 1-2 | Speculation. | Only if P0 |

Format: `[SEVERITY] (confidence: N/10) file:line — description`
Example: `[P1] (confidence: 9/10) data/roomdatabase/AppDatabase.kt:42 — migration drops column with live production data`

## Step 0 — Scope challenge

Before reviewing anything, answer:

1. **What existing code partially solves this?** Map each sub-problem to existing code (DAOs, Repositories, ViewModels, Lambda handlers). Rebuilding parallel paths is the #1 scope smell.
2. **Minimum set of changes** that achieves the goal? Flag work that could be deferred without blocking the core objective.
3. **Complexity smell**: plan touches > 8 files OR introduces > 2 new classes/services/Lambdas → challenge whether the same goal can be reached with fewer moving parts.
4. **Built-in check**: does the framework have this already? E.g., `androidx.lifecycle.SavedStateHandle` before inventing a state holder, `WorkManager` before rolling a scheduler, `StateFlow` before a custom observable, `LaunchedEffect` before a hand-rolled coroutine in a composable. On the Lambda side: boto3 paginators before a hand-rolled loop, RDS Proxy pooling before a connection-retry wrapper.
5. **Free/Pro placement**: does this belong in `data/decorators/` (sync/cache wrapping) or in the base repo? Wrong layer is the #1 source of Pro-path regressions.
6. **Native rewrite vs patch**: if the plan is rewriting an existing flow, is a narrow patch available? (Ask-AI planner rewrites have already regressed twice per `feedback_ask_ai_rewrites.md`.)

If the complexity check triggers: stop and propose a minimal version before continuing. Once the user accepts a scope, commit — don't re-argue for smaller scope during later sections.

## Review sections (one section at a time, one issue at a time)

**Anti-skip rule:** never condense or skip a section. If a section has zero findings, say "no issues" and move on — but evaluate it.

### 1. Architecture

- Component boundaries — where does this sit in MVVM + Clean? (UI / ViewModel / Repository / Decorator / DataSource)
- Dependency graph — does this add a cycle? New Hilt module? New `@Binds`?
- Data flow — from user tap to DB and back. Diagram it with ASCII if non-trivial.
- Free/Pro split — Free uses local-only base repo, Pro layers decorators. Which path does the plan touch?
- Failure scenarios — for each new codepath, one realistic production failure (Room migration fails, llama.cpp native crash, RDS Proxy connection exhaustion, Plaid webhook retry storm).
- Distribution — new artifact (AAR, Lambda layer, new manifest entry)? Build/publish pipeline included?

Draw ASCII diagrams for anything with branches. Stale diagrams in nearby code comments: flag as part of scope.

**STOP.** One AskUserQuestion per issue. Present options, state recommendation, explain WHY (mapped to an engineering preference). Don't batch. No issues or obvious fix → say so, move on.

### 2. Code quality

- Organization and module structure — new code fits existing patterns?
- DRY — same logic elsewhere? Point at the file and line.
- Error handling — specific exception types, not catch-all. Reference `silent-failure-hunter` patterns (empty catch blocks, ignored `Result`, Flow without `.catch`).
- Over- vs under-engineered. Any new abstraction solving a hypothetical future problem?
- Null safety — Gson fields parsed from JSON: **always declare nullable** (per `feedback_gson_null_bypass.md`). Room entities with missing columns: migration must set defaults.
- Kotlin style — follow `docs/kotlin-rules/kotlin-rules.md` (`§1 Style`, `§2 Patterns`).

**STOP.** One question per issue.

### 3. Tests — with regression rule

Detect the test stack first (Android: JUnit5 + MockK + Turbine + Compose UI tests; Lambda: pytest + moto). Then:

**Step A — trace every codepath**: follow each entry point (ViewModel method, Composable, DAO call, Lambda handler). For each: input source, transforms, output, what can go wrong at each step.

**Step B — map user flows and error states**: double-tap, navigate-away, stale session, offline, 429, 500, empty list, 10k-row list, max-length input. Each is a test target.

**Step C — check existing tests** per branch.

Quality rubric:
- ★★★ — behavior + edges + error paths
- ★★  — happy path only
- ★   — smoke check / "it doesn't throw"

**Decision matrix**:
- `[→UI]` — Compose UI test if spans 3+ composables (e.g., Ask-AI screen end-to-end)
- `[→INT]` — integration test if crosses layer boundaries with real fakes (e.g., DAO → Repository → ViewModel)
- `[→EVAL]` — LLM prompt change → run against a golden set (`llm/PromptRespository.kt` changes)
- Unit — everything else

**REGRESSION RULE (iron)**: if the diff modifies existing behavior and the existing test suite doesn't cover the changed path, a regression test goes into the plan as CRITICAL. No asking, no skipping.

Output an ASCII coverage diagram:
```
CODE PATHS                                          USER FLOWS
[+] ui/transactions/TransactionsViewModel.kt        [+] Add transaction
  ├── addTransaction()                                ├── [★★★ TESTED] happy — TransactionsVMTest:42
  │   ├── [★★  TESTED] happy only                     ├── [GAP] [→UI]  double-tap submit
  │   └── [GAP]         DAO throws                    └── [GAP]        offline, retry queue
  └── deleteTransaction()                           [+] Error states
      └── [GAP]         not-found case                ├── [GAP] [→UI]  budget delete while health job running

COVERAGE: 3/8 paths (38%)  |  REGRESSIONS: 1 CRITICAL (deleteTransaction previously removed row, now no-op on 404)
```

**STOP.** One question per gap.

### 4. Performance

- N+1 — Room queries inside `forEach`? Flow operator that re-queries per emission?
- Main-thread blocking — LLM inference on Dispatchers.Main? Heavy parsing in a Composable?
- Recomposition — missing `key` on LazyColumn items? Unstable lambdas? `remember` misuse?
- Main-thread I/O — file scans, SharedPreferences reads during Composition.
- Lambda cold start — oversize deps, eager SDK clients outside the handler.
- Caching — expensive computation recomputed per recomposition / per request? BudgetHealthCache invalidation correct?

**STOP.** One question per issue.

## Required outputs

### NOT in scope
List work considered and explicitly deferred, one-line rationale each.

### What already exists
Existing code/flows that partially solve sub-problems — is the plan reusing or rebuilding them?

### TODOS
If the repo has `TODOS.md`, read it. For each new TODO the review surfaces: describe **what / why / pros / cons / context / depends-on**. Then ask: add to TODOS.md, skip, or build now. One per question. Don't batch. Don't append vague bullets.

### Failure modes
For each new codepath from the test diagram: one realistic production failure mode and whether (1) a test covers it, (2) error handling exists, (3) user sees a clear error or a silent failure. If all three are no → **critical gap**.

### Worktree parallelization
Per user memory `feedback_use_worktrees.md`, always consider parallel lanes. Skip if all steps touch the same module OR < 2 independent workstreams — write "Sequential, no parallelization."

Otherwise produce:
- Dependency table: step × modules × depends-on (module-level, not file-level)
- Parallel lanes: steps with no shared modules and no dependency go in separate lanes
- Execution order: which lanes launch in parallel, which wait
- Conflict flags: lanes touching the same module → flag merge risk

### Completion summary
- Step 0 scope: accepted as-is / reduced
- Architecture: N issues
- Code quality: N issues
- Tests: diagram produced, N gaps, M critical regressions
- Performance: N issues
- NOT in scope: written
- What already exists: written
- TODOS: N proposed
- Failure modes: N critical gaps
- Parallelization: N lanes, P parallel / S sequential

## Asking questions

- One issue = one AskUserQuestion. Never combine.
- File:line references, concrete.
- 2-3 options including "do nothing" when reasonable.
- Each option: effort (human ~X / CC ~Y), risk, maintenance.
- Map recommendation to a specific engineering preference.
- Label NUMBER + LETTER (3A, 3B, 3C).
- If a section has no issues or an obvious fix: state it and move on. Don't waste a question.

## Rules

- No code edits. Review only. The plan is the artifact.
- No learnings plumbing, no telemetry, no preamble scripts. This is a pure review skill.
- Priority under context pressure: Step 0 > Test diagram > Failure modes > Architecture > Quality > Performance.
- If the user's plan is for the Ask-AI flow: default to narrow patch recommendations. The planner has regressed twice on rewrites.
