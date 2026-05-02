#!/bin/bash
# =============================================================================
# batch-qa.sh — Batch QA pipeline for HTML email templates
#
# Scans all HTML email templates across brands and runs validation checks.
# Produces a Markdown report with per-file results and a summary.
#
# Compatible with macOS bash 3.2 + BSD grep (no GNU grep -P required).
# Uses perl for PCRE patterns instead of grep -P.
#
# Usage:
#   ./batch-qa.sh                    # Scan all brands
#   ./batch-qa.sh row                # Scan only row/
#   ./batch-qa.sh tg/us/zurich       # Scan a specific subdirectory
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
  -not -path "$SCAN_DIR/.claude/*" \
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
CAT_duplicate_class=0
CAT_aig_branding=0
CAT_aig_email=0
CAT_legacy_vars=0
CAT_missing_dark_gmail=0
CAT_dark_mode_gotcha=0
CAT_missing_body_bg=0
CAT_missing_alt=0
CAT_relative_img=0
CAT_missing_role=0
CAT_mso_mismatch=0
CAT_env_urls=0
CAT_mobile_boxsizing=0
CAT_missing_preheader_padding=0

# Temp file for per-file results
RESULTS_TMP=$(mktemp)
trap "rm -f $RESULTS_TMP" EXIT

echo "Scanning $TOTAL templates in $SCAN_LABEL..."

# ---------------------------------------------------------------------------
# Helper: perl-based line-number grep (replaces grep -Pon)
# Usage: pgrep_lines PATTERN "$CONTENT"
# Output: linenum:match (like grep -Pon)
# ---------------------------------------------------------------------------
pgrep_lines() {
  local pattern="$1"
  echo "$2" | perl -sne 'if (/$pat/) { print "$.:$&\n" }' -- -pat="$pattern" 2>/dev/null | head -5
}

# Helper: perl-based count (replaces grep -Poc)
pgrep_count() {
  local pattern="$1"
  echo "$2" | perl -sne '$c++ while /$pat/g; END { print $c+0 }' -- -pat="$pattern" 2>/dev/null
}

# Helper: perl-based case-insensitive line grep (replaces grep -Pion)
pgrep_lines_i() {
  local pattern="$1"
  echo "$2" | perl -sne 'if (/$pat/i) { print "$.:$&\n" }' -- -pat="$pattern" 2>/dev/null | head -5
}

