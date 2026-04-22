---
name: investigate
description: Use for hard bugs that resist a single pass through systematic-debugging — recurring regressions, intermittent failures, cross-layer issues, or anything where the obvious fix hasn't stuck. Runs a disciplined 5-phase forensic flow and ends with a structured debug report.
---

# Investigate

Heavier-weight forensic discipline on top of `superpowers:systematic-debugging`. Use when the lightweight loop isn't closing the bug.

**Iron Law: no fix without a confirmed root cause.** A fix that hasn't been proven to address the *mechanism* is a guess.

## When to use this vs. systematic-debugging

- **systematic-debugging** — first pass on any bug. Reach for it first.
- **investigate** — the bug survived a systematic-debugging pass, OR it's in a file that's been fixed before (recurrence is an architectural smell), OR it spans multiple layers (UI → VM → repo → DB → Lambda), OR it's intermittent/timing-dependent.

## Phase 1 — Evidence

No hypothesis until evidence is in hand.

1. **Symptoms.** Read the stack trace / logcat / crash / test output end to end. Note every line, path, and value. Don't paraphrase.
2. **Reproduce.** Deterministic repro or more evidence. If you can't reproduce, add logging and stop here.
3. **Recent changes.** `git log --oneline -20 -- <affected-paths>` and `git log -S"<symbol>" --oneline -20`. A regression's root cause is in the diff.
4. **Recurrence check.** `git log --all --oneline -- <file>` — has this file been fixed for similar bugs before? If yes, the bug is structural, not local. Note the pattern.
5. **Cross-layer instrumentation.** For multi-component flows, add one log per boundary (UI → VM, VM → repo, repo → local/remote, Lambda → DB) and run the repro once. The failing boundary is the one where observed input ≠ observed output.

Output: one sentence. **"Root cause hypothesis: ___ because ___."** Specific, testable, mechanical.

## Phase 2 — Pattern match

Before writing a fix, check if this is a known shape.

| Pattern | Signature | Kotlin/Android hot spots | Python/Lambda hot spots |
|---|---|---|---|
| Race / concurrency | Intermittent, order-dependent, "works in debug" | Coroutine scope leak, `StateFlow` emission order, `launch` without `Job` tracking, Compose recomposition loops | async/await mismatch, unpatched thread pool, lambda cold-start concurrency |
| Null propagation | NPE, `IllegalStateException`, silent default | `lateinit` access before init, Gson non-null field with missing JSON (see your memory), `requireContext()` post-destroy | `KeyError`, unchecked `.get()` on dict, null env var |
| State corruption | Inconsistent after retry, works once | ViewModel surviving config change with stale state, cache decorator out of sync, partial Room transaction | Mutable default arg, module-level cache, DB connection reuse across invocations |
| Integration failure | Timeout / 4xx / 5xx at a boundary | Hilt binding missing at runtime, OkHttp interceptor order, repository factory picking wrong Free/Pro branch | IAM / lambda layer missing, RDS Proxy auth drift, region mismatch |
| Config drift | Works locally, fails elsewhere | `BuildConfig.DEBUG` branches, signing config, minify/R8 stripping, ProGuard rules | Env var name typo, secrets manager staleness, `127.0.0.1` vs `host.docker.internal` (see your memory) |
| Stale cache | Fixes on clear / restart | Glide disk cache, DataStore not flushed, BudgetHealthCacheDao serving ghost rows | CloudFront, Lambda in-memory cache across warm invocations |
| Silent swallow | Error hidden, wrong result returned | `runCatching { }.getOrNull()`, empty `catch` block, unhandled Flow exception | Bare `except:`, `logging` without re-raise |

If no pattern matches, WebSearch for `"<framework> <sanitized generic error>"`. **Sanitize first** — strip file paths, hostnames, user data, SQL fragments, internal class names. Search the category, not the raw string.

## Phase 3 — Hypothesis test

1. **Prove the hypothesis with instrumentation.** A log statement or assertion at the suspected mechanism. Run the repro. Does evidence match?
2. **If wrong, go back to Phase 1.** Do not stack hypotheses.
3. **3-strike rule.** After three failed hypotheses, STOP. Ask the user:
   - (A) New hypothesis: `<describe>`
   - (B) Escalate — this likely needs human context you don't have
   - (C) Add logging and catch it next occurrence
4. **Red flags** — treat as "return to Phase 1":
   - "Quick fix for now"
   - Proposing a fix before tracing data flow
   - Each fix reveals a new problem elsewhere (= wrong layer)
   - You're editing a file you don't fully understand

## Phase 4 — Fix

Only once the hypothesis is confirmed.

1. **Minimal diff.** Fewest files, fewest lines. No "while I'm here" cleanup. Resist refactoring adjacent code.
2. **Regression test first.**
   - Must fail without the fix (proves the test catches the bug)
   - Must pass with the fix (proves the fix works)
   - Kotlin: prefer Turbine for Flow, MockK for interfaces, JUnit4 for Android instrumentation
   - Python: pytest with explicit fixture for the failing case
3. **Blast radius check.** If the fix touches more than 5 files, stop and ask:
   - (A) Proceed — root cause genuinely spans these files
   - (B) Split — critical path now, rest later
   - (C) Rethink — probably a more targeted approach exists
4. **Full test suite.** Paste output. No new failures.

## Phase 5 — Verify & report

1. **Fresh repro.** Re-run the original failing scenario. Confirm the symptom is gone. Not optional.
2. **Debug report** — emit this exact block at the end:

```
DEBUG REPORT
════════════════════════════════════
Symptom:         <what was observed>
Root cause:      <what was actually wrong — the mechanism>
Fix:             <file:line references for each change>
Evidence:        <test output or repro showing fix works>
Regression test: <file:line of new test>
Related:         <prior bugs in same file(s), architectural notes>
Status:          DONE | DONE_WITH_CONCERNS | BLOCKED
════════════════════════════════════
```

3. **If recurrence pattern.** If Phase 1 step 4 showed this file has been fixed for similar bugs before, note it under `Related:` and flag explicitly: *"This is the Nth fix in `<file>` — the pattern is structural. Consider refactor before the next bug."*

## Rules

- 3+ failed hypotheses → STOP. Question architecture, not code.
- Never ship a fix you can't verify with a repro.
- Never say "this should fix it." Show the evidence.
- Recurring bugs in the same file = architectural smell, not coincidence.
- No silent swallows. If you catch an exception to make the bug go away, you have not fixed the bug.
