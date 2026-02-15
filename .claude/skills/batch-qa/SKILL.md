---
name: batch-qa
description: Run QA validation across all HTML email templates and generate a report
allowed-tools: Bash(bash:*), Read, Glob, Grep
---

Run the batch QA pipeline to scan all HTML email templates for common issues.

## 1. Run the scan

Accept an optional directory argument to scope the scan. If no argument is provided, scan all brands.

```bash
bash "$CLAUDE_PROJECT_DIR/.claude/scripts/batch-qa.sh" [directory]
```

Examples:
- `/batch-qa` — scan all brands
- `/batch-qa row` — scan only row/
- `/batch-qa tg/us/zurich` — scan a specific subdirectory
- `/batch-qa expedia` — scan only expedia/

## 2. Read and present the report

Read the generated report:

```
.claude/reports/qa-report.md
```

Present the results to the user with:
- The summary table (pass/warn/fail counts and total issues)
- The issue type breakdown sorted by priority (HIGH first)
- Per-brand highlights — focus on brands with the most FAIL results
- Call out any HIGH priority issues that need immediate attention (duplicate class attrs, AIG branding, MSO mismatches, dark mode gotchas)

## 3. Offer next steps

Based on the results, offer to:
- **Fix a specific brand** — e.g., "Want me to fix the duplicate class attrs across all expedia/ templates?"
- **Fix a specific issue type** — e.g., "Want me to add missing alt tags across all templates?"
- **Deep-dive a single file** — open and review a specific template in detail
- **Compare with previous run** — if a previous report exists, diff the two to show progress

## Notes

- The script skips legacy AIG templates under `tg/*/aig/` — only Zurich templates are scanned
- The script also skips `node_modules/`, `build/`, `api-testing/`, and the component library
- LOW priority issues (missing role=presentation, box-sizing) are informational — don't push fixes unless asked
- HIGH priority issues (AIG branding, duplicate classes, MSO mismatches, dark mode gotchas) should be flagged prominently
