#!/usr/bin/env bash

set -euo pipefail

OPTIONS="Region
Window
Active window
Monitor
Active monitor"

SELECTION="$(printf '%s\n' "$OPTIONS" | wofi --dmenu --prompt "Screenshot:")" || exit 0

if [[ -z "$SELECTION" ]]; then
  exit 0
fi

# Let the chooser close and return focus before capturing the active window.
sleep "${HYPRSHOT_MENU_DELAY:-0.35}"

case "$SELECTION" in
  Region)
    exec hyprshot -m region --clipboard-only
    ;;
  Window)
    exec hyprshot -m window --clipboard-only
    ;;
  "Active window")
    exec hyprshot -m window -m active --clipboard-only
    ;;
  Monitor)
    exec hyprshot -m output --clipboard-only
    ;;
  "Active monitor")
    exec hyprshot -m output -m active --clipboard-only
    ;;
  *)
    notify-send "Screenshot failed" "Unknown capture type: $SELECTION"
    exit 1
    ;;
esac
