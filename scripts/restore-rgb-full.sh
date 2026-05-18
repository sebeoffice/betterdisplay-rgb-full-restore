#!/bin/zsh
set -u

BETTERDISPLAY="/Applications/BetterDisplay.app/Contents/MacOS/BetterDisplay"

DISPLAY_NAME="${BETTERDISPLAY_DISPLAY_NAME:-}"
RGB_FULL_MODE="${BETTERDISPLAY_RGB_FULL_MODE:-}"

if [[ ! -x "$BETTERDISPLAY" ]]; then
  exit 0
fi

if [[ -z "$DISPLAY_NAME" || -z "$RGB_FULL_MODE" ]]; then
  exit 0
fi

"$BETTERDISPLAY" set -name="$DISPLAY_NAME" -connectionMode="$RGB_FULL_MODE" >/dev/null 2>&1
