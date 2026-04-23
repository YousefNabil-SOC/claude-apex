#!/usr/bin/env bash
# Apex V7 Post-Compact Recovery Hook
# Fires after /compact to restore critical context awareness
# Outputs a reminder that gets injected into the conversation

echo "=== POST-COMPACT RECOVERY ==="
echo "Context was compacted. Re-read these files NOW:"
echo "1. ~/.claude/CAPABILITY-REGISTRY.md — routing table and tool inventory"
echo "2. ~/.claude/PRIMER.md — identity, stakeholders, active projects"
echo ""
echo "CRITICAL RULES (must survive compaction):"
echo "- TypeScript only. Files under 300 lines. npm run build after changes."
echo "- git add specific files only, NEVER git add -A"
echo "- vercel --prod → ALWAYS vercel alias set <url> <canonical-domain>"
echo "- Generate non-Latin scripts (Arabic/Hebrew/CJK) inside Python, never terminal"
echo "- If effort is above 'high', lower to 'high'. Never xhigh or max."
echo "- Use stakeholder titles EXACTLY as defined in PRIMER.md"
echo ""
echo "After re-reading, continue the task that was in flight."
echo "=== END RECOVERY ==="
