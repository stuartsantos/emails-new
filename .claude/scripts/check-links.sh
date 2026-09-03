#!/bin/bash
# =============================================================================
# check-links.sh — Live link/image reachability sweep for HTML email templates
#
# Unlike validate-email-html.sh and batch-qa.sh (which only check URL SHAPE —
# absolute vs relative, UAT/QA host, cmpid presence — by static regex), this
# script actually issues an HTTP request to every http(s) href/src found in
# the templates and reports which ones fail to resolve.
#
# This is deliberately NOT wired into the PostToolUse hook (validate-email-html.sh):
# network requests are slow and flaky in a way local regex checks are not, and
# a transient DNS blip or a bot-blocking WAF would then block an unrelated
# edit. Run this by hand (or from a periodic/CI job) before shipping a
# template, not on every keystroke.
#
# Same conventions as batch-qa.sh: scope arg, .claude/qa-exclude.txt, report
# under .claude/reports/.
#
# Usage:
#   ./check-links.sh                 # check all templates
#   ./check-links.sh row             # check only row/
#   ./check-links.sh tg/us/zurich    # check a specific subdirectory
#
# Output: .claude/reports/link-report.md
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPORT_DIR="$PROJECT_DIR/.claude/reports"
REPORT_FILE="$REPORT_DIR/link-report.md"
PARALLELISM=20
TIMEOUT_SECS=15
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36"

mkdir -p "$REPORT_DIR"

# Determine scan target (same logic as batch-qa.sh)
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

