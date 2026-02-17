#!/bin/bash
# =============================================================================
# validate-email-html.sh — Claude Code PostToolUse hook
# Validates HTML email templates after Edit/Write operations.
#
# Checks:
#   1. Duplicate class attributes on elements
#   2. AIG branding references (should be Travel Guard / Zurich)
#   3. Missing dark mode overrides for key classes
#   4. Missing alt attributes on <img> tags
#   5. Relative image paths (should be absolute URLs)
#   6. Layout tables missing role="presentation"
#   7. Mismatched MSO conditional comments
# =============================================================================

set -euo pipefail

# Read hook payload from stdin
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Bail early if no file path or not an HTML file
if [[ -z "$FILE_PATH" || "$FILE_PATH" != *.html ]]; then
  exit 0
fi

# Bail if file doesn't exist (deleted, etc.)
if [[ ! -f "$FILE_PATH" ]]; then
  exit 0
fi

# Skip files in node_modules, build artifacts, component library, legacy AIG templates
case "$FILE_PATH" in
  */node_modules/*|*/build/*|*/dist/*|*responsive-modular-email-templates*|*/api-testing/build/*|*/tg/*/aig/*)
    exit 0
    ;;
esac

# Skip files listed in qa-exclude.txt
EXCLUDE_FILE="${CLAUDE_PROJECT_DIR:-.}/.claude/qa-exclude.txt"
if [[ -f "$EXCLUDE_FILE" ]]; then
  # Get path relative to project dir for matching
  REL_PATH="${FILE_PATH#${CLAUDE_PROJECT_DIR:-.}/}"
  while IFS= read -r line; do
    trimmed=$(echo "$line" | sed 's/^[[:space:]]*//')
    [[ -z "$trimmed" || "$trimmed" == \#* ]] && continue
    if [[ "$REL_PATH" == "$trimmed" ]]; then
      exit 0
    fi
  done < "$EXCLUDE_FILE"
fi

CONTENT=$(cat "$FILE_PATH")
FILENAME=$(basename "$FILE_PATH")
ISSUES=()

# ---------------------------------------------------------------------------
# 1. Duplicate class attributes on the same element
#    e.g. <td class="foo" class="bar"> — email clients handle unpredictably
# ---------------------------------------------------------------------------
DUPES=$(echo "$CONTENT" | grep -Pon '<[^>]*\bclass="[^"]*"[^>]*\bclass="[^"]*"' | head -5 || true)
if [[ -n "$DUPES" ]]; then
  LINES=$(echo "$DUPES" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
  ISSUES+=("DUPLICATE CLASS ATTRS on line(s) $LINES — email clients handle these unpredictably. Merge into a single class attribute.")
fi

# ---------------------------------------------------------------------------
# 2. AIG branding references (rebranding to Travel Guard / Zurich)
# ---------------------------------------------------------------------------
AIG_REFS=$(echo "$CONTENT" | grep -Pion '\bAIG\b(?!\s*Travel\s*Guard)' | head -5 || true)
# Also check for old AIG email domains
AIG_EMAILS=$(echo "$CONTENT" | grep -Pon '@aig\.com' | head -5 || true)
# Check for old AIG variable format {Variable} vs {{handlebars}}
# Strip {{handlebars}} first, then match remaining {SingleBrace} vars
OLD_VARS=$(echo "$CONTENT" | sed 's/{{[^}]*}}//g' | grep -Pon '\{[A-Z][a-zA-Z_-]+\}' | head -5 || true)

if [[ -n "$AIG_REFS" ]]; then
  LINES=$(echo "$AIG_REFS" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
  ISSUES+=("AIG BRANDING on line(s) $LINES — should be 'Travel Guard' or 'Zurich'. See rebranding rules in CLAUDE.md.")
fi
if [[ -n "$AIG_EMAILS" ]]; then
  LINES=$(echo "$AIG_EMAILS" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
  ISSUES+=("AIG EMAIL DOMAIN (@aig.com) on line(s) $LINES — update to @zurich.com.")
fi
if [[ -n "$OLD_VARS" ]]; then
  LINES=$(echo "$OLD_VARS" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
  ISSUES+=("LEGACY VARIABLE FORMAT on line(s) $LINES — convert {Variable} to {{policyDetail-variable}} Handlebars format.")
fi

# ---------------------------------------------------------------------------
# 3. Missing dark mode overrides
#    Check that if template has dark mode media query, key classes exist
# ---------------------------------------------------------------------------
HAS_DARK_MQ=$(echo "$CONTENT" | grep -c 'prefers-color-scheme:\s*dark' || true)
HAS_OGSC=$(echo "$CONTENT" | grep -c '\[data-ogsc\]' || true)

if [[ "$HAS_DARK_MQ" -gt 0 ]]; then
  # Check .body-bg exists for outer container
  HAS_BODY_BG=$(echo "$CONTENT" | grep -c '\.body-bg' || true)
  if [[ "$HAS_BODY_BG" -eq 0 ]]; then
    ISSUES+=("MISSING DARK MODE CLASS — template has dark mode media query but no .body-bg class. Add .body-bg to the outer email container for dark mode background support.")
  fi
  # Warn if .content-bg or .dark-text on content areas (the gotcha from CLAUDE.md)
  # Exclude preheader <p> elements (font-size: 10px) — dark-text is correct there since
  # preheader sits on the outer #f1f6fb body background, not white content areas.
  BAD_DARK=$(echo "$CONTENT" | grep -Pon 'class="[^"]*\b(content-bg|dark-text)\b[^"]*"' | {
    while IFS=: read -r linenum rest; do
      LINE_CONTENT=$(echo "$CONTENT" | sed -n "${linenum}p")
      # Skip preheader rows: small font-size <p> on the body background is valid dark-text usage
      if echo "$LINE_CONTENT" | grep -qP 'font-size:\s*(8|9|10|11)px.*class="dark-text"'; then
        continue
      fi
      echo "${linenum}:${rest}"
    done || true
  } | head -3 || true)
  if [[ -n "$BAD_DARK" ]]; then
    LINES=$(echo "$BAD_DARK" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
    ISSUES+=("DARK MODE GOTCHA on line(s) $LINES — .content-bg/.dark-text should NOT be on white content areas (turns them dark gray). Only use on outer body area elements.")
  fi
fi

if [[ "$HAS_DARK_MQ" -gt 0 && "$HAS_OGSC" -eq 0 ]]; then
  ISSUES+=("MISSING GMAIL DARK MODE — template has prefers-color-scheme:dark but no [data-ogsc] selectors for Gmail dark mode support.")
fi

# ---------------------------------------------------------------------------
# 4. Missing alt attributes on <img> tags
# ---------------------------------------------------------------------------
MISSING_ALT=$(echo "$CONTENT" | grep -Pon '<img\b(?![^>]*\balt\s*=)[^>]*>' | head -5 || true)
if [[ -n "$MISSING_ALT" ]]; then
  LINES=$(echo "$MISSING_ALT" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
  ISSUES+=("MISSING ALT ATTR on <img> at line(s) $LINES — all images must have alt attributes for accessibility. Use alt=\"\" for decorative images.")
fi

# ---------------------------------------------------------------------------
# 5. Relative image paths (should be absolute URLs starting with http)
# ---------------------------------------------------------------------------
REL_IMGS=$(echo "$CONTENT" | grep -Pon '<img\b[^>]*\bsrc="(?!https?://|cid:|data:)[^"]*"' | head -5 || true)
if [[ -n "$REL_IMGS" ]]; then
  LINES=$(echo "$REL_IMGS" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
  ISSUES+=("RELATIVE IMAGE PATH on line(s) $LINES — image src must use absolute URLs (https://...) for email client compatibility.")
fi

# ---------------------------------------------------------------------------
# 6. Layout tables missing role="presentation"
#    Skip tables that look like data tables (have <th> elements)
# ---------------------------------------------------------------------------
# Count tables without role="presentation" — but only layout tables
# Strip CSS comments (/* ... */) and HTML comments (<!-- ... -->) first to avoid false positives
STRIPPED_CONTENT=$(echo "$CONTENT" | sed '/\/\*/,/\*\//d' | sed '/<!--/,/-->/{ /<!--.*-->/!d; }')
TABLES_NO_ROLE=$(echo "$STRIPPED_CONTENT" | grep -Pon '<table\b(?![^>]*role="presentation")[^>]*>' | head -5 || true)
if [[ -n "$TABLES_NO_ROLE" ]]; then
  LINES=$(echo "$TABLES_NO_ROLE" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
  ISSUES+=("MISSING role=\"presentation\" on <table> at line(s) $LINES — all layout tables need role=\"presentation\" for accessibility.")
fi

# ---------------------------------------------------------------------------
# 7. Mismatched MSO conditional comments
#    Count ALL conditional comment opens and closes:
#    Opens:  <!--[if mso]>, <!--[if !mso]><!-->, <!--[if !mso]-->, <!--[if gte mso X]>
#    Closes: <![endif]-->, <!--<![endif]-->, <!--[endif]-->
# ---------------------------------------------------------------------------
MSO_OPEN=$(echo "$CONTENT" | grep -Poc '<!--\[if\s+(!|gte\s+)?mso' || true)
MSO_CLOSE=$(echo "$CONTENT" | grep -Poc '(<!|<!--)\[endif\]-->' || true)
if [[ "$MSO_OPEN" -ne "$MSO_CLOSE" ]]; then
  ISSUES+=("MISMATCHED MSO CONDITIONALS — found $MSO_OPEN opening <!--[if (!)mso]> but $MSO_CLOSE closing <![endif]--> comments. Check for unclosed or extra MSO conditional blocks.")
fi

# ---------------------------------------------------------------------------
# 8. UAT/QA environment URLs (should be production URLs)
# ---------------------------------------------------------------------------
ENV_URLS=$(echo "$CONTENT" | grep -Pon 'https?://[a-zA-Z0-9._-]*\.(uat|qa)\.[a-zA-Z0-9._-]+' | head -5 || true)
if [[ -n "$ENV_URLS" ]]; then
  LINES=$(echo "$ENV_URLS" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//')
  ISSUES+=("UAT/QA ENVIRONMENT URL on line(s) $LINES — template contains non-production URLs. Replace with production URLs before shipping.")
fi

# ---------------------------------------------------------------------------
# 9. Bonus: missing box-sizing on mobile responsive blocks
# ---------------------------------------------------------------------------
HAS_DISPLAY_BLOCK=$(echo "$CONTENT" | grep -c 'display:\s*block' || true)
HAS_BOX_SIZING=$(echo "$CONTENT" | grep -c 'box-sizing:\s*border-box' || true)
if [[ "$HAS_DISPLAY_BLOCK" -gt 0 && "$HAS_BOX_SIZING" -eq 0 ]]; then
  ISSUES+=("MOBILE RESPONSIVE GOTCHA — template uses display:block but may be missing box-sizing:border-box. Add box-sizing:border-box !important to elements converted to display:block on mobile to prevent horizontal overflow.")
fi

# ---------------------------------------------------------------------------
# Report results
# ---------------------------------------------------------------------------
if [[ ${#ISSUES[@]} -eq 0 ]]; then
  exit 0
fi

# Build output — use JSON for structured feedback to Claude
ISSUE_TEXT=""
for i in "${!ISSUES[@]}"; do
  ISSUE_TEXT+="$((i+1)). ${ISSUES[$i]}\n"
done

ESCAPED_ISSUES=$(printf '%s' "$ISSUE_TEXT" | jq -Rs '.')

cat <<ENDJSON
{
  "decision": "block",
  "reason": "Email template validation found ${#ISSUES[@]} issue(s) in $FILENAME:\n\n$(printf '%s' "$ISSUE_TEXT" | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')"
}
ENDJSON

exit 0
