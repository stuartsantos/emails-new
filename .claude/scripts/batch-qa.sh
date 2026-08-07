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
# PERFORMANCE NOTE (Aug 2026):
#   This script used to shell out ~100 times per file (a perl/grep/sed/cut/tr
#   pipeline per check). That is fine on macOS, where a spawn costs ~1ms, but
#   on Windows Git Bash a spawn costs ~230ms — measured here, and worse again
#   inside a OneDrive-synced folder where sync and AV hooks fire on every exec.
#   A full 158-template scan took ~90 minutes and was routinely killed by the
#   2-minute tool timeout, which looked like a hang rather than a slow run.
#
#   All 14 checks now run inside ONE perl process for the ENTIRE scan, which
#   also writes the report. Total spawns for a full run: a handful, not ~16000.
#   The checks, their order, the issue strings and the report format are all
#   byte-for-byte identical to the previous version — only the process count
#   changed. If you add a check, add it inside the perl block; do not
#   reintroduce a per-file pipeline.
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

# Load exclude list.
# Leading whitespace is trimmed with parameter expansion rather than a sed
# subprocess per line — same result, no spawns.
EXCLUDE_FILE="$PROJECT_DIR/.claude/qa-exclude.txt"
EXCLUDE_LIST=()
if [[ -f "$EXCLUDE_FILE" ]]; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    trimmed="${line#"${line%%[![:space:]]*}"}"
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

# Filter out excluded files (pure bash, no spawns)
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
  FILES="${FILTERED%$'\n'}"
fi

if [[ -z "$FILES" ]]; then
  echo "No HTML files found in $SCAN_DIR" >&2
  exit 1
fi

