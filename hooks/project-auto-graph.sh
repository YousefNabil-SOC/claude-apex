#!/usr/bin/env bash
# Apex V7 — project-auto-graph.sh
# Runs at SessionStart. Detects if CWD is a project NOT already in the
# graphs manifest and queues it.
#
# This hook NEVER auto-runs graphify (cost risk from internal Claude API
# calls). It only queues + notifies. The user can opt-in by running:
#   cd <project> && graphify .

set -u

MANIFEST="$HOME/.claude/graphs/manifest.json"
QUEUE="$HOME/.claude/graphs/pending-queue.txt"
CWD="${PWD:-$(pwd)}"
[ -z "$CWD" ] && exit 0
[ "$CWD" = "$HOME" ] && exit 0
[ "$CWD" = "$HOME/.claude" ] && exit 0

# Protected paths — never queue
case "$CWD" in
  */.claude/backups*|*/.claude/graphs*|*/.claude/plugins*|*/.claude/skills*|*/claude-peers-mcp*)
    exit 0 ;;
esac

# Detect if CWD looks like a project
is_project=false
for marker in package.json pyproject.toml .git CLAUDE.md requirements.txt Cargo.toml go.mod composer.json; do
  [ -e "$CWD/$marker" ] && is_project=true && break
done
[ "$is_project" = false ] && exit 0

# Check if already in manifest
if [ -f "$MANIFEST" ] && command -v python3 >/dev/null 2>&1; then
  in_manifest="$(python3 -c "
import json, sys
from pathlib import Path
try:
    d=json.load(open(r'$MANIFEST', encoding='utf-8'))
    cwd=str(Path(r'$CWD').resolve())
    for p in d.get('projects', []):
        if str(Path(p['path']).resolve()) == cwd:
            print(p.get('status','pending'))
            break
    else:
        print('unknown')
except Exception:
    print('unknown')
")"
  case "$in_manifest" in
    complete)
      exit 0 ;;
    pending|unknown)
      mkdir -p "$(dirname "$QUEUE")"
      touch "$QUEUE"
      grep -Fxq "$CWD" "$QUEUE" 2>/dev/null || echo "$CWD" >> "$QUEUE"
      name="$(basename "$CWD")"
      if [ -f "$CWD/graphify-out/graph.json" ]; then
        echo "GRAPH: Ready (graphify-out/graph.json exists) — use graphify query."
      else
        echo "GRAPH: New project detected: $name. Queued. Build when ready: cd \"$CWD\" && graphify ."
      fi
      ;;
  esac
fi
