---
name: context-save
description: Use before context compaction, session interruption, or stepping away from long-running work — serializes the current working state (branch, diff, decisions, remaining steps, open questions) to a checkpoint file that context-restore can load later. State-capture only, never edits code.
---

# Context Save

Serialize session state to disk so a future session can resume without re-deriving context from scratch.

**Hard rule:** this skill captures state. It does NOT edit code, run tests, or modify anything outside the checkpoint file. If the user wants a "save and keep going," save first, then let them re-invoke the regular skill afterward.

## When to use

- About to hit context compaction (you're noticing summaries)
- Stepping away from a long task and want to resume cold tomorrow
- Handoff between sessions or worktrees
- Mid-investigation when a hypothesis turned into a longer detour than expected
- After a meaningful decision point you don't want to re-litigate later

## Usage

- `/context-save` — infer a title from current work
- `/context-save <title>` — use the given title
- `/context-save list` — list existing checkpoints for this repo
- (`/context-save resume` / `restore` — tell user to use `/context-restore` instead)

## Save flow

### 1. Gather git state

```bash
echo "=== BRANCH ==="; git rev-parse --abbrev-ref HEAD 2>/dev/null
echo "=== STATUS ==="; git status --short 2>/dev/null
echo "=== DIFF STAT ==="; git diff --stat 2>/dev/null
echo "=== STAGED ==="; git diff --cached --stat 2>/dev/null
echo "=== RECENT LOG ==="; git log --oneline -10 2>/dev/null
```

### 2. Resolve checkpoint path (in bash, not the LLM layer)

User-supplied titles must not inject shell metacharacters. Sanitize via allowlist.

```bash
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
CHECKPOINT_DIR="$REPO_ROOT/.claude/checkpoints"
mkdir -p "$CHECKPOINT_DIR"

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
RAW="${TITLE_RAW:-untitled}"
TITLE_SLUG=$(printf '%s' "$RAW" | tr '[:upper:]' '[:lower:]' | tr -s ' \t' '-' | tr -cd 'a-z0-9.-' | cut -c1-60)
TITLE_SLUG="${TITLE_SLUG:-untitled}"

FILE="${CHECKPOINT_DIR}/${TIMESTAMP}-${TITLE_SLUG}.md"
if [ -e "$FILE" ]; then
  SUFFIX=$(LC_ALL=C tr -dc 'a-z0-9' < /dev/urandom 2>/dev/null | head -c 4)
  FILE="${CHECKPOINT_DIR}/${TIMESTAMP}-${TITLE_SLUG}-${SUFFIX}.md"
fi
echo "FILE=$FILE"
```

Never overwrite an existing checkpoint — the suffix fallback guarantees uniqueness even on same-second saves.

### 3. Summarize from conversation + git state

Produce the summary from your own conversation memory. Four sections, each crisp:

- **Summary** — 1–3 sentences on the high-level goal and current position
- **Decisions made** — bulleted. Architectural choices, trade-offs, rejected alternatives with reasons
- **Remaining work** — numbered, in priority order. Concrete enough that a future session can pick one up without asking
- **Notes** — gotchas, open questions, things tried that didn't work, external references (issue numbers, memory file names)

### 4. Write the checkpoint file

```markdown
---
status: in-progress
branch: <current-branch>
timestamp: <ISO-8601>
files_modified:
  - <path>
  - <path>
---

## Working on: <title>

### Summary
<1-3 sentences>

### Decisions Made
- <decision 1>

### Remaining Work
1. <step 1>

### Notes
- <note>
```

`files_modified` comes from `git status --short` — relative paths from repo root, both staged and unstaged.

### 5. Confirm

```
CONTEXT SAVED
════════════════════════════════════
Title:    <title>
Branch:   <branch>
File:     <path>
Modified: <N> files
════════════════════════════════════
Resume with /context-restore.
```

## List flow (`/context-save list`)

```bash
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
CHECKPOINT_DIR="$REPO_ROOT/.claude/checkpoints"
if [ -d "$CHECKPOINT_DIR" ]; then
  ls -1t "$CHECKPOINT_DIR"/*.md 2>/dev/null | head -20
else
  echo "NO_CHECKPOINTS"
fi
```

Display a table: date, title (from filename), branch (from frontmatter), status.

## Rules

- Never edit source code in this skill. Capture only.
- Sanitize titles in bash, not in the prompt. User input ≠ shell input.
- Never overwrite an existing checkpoint. Filenames are append-only.
- Checkpoints live in the repo (`.claude/checkpoints/`). Add the dir to `.gitignore` if you don't want them committed — or commit them intentionally as session archaeology.
- If `/context-save` is invoked without active work (clean tree, no conversation context worth saving), tell the user and don't write an empty file.
