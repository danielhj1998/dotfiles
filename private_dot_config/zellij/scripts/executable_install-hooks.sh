#!/usr/bin/env bash
# install-hooks.sh — idempotent Claude Code hook installer
#
# Registers claude-hook.sh in ~/.claude/settings.json for the listed events.
# Safe to re-run: backs up settings, removes stale entries, adds fresh ones.
#
# Requires: jq

set -euo pipefail

HOOK="$HOME/.config/zellij/scripts/claude-hook.sh"
SETTINGS="$HOME/.claude/settings.json"

# Events to register — matches the case statement in claude-hook.sh
EVENTS='["UserPromptSubmit","PreToolUse","PermissionRequest","Stop","SubagentStop","Notification"]'

# Dependency check
command -v jq >/dev/null 2>&1 || { echo "ERROR: jq is required but not found in PATH"; exit 1; }

# Ensure hook script exists and is executable
[ -x "$HOOK" ] || { echo "ERROR: hook script not found or not executable: $HOOK"; exit 1; }

# Create settings file if it doesn't exist
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"

# Backup
cp "$SETTINGS" "${SETTINGS}.bak"
echo "Backed up settings to ${SETTINGS}.bak"

# Atomically update: remove any existing entries for this hook, add fresh ones
jq --arg hook "$HOOK" --argjson events "$EVENTS" '
  # Ensure hooks key exists
  .hooks //= {} |

  # Remove any existing entries for this hook script across all events
  .hooks |= with_entries(
    .value |= map(
      select(
        (.hooks // []) | map(.command == $hook) | any | not
      )
    )
  ) |

  # Register fresh entries for each event
  reduce $events[] as $e (
    .;
    .hooks[$e] //= [] |
    .hooks[$e] += [{
      "hooks": [{
        "type": "command",
        "command": $hook,
        "timeout": 5
      }]
    }]
  )
' "$SETTINGS" > "${SETTINGS}.tmp" && mv "${SETTINGS}.tmp" "$SETTINGS"

echo "Hooks registered for events: $EVENTS"
echo "Done. Restart Claude Code for changes to take effect."
