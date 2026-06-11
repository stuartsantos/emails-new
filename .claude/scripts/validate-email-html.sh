#!/bin/bash
# =============================================================================
# validate-email-html.sh — Claude Code PostToolUse hook
# Validates HTML email templates after Edit/Write operations.
#
# Compatible with macOS bash 3.2 + BSD grep (no GNU grep -P required).
# Uses perl for PCRE patterns instead of grep -P — hooks run with
# /usr/bin/grep (BSD), which silently fails on -P.
#
# Checks:
#   1. Duplicate class attributes on elements
#   2. AIG branding references (should be Travel Guard / Zurich)
#   3. Missing dark mode overrides for key classes
#   4. Missing alt attributes on <img> tags
#   5. Relative image paths (should be absolute URLs)
#   6. Layout tables missing role="presentation"
#   7. Mismatched MSO conditional comments
#   8. UAT/QA environment URLs
#   9. Missing box-sizing on mobile responsive blocks
#  10. Preheader missing &zwnj;&nbsp; padding
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
  */node_modules/*|*/build/*|*/dist/*|*responsive-modular-email-templates*|*/tg/*/aig/*)
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
# Helpers: perl-based PCRE matching (same as batch-qa.sh)
# ---------------------------------------------------------------------------

# Line-number grep (replaces grep -Pon). Output: linenum:match
pgrep_lines() {
  local pattern="$1"
  echo "$2" | perl -sne 'if (/$pat/) { print "$.:$&\n" }' -- -pat="$pattern" 2>/dev/null | head -5
}

# Case-insensitive line grep (replaces grep -Pion)
pgrep_lines_i() {
  local pattern="$1"
  echo "$2" | perl -sne 'if (/$pat/i) { print "$.:$&\n" }' -- -pat="$pattern" 2>/dev/null | head -5
}

# Match count (replaces grep -Poc)
pgrep_count() {
  local pattern="$1"
  echo "$2" | perl -sne '$c++ while /$pat/g; END { print $c+0 }' -- -pat="$pattern" 2>/dev/null
}

# Comma-joined line numbers from pgrep output
issue_lines() {
  echo "$1" | cut -d: -f1 | tr '\n' ', ' | sed 's/,$//'
}

# ---------------------------------------------------------------------------
# 1. Duplicate class attributes on the same element
#    e.g. <td class="foo" class="bar"> — email clients handle unpredictably
# ---------------------------------------------------------------------------
DUPES=$(pgrep_lines '<[^>]*\bclass="[^"]*"[^>]*\bclass="[^"]*"' "$CONTENT")
if [[ -n "$DUPES" ]]; then
  ISSUES+=("DUPLICATE CLASS ATTRS on line(s) $(issue_lines "$DUPES") — email clients handle these unpredictably. Merge into a single class attribute.")
fi

# ---------------------------------------------------------------------------
# 2. AIG branding references (rebranding to Travel Guard / Zurich)
# ---------------------------------------------------------------------------
AIG_REFS=$(pgrep_lines_i '\bAIG\b(?!\s*Travel\s*Guard)' "$CONTENT")
# Also check for old AIG email domains
AIG_EMAILS=$(pgrep_lines '@aig\.com' "$CONTENT")
# Check for old AIG variable format {Variable} vs {{handlebars}}
# Strip {{handlebars}} first, then match remaining {SingleBrace} vars
OLD_VARS=$(pgrep_lines '\{[A-Z][a-zA-Z_-]+\}' "$(echo "$CONTENT" | sed 's/{{[^}]*}}//g')")

if [[ -n "$AIG_REFS" ]]; then
  ISSUES+=("AIG BRANDING on line(s) $(issue_lines "$AIG_REFS") — should be 'Travel Guard' or 'Zurich'. See rebranding rules in CLAUDE.md.")
fi
if [[ -n "$AIG_EMAILS" ]]; then
  ISSUES+=("AIG EMAIL DOMAIN (@aig.com) on line(s) $(issue_lines "$AIG_EMAILS") — update to @zurich.com.")
fi
if [[ -n "$OLD_VARS" ]]; then
  ISSUES+=("LEGACY VARIABLE FORMAT on line(s) $(issue_lines "$OLD_VARS") — convert {Variable} to {{policyDetail-variable}} Handlebars format.")
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
    ISSUES+=("DARK MODE GOTCHA on line(s) $(issue_lines "$BAD_DARK") — .content-bg/.dark-text should NOT be on white content areas (turns them dark gray). Only use on outer body area elements.")
  fi
fi

if [[ "$HAS_DARK_MQ" -gt 0 && "$HAS_OGSC" -eq 0 ]]; then
  ISSUES+=("MISSING GMAIL DARK MODE — template has prefers-color-scheme:dark but no [data-ogsc] selectors for Gmail dark mode support.")
fi

# ---------------------------------------------------------------------------
# 4. Missing alt attributes on <img> tags
# ---------------------------------------------------------------------------
MISSING_ALT=$(pgrep_lines '<img\b(?![^>]*\balt\s*=)[^>]*>' "$CONTENT")
if [[ -n "$MISSING_ALT" ]]; then
  ISSUES+=("MISSING ALT ATTR on <img> at line(s) $(issue_lines "$MISSING_ALT") — all images must have alt attributes for accessibility. Use alt=\"\" for decorative images.")
fi

# ---------------------------------------------------------------------------
# 5. Relative image paths (should be absolute URLs starting with http)
# ---------------------------------------------------------------------------
REL_IMGS=$(pgrep_lines '<img\b[^>]*\bsrc="(?!https?:\/\/|cid:|data:)[^"]*"' "$CONTENT")
if [[ -n "$REL_IMGS" ]]; then
  ISSUES+=("RELATIVE IMAGE PATH on line(s) $(issue_lines "$REL_IMGS") — image src must use absolute URLs (https://...) for email client compatibility.")
fi

# ---------------------------------------------------------------------------
# 6. Layout tables missing role="presentation"
#    Skip <table> matches inside CSS comments (/* ... */) and HTML comments
# ---------------------------------------------------------------------------
TABLES_NO_ROLE=$(echo "$CONTENT" | perl -ne '
  if ($in_css) { $in_css = 0 if m{\*/}; next }
  if (m{/\*} && !m{\*/}) { $in_css = 1; next }
  if ($in_html) { $in_html = 0 if /-->/; next }
  if (/<!--/ && !/-->/) { $in_html = 1; next }
  if (/<table\b(?![^>]*role="presentation")[^>]*>/) { print "$.:$&\n" }
' 2>/dev/null | head -5 || true)
if [[ -n "$TABLES_NO_ROLE" ]]; then
  ISSUES+=("MISSING role=\"presentation\" on <table> at line(s) $(issue_lines "$TABLES_NO_ROLE") — all layout tables need role=\"presentation\" for accessibility.")
fi

# ---------------------------------------------------------------------------
# 7. Mismatched MSO conditional comments
#    Count ALL conditional comment opens and closes:
#    Opens:  <!--[if mso]>, <!--[if !mso]><!-->, <!--[if !mso]-->, <!--[if gte mso X]>
#    Closes: <![endif]-->, <!--<![endif]-->, <!--[endif]-->
# ---------------------------------------------------------------------------
MSO_OPEN=$(pgrep_count '<!--\[if\s+(!|gte\s+)?mso' "$CONTENT")
MSO_CLOSE=$(pgrep_count '(<!|<!--)\[endif\]-->' "$CONTENT")
if [[ "${MSO_OPEN:-0}" -ne "${MSO_CLOSE:-0}" ]]; then
  ISSUES+=("MISMATCHED MSO CONDITIONALS — found $MSO_OPEN opening <!--[if (!)mso]> but $MSO_CLOSE closing <![endif]--> comments. Check for unclosed or extra MSO conditional blocks.")
fi

# ---------------------------------------------------------------------------
# 8. UAT/QA environment URLs (should be production URLs)
# ---------------------------------------------------------------------------
ENV_URLS=$(pgrep_lines 'https?:\/\/[a-zA-Z0-9._-]*\.(uat|qa)\.[a-zA-Z0-9._-]+' "$CONTENT")
if [[ -n "$ENV_URLS" ]]; then
  ISSUES+=("UAT/QA ENVIRONMENT URL on line(s) $(issue_lines "$ENV_URLS") — template contains non-production URLs. Replace with production URLs before shipping.")
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
# 10. Preheader missing &zwnj;&nbsp; padding
#     The hidden preheader div should contain &zwnj;&nbsp; repeated ~20 times
#     to prevent email clients from pulling body content into preview snippet.
# ---------------------------------------------------------------------------
# Find preheader divs (display:none with max-height:0 — standard preheader pattern)
HAS_PREHEADER=$(echo "$CONTENT" | perl -0777 -ne 'print "1" if /<div[^>]*display:\s*none[^>]*max-height:\s*0[^>]*>.*?<\/div>/s' 2>/dev/null || true)
if [[ -n "$HAS_PREHEADER" ]]; then
  HAS_ZWNJ=$(echo "$CONTENT" | perl -0777 -ne 'if (/<div[^>]*display:\s*none[^>]*max-height:\s*0[^>]*>(.*?)<\/div>/s) { print "1" if $1 =~ /zwnj/ }' 2>/dev/null || true)
  if [[ -z "$HAS_ZWNJ" ]]; then
    ISSUES+=("MISSING PREHEADER PADDING — preheader div should include &zwnj;&nbsp; padding (20 repetitions) after text to prevent email clients from pulling body content into preview snippet.")
  fi
fi

# ---------------------------------------------------------------------------
# Report results
# ---------------------------------------------------------------------------
if [[ ${#ISSUES[@]} -eq 0 ]]; then
  exit 0
fi

REASON="Email template validation found ${#ISSUES[@]} issue(s) in $FILENAME:"$'\n'
for i in "${!ISSUES[@]}"; do
  REASON+=$'\n'"$((i+1)). ${ISSUES[$i]}"
done

jq -n --arg reason "$REASON" '{decision: "block", reason: $reason}'

exit 0
