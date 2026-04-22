---
name: ship
description: Use when completing work that needs to leave the local worktree — merging to master, cutting a release, pushing an Android APK artifact, or deploying a Lambda/backend service. Runs a pre-flight, tests, review, scope-drift, and verify-after-deploy sequence. Composes with superpowers skills for code review and verification rather than duplicating them.
---

# Ship

The final gate before work leaves your machine. Not a replacement for `superpowers:finishing-a-development-branch` (which decides *how* to integrate) — this runs *after* that decision, during the actual handoff.

## When to use

- Branch is ready to merge to `master`
- Android APK / AAB is ready to distribute
- Lambda / backend service needs manual deploy (your WS3 / WS3.6 / WS6b pattern)
- Any artifact needs to reach users or production

## When NOT to use

- Mid-feature commits — just commit, don't ship
- WIP pushes to a feature branch for backup
- Experimental spikes

## Phase 1 — Classify

Answer three questions up front. They determine which tracks run.

1. **What's the artifact?** Pick one or more:
   - `code-merge` — branch merges into `master` (local squash or PR)
   - `android-release` — APK/AAB build + signing
   - `lambda-deploy` — Python Lambda needs cloud deploy
   - `backend-deploy` — other backend service (ECS, RDS migration, etc.)
2. **Who sees the result?** Just you (dogfood / on-device verify) → different bar than public users.
3. **Is it reversible?** If not (DB migration, released APK, prod deploy), bar goes up — require an extra verification pass in Phase 6.

State the answers in one sentence before continuing. ("Shipping WS3.6: lambda-deploy, reaches real users, not reversible without data migration.")

## Phase 2 — Pre-flight

Run in order. Stop at the first failure.

1. **Worktree clean.** `git status --short` — no uncommitted changes except deliberate WIP.
2. **On the right branch.** `git branch --show-current`. Cross-check against the arc being shipped.
3. **Rebased / up-to-date.** `git fetch origin && git log --oneline HEAD..origin/master` — if not empty, rebase or merge first.
4. **Secret scan.** Grep the diff for likely secrets: `git diff master..HEAD | grep -iE '(api[_-]?key|secret|password|token|bearer)'`. False positives are cheap; a leaked key is not.

## Phase 3 — Test

- **Android**: `./gradlew testDebugUnitTest lint` — paste summary (not full output). If this branch added tests, assert the new tests are in the run.
- **Python/Lambda**: `pytest` in the service dir. If contract tests exist, run those explicitly — they're cheap and catch shape drift.
- **No skipped tests.** If anything is skipped, name why. `@Ignore` / `@pytest.mark.skip` without a reason is a ship blocker.

If a test fails in code you didn't touch, classify first: is it pre-existing flakiness, or did your diff break it indirectly? Never silence an unowned failure.

## Phase 4 — Review gate

Delegate to existing skills rather than re-implementing.

1. **Code review** — invoke `superpowers:requesting-code-review` against the diff. Don't accept this step as a no-op; read the findings and decide whether to address before or after ship.
2. **Security gate** — invoke your `security-gate` skill. Non-negotiable for anything user-facing or any artifact that handles tokens, secrets, or PII.
3. **Specialist dispatch (conditional)** — if the diff touches:
   - Kotlin coroutine / Flow code → `kotlin-reviewer`
   - Room DAO / migration → `database-reviewer`
   - UI screens → `a11y-architect`
   - Any file with a `catch` block → `silent-failure-hunter`
4. **Scope drift check** — `git diff master..HEAD --stat` — does every changed file trace back to the arc's stated thesis? If not, either split the drift into a separate commit/PR or note it explicitly in the commit message.

## Phase 5 — Commit / merge

- Prefer squash-merges into `master` for feature branches. Keeps history bisectable.
- Commit message = single line summary + 1-3 sentence "why" body. No AI trailer unless the user has set one. Reference the arc name (workstream, issue, PR).
- If working from a worktree (per your standard practice), merge into `master` in the main tree, not the worktree. The worktree is disposable.

## Phase 6 — Deploy (when applicable)

Only runs if classification included `lambda-deploy`, `backend-deploy`, or `android-release`.

**Lambda / backend:**
1. Show the deploy command. Confirm with the user before running.
2. Run the deploy.
3. **Verify after deploy.** Hit a canary endpoint or call a test method. Don't trust "deploy succeeded" — trust the response.
4. For per-tenant setups (your WS3.6 subscriptions pattern): verify against at least one real tenant, not just the shim.

**Android release:**
1. `./gradlew assembleRelease` or `bundleRelease` per target.
2. Verify signing config, ProGuard mapping upload (if applicable), and version code / name.
3. Sideload on a physical device for smoke test before uploading to Play Console. On-device verification is non-negotiable for any release build — the emulator misses real-device issues.

## Phase 7 — Report

Emit this block. Terse.

```
SHIP REPORT
════════════════════════════════════
Arc:             <name>
Artifact:        <code-merge | android-release | lambda-deploy | backend-deploy>
Reversible:      <yes / no — if no, what's the rollback path>
Tests:           <N passed, 0 failed, M skipped-with-reason>
Review findings: <N addressed, M deferred with rationale>
Security gate:   <pass / issues addressed>
Merge / deploy:  <commit hash or deployment id>
Post-verify:     <what you checked, what you observed>
Status:          DONE | DONE_WITH_CONCERNS | BLOCKED
════════════════════════════════════
```

If status is `DONE_WITH_CONCERNS`, list each concern with a follow-up action. Don't bury them in prose.

## Rules

- Never ship with failing tests. Never ship with silenced tests.
- Never deploy without post-deploy verification.
- Never merge a diff you haven't read end-to-end in this session.
- For non-reversible ships (prod deploy, DB migration, public release), require explicit user confirmation before Phase 6 runs. Auto mode is not a license to deploy.
- Scope drift is a ship blocker if the drifted change isn't trivially justifiable. Split or document — don't smuggle.
- The ship report is the contract. If you can't fill a field honestly, the ship isn't done.
