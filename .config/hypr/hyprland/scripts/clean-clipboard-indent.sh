#!/usr/bin/env bash
set -euo pipefail

FOCUS_DELAY="${FOCUS_DELAY:-0.05}"
PASTE_DELAY="${PASTE_DELAY:-0.3}"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$1" >&2
    exit 1
  fi
}

read_clipboard() {
  local mime_type="$1"

  wl-paste --type "$mime_type" 2>/dev/null || return 1
}

active_window_class() {
  hyprctl activewindow 2>/dev/null | awk -F': ' '$1 ~ /^[[:space:]]*class$/ { print $2; exit }' || true
}

uses_terminal_paste_shortcut() {
  local window_class="${1,,}"

  case "$window_class" in
    alacritty|kitty|foot|ghostty|wezterm|org.wezfurlong.wezterm|com.mitchellh.ghostty)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

send_paste_shortcut() {
  local dispatch_output=""
  local shortcuts=(
    "CTRL,V,activewindow"
    "CTRL, V, activewindow"
    "CONTROL,V,activewindow"
    "CONTROL, V, activewindow"
    "CTRL,V"
    "CTRL, V"
    "CONTROL,V"
    "CONTROL, V"
  )

  if uses_terminal_paste_shortcut "$ACTIVE_WINDOW_CLASS"; then
    shortcuts=(
      "CTRL SHIFT,V,activewindow"
      "CTRL SHIFT, V, activewindow"
      "CONTROL SHIFT,V,activewindow"
      "CONTROL SHIFT, V, activewindow"
      "CTRL SHIFT,V"
      "CTRL SHIFT, V"
      "CONTROL SHIFT,V"
      "CONTROL SHIFT, V"
    )
  fi

  sleep "$FOCUS_DELAY"

  if command -v wtype >/dev/null 2>&1; then
    if uses_terminal_paste_shortcut "$ACTIVE_WINDOW_CLASS"; then
      if wtype -M ctrl -M shift -k v -m shift -m ctrl >/dev/null 2>&1; then
        return 0
      fi
    fi

    if wtype -M ctrl -k v -m ctrl >/dev/null 2>&1; then
      return 0
    fi
  fi

  for shortcut in "${shortcuts[@]}"; do
    if dispatch_output="$(hyprctl dispatch sendshortcut "$shortcut" 2>&1)"; then
      return 0
    fi
  done

  printf '%s\n' "$dispatch_output" >&2
  return 1
}

restore_clipboard() {
  local original_file="$1"
  local original_mime="$2"

  (
    sleep "$PASTE_DELAY"

    if [[ -n "$original_mime" && -s "$original_file" ]]; then
      wl-copy --type "$original_mime" < "$original_file"
    else
      wl-copy --clear
    fi

    rm -f "$original_file"
  ) >/dev/null 2>&1 &
}

clean_clipboard_text() {
  local mode="$1"

  python3 - "$mode" <<'PY'
import sys

mode = sys.argv[1]
data = sys.stdin.buffer.read()
lines = data.splitlines(keepends=True)

if mode == "trim-start":
    data = data.lstrip(b" \t\r\n")
elif mode == "trim-lines":
    data = b"".join(line.lstrip(b" \t") for line in lines)
elif mode == "remove-two-spaces":
    data = b"".join(
        line[2:] if line.startswith(b"  ") else line[1:] if line.startswith(b" ") else line
        for line in lines
    )
else:
    raise SystemExit(f"Unknown clean mode: {mode}")

sys.stdout.buffer.write(data)
PY
}

require_command python3
require_command wl-copy
require_command wl-paste
require_command hyprctl

clean_mode="${1:-remove-two-spaces}"
ACTIVE_WINDOW_CLASS="$(active_window_class)"
original_file="$(mktemp)"
cleaned_file="$(mktemp)"
original_mime=""

for candidate in "text/plain;charset=utf-8" "text/plain" "UTF8_STRING" "STRING"; do
  if read_clipboard "$candidate" > "$original_file"; then
    original_mime="$candidate"
    break
  fi
done

if [[ -z "$original_mime" ]]; then
  rm -f "$original_file" "$cleaned_file"
  exit 0
fi

clean_clipboard_text "$clean_mode" < "$original_file" > "$cleaned_file"
wl-copy --type text/plain < "$cleaned_file"
rm -f "$cleaned_file"

if send_paste_shortcut; then
  restore_clipboard "$original_file" "$original_mime"
  exit 0
fi

wl-copy --type "$original_mime" < "$original_file"
rm -f "$original_file"
exit 1
