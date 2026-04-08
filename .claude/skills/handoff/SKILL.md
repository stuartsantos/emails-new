---
name: handoff
description: Create or update a handoff.md for resuming work in a new session
allowed-tools: Read, Write, Edit, Glob, Bash(git:*)
---

Create or update a `handoff.md` in the current working directory so a new session can pick up where this one left off. Follow every step below.

## 1. Check for an active plan

Look for plan files:

```bash
ls -t .claude/plans/*.md 2>/dev/null | head -1
```

If a plan file exists, read it. Extract:
- The overall goal/approach
- Key decisions and constraints
- Execution steps or task breakdown

If no plan exists, rely on conversation context instead.

## 2. Check for existing handoff

Look for `handoff.md` in the current working directory.

If one exists, read it fully. You will **update** it rather than overwrite — preserve existing sections that are still relevant (rules, asset refs, patterns, variable mappings) and update status/progress entries.

If none exists, you will create a new one.

## 3. Gather git context

Run these to understand what was touched this session:

```bash
git diff --stat
git diff --cached --stat
git log --oneline -20
```

Use this to build a concrete list of files modified or created during the session.

## 4. Synthesize from conversation

From the current session context, collect:

- **What the work is about** — the task, project, or goal
- **Progress** — what's done, in progress, and remaining
- **Decisions & rules** — choices made during the session that affect how remaining work should be done (e.g., "use QA URLs", "follow docx order", "keep content verbatim")
- **File paths** — files modified, created, or referenced
- **Patterns & references** — code patterns, variable mappings, URL templates, asset paths — anything a new session needs to replicate the approach
- **Open questions or blockers** — anything unresolved or flagged for review

## 5. Write or update handoff.md

Use this structure. Adapt section content to the specific work — not every section will always apply.

```markdown
# [Project/Task Name] — Handoff

## Overview
What this work is and why it's being done. If a plan exists, summarize its
approach here (don't duplicate the full plan).

## Status
- [x] completed items
- [ ] remaining items
Use a table if the task list is structured (e.g., templates by market).

## Key Decisions & Rules
Numbered or bulleted list of decisions and rules established during work.
Include the *why* so the next session can judge edge cases.

## Modified Files
Files changed this session with brief notes on what was done.

## Reference Files & Patterns
File paths, code patterns, variable mappings, URL templates, and asset
references needed to continue the work. Include enough detail that the
next session doesn't need to re-derive these.

## Plan File
Path to the plan file in `.claude/plans/` if one exists. The next session
can read this for the full agreed-upon approach.

## Open Questions
Anything unresolved, flagged for review, or needing user input.

## Next Steps
What to do first when resuming. Be specific — name the next item,
the file to work on, and any prep needed.
```

**When updating an existing handoff.md:**
- Update the Status section with current progress
- Append new decisions to Key Decisions & Rules (don't remove existing ones unless superseded)
- Update Modified Files with new changes
- Update Next Steps to reflect current state
- Preserve Reference Files & Patterns content that's still relevant
- Move resolved Open Questions out; add new ones

## 6. Confirm

Tell the user:
- Where the handoff.md was written (path)
- A brief summary of what it contains
- What the next session should do first when resuming
