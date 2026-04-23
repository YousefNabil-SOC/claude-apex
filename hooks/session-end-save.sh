#!/bin/bash
# SessionEnd Hook
# Purpose: Save session summary for next session to pick up

TIMESTAMP=$(date +"%Y-%m-%d %H:%M")
SESSION_LOG="$HOME/.claude/memory/session-handoff.md"

# Append session end marker
echo "" >> "$SESSION_LOG"
echo "## Session ended: $TIMESTAMP" >> "$SESSION_LOG"
echo "---" >> "$SESSION_LOG"

# Keep only last 50 lines to prevent bloat
if [ -f "$SESSION_LOG" ]; then
    tail -50 "$SESSION_LOG" > "$SESSION_LOG.tmp"
    mv "$SESSION_LOG.tmp" "$SESSION_LOG"
fi
