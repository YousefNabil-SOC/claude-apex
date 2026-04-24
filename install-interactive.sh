#!/usr/bin/env bash
set -euo pipefail

# Claude Apex V7 Interactive Installer
# Lets users choose what to install
# Author: Engineer Yousef Nabil -- https://github.com/YousefNabil-SOC/claude-apex

APEX_VERSION="7.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "=============================================="
echo "  Claude Apex V${APEX_VERSION} -- Interactive Setup"
echo "  by Engineer Yousef Nabil"
echo "  github.com/YousefNabil-SOC/claude-apex"
echo "=============================================="
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
ask "  Install slash commands (healthcheck, switch-project, templates, PAUL/SEED/autoresearch subdirs)?" && INSTALL_COMMANDS=true
ask "  Install automation hooks (7 V7 scripts)?" && INSTALL_HOOKS=true
ask "  Install custom skills (9 Apex custom)?" && INSTALL_SKILLS=true
ask "  Install CARL domains (9 domains, 40 JIT rules)?" && INSTALL_CARL=true
ask "  Install config templates (orchestration, capability-registry, command-registry, agents, auto-activation-matrix)?" && INSTALL_CONFIG=true
ask "  Install third-party tools (Bun for Claude Peers)?" && INSTALL_THIRDPARTY=true

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
[[ -f "$HOME/.claude/PRIMER.md" ]] && cp "$HOME/.claude/PRIMER.md" "$BACKUP_DIR/"
[[ -d "$HOME/.claude/agents" ]] && cp -r "$HOME/.claude/agents" "$BACKUP_DIR/agents-bak"
[[ -d "$HOME/.claude/commands" ]] && cp -r "$HOME/.claude/commands" "$BACKUP_DIR/commands-bak"
[[ -d "$HOME/.claude/hooks" ]] && cp -r "$HOME/.claude/hooks" "$BACKUP_DIR/hooks-bak"
echo "  Backup at: $BACKUP_DIR"
echo ""

if $INSTALL_AGENTS; then
  echo "Installing agents (25 specialists)..."
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
  # Subdirs
  for subdir in paul seed autoresearch; do
    if [[ -d "$SCRIPT_DIR/commands/$subdir" ]]; then
      if [[ -d "$HOME/.claude/commands/$subdir" ]]; then
        echo "  [SKIP] commands/$subdir"
      else
        mkdir -p "$HOME/.claude/commands/$subdir"
        cp -r "$SCRIPT_DIR/commands/$subdir/." "$HOME/.claude/commands/$subdir/"
        echo "  [INSTALL] commands/$subdir"
      fi
    fi
  done
  echo ""
fi

if $INSTALL_HOOKS; then
  echo "Installing hooks (V7 -- 7 scripts)..."
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
  echo "Installing skills (V7 -- 9 custom Apex)..."
  mkdir -p "$HOME/.claude/skills"
  for skill in dream-consolidation autoresearch premium-web-design 21st-dev-magic instagram-access graphify graphic-design-studio impeccable fireworks-tech-graph; do
    if [[ ! -d "$HOME/.claude/skills/$skill" ]]; then
      if [[ -d "$SCRIPT_DIR/skills/$skill" ]]; then
        mkdir -p "$HOME/.claude/skills/$skill"
        cp -r "$SCRIPT_DIR/skills/$skill/." "$HOME/.claude/skills/$skill/"
        echo "  [INSTALL] skill: $skill"
      fi
    else
      echo "  [SKIP] skill: $skill"
    fi
  done
  echo ""
fi

if $INSTALL_CARL; then
  echo "Installing CARL domains (9 domains, 40 rules)..."
  if [[ ! -f "$HOME/.carl/carl.json" ]]; then
    mkdir -p "$HOME/.carl"
    cp "$SCRIPT_DIR/config/carl-domains.json" "$HOME/.carl/carl.json"
    echo "  [INSTALL] carl.json (9 domains, 40 rules)"
  else
    echo "  [SKIP] carl.json already exists"
  fi
  echo ""
fi

