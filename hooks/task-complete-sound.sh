#!/usr/bin/env bash
# Task Complete Sound Notification
# Plays a system sound when Claude Code session ends

# macOS
if command -v afplay &>/dev/null; then
  afplay /System/Library/Sounds/Glass.aiff &>/dev/null &
# Linux (PulseAudio)
elif command -v paplay &>/dev/null; then
  paplay /usr/share/sounds/freedesktop/stereo/complete.oga &>/dev/null &
# Windows (Git Bash)
elif command -v powershell.exe &>/dev/null; then
  powershell.exe -c "[console]::beep(800,300)" &>/dev/null &
fi
