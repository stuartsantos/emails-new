#!/bin/bash
# =============================================================================
# batch-qa.sh — Batch QA pipeline for HTML email templates
#
# Scans all HTML email templates across brands and runs validation checks.
# Produces a Markdown report with per-file results and a summary.
#
# Usage:
#   ./batch-qa.sh                    # Scan all brands
#   ./batch-qa.sh row                # Scan only row/
#   ./batch-qa.sh tg/us/zurich       # Scan a specific subdirectory
#   ./batch-qa.sh --fix-report       # Regenerate from last scan
#
# Output: .claude/reports/qa-report.md
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPORT_DIR="$PROJECT_DIR/.claude/reports"
REPORT_FILE="$REPORT_DIR/qa-report.md"

mkdir -p "$REPORT_DIR"

# Determine scan target
SCAN_TARGET="${1:-}"
if [[ -n "$SCAN_TARGET" && "$SCAN_TARGET" != "--"* ]]; then
  SCAN_DIR="$PROJECT_DIR/$SCAN_TARGET"
  if [[ ! -d "$SCAN_DIR" ]]; then
    echo "ERROR: Directory not found: $SCAN_DIR" >&2
    exit 1
  fi
  SCAN_LABEL="$SCAN_TARGET"
else
  SCAN_DIR="$PROJECT_DIR"
  SCAN_LABEL="all brands"
fi

