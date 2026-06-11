#!/bin/bash
# =============================================================================
# email-qa-bash-guard.sh — PreToolUse hook for the email-qa subagent
# Enforces the agent's read-only contract structurally: its Bash tool may only
# run pandoc, the static lint script, or a short list of read-only commands.
# Exit 2 blocks the command; the message on stderr is shown to the agent.
# =============================================================================

set -euo pipefail

INPUT=$(cat)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

[[ -z "$CMD" ]] && exit 0

# No chaining, piping, redirection, or command substitution — keeps the
# allowlist below meaningful (blocks e.g. `pandoc x && rm y`).
if echo "$CMD" | grep -q '[;&|<>`]\|\$('; then
  echo "email-qa is read-only: command chaining/pipes/redirection are not allowed. Run one plain command at a time." >&2
  exit 2
fi

# Allowlist: pandoc extraction, the lint script, and read-only inspection
case "$CMD" in
  pandoc\ *) exit 0 ;;
  bash\ *validate-email-html.sh*) exit 0 ;;
  ls|ls\ *|find\ *|wc\ *|head\ *|tail\ *|file\ *|stat\ *) exit 0 ;;
esac

echo "email-qa is read-only: bash is limited to pandoc, the validate-email-html.sh lint script, and read-only inspection (ls/find/wc/head/tail/file/stat). Use Read/Grep/Glob for file access." >&2
exit 2
