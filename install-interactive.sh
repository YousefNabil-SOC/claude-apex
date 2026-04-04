#!/usr/bin/env bash
set -euo pipefail

# Claude Pantheon V6 Interactive Installer
# Lets users choose what to install

PANTHEON_VERSION="6.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "═══════════════════════════════════════════"
echo "  CLAUDE PANTHEON V${PANTHEON_VERSION} — Interactive Setup"
echo "═══════════════════════════════════════════"
echo ""
echo "This installer lets you choose which components to install."
echo "Your existing configuration will be backed up first."
echo ""

ask() {
  local prompt="$1"
  read -rp "$prompt (y/n): " answer
  [[ "$answer" == "y" || "$answer" == "Y" ]]
}

INSTALL_AGENTS=false
INSTALL_COMMANDS=false
INSTALL_HOOKS=false
INSTALL_SKILLS=false
INSTALL_CARL=false
INSTALL_CONFIG=false
INSTALL_THIRDPARTY=false

echo "Select components to install:"
echo ""
ask "  Install 25 specialist agents?" && INSTALL_AGENTS=true
ask "  Install slash commands (healthcheck, switch-project, templates)?" && INSTALL_COMMANDS=true
ask "  Install automation hooks (5 scripts)?" && INSTALL_HOOKS=true
ask "  Install custom skills (dream-consolidation, autoresearch)?" && INSTALL_SKILLS=true
ask "  Install CARL domains (7 domains, 33 JIT rules)?" && INSTALL_CARL=true
ask "  Install config templates (orchestration engine, capability registry)?" && INSTALL_CONFIG=true
ask "  Install third-party tools (OMC, PAUL, Claude Peers)?" && INSTALL_THIRDPARTY=true

echo ""

# Check if anything was selected
if ! $INSTALL_AGENTS && ! $INSTALL_COMMANDS && ! $INSTALL_HOOKS && \
   ! $INSTALL_SKILLS && ! $INSTALL_CARL && ! $INSTALL_CONFIG && \
   ! $INSTALL_THIRDPARTY; then
  echo "Nothing selected. Exiting."
  exit 0
fi

echo "Creating backup..."
BACKUP_DIR="$HOME/.claude/backups/pre-pantheon-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
[[ -f "$HOME/.claude/settings.json" ]] && cp "$HOME/.claude/settings.json" "$BACKUP_DIR/"
[[ -f "$HOME/.claude/CLAUDE.md" ]] && cp "$HOME/.claude/CLAUDE.md" "$BACKUP_DIR/"
echo "  Backup at: $BACKUP_DIR"
echo ""

if $INSTALL_AGENTS; then
  echo "Installing agents..."
  mkdir -p "$HOME/.claude/agents"
  for f in "$SCRIPT_DIR"/agents/*.md; do
    [[ "$(basename "$f")" == "README.md" ]] && continue
    name=$(basename "$f")
    if [[ ! -f "$HOME/.claude/agents/$name" ]]; then
      cp "$f" "$HOME/.claude/agents/$name"
      echo "  [INSTALL] $name"
    else
      echo "  [SKIP] $name"
    fi
  done
  echo ""
fi

if $INSTALL_COMMANDS; then
  echo "Installing commands..."
  mkdir -p "$HOME/.claude/commands"
  for f in "$SCRIPT_DIR"/commands/*.md; do
    [[ "$(basename "$f")" == "README.md" ]] && continue
    name=$(basename "$f")
    if [[ ! -f "$HOME/.claude/commands/$name" ]]; then
      cp "$f" "$HOME/.claude/commands/$name"
      echo "  [INSTALL] $name"
    else
      echo "  [SKIP] $name"
    fi
  done
  echo ""
fi

if $INSTALL_HOOKS; then
  echo "Installing hooks..."
  mkdir -p "$HOME/.claude/hooks"
  for f in "$SCRIPT_DIR"/hooks/*; do
    [[ "$(basename "$f")" == "README.md" ]] && continue
    name=$(basename "$f")
    if [[ ! -f "$HOME/.claude/hooks/$name" ]]; then
      cp "$f" "$HOME/.claude/hooks/$name"
      chmod +x "$HOME/.claude/hooks/$name" 2>/dev/null || true
      echo "  [INSTALL] $name"
    else
      echo "  [SKIP] $name"
    fi
  done
  echo ""
fi

if $INSTALL_SKILLS; then
  echo "Installing skills..."
  for skill in dream-consolidation autoresearch; do
    if [[ ! -d "$HOME/.claude/skills/$skill" ]]; then
      mkdir -p "$HOME/.claude/skills/$skill"
      cp -r "$SCRIPT_DIR/skills/$skill/"* "$HOME/.claude/skills/$skill/"
      echo "  [INSTALL] $skill"
    else
      echo "  [SKIP] $skill"
    fi
  done
  echo ""
fi

if $INSTALL_CARL; then
  echo "Installing CARL domains..."
  if [[ ! -f "$HOME/.carl/carl.json" ]]; then
    mkdir -p "$HOME/.carl"
    cp "$SCRIPT_DIR/config/carl-domains.json" "$HOME/.carl/carl.json"
    echo "  [INSTALL] carl.json (7 domains, 33 rules)"
  else
    echo "  [SKIP] carl.json already exists"
  fi
  echo ""
fi

if $INSTALL_CONFIG; then
  echo "Installing config templates..."
  [[ ! -f "$HOME/.claude/ORCHESTRATION-ENGINE.md" ]] && \
    cp "$SCRIPT_DIR/config/orchestration-engine.md" "$HOME/.claude/ORCHESTRATION-ENGINE.md" && \
    echo "  [INSTALL] orchestration-engine.md" || echo "  [SKIP] orchestration-engine.md"
  [[ ! -f "$HOME/.claude/CAPABILITY-REGISTRY.md" ]] && \
    cp "$SCRIPT_DIR/config/capability-registry.md" "$HOME/.claude/CAPABILITY-REGISTRY.md" && \
    echo "  [INSTALL] capability-registry.md" || echo "  [SKIP] capability-registry.md"
  echo ""
fi

if $INSTALL_THIRDPARTY; then
  echo "Third-party tools:"
  echo ""
  echo "  To install oh-my-claudecode, open Claude Code and run:"
  echo "    /install-plugin oh-my-claudecode@omc"
  echo ""
  echo "  To install PAUL framework:"
  echo "    npx paul-framework --global"
  echo ""
  if [[ ! -d "$HOME/claude-peers-mcp" ]]; then
    echo "  Cloning Claude Peers MCP..."
    git clone https://github.com/louislva/claude-peers-mcp.git "$HOME/claude-peers-mcp" 2>/dev/null || true
  else
    echo "  [SKIP] Claude Peers already cloned"
  fi
  echo ""
fi

echo "═══════════════════════════════════════════"
echo "  Installation complete!"
echo "═══════════════════════════════════════════"
echo ""
echo "  Restart Claude Code, then run /healthcheck"
echo "  Backup at: $BACKUP_DIR"
echo ""