# Load exclude list
EXCLUDE_FILE="$PROJECT_DIR/.claude/qa-exclude.txt"
EXCLUDE_LIST=()
if [[ -f "$EXCLUDE_FILE" ]]; then
  while IFS= read -r line; do
    # Skip comments and blank lines, trim leading whitespace
    trimmed=$(echo "$line" | sed 's/^[[:space:]]*//')
    [[ -z "$trimmed" || "$trimmed" == \#* ]] && continue
    EXCLUDE_LIST+=("$trimmed")
  done < "$EXCLUDE_FILE"
fi

# Find all HTML templates (skip non-template dirs)
FILES=$(find "$SCAN_DIR" -name "*.html" \
  -not -path "*/node_modules/*" \
  -not -path "*/build/*" \
  -not -path "*/dist/*" \
  -not -path "*responsive-modular*" \
  -not -path "*/api-testing/*" \
  -not -path "*/.claude/*" \
  -not -path "*/tg/*/aig/*" \
  | sort)

# Filter out excluded files
if [[ ${#EXCLUDE_LIST[@]} -gt 0 ]]; then
  FILTERED=""
  while IFS= read -r FILE_PATH; do
    [[ -z "$FILE_PATH" ]] && continue
    REL="${FILE_PATH#$PROJECT_DIR/}"
    SKIP=false
    for excl in "${EXCLUDE_LIST[@]}"; do
      if [[ "$REL" == "$excl" ]]; then
        SKIP=true
        break
      fi
    done
    if [[ "$SKIP" == false ]]; then
      FILTERED+="$FILE_PATH"$'\n'
    fi
  done <<< "$FILES"
  FILES=$(echo "$FILTERED" | sed '/^$/d')
fi

TOTAL=$(echo "$FILES" | grep -c '.' || true)
if [[ "$TOTAL" -eq 0 ]]; then
  echo "No HTML files found in $SCAN_DIR" >&2
  exit 1
fi
EXCLUDED_COUNT=${#EXCLUDE_LIST[@]}
echo "Excluded $EXCLUDED_COUNT files via .claude/qa-exclude.txt"

# Counters
PASS=0
WARN=0
FAIL=0
TOTAL_ISSUES=0

# Issue category counters
declare -A CATEGORY_COUNTS
CATEGORY_COUNTS=(
  [duplicate_class]=0
  [aig_branding]=0
  [aig_email]=0
  [legacy_vars]=0
  [missing_dark_gmail]=0
  [dark_mode_gotcha]=0
  [missing_body_bg]=0
  [missing_alt]=0
  [relative_img]=0
  [missing_role]=0
  [mso_mismatch]=0
  [env_urls]=0
  [mobile_boxsizing]=0
)

# Temp file for per-file results
RESULTS_TMP=$(mktemp)
trap "rm -f $RESULTS_TMP" EXIT

echo "Scanning $TOTAL templates in $SCAN_LABEL..."

# ---------------------------------------------------------------------------
# Validate each file
# ---------------------------------------------------------------------------
while IFS= read -r FILE_PATH; do
  [[ -z "$FILE_PATH" ]] && continue

  REL_PATH="${FILE_PATH#$PROJECT_DIR/}"
  CONTENT=$(cat "$FILE_PATH")
  FILE_ISSUES=()

  # --- 1. Duplicate class attributes ---
  DUPES=$(echo "$CONTENT" | grep -Pon '<[^>]*\bclass="[^"]*"[^>]*\bclass="[^"]*"' | head -5 || true)
  if [[ -n "$DUPES" ]]; then
    LINES=$(echo "$DUPES" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
    FILE_ISSUES+=("Duplicate class attrs (L$LINES)")
    CATEGORY_COUNTS[duplicate_class]=$(( ${CATEGORY_COUNTS[duplicate_class]} + 1 ))
  fi

  # --- 2. AIG branding ---
  AIG_REFS=$(echo "$CONTENT" | grep -Pion '\bAIG\b(?!\s*Travel\s*Guard)' | head -5 || true)
  if [[ -n "$AIG_REFS" ]]; then
    LINES=$(echo "$AIG_REFS" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
    FILE_ISSUES+=("AIG branding (L$LINES)")
    CATEGORY_COUNTS[aig_branding]=$(( ${CATEGORY_COUNTS[aig_branding]} + 1 ))
  fi

  # --- 3. AIG email domains ---
  AIG_EMAILS=$(echo "$CONTENT" | grep -Pon '@aig\.com' | head -5 || true)
  if [[ -n "$AIG_EMAILS" ]]; then
    LINES=$(echo "$AIG_EMAILS" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
    FILE_ISSUES+=("@aig.com email (L$LINES)")
    CATEGORY_COUNTS[aig_email]=$(( ${CATEGORY_COUNTS[aig_email]} + 1 ))
  fi

  # --- 4. Legacy {Variable} format (strip {{handlebars}} first, then match {SingleBrace}) ---
  OLD_VARS=$(echo "$CONTENT" | sed 's/{{[^}]*}}//g' | grep -Pon '\{[A-Z][a-zA-Z_-]+\}' | head -5 || true)
  if [[ -n "$OLD_VARS" ]]; then
    LINES=$(echo "$OLD_VARS" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
    FILE_ISSUES+=("Legacy {vars} (L$LINES)")
    CATEGORY_COUNTS[legacy_vars]=$(( ${CATEGORY_COUNTS[legacy_vars]} + 1 ))
  fi

  # --- 5/6/7. Dark mode checks ---
  HAS_DARK_MQ=$(echo "$CONTENT" | grep -c 'prefers-color-scheme:\s*dark' || true)
  HAS_OGSC=$(echo "$CONTENT" | grep -c '\[data-ogsc\]' || true)

  if [[ "$HAS_DARK_MQ" -gt 0 ]]; then
    HAS_BODY_BG=$(echo "$CONTENT" | grep -c '\.body-bg' || true)
    if [[ "$HAS_BODY_BG" -eq 0 ]]; then
      FILE_ISSUES+=("Missing .body-bg class")
      CATEGORY_COUNTS[missing_body_bg]=$(( ${CATEGORY_COUNTS[missing_body_bg]} + 1 ))
    fi

    # Exclude preheader <p> elements (small font-size) — dark-text is correct there
    BAD_DARK=$(echo "$CONTENT" | grep -Pon 'class="[^"]*\b(content-bg|dark-text)\b[^"]*"' | {
      while IFS=: read -r linenum rest; do
        LINE_CONTENT=$(echo "$CONTENT" | sed -n "${linenum}p")
        if echo "$LINE_CONTENT" | grep -qP 'font-size:\s*(8|9|10|11)px.*class="dark-text"'; then
          continue
        fi
        echo "${linenum}:${rest}"
      done || true
    } | head -3 || true)
    if [[ -n "$BAD_DARK" ]]; then
      LINES=$(echo "$BAD_DARK" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
      FILE_ISSUES+=("Dark mode gotcha: .content-bg/.dark-text on content area (L$LINES)")
      CATEGORY_COUNTS[dark_mode_gotcha]=$(( ${CATEGORY_COUNTS[dark_mode_gotcha]} + 1 ))
    fi

    if [[ "$HAS_OGSC" -eq 0 ]]; then
      FILE_ISSUES+=("Missing Gmail dark mode [data-ogsc] selectors")
      CATEGORY_COUNTS[missing_dark_gmail]=$(( ${CATEGORY_COUNTS[missing_dark_gmail]} + 1 ))
    fi
  fi

  # --- 8. Missing alt attributes ---
  MISSING_ALT=$(echo "$CONTENT" | grep -Pon '<img\b(?![^>]*\balt\s*=)[^>]*>' | head -5 || true)
  if [[ -n "$MISSING_ALT" ]]; then
    COUNT=$(echo "$MISSING_ALT" | wc -l)
    FILE_ISSUES+=("Missing alt on $COUNT img(s)")
    CATEGORY_COUNTS[missing_alt]=$(( ${CATEGORY_COUNTS[missing_alt]} + 1 ))
  fi

  # --- 9. Relative image paths ---
  REL_IMGS=$(echo "$CONTENT" | grep -Pon '<img\b[^>]*\bsrc="(?!https?://|cid:|data:)[^"]*"' | head -5 || true)
  if [[ -n "$REL_IMGS" ]]; then
    COUNT=$(echo "$REL_IMGS" | wc -l)
    FILE_ISSUES+=("Relative img path ($COUNT)")
    CATEGORY_COUNTS[relative_img]=$(( ${CATEGORY_COUNTS[relative_img]} + 1 ))
  fi

  # --- 10. Tables missing role="presentation" ---
  TABLES_NO_ROLE=$(echo "$CONTENT" | grep -Pon '<table\b(?![^>]*role="presentation")[^>]*>' | head -5 || true)
  if [[ -n "$TABLES_NO_ROLE" ]]; then
    COUNT=$(echo "$TABLES_NO_ROLE" | wc -l)
    FILE_ISSUES+=("Missing role=presentation ($COUNT tables)")
    CATEGORY_COUNTS[missing_role]=$(( ${CATEGORY_COUNTS[missing_role]} + 1 ))
  fi

  # --- 11. Mismatched MSO conditionals ---
  # Count ALL conditional opens and closes (3 variants each):
  # Opens:  <!--[if mso]>, <!--[if !mso]><!-->, <!--[if !mso]-->
  # Closes: <![endif]-->, <!--<![endif]-->, <!--[endif]-->
  MSO_OPEN=$(echo "$CONTENT" | grep -Poc '<!--\[if\s+(!|gte\s+)?mso' || true)
  MSO_CLOSE=$(echo "$CONTENT" | grep -Poc '(<!|<!--)\[endif\]-->' || true)
  if [[ "$MSO_OPEN" -ne "$MSO_CLOSE" ]]; then
    FILE_ISSUES+=("MSO mismatch: $MSO_OPEN opens vs $MSO_CLOSE closes")
    CATEGORY_COUNTS[mso_mismatch]=$(( ${CATEGORY_COUNTS[mso_mismatch]} + 1 ))
  fi

  # --- 12. UAT/QA environment URLs ---
  ENV_URLS=$(echo "$CONTENT" | grep -Pon 'https?://[a-zA-Z0-9._-]*\.(uat|qa)\.[a-zA-Z0-9._-]+' | head -5 || true)
  if [[ -n "$ENV_URLS" ]]; then
    LINES=$(echo "$ENV_URLS" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
    FILE_ISSUES+=("UAT/QA env URL (L$LINES)")
    CATEGORY_COUNTS[env_urls]=$(( ${CATEGORY_COUNTS[env_urls]} + 1 ))
  fi

  # --- 13. Mobile box-sizing ---
  HAS_DISPLAY_BLOCK=$(echo "$CONTENT" | grep -c 'display:\s*block' || true)
  HAS_BOX_SIZING=$(echo "$CONTENT" | grep -c 'box-sizing:\s*border-box' || true)
  if [[ "$HAS_DISPLAY_BLOCK" -gt 0 && "$HAS_BOX_SIZING" -eq 0 ]]; then
    FILE_ISSUES+=("Missing box-sizing:border-box for mobile")
    CATEGORY_COUNTS[mobile_boxsizing]=$(( ${CATEGORY_COUNTS[mobile_boxsizing]} + 1 ))
  fi

  # --- Tally ---
  NUM_ISSUES=${#FILE_ISSUES[@]}
  TOTAL_ISSUES=$(( TOTAL_ISSUES + NUM_ISSUES ))

  if [[ "$NUM_ISSUES" -eq 0 ]]; then
    STATUS="PASS"
    PASS=$(( PASS + 1 ))
  elif [[ "$NUM_ISSUES" -le 2 ]]; then
    STATUS="WARN"
    WARN=$(( WARN + 1 ))
  else
    STATUS="FAIL"
    FAIL=$(( FAIL + 1 ))
  fi

  # Write result line
  if [[ "$NUM_ISSUES" -gt 0 ]]; then
    ISSUE_STR=$(IFS='; '; echo "${FILE_ISSUES[*]}")
    echo "$STATUS|$REL_PATH|$NUM_ISSUES|$ISSUE_STR" >> "$RESULTS_TMP"
  else
    echo "$STATUS|$REL_PATH|0|—" >> "$RESULTS_TMP"
  fi

done <<< "$FILES"

# ---------------------------------------------------------------------------
# Generate Markdown report
# ---------------------------------------------------------------------------
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M UTC")

cat > "$REPORT_FILE" << HEADER
# Email Template QA Report

**Scanned:** $SCAN_LABEL ($TOTAL templates)
**Date:** $TIMESTAMP
**Pass:** $PASS | **Warn:** $WARN | **Fail:** $FAIL | **Total issues:** $TOTAL_ISSUES

## Summary by Issue Type

| Issue | Files Affected | Priority |
|-------|---------------|----------|
HEADER

# Sort categories by count descending and write to report
declare -A PRIORITY_MAP
PRIORITY_MAP=(
  [duplicate_class]="HIGH"
  [aig_branding]="HIGH"
  [aig_email]="HIGH"
  [legacy_vars]="MED"
  [missing_dark_gmail]="MED"
  [dark_mode_gotcha]="HIGH"
  [missing_body_bg]="MED"
  [missing_alt]="MED"
  [relative_img]="MED"
  [missing_role]="LOW"
  [mso_mismatch]="HIGH"
  [env_urls]="HIGH"
  [mobile_boxsizing]="LOW"
)

declare -A LABEL_MAP
LABEL_MAP=(
  [duplicate_class]="Duplicate class attributes"
  [aig_branding]="AIG branding references"
  [aig_email]="@aig.com email domains"
  [legacy_vars]="Legacy {Variable} format"
  [missing_dark_gmail]="Missing Gmail dark mode"
  [dark_mode_gotcha]="Dark mode .content-bg/.dark-text gotcha"
  [missing_body_bg]="Missing .body-bg class"
  [missing_alt]="Missing img alt attributes"
  [relative_img]="Relative image paths"
  [missing_role]="Missing role=presentation"
  [mso_mismatch]="Mismatched MSO conditionals"
  [env_urls]="UAT/QA environment URLs"
  [mobile_boxsizing]="Missing box-sizing for mobile"
)

# Sort by count
for key in $(for k in "${!CATEGORY_COUNTS[@]}"; do echo "${CATEGORY_COUNTS[$k]} $k"; done | sort -rn | awk '{print $2}'); do
  COUNT=${CATEGORY_COUNTS[$key]}
  if [[ "$COUNT" -gt 0 ]]; then
    echo "| ${LABEL_MAP[$key]} | $COUNT | ${PRIORITY_MAP[$key]} |" >> "$REPORT_FILE"
  fi
done

# Per-brand breakdown
cat >> "$REPORT_FILE" << 'SECTION'

## Results by Brand

SECTION

CURRENT_BRAND=""
while IFS='|' read -r STATUS REL_PATH NUM_ISSUES ISSUES; do
  BRAND=$(echo "$REL_PATH" | cut -d/ -f1)

  if [[ "$BRAND" != "$CURRENT_BRAND" ]]; then
    if [[ -n "$CURRENT_BRAND" ]]; then
      echo "" >> "$REPORT_FILE"
    fi
    CURRENT_BRAND="$BRAND"
    BRAND_TOTAL=$(grep -c "^[^|]*|$BRAND/" "$RESULTS_TMP" || true)
    BRAND_PASS=$(grep -c "^PASS|$BRAND/" "$RESULTS_TMP" || true)
    BRAND_FAIL=$(grep -c "^FAIL|$BRAND/" "$RESULTS_TMP" || true)
    BRAND_WARN=$(grep -c "^WARN|$BRAND/" "$RESULTS_TMP" || true)

    echo "### $BRAND/ ($BRAND_TOTAL files: $BRAND_PASS pass, $BRAND_WARN warn, $BRAND_FAIL fail)" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
  fi

  if [[ "$STATUS" == "PASS" ]]; then
    continue  # Only show files with issues
  fi

  ICON="⚠️"
  [[ "$STATUS" == "FAIL" ]] && ICON="❌"

  echo "- $ICON \`$REL_PATH\` — $ISSUES" >> "$REPORT_FILE"

done < "$RESULTS_TMP"

# Files that passed — just list the count
cat >> "$REPORT_FILE" << FOOTER

---

*Generated by batch-qa.sh — run \`.claude/scripts/batch-qa.sh\` to refresh.*
FOOTER

# ---------------------------------------------------------------------------
# Terminal summary
# ---------------------------------------------------------------------------
echo ""
echo "========================================="
echo "  EMAIL TEMPLATE QA REPORT"
echo "========================================="
echo "  Scanned:  $TOTAL templates ($SCAN_LABEL)"
echo "  Pass:     $PASS"
echo "  Warn:     $WARN (1-2 issues)"
echo "  Fail:     $FAIL (3+ issues)"
echo "  Issues:   $TOTAL_ISSUES total"
echo "========================================="
echo ""

# Top issues
echo "Top issues:"
for key in $(for k in "${!CATEGORY_COUNTS[@]}"; do echo "${CATEGORY_COUNTS[$k]} $k"; done | sort -rn | awk '{print $2}'); do
  COUNT=${CATEGORY_COUNTS[$key]}
  if [[ "$COUNT" -gt 0 ]]; then
    printf "  %-40s %d files\n" "${LABEL_MAP[$key]}" "$COUNT"
  fi
done

echo ""
echo "Full report: $REPORT_FILE"
