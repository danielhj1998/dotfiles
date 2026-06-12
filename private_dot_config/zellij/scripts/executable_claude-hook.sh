#!/usr/bin/env bash
# claude-hook.sh — Claude Code → zjstatus pipe bridge
#
# Registered in ~/.claude/settings.json for these events:
#   UserPromptSubmit  PreToolUse  PermissionRequest  Stop  SubagentStop  Notification
#
# Pattern from zellaude (https://github.com/ishefi/zellaude):
#   - single script handles all events via case statement
#   - reads stdin once, parses with jq
#   - guards on both ZELLIJ env vars before doing anything

# Guard: only run inside a live Zellij session
[ -z "$ZELLIJ_SESSION_NAME" ] && exit 0
[ -z "$ZELLIJ_PANE_ID" ]     && exit 0

INPUT=$(cat)
HOOK_EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // empty')
TOOL_NAME=$(echo  "$INPUT" | jq -r '.tool_name // empty')

[ -z "$HOOK_EVENT" ] && exit 0

# Helpers: write to zjstatus pipe widget or send a transient notification
_pipe()   { zellij pipe -- "zjstatus::pipe::claude_activity::${1}" 2>/dev/null || true; }
_notify() { zellij pipe -- "zjstatus::notify::${1}"                2>/dev/null || true; }

case "$HOOK_EVENT" in
  UserPromptSubmit)
    # Show "thinking" before the first tool call — covers the gap between
    # submitting a prompt and the first PreToolUse firing.
    _pipe "󰚩 thinking  "
    ;;

  PreToolUse)
    # Update indicator to show the specific tool that is about to run.
    # Not cleared on PostToolUse to avoid flashing between sequential tool calls.
    _pipe "󰚩 ${TOOL_NAME:-working}  "
    ;;

  Stop|SubagentStop)
    _pipe ""                  # clear the activity indicator
    _notify "󰄬 Claude done"   # transient 5-second toast
    ;;

  PermissionRequest)
    # Ring the terminal bell and show a toast — user action required.
    printf '\a' > /dev/tty 2>/dev/null || true
    _notify "⚠ Permission: ${TOOL_NAME:-?}"
    ;;
esac
