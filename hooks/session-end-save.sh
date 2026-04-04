#!/usr/bin/env bash
# Session End Save Hook
# Appends timestamp to session handoff file on exit

HANDOFF="$HOME/.claude/memory/session-handoff.md"
if [[ -f "$HANDOFF" ]]; then
  echo "" >> "$HANDOFF"
  echo "## Session ended: $(date '+%Y-%m-%d %H:%M')" >> "$HANDOFF"
  echo "---" >> "$HANDOFF"
fi