EXCLUDED_COUNT=${#EXCLUDE_LIST[@]}
echo "Excluded $EXCLUDED_COUNT files via .claude/qa-exclude.txt"

# Count without spawning: one line per file
TOTAL=0
while IFS= read -r _l; do
  [[ -n "$_l" ]] && TOTAL=$(( TOTAL + 1 ))
done <<< "$FILES"

echo "Scanning $TOTAL templates in $SCAN_LABEL..."

SUMMARY_TMP=$(mktemp)
FILELIST_TMP=$(mktemp)
trap 'rm -f "$SUMMARY_TMP" "$FILELIST_TMP"' EXIT

printf '%s\n' "$FILES" > "$FILELIST_TMP"

# ---------------------------------------------------------------------------
# Single perl pass: runs all 14 checks over every file and writes the report.
#
# The program itself arrives on stdin via the heredoc (`perl -`), so the file
# list CANNOT also come in on stdin — it is passed as a path and opened below.
# Writes the Markdown report to $REPORT_FILE and a shell-sourceable summary
# (counters + preformatted "Top issues" lines) to $SUMMARY_TMP.
# ---------------------------------------------------------------------------
perl - "$PROJECT_DIR" "$REPORT_FILE" "$SUMMARY_TMP" "$SCAN_LABEL" "$TOTAL" "$FILELIST_TMP" <<'PERL_EOF'
use strict;
use warnings;

my ($project_dir, $report_file, $summary_file, $scan_label, $total, $filelist) = @ARGV;

open(my $lf, '<', $filelist) or die "Cannot read file list $filelist: $!";

# Issue categories, in report-table order. Each counts FILES affected, not
# occurrences — one increment per file, matching the original behaviour.
my @cat_order = (
  ['duplicate_class',          'Duplicate class attributes',              'HIGH'],
  ['aig_branding',             'AIG branding references',                 'HIGH'],
  ['aig_email',                '@aig.com email domains',                  'HIGH'],
  ['legacy_vars',              'Legacy {Variable} format',                'MED'],
  ['missing_dark_gmail',       'Missing Gmail dark mode',                 'MED'],
  ['dark_mode_gotcha',         'Dark mode .content-bg/.dark-text gotcha',  'HIGH'],
  ['missing_body_bg',          'Missing .body-bg class',                  'MED'],
  ['missing_alt',              'Missing img alt attributes',              'MED'],
  ['relative_img',             'Relative image paths',                    'MED'],
  ['missing_role',             'Missing role=presentation',               'LOW'],
  ['mso_mismatch',             'Mismatched MSO conditionals',             'HIGH'],
  ['env_urls',                 'UAT/QA environment URLs',                 'HIGH'],
  ['mobile_boxsizing',         'Missing box-sizing for mobile',           'LOW'],
  ['missing_preheader_padding','Missing preheader zwnj padding',          'LOW'],
);
my %cat = map { $_->[0] => 0 } @cat_order;

my ($pass, $warn, $fail, $total_issues) = (0, 0, 0, 0);
my @results;    # [status, rel_path, num_issues, issue_string]

# Collect up to $cap 1-based line numbers whose line matches $re.
sub hits {
  my ($lines, $re, $cap) = @_;
  my @out;
  for my $i (0 .. $#$lines) {
    if ($lines->[$i] =~ $re) {
      push @out, $i + 1;
      last if @out >= $cap;
    }
  }
  return @out;
}

# Count lines matching $re (mirrors `grep -c`, which counts lines not matches).
sub count_lines {
  my ($lines, $re) = @_;
  my $n = 0;
  for my $l (@$lines) { $n++ if $l =~ $re }
  return $n;
}

# Count total occurrences of $re (mirrors the old pgrep_count helper).
sub count_all {
  my ($lines, $re) = @_;
  my $n = 0;
  for my $l (@$lines) { $n++ while $l =~ /$re/g }
  return $n;
}

while (my $file = <$lf>) {
  chomp $file;
  next unless length $file;

  open(my $fh, '<', $file) or next;
  my @lines = <$fh>;
  close $fh;

  # `CONTENT=$(cat ...)` stripped trailing newlines; only the slurped
  # preheader check below is sensitive to that, and it is anchored on <div>.
  my $content = join('', @lines);

  # Handlebars stripped per line, matching the original `sed 's/{{[^}]*}}//g'`.
  # Line-scoped, so a token split across lines is deliberately NOT removed.
  my @nohbs = map { (my $x = $_) =~ s/\{\{[^}]*\}\}//g; $x } @lines;

  my @issues;

  # --- 1. Duplicate class attributes ---
  if (my @m = hits(\@lines, qr/<[^>]*\bclass="[^"]*"[^>]*\bclass="[^"]*"/, 5)) {
    push @issues, 'Duplicate class attrs (L' . join(',', @m) . ')';
    $cat{duplicate_class}++;
  }

  # --- 2. AIG branding ---
  # Token names are ESP-side identifiers, never rendered to the customer, and
  # some are AIG-era names we don't control (e.g. {{Image_AIGGlobalLogoHeader}}).
  # Only visible copy is a branding issue, hence the handlebars-stripped source.
  if (my @m = hits(\@nohbs, qr/\bAIG\b(?!\s*Travel\s*Guard)/i, 5)) {
    push @issues, 'AIG branding (L' . join(',', @m) . ')';
    $cat{aig_branding}++;
  }

  # --- 3. AIG email domains ---
  if (my @m = hits(\@lines, qr/\@aig\.com/, 5)) {
    push @issues, '@aig.com email (L' . join(',', @m) . ')';
    $cat{aig_email}++;
  }

  # --- 4. Legacy {Variable} format ---
  if (my @m = hits(\@nohbs, qr/\{[A-Z][a-zA-Z_-]+\}/, 5)) {
    push @issues, 'Legacy {vars} (L' . join(',', @m) . ')';
    $cat{legacy_vars}++;
  }

  # --- 5/6/7. Dark mode checks ---
  my $has_dark_mq = count_lines(\@lines, qr/prefers-color-scheme/);
  my $has_ogsc    = count_lines(\@lines, qr/\[data-ogsc\]/);

  if ($has_dark_mq > 0) {
    if (count_lines(\@lines, qr/\.body-bg/) == 0) {
      push @issues, 'Missing .body-bg class';
      $cat{missing_body_bg}++;
    }

    # 5-line sliding window catches multi-line tags where font-size and
    # class="dark-text" sit on separate lines of the same element.
    my (@win, @bad);
    for my $i (0 .. $#lines) {
      push @win, $lines[$i];
      shift @win if @win > 5;
      if ($lines[$i] =~ /class="[^"]*\b(content-bg|dark-text)\b[^"]*"/) {
        my $ctx = join('', @win);
        next if $ctx =~ /font-size:\s*(8|9|10|11)px/;   # small print, not content
        next if $ctx =~ /display:\s*none.*max-height:\s*0/s;  # preheader div
        push @bad, $i + 1;
        last if @bad >= 3;
      }
    }
    if (@bad) {
      push @issues, 'Dark mode gotcha: .content-bg/.dark-text on content area (L'
                    . join(',', @bad) . ')';
      $cat{dark_mode_gotcha}++;
    }

    if ($has_ogsc == 0) {
      push @issues, 'Missing Gmail dark mode [data-ogsc] selectors';
      $cat{missing_dark_gmail}++;
    }
  }

  # --- 8. Missing alt attributes ---
  if (my @m = hits(\@lines, qr/<img\b(?![^>]*\balt\s*=)[^>]*>/, 5)) {
    push @issues, 'Missing alt on ' . scalar(@m) . ' img(s)';
    $cat{missing_alt}++;
  }

  # --- 9. Relative image paths ---
  if (my @m = hits(\@lines, qr/<img\b[^>]*\bsrc="(?!https?:\/\/|cid:|data:)[^"]*"/, 5)) {
    push @issues, 'Relative img path (' . scalar(@m) . ')';
    $cat{relative_img}++;
  }

  # --- 10. Tables missing role="presentation" ---
  # Skips multi-line CSS (/* ... */) and HTML (<!-- ... -->) comment blocks.
  {
    my ($in_css, $in_html) = (0, 0);
    my @m;
    for my $i (0 .. $#lines) {
      my $l = $lines[$i];
      if ($in_css)  { $in_css  = 0 if $l =~ m{\*/};  next }
      if ($l =~ m{/\*} && $l !~ m{\*/}) { $in_css  = 1; next }
      if ($in_html) { $in_html = 0 if $l =~ /-->/;   next }
      if ($l =~ /<!--/ && $l !~ /-->/)  { $in_html = 1; next }
      if ($l =~ /<table\b(?![^>]*role="presentation")[^>]*>/) {
        push @m, $i + 1;
        last if @m >= 5;
      }
    }
    if (@m) {
      push @issues, 'Missing role=presentation (' . scalar(@m) . ' tables)';
      $cat{missing_role}++;
    }
  }

  # --- 11. Mismatched MSO conditionals ---
  my $mso_open  = count_all(\@lines, qr/<!--\[if\s+(?:!|gte\s+)?mso/);
  my $mso_close = count_all(\@lines, qr/(?:<!|<!--)\[endif\]-->/);
  if ($mso_open != $mso_close) {
    push @issues, "MSO mismatch: $mso_open opens vs $mso_close closes";
    $cat{mso_mismatch}++;
  }

  # --- 12. UAT/QA environment URLs ---
  if (my @m = hits(\@lines, qr/https?:\/\/[a-zA-Z0-9._-]*\.(uat|qa)\.[a-zA-Z0-9._-]+/, 5)) {
    push @issues, 'UAT/QA env URL (L' . join(',', @m) . ')';
    $cat{env_urls}++;
  }

  # --- 13. Mobile box-sizing ---
  if (count_lines(\@lines, qr/display:.*block/) > 0
      && count_lines(\@lines, qr/box-sizing:.*border-box/) == 0) {
    push @issues, 'Missing box-sizing:border-box for mobile';
    $cat{mobile_boxsizing}++;
  }

  # --- 14. Preheader missing &zwnj;&nbsp; padding ---
  if ($content =~ /<div[^>]*display:\s*none[^>]*max-height:\s*0[^>]*>(.*?)<\/div>/s) {
    my $inner = $1;
    if ($inner !~ /zwnj/) {
      push @issues, 'Missing preheader &zwnj;&nbsp; padding';
      $cat{missing_preheader_padding}++;
    }
  }

  # --- Tally ---
  my $num = scalar @issues;
  $total_issues += $num;

  my $status;
  if    ($num == 0) { $status = 'PASS'; $pass++ }
  elsif ($num <= 2) { $status = 'WARN'; $warn++ }
  else              { $status = 'FAIL'; $fail++ }

  (my $rel = $file) =~ s/^\Q$project_dir\E\///;

  # Original joined with ${array[*]} under IFS='; ', which uses only the FIRST
  # IFS character — so the separator is ';', not '; '.
  push @results, [$status, $rel, $num, $num ? join(';', @issues) : '—'];
}

# ---------------------------------------------------------------------------
# Generate Markdown report
# ---------------------------------------------------------------------------
my @t = gmtime(time);
my $timestamp = sprintf('%04d-%02d-%02d %02d:%02d UTC',
                        $t[5] + 1900, $t[4] + 1, $t[3], $t[2], $t[1]);

open(my $rf, '>', $report_file) or die "Cannot write $report_file: $!";
binmode($rf, ':encoding(UTF-8)');

print $rf <<"HEADER";
# Email Template QA Report

**Scanned:** $scan_label ($total templates)
**Date:** $timestamp
**Pass:** $pass | **Warn:** $warn | **Fail:** $fail | **Total issues:** $total_issues

## Summary by Issue Type

| Issue | Files Affected | Priority |
|-------|---------------|----------|
HEADER

# Rows carried a "count|key|label|priority" shape and were ordered by
# `sort -t'|' -k1 -rn`. GNU sort's last-resort comparison is the whole line,
# and -r reverses that too, so ties fall back to reverse string order.
my @rows = grep { $cat{$_->[0]} > 0 } @cat_order;
my @sorted = sort {
  $cat{$b->[0]} <=> $cat{$a->[0]}
    || join('|', $cat{$b->[0]}, @$b) cmp join('|', $cat{$a->[0]}, @$a)
} @rows;

for my $r (@sorted) {
  print $rf "| $r->[1] | $cat{$r->[0]} | $r->[2] |\n";
}

print $rf "\n## Results by Brand\n\n";

# Per-brand totals, keyed on the first path component.
my (%b_total, %b_pass, %b_warn, %b_fail);
for my $r (@results) {
  my ($brand) = split m{/}, $r->[1], 2;
  $b_total{$brand}++;
  $b_pass{$brand}++ if $r->[0] eq 'PASS';
  $b_warn{$brand}++ if $r->[0] eq 'WARN';
  $b_fail{$brand}++ if $r->[0] eq 'FAIL';
}

my $current_brand = '';
for my $r (@results) {
  my ($status, $rel, $num, $issues) = @$r;
  my ($brand) = split m{/}, $rel, 2;

  if ($brand ne $current_brand) {
    print $rf "\n" if $current_brand ne '';
    $current_brand = $brand;
    printf $rf "### %s/ (%d files: %d pass, %d warn, %d fail)\n\n",
      $brand, $b_total{$brand} || 0, $b_pass{$brand} || 0,
      $b_warn{$brand} || 0, $b_fail{$brand} || 0;
  }

  next if $status eq 'PASS';

  my $icon = $status eq 'FAIL' ? "\x{274C}" : "\x{26A0}\x{FE0F}";
  print $rf "- $icon `$rel` \x{2014} $issues\n";
}

print $rf <<"FOOTER";

---

*Generated by batch-qa.sh \x{2014} run `.claude/scripts/batch-qa.sh` to refresh.*
FOOTER
close $rf;

# ---------------------------------------------------------------------------
# Shell-sourceable summary for the terminal output
# ---------------------------------------------------------------------------
open(my $sf, '>', $summary_file) or die "Cannot write $summary_file: $!";
print $sf "PASS=$pass\nWARN=$warn\nFAIL=$fail\nTOTAL_ISSUES=$total_issues\n";
my $top = '';
for my $r (@sorted) {
  $top .= sprintf("  %-40s %d files\n", $r->[1], $cat{$r->[0]});
}
$top =~ s/'/'\\''/g;
print $sf "TOP_ISSUES='$top'\n";
close $sf;
PERL_EOF

# shellcheck source=/dev/null
. "$SUMMARY_TMP"

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
printf '%s' "$TOP_ISSUES"

echo ""
echo "Full report: $REPORT_FILE"
