#!/usr/bin/env bash
set -euo pipefail

# Claude Apex Uninstaller
# Restores backup created during installation

echo ""
echo "═══════════════════════════════════════════"
echo "  CLAUDE APEX — Uninstaller"
echo "═══════════════════════════════════════════"
echo ""

BACKUP_BASE="$HOME/.claude/backups"

# Find most recent pre-apex backup
BACKUP_DIR=$(ls -dt "$BACKUP_BASE"/pre-apex-* 2>/dev/null | head -1)

if [[ -z "$BACKUP_DIR" ]]; then
  echo "No Apex backup found at $BACKUP_BASE/pre-apex-*"
  echo "Cannot restore. You may need to manually remove Apex files."
  exit 1
fi

echo "Found backup: $BACKUP_DIR"
echo ""
echo "This will:"
echo "  1. Restore settings.json and CLAUDE.md from backup"
echo "  2. Remove Apex-added agents, commands, hooks, and skills"
echo "  3. Remove CARL config if it was installed by Apex"
echo ""
read -rp "Continue? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Aborted."
  exit 0
fi

echo ""

# Apex-specific agents (only remove these, not user's own agents)
APEX_AGENTS=(
  architect.md build-error-resolver.md chief-of-staff.md code-reviewer.md
  cs-ceo-advisor.md cs-cto-advisor.md database-reviewer.md doc-updater.md
  e2e-runner.md go-build-resolver.md go-reviewer.md harness-optimizer.md
  loop-operator.md planner.md python-reviewer.md refactor-cleaner.md
  security-reviewer.md seo-content.md seo-geo.md seo-performance.md
  seo-schema.md seo-sitemap.md seo-technical.md seo-visual.md tdd-guide.md
)

echo "Removing Apex agents..."
for agent in "${APEX_AGENTS[@]}"; do
  if [[ -f "$HOME/.claude/agents/$agent" ]]; then
    rm "$HOME/.claude/agents/$agent"
    echo "  [REMOVED] $agent"
  fi
done

echo "Removing Apex commands..."
for cmd in healthcheck.md switch-project.md templates.md; do
  if [[ -f "$HOME/.claude/commands/$cmd" ]]; then
    rm "$HOME/.claude/commands/$cmd"
    echo "  [REMOVED] $cmd"
  fi
done

echo "Removing Apex hooks..."
for hook in post-compact-recovery.sh session-end-save.sh task-complete-sound.sh peers-auto-register.sh carl-hook.py; do
  if [[ -f "$HOME/.claude/hooks/$hook" ]]; then
    rm "$HOME/.claude/hooks/$hook"
    echo "  [REMOVED] $hook"
  fi
done

echo "Removing Apex skills..."
rm -rf "$HOME/.claude/skills/dream-consolidation" 2>/dev/null && echo "  [REMOVED] dream-consolidation" || true
rm -rf "$HOME/.claude/skills/autoresearch" 2>/dev/null && echo "  [REMOVED] autoresearch" || true

echo "Removing Apex config..."
rm -f "$HOME/.claude/ORCHESTRATION-ENGINE.md" 2>/dev/null && echo "  [REMOVED] ORCHESTRATION-ENGINE.md" || true
rm -f "$HOME/.claude/CAPABILITY-REGISTRY.md" 2>/dev/null && echo "  [REMOVED] CAPABILITY-REGISTRY.md" || true

# Restore backups
echo ""
echo "Restoring from backup..."
[[ -f "$BACKUP_DIR/settings.json" ]] && cp "$BACKUP_DIR/settings.json" "$HOME/.claude/settings.json" && echo "  [RESTORED] settings.json"
[[ -f "$BACKUP_DIR/CLAUDE.md" ]] && cp "$BACKUP_DIR/CLAUDE.md" "$HOME/.claude/CLAUDE.md" && echo "  [RESTORED] CLAUDE.md"

echo ""
echo "═══════════════════════════════════════════"
echo "  Uninstall complete!"
echo "═══════════════════════════════════════════"
echo ""
echo "  Restart Claude Code to apply changes."
echo "  Your backup remains at: $BACKUP_DIR"
echo ""
