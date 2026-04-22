---
name: context-restore
description: Use at the start of a session when resuming work that was previously saved with context-save — loads the most recent checkpoint (or a user-specified one), parses the decisions/remaining/notes, and primes the session to continue from exactly where it left off. Read-only loader, never writes to disk itself.
---

# Context Restore

Load a checkpoint written by `context-save` and resume. Does not edit code, does not modify the checkpoint file — pure read-and-prime.

## When to use

- First message of a session where prior work was checkpointed
- After context compaction trimmed something you care about and a checkpoint exists
- Resuming on a different machine or worktree
- Handoff between sessions on the same branch

## Usage

- `/context-restore` — load the most recent checkpoint for this repo
- `/context-restore <title-fragment>` — load the newest checkpoint whose filename contains the fragment
- `/context-restore list` — show recent checkpoints and stop (same as `/context-save list`)

## Restore flow

### 1. Find checkpoints

```bash
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
CHECKPOINT_DIR="$REPO_ROOT/.claude/checkpoints"
if [ ! -d "$CHECKPOINT_DIR" ]; then
  echo "NO_CHECKPOINT_DIR"
  exit 0
fi
ls -1t "$CHECKPOINT_DIR"/*.md 2>/dev/null | head -20
```

If no checkpoints exist, tell the user and stop.

### 2. Select the file

- Zero args: newest `*.md` in the checkpoint dir
- With a fragment: newest file whose basename contains the fragment (case-insensitive match)
- If multiple checkpoints match a fragment ambiguously, show the matches and ask.

### 3. Load and parse

Read the file. Parse the YAML frontmatter for:
- `branch`
- `timestamp`
- `files_modified`

Parse the markdown body for the four sections: Summary, Decisions Made, Remaining Work, Notes.

### 4. Sanity-check against current repo state

```bash
git rev-parse --abbrev-ref HEAD
git status --short
git log --oneline -5
```

Flag any divergence from what the checkpoint says:
- **Different branch** — tell the user. Ask whether to check out the branch from the checkpoint, or continue here.
- **Files modified list is stale** — if the checkpoint named files and some are now clean (or vice versa), note it.
- **Commits landed since save** — if `git log` shows commits after the checkpoint timestamp, summarize what landed (by commit message) so the user can judge whether the remaining-work list is still valid.

### 5. Prime the session

Emit this block so both user and session see the loaded state:

```
CONTEXT RESTORED
════════════════════════════════════
From:       <checkpoint-filename>
Saved:      <timestamp>
Branch:     <branch-from-checkpoint>  (current: <current-branch>)
Divergence: <none | listed below>

Summary:    <from checkpoint>
Next step:  <first item from Remaining Work>
════════════════════════════════════
```

Then internalize the full checkpoint content — decisions, remaining work, notes — as active session context. Treat it like it was in the conversation all along.

### 6. Ask what to do

After priming, ask:
- (A) Continue with the first remaining-work item as-is
- (B) Re-plan — remaining work was written N hours/days ago, may be stale
- (C) Pick a specific remaining item (list them numbered)
- (D) Just loaded — you'll give new instructions

Don't auto-execute. A stale remaining-work list executed blindly is worse than no restore.

## Rules

- Never modify the checkpoint file. Restore is read-only. If the user wants to update a checkpoint, tell them to `/context-save` a new one — checkpoint files are append-only archaeology.
- Never restore without sanity-checking against current repo state. Silent restore on a diverged branch produces garbage recommendations.
- If the checkpoint is older than 7 days, flag it explicitly: "This checkpoint is N days old — decisions may be stale."
- If `/context-restore` runs with no checkpoints, just say so. Don't offer to create one — that's `/context-save`'s job.
- If the session already has significant context (mid-conversation restore), warn: "Restoring will mix saved context with current — confirm?" Restore is best at session start.
