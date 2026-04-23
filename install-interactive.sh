#!/usr/bin/env bash
set -euo pipefail

# Claude Apex V6 Interactive Installer
# Lets users choose what to install

APEX_VERSION="7.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "═══════════════════════════════════════════"
echo "  CLAUDE APEX V${APEX_VERSION} — Interactive Setup"
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
BACKUP_DIR="$HOME/.claude/backups/pre-apex-$(date +%Y%m%d-%H%M%S)"
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
  if [[ ! -d "$HOME/claude-peers-mcp" ]]; then
    echo "  Cloning Claude Peers MCP..."
    git clone https://github.com/louislva/claude-peers-mcp.git "$HOME/claude-peers-mcp" 2>/dev/null || true
  else
    echo "  [SKIP] Claude Peers already cloned"
  fi

  if command -v bun &>/dev/null; then
    echo "  [OK] Bun already installed"
  else
    echo "  Installing Bun..."
    npm install -g bun 2>/dev/null && echo "  [OK] Bun installed" || echo "  [SKIP] Bun install failed (optional)"
  fi
  echo ""
fi

# --- Configure MCP Servers ---
if $INSTALL_CONFIG || $INSTALL_THIRDPARTY; then
  echo "Configuring MCP servers..."
  python3 << 'PYEOF'
import json, os, sys

settings_path = os.path.expanduser("~/.claude/settings.json")
if not os.path.exists(settings_path):
    print("  [SKIP] No settings.json found — skipping MCP config")
    sys.exit(0)

with open(settings_path) as f:
    settings = json.load(f)

if "mcpServers" not in settings:
    settings["mcpServers"] = {}

servers_to_add = {
    "context7": {"command": "npx", "args": ["-y", "@context7/mcp-server"]},
    "playwright": {"command": "npx", "args": ["-y", "@playwright/mcp"]},
    "memory": {"command": "npx", "args": ["-y", "@modelcontextprotocol/server-memory"]},
    "sequential-thinking": {"command": "npx", "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]}
}

added = 0
for name, config in servers_to_add.items():
    if name not in settings["mcpServers"]:
        settings["mcpServers"][name] = config
        print(f"  [INSTALL] MCP server: {name}")
        added += 1
    else:
        print(f"  [SKIP] MCP server: {name} (already exists)")

if added > 0:
    with open(settings_path, 'w') as f:
        json.dump(settings, f, indent=2)
    print(f"  {added} MCP servers added to settings.json")
else:
    print("  All MCP servers already configured")
PYEOF
  echo ""
fi

# --- Configure Hooks in settings.json ---
if $INSTALL_HOOKS; then
  echo "Configuring hooks in settings.json..."
  python3 << 'PYEOF'
import json, os, sys

settings_path = os.path.expanduser("~/.claude/settings.json")
if not os.path.exists(settings_path):
    print("  [SKIP] No settings.json found — skipping hooks config")
    sys.exit(0)

with open(settings_path) as f:
    settings = json.load(f)

if "hooks" not in settings:
    settings["hooks"] = {}

changed = False

if "PostCompact" not in settings["hooks"]:
    settings["hooks"]["PostCompact"] = [
        {"type": "command", "command": "bash $HOME/.claude/hooks/post-compact-recovery.sh"}
    ]
    print("  [INSTALL] PostCompact hook")
    changed = True
else:
    print("  [SKIP] PostCompact hook (already exists)")

if "Stop" not in settings["hooks"]:
    settings["hooks"]["Stop"] = []

stop_hooks = settings["hooks"]["Stop"]
existing_commands = [h.get("command", "") for h in stop_hooks if isinstance(h, dict)]

if not any("session-end-save" in c for c in existing_commands):
    stop_hooks.append({"type": "command", "command": "bash $HOME/.claude/hooks/session-end-save.sh"})
    print("  [INSTALL] session-end-save Stop hook")
    changed = True

if not any("task-complete-sound" in c for c in existing_commands):
    stop_hooks.append({"type": "command", "command": "bash $HOME/.claude/hooks/task-complete-sound.sh"})
    print("  [INSTALL] task-complete-sound Stop hook")
    changed = True

if changed:
    with open(settings_path, 'w') as f:
        json.dump(settings, f, indent=2)
    print("  Hooks configured in settings.json")
else:
    print("  All hooks already configured")
PYEOF
  echo ""
fi

# --- Plugin Installation Instructions ---
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  IMPORTANT: Complete these steps in Claude Code"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "  Open Claude Code and run these commands to install"
echo "  the plugins that bring 1,000+ skills and 19 agents:"
echo ""
echo "  1. Install everything-claude-code (1,000+ skills):"
echo "     /plugin marketplace add https://github.com/anthropic-community/everything-claude-code"
echo "     /plugin install everything-claude-code"
echo ""
echo "  2. Install oh-my-claudecode (19 agents, autopilot):"
echo "     /plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode"
echo "     /plugin install oh-my-claudecode"
echo ""
echo "  3. Run OMC setup:"
echo "     /oh-my-claudecode:omc-setup"
echo ""
echo "  4. Verify everything:"
echo "     /healthcheck"
echo ""
echo "═══════════════════════════════════════════════════════════"

# --- Post-Install Verification ---
echo ""
echo "[APEX] Running post-install verification..."
echo ""
if [ -f "$SCRIPT_DIR/verify.sh" ]; then
  bash "$SCRIPT_DIR/verify.sh"
fi

echo ""
echo "==========================================="
echo "  Installation complete!"
echo "==========================================="
echo ""
echo "  Restart Claude Code, then run /healthcheck"
echo "  Backup at: $BACKUP_DIR"
echo ""
