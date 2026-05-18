#!/bin/zsh
set -euo pipefail

LABEL="com.local.betterdisplay-rgb-full-restore"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
INSTALL_DIR="$HOME/Library/Scripts/BetterDisplayRGBFullRestore"

launchctl bootout "gui/$(id -u)" "$PLIST" >/dev/null 2>&1 || true
rm -f "$PLIST"
rm -rf "$INSTALL_DIR"

echo "Uninstalled BetterDisplay RGB Full Restore"
