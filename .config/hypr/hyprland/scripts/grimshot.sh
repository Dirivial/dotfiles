#!/usr/bin/env bash

set -euo pipefail

MENU_DELAY="${GRIMSHOT_MENU_DELAY:-0.35}"

OPTIONS="active
screen
output
area
window
anything"

get_active_geometry() {
  hyprctl -j activewindow 2>/dev/null | jq -r '
    select(.at and .size and (.at | length) == 2 and (.size | length) == 2) |
    "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"
  '
}

get_focused_output() {
  hyprctl -j monitors 2>/dev/null | jq -r '.[] | select(.focused) | .name'
}

get_visible_window_boxes() {
  hyprctl -j clients 2>/dev/null | jq -r '
    .[]
    | select(.mapped == true)
    | select((.hidden // false) | not)
    | select(.at and .size and (.at | length) == 2 and (.size | length) == 2)
    | select(.size[0] > 0 and .size[1] > 0)
    | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"
  '
}

get_output_boxes() {
  hyprctl -j monitors 2>/dev/null | jq -r '
    .[]
    | select(.x != null and .y != null and .width != null and .height != null)
    | select(.width > 0 and .height > 0)
    | "\(.x),\(.y) \(.width)x\(.height)"
  '
}

copy_with_grim() {
  local -a grim_args=("$@")

  if grim "${grim_args[@]}" - | wl-copy; then
    notify-send "Screenshot copied" "Image copied to clipboard."
    return 0
  fi

  return 1
}

copy_selected_box() {
  local mode="$1"
  local boxes
  local selection

  boxes="$(case "$mode" in
    window) get_visible_window_boxes ;;
    anything)
      {
        get_output_boxes
        get_visible_window_boxes
      } | awk '!seen[$0]++'
      ;;
  esac)"

  if [[ -z "$boxes" ]]; then
    return 1
  fi

  if [[ "$mode" == "window" ]]; then
    selection="$(printf '%s\n' "$boxes" | slurp -r)"
  else
    selection="$(printf '%s\n' "$boxes" | slurp)"
  fi

  if [[ -z "$selection" ]]; then
    return 1
  fi

  copy_with_grim -g "$selection"
}

ACTIVE_GEOMETRY="$(get_active_geometry || true)"
FOCUSED_OUTPUT="$(get_focused_output || true)"

SELECTION="$(printf '%s\n' "$OPTIONS" | wofi --dmenu --prompt "Select grimshot action:")"

if [[ -z "$SELECTION" ]]; then
  exit 0
fi

sleep "$MENU_DELAY"

case "$SELECTION" in
  active)
    if [[ -n "$ACTIVE_GEOMETRY" ]] && copy_with_grim -g "$ACTIVE_GEOMETRY"; then
      exit 0
    fi
    grimshot --notify copy active
    ;;
  output)
    if [[ -n "$FOCUSED_OUTPUT" ]] && copy_with_grim -o "$FOCUSED_OUTPUT"; then
      exit 0
    fi
    grimshot --notify copy output
    ;;
  screen)
    if copy_with_grim; then
      exit 0
    fi
    grimshot --notify copy screen
    ;;
  area)
    grimshot --notify copy "$SELECTION"
    ;;
  window|anything)
    if copy_selected_box "$SELECTION"; then
      exit 0
    fi
    notify-send "Screenshot cancelled" "No selection made."
    exit 1
    ;;
  *)
    notify-send "Screenshot failed" "Unknown screenshot action: $SELECTION"
    exit 1
    ;;
esac
