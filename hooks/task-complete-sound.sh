#!/bin/bash
# Play a sound when Claude Code finishes a task (Stop event)
# Cooldown: skip if sound played in the last 60 seconds
LOCKFILE="/tmp/claude-sound-cooldown"
NOW=$(date +%s)
if [ -f "$LOCKFILE" ]; then
    LAST=$(cat "$LOCKFILE" 2>/dev/null || echo 0)
    DIFF=$((NOW - LAST))
    [ "$DIFF" -lt 60 ] && exit 0
fi
echo "$NOW" > "$LOCKFILE"
powershell.exe -c "[System.Media.SystemSounds]::Asterisk.Play()" 2>/dev/null || true
