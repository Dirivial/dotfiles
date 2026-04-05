#!/usr/bin/env bash

set -euo pipefail

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/hypr"
EMOJI_CACHE="$CACHE_DIR/emojis.tsv"
PROMPT="${EMOJI_SELECTOR_PROMPT:-Select emoji}"
PASTE_DELAY="${EMOJI_SELECTOR_PASTE_DELAY:-0.2}"

mkdir -p "$CACHE_DIR"

require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    notify-send "Emoji selector failed" "Missing dependency: $command_name"
    exit 1
  fi
}

build_emoji_cache() {
  python3 - "$EMOJI_CACHE" <<'PY'
import sys
import unicodedata

target = sys.argv[1]

RANGES = (
    (0x2600, 0x27BF),
    (0x1F300, 0x1F5FF),
    (0x1F600, 0x1F64F),
    (0x1F680, 0x1F6FF),
    (0x1F900, 0x1F9FF),
    (0x1FA70, 0x1FAFF),
)

EXCLUDED = {
    0x200D,
    0x20E3,
    0xFE0E,
    0xFE0F,
}

def should_append_vs16(codepoint: int) -> bool:
    return 0x2600 <= codepoint <= 0x27BF

def label_for(char: str) -> str:
    names = []
    for ch in char:
        codepoint = ord(ch)
        if codepoint in EXCLUDED:
            continue
        try:
            name = unicodedata.name(ch)
        except ValueError:
            continue
        if name.startswith("REGIONAL INDICATOR SYMBOL LETTER "):
            names.append(name.removeprefix("REGIONAL INDICATOR SYMBOL LETTER "))
            continue
        names.append(name)

    if not names:
        return ""

    label = " ".join(names).replace("_", " ").lower()
    return " ".join(label.split())

entries = {}

def add(char: str, label: str) -> None:
    if not label:
        return
    entries[char] = label

for start, end in RANGES:
    for codepoint in range(start, end + 1):
        if codepoint in EXCLUDED:
            continue
        if 0x1F1E6 <= codepoint <= 0x1F1FF:
            continue
        if 0x1F3FB <= codepoint <= 0x1F3FF:
            continue
        if 0xE0020 <= codepoint <= 0xE007F:
            continue

        char = chr(codepoint)
        try:
            unicodedata.name(char)
        except ValueError:
            continue

        if should_append_vs16(codepoint):
            char = f"{char}\N{VARIATION SELECTOR-16}"

        add(char, label_for(char))

for keycap in "#*0123456789":
    add(f"{keycap}\N{VARIATION SELECTOR-16}\N{COMBINING ENCLOSING KEYCAP}", f"{keycap} keycap")

for first in range(0x1F1E6, 0x1F200):
    for second in range(0x1F1E6, 0x1F200):
        char = chr(first) + chr(second)
        label = label_for(char)
        if len(label) == 3:
            add(char, f"flag {label.lower()}")

with open(target, "w", encoding="utf-8") as handle:
    for char, label in sorted(entries.items(), key=lambda item: item[1]):
        handle.write(f"{char}\t{label}\n")
PY
}

read_clipboard() {
  local mime_type="$1"

  wl-paste --no-newline --type "$mime_type" 2>/dev/null || return 1
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

paste_selection() {
  local value="$1"
  local original_file
  local original_mime=""
  local candidate

  original_file="$(mktemp)"

  for candidate in "text/plain;charset=utf-8" "text/plain" "UTF8_STRING" "STRING"; do
    if read_clipboard "$candidate" >"$original_file"; then
      original_mime="$candidate"
      break
    fi
  done

  printf '%s' "$value" | wl-copy --trim-newline

  if command -v wtype >/dev/null 2>&1; then
    restore_clipboard "$original_file" "$original_mime"
    wtype -- "$value"
    return 0
  fi

  restore_clipboard "$original_file" "$original_mime"

  local dispatch_output=""

  for shortcut in \
    "CTRL,V" \
    "CTRL, V" \
    "CONTROL,V" \
    "CONTROL, V"
  do
    if dispatch_output="$(hyprctl dispatch sendshortcut "$shortcut" 2>&1)"; then
      return 0
    fi
  done

  notify-send "Emoji copied" "Paste the selected emoji manually if it was not inserted."
  printf '%s\n' "$dispatch_output" >&2
  return 1
}

require_command python3
require_command wofi
require_command wl-copy
require_command wl-paste
require_command hyprctl

if [[ ! -s "$EMOJI_CACHE" ]]; then
  build_emoji_cache
fi

selection="$(wofi --dmenu --prompt "$PROMPT" < "$EMOJI_CACHE")"

if [[ -z "$selection" ]]; then
  exit 0
fi

emoji="${selection%%$'\t'*}"

if [[ -z "$emoji" ]]; then
  notify-send "Emoji selector failed" "Unable to parse selected emoji."
  exit 1
fi

paste_selection "$emoji"
