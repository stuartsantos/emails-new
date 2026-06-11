#!/bin/bash
# =============================================================================
# mcp-preflight.sh — Claude Code PreToolUse hook
# Runs a one-time MCP health check per session before the first MCP tool call.
#
# Checks:
#   1. Figma API reachability (https://api.figma.com)
#   2. GitHub API reachability (https://api.github.com)
#   3. MCP config file presence
#
# Reachability only — these probes are unauthenticated, so HTTP status codes
# say nothing about auth state (api.figma.com/v1/me always returns 403 without
# a token; api.github.com can 403 on anonymous rate limits). Do not add
# "auth expired" warnings based on 401/403 here.
#
# Fires on: PreToolUse (matcher: "mcp__")
# Runs once: uses /tmp flag file keyed to session_id
# =============================================================================

set -euo pipefail

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')

# Only run on MCP tool calls
if [[ "$TOOL_NAME" != mcp__* ]]; then
  exit 0
fi

# One-time per session — skip if already checked
FLAG_FILE="/tmp/.claude-mcp-preflight-${SESSION_ID:0:12}"
if [[ -f "$FLAG_FILE" ]]; then
  exit 0
fi
touch "$FLAG_FILE"

# Clean up stale flag files older than 24h
find /tmp -maxdepth 1 -name ".claude-mcp-preflight-*" -mtime +1 -delete 2>/dev/null || true

WARNINGS=()

# ---------------------------------------------------------------------------
# 1. Figma API reachability
# ---------------------------------------------------------------------------
if [[ "$TOOL_NAME" == mcp__*igma* || "$TOOL_NAME" == mcp__*Figma* ]]; then
  FIGMA_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 --max-time 10 "https://api.figma.com/v1/me" 2>/dev/null || echo "000")
  if [[ "$FIGMA_STATUS" == "000" ]]; then
    WARNINGS+=("FIGMA UNREACHABLE — cannot connect to api.figma.com. Check your network connection. Run 'claude mcp list' to verify the Figma MCP server is configured.")
  fi
fi

# ---------------------------------------------------------------------------
# 2. GitHub API reachability
# ---------------------------------------------------------------------------
if [[ "$TOOL_NAME" == mcp__*ithub* || "$TOOL_NAME" == mcp__*GitHub* ]]; then
  GH_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 --max-time 10 "https://api.github.com/zen" 2>/dev/null || echo "000")
  if [[ "$GH_STATUS" == "000" ]]; then
    WARNINGS+=("GITHUB UNREACHABLE — cannot connect to api.github.com. Check your network connection. Run 'claude mcp list' to verify the GitHub MCP server is configured.")
  fi
fi

# ---------------------------------------------------------------------------
# 3. General MCP config sanity
# ---------------------------------------------------------------------------
# MCP servers live in ~/.claude.json (user scope) or <project>/.mcp.json (project scope)
if [[ ! -f "$HOME/.claude.json" && ! -f "${CLAUDE_PROJECT_DIR:-.}/.mcp.json" ]]; then
  WARNINGS+=("NO MCP CONFIG FOUND — expected ~/.claude.json or .mcp.json. MCP servers may not be configured. Run 'claude mcp list' to check.")
fi

# ---------------------------------------------------------------------------
# Report
# ---------------------------------------------------------------------------
if [[ ${#WARNINGS[@]} -eq 0 ]]; then
  # All good — let the tool call proceed
  exit 0
fi

# Build warning text
WARNING_TEXT=""
for i in "${!WARNINGS[@]}"; do
  WARNING_TEXT+="$((i+1)). ${WARNINGS[$i]}\n"
done

# Surface warnings as additional context — don't block the call,
# just let Claude know so it can warn the user proactively
cat <<ENDJSON
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "MCP PRE-FLIGHT CHECK found ${#WARNINGS[@]} issue(s):\n\n$(printf '%s' "$WARNING_TEXT" | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')\n\nSuggest the user fix these before continuing. If the MCP server is down, do not keep retrying — tell the user immediately."
  }
}
ENDJSON

exit 0