if $INSTALL_CONFIG; then
  echo "Installing config templates (V7 three-layer routing)..."
  for f in orchestration-engine:ORCHESTRATION-ENGINE.md capability-registry:CAPABILITY-REGISTRY.md command-registry:COMMAND-REGISTRY.md agents:AGENTS.md auto-activation-matrix:AUTO-ACTIVATION-MATRIX.md; do
    src="${f%%:*}.md"
    dest_name="${f##*:}"
    if [[ ! -f "$HOME/.claude/$dest_name" ]]; then
      cp "$SCRIPT_DIR/config/$src" "$HOME/.claude/$dest_name"
      echo "  [INSTALL] $dest_name"
    else
      echo "  [SKIP] $dest_name"
    fi
  done
  # env.template
  if [[ ! -f "$HOME/.claude/.env" ]]; then
    cp "$SCRIPT_DIR/config/env.template" "$HOME/.claude/.env"
    chmod 600 "$HOME/.claude/.env" 2>/dev/null || true
    echo "  [INSTALL] Created ~/.claude/.env from template (chmod 600)"
    echo "  [ACTION] Edit ~/.claude/.env and add your real API keys"
  else
    echo "  [SKIP] ~/.claude/.env already exists"
  fi
  # CLAUDE.md and PRIMER.md templates (only if missing)
  if [[ ! -f "$HOME/.claude/CLAUDE.md" ]]; then
    cp "$SCRIPT_DIR/config/claude-md-template.md" "$HOME/.claude/CLAUDE.md"
    echo "  [INSTALL] CLAUDE.md (from template)"
  else
    echo "  [SKIP] CLAUDE.md (already exists)"
  fi
  if [[ ! -f "$HOME/.claude/PRIMER.md" ]]; then
    cp "$SCRIPT_DIR/config/primer-template.md" "$HOME/.claude/PRIMER.md"
    echo "  [INSTALL] PRIMER.md (from template)"
  else
    echo "  [SKIP] PRIMER.md (already exists)"
  fi
  echo ""
fi

if $INSTALL_THIRDPARTY; then
  echo "Third-party tools:"
  echo ""
  if command -v bun &>/dev/null; then
    echo "  [OK] Bun already installed"
  else
    echo "  Installing Bun (optional, for Claude Peers)..."
    npm install -g bun 2>/dev/null && echo "  [OK] Bun installed" || echo "  [SKIP] Bun install failed (optional)"
  fi
  echo ""
fi

# --- Configure MCP Servers (V7 defaults) ---
if $INSTALL_CONFIG || $INSTALL_HOOKS; then
  echo "Configuring MCP servers (4 V7 defaults)..."
  python3 <<PYEOF
import json, os, sys, shutil

settings_path = os.path.expanduser("~/.claude/settings.json")

if not os.path.exists(settings_path):
    template = "$SCRIPT_DIR/config/settings-template.json"
    if os.path.exists(template):
        shutil.copy(template, settings_path)
        print("  [INSTALL] Created settings.json from V7 template")
        sys.exit(0)
    else:
        print("  [SKIP] No settings.json and no template found")
        sys.exit(0)

with open(settings_path) as f:
    settings = json.load(f)

if "mcpServers" not in settings:
    settings["mcpServers"] = {}

servers_to_add = {
    "playwright": {
        "command": "npx", "args": ["-y", "@playwright/mcp"],
        "description": "Browser automation, E2E testing, web scraping"
    },
    "github": {
        "command": "npx", "args": ["-y", "@modelcontextprotocol/server-github"],
        "env": {"GITHUB_PERSONAL_ACCESS_TOKEN": "\${GITHUB_PERSONAL_ACCESS_TOKEN}"},
        "description": "GitHub PRs, issues, repos"
    },
    "exa-web-search": {
        "command": "npx", "args": ["-y", "exa-mcp-server"],
        "env": {"EXA_API_KEY": "\${EXA_API_KEY}"},
        "description": "Deep web research"
    },
    "@21st-dev/magic": {
        "command": "npx", "args": ["-y", "@21st-dev/magic@latest"],
        "env": {"API_KEY": "\${TWENTY_FIRST_DEV_API_KEY}"},
        "description": "Premium React component generation"
    }
}

added = 0
for name, config in servers_to_add.items():
    if name not in settings["mcpServers"]:
        settings["mcpServers"][name] = config
        print(f"  [INSTALL] MCP: {name}")
        added += 1
    else:
        print(f"  [SKIP] MCP: {name} (already exists)")

# V7 env block
settings.setdefault("env", {})
for k, v in {
    "MAX_THINKING_TOKENS": "10000",
    "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "50",
    "CLAUDE_CODE_SUBAGENT_MODEL": "haiku",
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1",
    "FAL_KEY": "\${FAL_KEY}",
    "ENABLE_PROMPT_CACHING_1H": "1"
}.items():
    if k not in settings["env"]:
        settings["env"][k] = v
        added += 1

# Enforce effort=high
if settings.get("effortLevel") in (None, "xhigh", "max"):
    settings["effortLevel"] = "high"
    print("  [FIX] effortLevel set to 'high' (self-healing enforced)")
    added += 1

