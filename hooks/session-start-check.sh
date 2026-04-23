#!/bin/bash
# SessionStart Hook
# Purpose: Quick health check at session start

echo "=== SESSION START HEALTH CHECK ==="

# Check critical files exist
for f in CLAUDE.md PRIMER.md CAPABILITY-REGISTRY.md AGENTS.md; do
    if [ -f "$HOME/.claude/$f" ]; then
        echo "OK: $f ($(wc -l < "$HOME/.claude/$f") lines)"
    else
        echo "MISSING: $f - CRITICAL FILE MISSING"
    fi
done

# Check memory files
for f in tool-health.md session-handoff.md decisions.md learning-log.md; do
    if [ -f "$HOME/.claude/memory/$f" ]; then
        echo "OK: memory/$f"
    else
        echo "WARN: memory/$f missing"
    fi
done

# Show last session handoff if exists
if [ -f "$HOME/.claude/memory/session-handoff.md" ]; then
    echo ""
    echo "=== LAST SESSION HANDOFF ==="
    tail -20 "$HOME/.claude/memory/session-handoff.md"
fi

# claude-mem heartbeat (non-blocking, short timeout)
if command -v claude-mem >/dev/null 2>&1; then
    CM_VER="$(claude-mem --version 2>/dev/null | head -1 || true)"
    [ -n "$CM_VER" ] && echo "CLAUDE-MEM: v$CM_VER loaded — search with /mem-search"
fi

echo "=== END HEALTH CHECK ==="
