# BetterDisplay RGB Full Restore

Small macOS helper for displays that revert from `RGB Full` back to `YCbCr Limited` after sleep, wake, or restart.

It uses BetterDisplay's command line interface to periodically restore a chosen display to an RGB full-range connection mode.

## When This Helps

Use this if BetterDisplay shows something like:

- desired: `8bit SDR RGB Full`
- reverted state: `8bit SDR YCbCr 4:4:4 Limited`

BetterDisplay Pro has built-in configuration protection for this. This helper is a lightweight fallback for setups where that protection is unavailable.

## Requirements

- macOS on Apple Silicon
- BetterDisplay installed at `/Applications/BetterDisplay.app`
- A display mode listed by BetterDisplay that contains `SDR RGB Full`

## Install

```bash
./install.sh "MSI MP242"
```

Replace `MSI MP242` with your display name as shown by BetterDisplay.

The installer:

- finds the first compatible `SDR RGB Full` mode for the display
- installs a restore script under `~/Library/Scripts/BetterDisplayRGBFullRestore`
- installs a LaunchAgent under `~/Library/LaunchAgents`
- runs it once at login

It intentionally does not run every minute. Reapplying display connection modes
can wake some monitors or make BetterDisplay simulate user activity, which may
prevent clean sleep.

## Check Current Modes

```bash
/Applications/BetterDisplay.app/Contents/MacOS/BetterDisplay get -name="MSI MP242" -connectionModeList
```

## Uninstall

```bash
./uninstall.sh
```

## Notes

This does not modify BetterDisplay itself. It simply asks BetterDisplay to reapply a known-good connection mode.

If your display changes mode after wake, run the installed script manually or
use BetterDisplay Pro's built-in configuration protection instead of polling.