if added > 0:
    with open(settings_path, "w") as f:
        json.dump(settings, f, indent=2)
    print(f"  {added} settings updates applied")
else:
    print("  All MCP servers + env already configured")
PYEOF
  echo ""
fi

# --- Configure Hooks in settings.json (V7 five-event chain) ---
if $INSTALL_HOOKS; then
  echo "Configuring hooks in settings.json (V7 five-event chain)..."
  python3 <<'PYEOF'
import json, os, sys

settings_path = os.path.expanduser("~/.claude/settings.json")
if not os.path.exists(settings_path):
    print("  [SKIP] No settings.json found")
    sys.exit(0)

with open(settings_path) as f:
    settings = json.load(f)
settings.setdefault("hooks", {})
changed = False
HOOK_HOME = "$HOME/.claude/hooks"

def has_cmd(event_list, substr):
    for group in event_list:
        for h in group.get("hooks", []):
            if substr in h.get("command", ""):
                return True
    return False

# PostCompact
settings["hooks"].setdefault("PostCompact", [])
if not has_cmd(settings["hooks"]["PostCompact"], "post-compact-recovery"):
    settings["hooks"]["PostCompact"].append({
        "matcher": "",
        "hooks": [{"type": "command", "command": f"bash {HOOK_HOME}/post-compact-recovery.sh"}]
    })
    print("  [INSTALL] PostCompact hook"); changed = True

# Stop (session-end-save + task-complete-sound)
settings["hooks"].setdefault("Stop", [])
if not has_cmd(settings["hooks"]["Stop"], "session-end-save"):
    settings["hooks"]["Stop"].append({
        "matcher": "",
        "hooks": [
            {"type": "command", "command": f"bash {HOOK_HOME}/session-end-save.sh"},
            {"type": "command", "command": f"bash {HOOK_HOME}/task-complete-sound.sh"}
        ]
    })
    print("  [INSTALL] Stop hooks (session-end-save + task-complete-sound)"); changed = True

# UserPromptSubmit -- CARL
settings["hooks"].setdefault("UserPromptSubmit", [])
if not has_cmd(settings["hooks"]["UserPromptSubmit"], "carl-hook"):
    settings["hooks"]["UserPromptSubmit"].append({
        "hooks": [{"type": "command", "command": f"python3 {HOOK_HOME}/carl-hook.py"}]
    })
    print("  [INSTALL] UserPromptSubmit hook (CARL)"); changed = True

# SessionStart -- chain
settings["hooks"].setdefault("SessionStart", [])
if not has_cmd(settings["hooks"]["SessionStart"], "session-start-check"):
    settings["hooks"]["SessionStart"].append({
        "matcher": "",
        "hooks": [
            {"type": "command", "command": f"bash {HOOK_HOME}/session-start-check.sh"},
            {"type": "command", "command": f"bash {HOOK_HOME}/project-auto-graph.sh"}
        ]
    })
    print("  [INSTALL] SessionStart hook chain"); changed = True

if changed:
    with open(settings_path, "w") as f:
        json.dump(settings, f, indent=2)
    print("  Hooks saved")
else:
    print("  All hooks already configured")
PYEOF
  echo ""
fi

# --- Plugin Installation Instructions ---
echo ""
echo "==========================================================="
echo "  IMPORTANT: Complete these steps in Claude Code"
echo "==========================================================="
echo ""
echo "  Open Claude Code and run these to unlock 1,000+ skills and 19 OMC agents:"
echo ""
echo "  1. /plugin marketplace add https://github.com/anthropic-community/everything-claude-code"
echo "  2. /plugin install everything-claude-code"
echo ""
echo "  3. /plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode"
echo "  4. /plugin install oh-my-claudecode"
echo "  5. /oh-my-claudecode:omc-setup"
echo ""
echo "  6. /healthcheck"
echo ""
echo "==========================================================="

# --- Post-Install Verification ---
echo ""
echo "[APEX] Running post-install verification..."
echo ""
if [ -f "$SCRIPT_DIR/verify.sh" ]; then
  bash "$SCRIPT_DIR/verify.sh" || true
fi

echo ""
echo "=============================================="
echo "  Claude Apex V${APEX_VERSION} installed successfully!"
echo "  Prepared by Engineer Yousef Nabil"
echo "  Star the repo: github.com/YousefNabil-SOC/claude-apex"
echo "=============================================="
echo ""
echo "  Restart Claude Code, then run /healthcheck"
echo "  Backup at: $BACKUP_DIR"
echo ""
