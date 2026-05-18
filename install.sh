#!/bin/zsh
set -euo pipefail

BETTERDISPLAY="/Applications/BetterDisplay.app/Contents/MacOS/BetterDisplay"
LABEL="com.local.betterdisplay-rgb-full-restore"
INSTALL_DIR="$HOME/Library/Scripts/BetterDisplayRGBFullRestore"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"

if [[ $# -lt 1 ]]; then
  echo "Usage: ./install.sh \"Display Name\""
  exit 2
fi

DISPLAY_NAME="$1"

if [[ ! -x "$BETTERDISPLAY" ]]; then
  echo "BetterDisplay was not found at $BETTERDISPLAY"
  exit 1
fi

MODE_LINE="$("$BETTERDISPLAY" get -name="$DISPLAY_NAME" -connectionModeList | grep -E 'SDR RGB Full' | head -1 || true)"

if [[ -z "$MODE_LINE" ]]; then
  echo "No SDR RGB Full connection mode found for display: $DISPLAY_NAME"
  echo "Available modes:"
  "$BETTERDISPLAY" get -name="$DISPLAY_NAME" -connectionModeList
  exit 1
fi

RGB_FULL_MODE="$(echo "$MODE_LINE" | awk '{print $1}')"

mkdir -p "$INSTALL_DIR" "$HOME/Library/LaunchAgents"
cp "$(dirname "$0")/scripts/restore-rgb-full.sh" "$INSTALL_DIR/restore-rgb-full.sh"
chmod +x "$INSTALL_DIR/restore-rgb-full.sh"

cat > "$PLIST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$LABEL</string>
  <key>ProgramArguments</key>
  <array>
    <string>$INSTALL_DIR/restore-rgb-full.sh</string>
  </array>
  <key>EnvironmentVariables</key>
  <dict>
    <key>BETTERDISPLAY_DISPLAY_NAME</key>
    <string>$DISPLAY_NAME</string>
    <key>BETTERDISPLAY_RGB_FULL_MODE</key>
    <string>$RGB_FULL_MODE</string>
  </dict>
  <key>RunAtLoad</key>
  <true/>
  <key>StartInterval</key>
  <integer>60</integer>
  <key>StandardOutPath</key>
  <string>/tmp/betterdisplay-rgb-full-restore.out.log</string>
  <key>StandardErrorPath</key>
  <string>/tmp/betterdisplay-rgb-full-restore.err.log</string>
</dict>
</plist>
PLIST

plutil -lint "$PLIST" >/dev/null

launchctl bootout "gui/$(id -u)" "$PLIST" >/dev/null 2>&1 || true
launchctl bootstrap "gui/$(id -u)" "$PLIST"
launchctl kickstart -k "gui/$(id -u)/$LABEL"

echo "Installed BetterDisplay RGB Full Restore"
echo "Display: $DISPLAY_NAME"
echo "Mode: $MODE_LINE"
