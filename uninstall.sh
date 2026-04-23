#!/usr/bin/env bash
set -euo pipefail

# Claude Apex V7 Uninstaller
# Restores backup created during installation

echo ""
echo "═══════════════════════════════════════════"
echo "  CLAUDE APEX V7 — Uninstaller"
echo "═══════════════════════════════════════════"
echo ""

BACKUP_BASE="$HOME/.claude/backups"

BACKUP_DIR=$(ls -dt "$BACKUP_BASE"/pre-apex-* 2>/dev/null | head -1 || true)

if [[ -z "${BACKUP_DIR:-}" ]]; then
  echo "No Apex backup found at $BACKUP_BASE/pre-apex-*"
  echo "Cannot restore. You may need to manually remove Apex files."
  exit 1
fi

echo "Found backup: $BACKUP_DIR"
echo ""
echo "This will:"
echo "  1. Restore settings.json, CLAUDE.md, PRIMER.md from backup"
echo "  2. Remove Apex-added agents, commands, hooks, and skills"
echo "  3. Remove CARL config if it was installed by Apex"
echo "  4. Remove V7 config files (ORCHESTRATION-ENGINE.md, CAPABILITY-REGISTRY.md, etc.)"
echo ""
read -rp "Continue? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Aborted."
  exit 0
fi

echo ""

# Apex-specific agents (25)
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

echo ""
echo "Removing Apex commands..."
for cmd in healthcheck.md switch-project.md templates.md; do
  if [[ -f "$HOME/.claude/commands/$cmd" ]]; then
    rm "$HOME/.claude/commands/$cmd"
    echo "  [REMOVED] $cmd"
  fi
done
# Also remove paul/seed/autoresearch subdirs if Apex installed them
# (conservative — only remove if the user didn't have them before)
# Skipping auto-removal of subdirs for safety.

echo ""
echo "Removing Apex hooks (V7 — 7 hooks)..."
for hook in carl-hook.py post-compact-recovery.sh session-end-save.sh task-complete-sound.sh peers-auto-register.sh session-start-check.sh project-auto-graph.sh; do
  if [[ -f "$HOME/.claude/hooks/$hook" ]]; then
    rm "$HOME/.claude/hooks/$hook"
    echo "  [REMOVED] $hook"
  fi
done

echo ""
echo "Removing Apex skills (9 custom)..."
for skill in dream-consolidation autoresearch premium-web-design 21st-dev-magic instagram-access graphify graphic-design-studio impeccable fireworks-tech-graph; do
  if [[ -d "$HOME/.claude/skills/$skill" ]]; then
    rm -rf "$HOME/.claude/skills/$skill"
    echo "  [REMOVED] skill: $skill"
  fi
done

echo ""
echo "Removing Apex config files..."
for f in ORCHESTRATION-ENGINE.md CAPABILITY-REGISTRY.md COMMAND-REGISTRY.md AGENTS.md AUTO-ACTIVATION-MATRIX.md; do
  [[ -f "$HOME/.claude/$f" ]] && rm "$HOME/.claude/$f" && echo "  [REMOVED] $f"
done

# Restore backups
echo ""
echo "Restoring from backup..."
for f in settings.json CLAUDE.md PRIMER.md; do
  [[ -f "$BACKUP_DIR/$f" ]] && cp "$BACKUP_DIR/$f" "$HOME/.claude/$f" && echo "  [RESTORED] $f"
done

echo ""
echo "═══════════════════════════════════════════"
echo "  Uninstall complete!"
echo "═══════════════════════════════════════════"
echo ""
echo "  Restart Claude Code to apply changes."
echo "  Your backup remains at: $BACKUP_DIR"
echo ""
echo "  Note: ~/.carl/carl.json was NOT removed. Delete manually if desired:"
echo "    rm -rf ~/.carl"
echo "  Note: ~/.claude/.env was NOT removed (keeps your API keys safe). Delete manually if desired."
echo ""