# ---------------------------------------------------------------------------
# Validate each file
# ---------------------------------------------------------------------------
while IFS= read -r FILE_PATH; do
  [[ -z "$FILE_PATH" ]] && continue

  REL_PATH="${FILE_PATH#$PROJECT_DIR/}"
  CONTENT=$(cat "$FILE_PATH")
  FILE_ISSUES=()

  # --- 1. Duplicate class attributes ---
  DUPES=$(pgrep_lines '<[^>]*\bclass="[^"]*"[^>]*\bclass="[^"]*"' "$CONTENT")
  if [[ -n "$DUPES" ]]; then
    LINES=$(echo "$DUPES" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
    FILE_ISSUES+=("Duplicate class attrs (L$LINES)")
    CAT_duplicate_class=$(( CAT_duplicate_class + 1 ))
  fi

  # --- 2. AIG branding ---
  AIG_REFS=$(pgrep_lines_i '\bAIG\b(?!\s*Travel\s*Guard)' "$CONTENT")
  if [[ -n "$AIG_REFS" ]]; then
    LINES=$(echo "$AIG_REFS" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
    FILE_ISSUES+=("AIG branding (L$LINES)")
    CAT_aig_branding=$(( CAT_aig_branding + 1 ))
  fi

  # --- 3. AIG email domains ---
  AIG_EMAILS=$(pgrep_lines '@aig\.com' "$CONTENT")
  if [[ -n "$AIG_EMAILS" ]]; then
    LINES=$(echo "$AIG_EMAILS" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
    FILE_ISSUES+=("@aig.com email (L$LINES)")
    CAT_aig_email=$(( CAT_aig_email + 1 ))
  fi

  # --- 4. Legacy {Variable} format ---
  CONTENT_NO_HBS=$(echo "$CONTENT" | sed 's/{{[^}]*}}//g')
  OLD_VARS=$(pgrep_lines '\{[A-Z][a-zA-Z_-]+\}' "$CONTENT_NO_HBS")
  if [[ -n "$OLD_VARS" ]]; then
    LINES=$(echo "$OLD_VARS" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
    FILE_ISSUES+=("Legacy {vars} (L$LINES)")
    CAT_legacy_vars=$(( CAT_legacy_vars + 1 ))
  fi

  # --- 5/6/7. Dark mode checks ---
  HAS_DARK_MQ=$(echo "$CONTENT" | grep -c 'prefers-color-scheme' || true)
  HAS_OGSC=$(echo "$CONTENT" | grep -c '\[data-ogsc\]' || true)

  if [[ "$HAS_DARK_MQ" -gt 0 ]]; then
    HAS_BODY_BG=$(echo "$CONTENT" | grep -c '\.body-bg' || true)
    if [[ "$HAS_BODY_BG" -eq 0 ]]; then
      FILE_ISSUES+=("Missing .body-bg class")
      CAT_missing_body_bg=$(( CAT_missing_body_bg + 1 ))
    fi

    # Check for .content-bg or .dark-text on content areas (not preheader small text)
    # Uses a 5-line sliding window to catch multi-line tags where font-size and
    # class="dark-text" are on separate lines of the same element.
    BAD_DARK=$(echo "$CONTENT" | perl -ne '
      push @win, $_;
      shift @win if @win > 5;
      if (/class="[^"]*\b(content-bg|dark-text)\b[^"]*"/) {
        # Skip if font-size 8-11px appears nearby (same element, multi-line tag)
        $ctx = join("", @win);
        next if $ctx =~ /font-size:\s*(8|9|10|11)px/;
        # Also skip preheader div area (display:none + max-height:0)
        next if $ctx =~ /display:\s*none.*max-height:\s*0/s;
        print "$.:$&\n";
      }
    ' 2>/dev/null | head -3 || true)
    if [[ -n "$BAD_DARK" ]]; then
      LINES=$(echo "$BAD_DARK" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
      FILE_ISSUES+=("Dark mode gotcha: .content-bg/.dark-text on content area (L$LINES)")
      CAT_dark_mode_gotcha=$(( CAT_dark_mode_gotcha + 1 ))
    fi

    if [[ "$HAS_OGSC" -eq 0 ]]; then
      FILE_ISSUES+=("Missing Gmail dark mode [data-ogsc] selectors")
      CAT_missing_dark_gmail=$(( CAT_missing_dark_gmail + 1 ))
    fi
  fi

  # --- 8. Missing alt attributes ---
  MISSING_ALT=$(echo "$CONTENT" | perl -ne 'if (/<img\b(?![^>]*\balt\s*=)[^>]*>/) { print "$.:$&\n" }' 2>/dev/null | head -5 || true)
  if [[ -n "$MISSING_ALT" ]]; then
    COUNT=$(echo "$MISSING_ALT" | wc -l | tr -d ' ')
    FILE_ISSUES+=("Missing alt on $COUNT img(s)")
    CAT_missing_alt=$(( CAT_missing_alt + 1 ))
  fi

  # --- 9. Relative image paths ---
  REL_IMGS=$(echo "$CONTENT" | perl -ne 'if (/<img\b[^>]*\bsrc="(?!https?:\/\/|cid:|data:)[^"]*"/) { print "$.:$&\n" }' 2>/dev/null | head -5 || true)
  if [[ -n "$REL_IMGS" ]]; then
    COUNT=$(echo "$REL_IMGS" | wc -l | tr -d ' ')
    FILE_ISSUES+=("Relative img path ($COUNT)")
    CAT_relative_img=$(( CAT_relative_img + 1 ))
  fi

  # --- 10. Tables missing role="presentation" ---
  # Track multi-line CSS comment blocks (/* ... */) and HTML comments (<!-- ... -->)
  TABLES_NO_ROLE=$(echo "$CONTENT" | perl -ne '
    if ($in_css) { $in_css = 0 if m{\*/}; next }
    if (m{/\*} && !m{\*/}) { $in_css = 1; next }
    if ($in_html) { $in_html = 0 if /-->/; next }
    if (/<!--/ && !/-->/) { $in_html = 1; next }
    if (/<table\b(?![^>]*role="presentation")[^>]*>/) { print "$.:$&\n" }
  ' 2>/dev/null | head -5 || true)
  if [[ -n "$TABLES_NO_ROLE" ]]; then
    COUNT=$(echo "$TABLES_NO_ROLE" | wc -l | tr -d ' ')
    FILE_ISSUES+=("Missing role=presentation ($COUNT tables)")
    CAT_missing_role=$(( CAT_missing_role + 1 ))
  fi

  # --- 11. Mismatched MSO conditionals ---
  MSO_OPEN=$(pgrep_count '<!--\[if\s+(!|gte\s+)?mso' "$CONTENT")
  MSO_CLOSE=$(pgrep_count '(<!|<!--)\[endif\]-->' "$CONTENT")
  if [[ "$MSO_OPEN" -ne "$MSO_CLOSE" ]]; then
    FILE_ISSUES+=("MSO mismatch: $MSO_OPEN opens vs $MSO_CLOSE closes")
    CAT_mso_mismatch=$(( CAT_mso_mismatch + 1 ))
  fi

  # --- 12. UAT/QA environment URLs ---
  ENV_URLS=$(pgrep_lines 'https?:\/\/[a-zA-Z0-9._-]*\.(uat|qa)\.[a-zA-Z0-9._-]+' "$CONTENT")
  if [[ -n "$ENV_URLS" ]]; then
    LINES=$(echo "$ENV_URLS" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
    FILE_ISSUES+=("UAT/QA env URL (L$LINES)")
    CAT_env_urls=$(( CAT_env_urls + 1 ))
  fi

  # --- 13. Mobile box-sizing ---
  HAS_DISPLAY_BLOCK=$(echo "$CONTENT" | grep -c 'display:.*block' || true)
  HAS_BOX_SIZING=$(echo "$CONTENT" | grep -c 'box-sizing:.*border-box' || true)
  if [[ "$HAS_DISPLAY_BLOCK" -gt 0 && "$HAS_BOX_SIZING" -eq 0 ]]; then
    FILE_ISSUES+=("Missing box-sizing:border-box for mobile")
    CAT_mobile_boxsizing=$(( CAT_mobile_boxsizing + 1 ))
  fi

  # --- 14. Preheader missing &zwnj;&nbsp; padding ---
  HAS_PREHEADER=$(echo "$CONTENT" | perl -0777 -ne 'print "1" if /<div[^>]*display:\s*none[^>]*max-height:\s*0[^>]*>.*?<\/div>/s' 2>/dev/null || true)
  if [[ -n "$HAS_PREHEADER" ]]; then
    HAS_ZWNJ=$(echo "$CONTENT" | perl -0777 -ne 'if (/<div[^>]*display:\s*none[^>]*max-height:\s*0[^>]*>(.*?)<\/div>/s) { print "1" if $1 =~ /zwnj/ }' 2>/dev/null || true)
    if [[ -z "$HAS_ZWNJ" ]]; then
      FILE_ISSUES+=("Missing preheader &zwnj;&nbsp; padding")
      CAT_missing_preheader_padding=$(( CAT_missing_preheader_padding + 1 ))
    fi
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

# Build issue summary rows: count|key|label|priority
ISSUE_ROWS=""
for entry in \
  "${CAT_duplicate_class}|duplicate_class|Duplicate class attributes|HIGH" \
  "${CAT_aig_branding}|aig_branding|AIG branding references|HIGH" \
  "${CAT_aig_email}|aig_email|@aig.com email domains|HIGH" \
  "${CAT_legacy_vars}|legacy_vars|Legacy {Variable} format|MED" \
  "${CAT_missing_dark_gmail}|missing_dark_gmail|Missing Gmail dark mode|MED" \
  "${CAT_dark_mode_gotcha}|dark_mode_gotcha|Dark mode .content-bg/.dark-text gotcha|HIGH" \
  "${CAT_missing_body_bg}|missing_body_bg|Missing .body-bg class|MED" \
  "${CAT_missing_alt}|missing_alt|Missing img alt attributes|MED" \
  "${CAT_relative_img}|relative_img|Relative image paths|MED" \
  "${CAT_missing_role}|missing_role|Missing role=presentation|LOW" \
  "${CAT_mso_mismatch}|mso_mismatch|Mismatched MSO conditionals|HIGH" \
  "${CAT_env_urls}|env_urls|UAT/QA environment URLs|HIGH" \
  "${CAT_mobile_boxsizing}|mobile_boxsizing|Missing box-sizing for mobile|LOW" \
  "${CAT_missing_preheader_padding}|missing_preheader_padding|Missing preheader zwnj padding|LOW"; do
  CNT=$(echo "$entry" | cut -d'|' -f1)
  if [[ "$CNT" -gt 0 ]]; then
    ISSUE_ROWS+="${entry}"$'\n'
  fi
done

# Sort by count descending and write to report
echo "$ISSUE_ROWS" | sed '/^$/d' | sort -t'|' -k1 -rn | while IFS='|' read -r CNT KEY LABEL PRIORITY; do
  echo "| $LABEL | $CNT | $PRIORITY |" >> "$REPORT_FILE"
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
    continue
  fi

  ICON="⚠️"
  [[ "$STATUS" == "FAIL" ]] && ICON="❌"

  echo "- $ICON \`$REL_PATH\` — $ISSUES" >> "$REPORT_FILE"

done < "$RESULTS_TMP"

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

echo "Top issues:"
echo "$ISSUE_ROWS" | sed '/^$/d' | sort -t'|' -k1 -rn | while IFS='|' read -r CNT KEY LABEL PRIORITY; do
  printf "  %-40s %d files\n" "$LABEL" "$CNT"
done

echo ""
echo "Full report: $REPORT_FILE"
