#!/usr/bin/env bash
[ -z "$ZELLIJ_SESSION_NAME" ] && exit 0
[ -z "$ZELLIJ_PANE_ID" ] && exit 0

INPUT=$(cat)
HOOK=$(echo "$INPUT" | jq -r '.hook_event_name // empty')
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty')

[ -z "$HOOK" ] && exit 0

NOTIFY="$HOME/.config/zellij/scripts/notify.sh"

case "$HOOK" in
UserPromptSubmit)
  "$NOTIFY" claude working "🧠 thinking"
  ;;
PreToolUse)
  "$NOTIFY" claude working "🛠️ ${TOOL:-working}"
  ;;
Stop | SubagentStop)
  "$NOTIFY" claude success
  ;;
PermissionRequest)
  printf '\a' >/dev/tty 2>/dev/null || true
  "$NOTIFY" claude error "permission: ${TOOL:-?}"
  ;;
esac
