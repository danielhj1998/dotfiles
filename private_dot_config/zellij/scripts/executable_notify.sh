#!/usr/bin/env bash
# Usage: notify.sh <profile> <success|error|working> [custom_text]

[ -z "$ZELLIJ_SESSION_NAME" ] && exit 0

PROFILE="${1:-generic}"
STATUS="${2:-working}"
CUSTOM_TEXT="${3:-}"

CONFIG="$HOME/.config/zellij/notifications.toml"
CACHE="$HOME/.cache/zj-activity"
PIPE="pipe_zj_activity"
BASE="#1e1e2e"

# Defaults (Catppuccin Mocha, Nerd Font icons)
case "$STATUS" in
success) ICON="󰄬" COLOR="#a6e3a1" DURATION=5 ;;
error) ICON="󰅚" COLOR="#f38ba8" DURATION=5 ;;
*) ICON="⏲" COLOR="#f9e2af" DURATION=0 ;;
esac
TEXT="${CUSTOM_TEXT:-$PROFILE $STATUS}"

# Override from config if yq is available
if command -v yq &>/dev/null && [ -f "$CONFIG" ]; then
  ICON=$(yq eval ".styles.$STATUS.icon" "$CONFIG")
  COLOR=$(yq eval ".styles.$STATUS.color" "$CONFIG")
  DURATION=$(yq eval ".styles.$STATUS.duration" "$CONFIG")
  [ -z "$CUSTOM_TEXT" ] && TEXT=$(yq eval ".profiles.$PROFILE.$STATUS" "$CONFIG")
fi

# Write to the activity pipe
zellij pipe -- "zjstatus::pipe::$PIPE::#[fg=$COLOR,bg=$BASE,bold] $ICON $TEXT " 2>/dev/null || true

# Auto-clear transient messages (token prevents stale clears from concurrent writes)
if [ "$DURATION" -gt 0 ]; then
  mkdir -p "$CACHE"
  TOKEN=$(date +%s%N 2>/dev/null || date +%s)
  echo "$TOKEN" >"$CACHE/token"
  (
    sleep "$DURATION"
    [ "$(cat "$CACHE/token" 2>/dev/null)" = "$TOKEN" ] &&
      zellij pipe -- "zjstatus::pipe::$PIPE::" 2>/dev/null || true
  ) &
fi