EXCLUDE_FILE="$PROJECT_DIR/.claude/qa-exclude.txt"
EXCLUDE_LIST=()
if [[ -f "$EXCLUDE_FILE" ]]; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    trimmed="${line#"${line%%[![:space:]]*}"}"
    [[ -z "$trimmed" || "$trimmed" == \#* ]] && continue
    EXCLUDE_LIST+=("$trimmed")
  done < "$EXCLUDE_FILE"
fi

FILES=$(find "$SCAN_DIR" -name "*.html" \
  -not -path "*/node_modules/*" \
  -not -path "*/build/*" \
  -not -path "*/dist/*" \
  -not -path "*responsive-modular*" \
  -not -path "$SCAN_DIR/.claude/*" \
  -not -path "*/tg/*/aig/*" \
  | sort)

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

TOTAL=0
while IFS= read -r _l; do
  [[ -n "$_l" ]] && TOTAL=$(( TOTAL + 1 ))
done <<< "$FILES"

echo "Extracting links from $TOTAL templates in $SCAN_LABEL..."

FILELIST_TMP=$(mktemp)
URLS_TMP=$(mktemp)
RESULTS_TMP=$(mktemp)
trap 'rm -f "$FILELIST_TMP" "$URLS_TMP" "$RESULTS_TMP"' EXIT

printf '%s\n' "$FILES" > "$FILELIST_TMP"

# ---------------------------------------------------------------------------
# Phase 1 (single perl process, no network): extract every http(s) href/src,
# skip anything with an unresolved {{handlebars}} token (can't be fetched as
# literal text), and group by URL with the query string stripped — the query
# on these templates is only ever a `cmpid=` tracking value, so checking one
# representative URL per (scheme+host+path) is enough to prove the
# destination resolves, without re-requesting the same page hundreds of times
# for hundreds of per-market/per-campaign cmpid values.
#
# Emits one line per group to $URLS_TMP: base_url \t example_full_url \t
# comma-separated relative file paths that reference it.
# ---------------------------------------------------------------------------
perl - "$PROJECT_DIR" "$FILELIST_TMP" "$URLS_TMP" <<'PERL_EOF'
use strict;
use warnings;

my ($project_dir, $filelist, $urls_out) = @ARGV;

open(my $lf, '<', $filelist) or die "Cannot read $filelist: $!";
my %group; # base_url => { example => full_url, files => { rel => 1 } }

while (my $path = <$lf>) {
  chomp $path;
  next unless length $path;
  open(my $fh, '<', $path) or next;
  local $/;
  my $content = <$fh>;
  close $fh;
  my $rel = $path;
  $rel =~ s/^\Q$project_dir\E[\\\/]//;
  $rel =~ s{\\}{/}g;

  while ($content =~ /(?:href|src)="(https?:\/\/[^"]+)"/g) {
    my $url = $1;
    # Skip unresolved template placeholders: Handlebars {{...}}, and ESP
    # merge tags (Responsys etc.) which show up literally or percent-encoded,
    # e.g. ...Unsubscribe.aspx?email=%7B%email_address%%7D — these are never
    # meant to be fetched as literal text, only rendered at send time.
    next if $url =~ /[{}]/ || $url =~ /%7[BD]/i;
    (my $base = $url) =~ s/[?#].*$//;
    $group{$base}{example} ||= $url;
    $group{$base}{files}{$rel} = 1;
  }
}
close $lf;

open(my $of, '>', $urls_out) or die "Cannot write $urls_out: $!";
for my $base (sort keys %group) {
  my $example = $group{$base}{example};
  my $files = join(',', sort keys %{$group{$base}{files}});
  print $of "$base\t$example\t$files\n";
}
close $of;
PERL_EOF

UNIQUE_COUNT=$(wc -l < "$URLS_TMP" | tr -d ' ')
echo "Found $UNIQUE_COUNT unique destinations. Checking (parallel=$PARALLELISM, timeout=${TIMEOUT_SECS}s)..."

# ---------------------------------------------------------------------------
# Phase 2 (network): one curl per unique destination, run in parallel.
#
# Deliberately does NOT follow redirects (-L). A 3xx from the template's own
# domain means that link works — what a downstream redirect target (e.g. a
# review-platform page the site forwards to) does with our request is a
# separate site's problem, not this template's. Confirmed case: travelguard.com
# healthily 302s to trustpilot.com/review/travelguard.com, but Trustpilot's own
# bot-management then blocks curl — following the redirect made a good
# travelguard.com link look broken. So: capture the immediate status code plus
# headers, and classify from that alone.
# ---------------------------------------------------------------------------
check_one() {
  local base="$1" url="$2"
  local raw code

  fetch() {
    # --ssl-no-revoke: on this Windows/Schannel curl build, OCSP revocation
    # checks fail outbound on this network (CRYPT_E_NO_REVOCATION_CHECK) even
    # for perfectly live sites (confirmed against facebook.com, google.com/maps,
    # fonts.googleapis.com — all curl error 35 without this flag, all 2xx/4xx
    # with it). Without it, most external domains false-positive as FAIL.
    curl -s -D - -o /dev/null --max-time "$TIMEOUT_SECS" \
      --ssl-no-revoke -A "$USER_AGENT" -w $'\n__CODE__:%{http_code}' "$1" 2>/dev/null
  }

  raw=$(fetch "$url") || raw=""
  code=$(printf '%s' "$raw" | grep -o '__CODE__:[0-9]*' | tail -1 | cut -d: -f2)
  [[ -z "$code" ]] && code="000"

  if [[ "$code" == "000" || "$code" -ge 400 ]]; then
    # one retry — transient network/DNS blips shouldn't read as a broken link
    sleep 1
    local raw2 code2
    raw2=$(fetch "$url") || raw2=""
    code2=$(printf '%s' "$raw2" | grep -o '__CODE__:[0-9]*' | tail -1 | cut -d: -f2)
    [[ -z "$code2" ]] && code2="000"
    if [[ "$code2" != "000" && ( "$code" == "000" || "$code2" -lt "$code" ) ]]; then
      raw="$raw2"; code="$code2"
    fi
  fi

  local note=""
  if [[ "$code" -ge 300 && "$code" -lt 400 ]]; then
    local loc
    loc=$(printf '%s' "$raw" | grep -i '^location:' | tail -1 | sed 's/^[Ll]ocation: *//i' | tr -d '\r')
    # A 3xx status is technically "healthy", but a same-site redirect that
    # lands on the site's own error/not-found page is really a dead link
    # wearing a green light. Confirmed case:
    # travelguard.com/o/coronavirus-resource-center/voucher-and-refund-form
    # 302s to travelguard.com/.../error-page.html — <title>Error Page</title>.
    # Cheap heuristic on the target path (no extra network hop, so it can't
    # trip the cross-domain bot-blocking this checker already routes around).
    if [[ -n "$loc" && "$loc" =~ [Ee]rror-?[Pp]age|/404([/.?]|$)|[Nn]ot-?[Ff]ound ]]; then
      note="SUSPICIOUS_REDIRECT:redirects to ${loc} — target URL looks like a dead/error page, verify manually"
    else
      note="redirects to ${loc:-an unspecified location}"
    fi
  elif [[ "$code" == "000" || "$code" -ge 400 ]]; then
    # A response that varies by User-Agent (common on AEM/CloudFront-fronted
    # travelguard.com pages) may be cached per-UA — this checker's synthetic
    # UA can land in a different cache partition than a real browser's, so a
    # 4xx here isn't trustworthy on its own. Confirmed case:
    # claims.travelguard.com/status 404s for curl's UA (Vary: User-Agent
    # present) while resolving fine in an actual browser.
    if printf '%s' "$raw" | grep -qi '^vary:.*user-agent'; then
      note="response is cached per User-Agent (Vary header present) -- this checker's UA may see a different cached result than a browser; verify manually"
    fi
  fi
  note="${note//$'\t'/ }"
  note="${note//$'\n'/ }"

  printf '%s\t%s\t%s\n' "$base" "$code" "$note"
}
export -f check_one
export TIMEOUT_SECS USER_AGENT

cut -f1,2 "$URLS_TMP" | \
  xargs -P "$PARALLELISM" -I{} bash -c 'IFS=$'"'"'\t'"'"' read -r b u <<< "{}"; check_one "$b" "$u"' \
  > "$RESULTS_TMP"

# ---------------------------------------------------------------------------
# Phase 3 (single perl process, no network): join results with the file
# mapping and write the report + terminal summary.
# ---------------------------------------------------------------------------
perl - "$URLS_TMP" "$RESULTS_TMP" "$REPORT_FILE" "$SCAN_LABEL" "$TOTAL" "$UNIQUE_COUNT" <<'PERL_EOF'
use strict;
use warnings;
use utf8; # source has literal em-dashes; decode them so :encoding(UTF-8) on $out doesn't double-encode

my ($urls_file, $results_file, $report_file, $scan_label, $total, $unique_count) = @ARGV;

my %files_of; # base => rel file list string
my %example_of;
open(my $uf, '<:encoding(UTF-8)', $urls_file) or die "Cannot read $urls_file: $!";
while (<$uf>) {
  chomp;
  my ($base, $example, $files) = split /\t/, $_, 3;
  $files_of{$base} = $files;
  $example_of{$base} = $example;
}
close $uf;

my %status_of;
my %note_of;
open(my $rf, '<:encoding(UTF-8)', $results_file) or die "Cannot read $results_file: $!";
while (<$rf>) {
  chomp;
  my ($base, $code, $note) = split /\t/, $_, 3;
  $status_of{$base} = $code;
  $note_of{$base} = $note // '';
}
close $rf;

# Social platforms are notorious for bot-blocking scripted requests (curl gets
# a 400/403/429 that a real browser never would) — a hit here says "verify by
# hand", not "this link is broken". Downgrade to WARN instead of FAIL so they
# don't cry wolf on every run and bury genuine dead links.
my $social_re = qr/(?:^|\.)(?:facebook|instagram|tiktok|twitter|x|youtube|linkedin|trustpilot)\.com$/i;

my (@fail, @warn, @pass);
for my $base (sort keys %files_of) {
  my $code = $status_of{$base} // '000';
  my $note = $note_of{$base} // '';
  my ($host) = $base =~ m{^https?://([^/]+)};
  $host =~ s/:\d+$// if defined $host;
  my $is_social = defined($host) && $host =~ $social_re;

  if ($code >= 300 && $code < 400 && $note =~ /^SUSPICIOUS_REDIRECT:/) {
    (my $clean_note = $note) =~ s/^SUSPICIOUS_REDIRECT://;
    push @warn, [$base, $code, $clean_note];
  } elsif ($code >= 300 && $code < 400) {
    # Not fetched further by design (see check_one) — the template's own
    # domain responded and handed off; that's a working link.
    push @pass, [$base, $code, $note];
  } elsif ($code eq '000' || $code >= 400) {
    if ($is_social) {
      push @warn, [$base, $code, 'social platform — bot-blocked automated checks, verify manually'];
    } elsif ($note) {
      push @warn, [$base, $code, $note];
    } else {
      push @fail, [$base, $code, ''];
    }
  } else {
    push @pass, [$base, $code, $note];
  }
}

my $timestamp = localtime();
open(my $out, '>:encoding(UTF-8)', $report_file) or die "Cannot write $report_file: $!";
print $out <<"HEADER";
# Link Check Report

**Scanned:** $scan_label ($total templates)
**Date:** $timestamp
**Unique destinations:** $unique_count
**Pass:** ${\ scalar @pass} | **Warn:** ${\ scalar @warn} | **Fail:** ${\ scalar @fail}

HEADER

if (@fail) {
  print $out "## Failed (unreachable / 4xx / 5xx)\n\n";
  for my $r (@fail) {
    my ($base, $code) = @$r;
    print $out "- \x{274C} **$code** $base\n";
    print $out "  - used in: `" . join('`, `', split(/,/, $files_of{$base})) . "`\n";
  }
  print $out "\n";
}

if (@warn) {
  print $out "## Warnings (couldn't independently confirm \x{2014} worth a manual check)\n\n";
  for my $r (@warn) {
    my ($base, $code, $note) = @$r;
    print $out "- \x{26A0}\x{FE0F} **$code** $base" . ($note ? " — $note" : "") . "\n";
    print $out "  - used in: `" . join('`, `', split(/,/, $files_of{$base})) . "`\n";
  }
  print $out "\n";
}

my @redirects = grep { $_->[1] >= 300 } @pass;
my @clean_pass = grep { $_->[1] < 300 } @pass;

if (@redirects) {
  print $out "## Redirects (healthy \x{2014} the template's own link responded and handed off)\n\n";
  for my $r (@redirects) {
    my ($base, $code, $note) = @$r;
    print $out "- \x{2705} **$code** $base" . ($note ? " — $note" : "") . "\n";
  }
  print $out "\n";
}

print $out "## Passed\n\n";
print $out scalar(@clean_pass) . " destinations returned 2xx. Not itemized — see link-report.md history if needed.\n\n";

print $out <<"FOOTER";
---

*Generated by check-links.sh \x{2014} run `.claude/scripts/check-links.sh` to refresh. Query strings (cmpid tracking params) are stripped before deduping, so one check covers every market/campaign variant of the same destination.*
FOOTER
close $out;

print "PASS=" . scalar(@pass) . "\n";
print "WARN=" . scalar(@warn) . "\n";
print "FAIL=" . scalar(@fail) . "\n";
PERL_EOF

echo ""
echo "========================================="
echo "  LINK CHECK REPORT"
echo "========================================="
echo "  Scanned:      $TOTAL templates ($SCAN_LABEL)"
echo "  Destinations: $UNIQUE_COUNT"
echo "========================================="
echo ""
echo "Full report: $REPORT_FILE"
