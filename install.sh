#!/usr/bin/env bash
set -euo pipefail

# Claude Apex V7 Installer (Mac/Linux)
# Non-destructive: backs up everything before changes

APEX_VERSION="7.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
CARL_DIR="$HOME/.carl"
BACKUP_DIR="$CLAUDE_DIR/backups/pre-apex-$(date +%Y%m%d-%H%M%S)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

installed=0
skipped=0
failed=0

banner() {
  echo ""
  echo -e "${CYAN}╔═══════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║           CLAUDE APEX V${APEX_VERSION}                      ║${NC}"
  echo -e "${CYAN}║  1,276+ skills. 108 agents. 182 commands.         ║${NC}"
  echo -e "${CYAN}║  Three-layer auto-routing. One unified brain.     ║${NC}"
  echo -e "${CYAN}╚═══════════════════════════════════════════════════╝${NC}"
  echo ""
}

check_prereq() {
  local name="$1" cmd="$2" min_label="$3"
  if command -v "$cmd" &>/dev/null; then
    local ver
    ver=$($cmd --version 2>&1 | head -1)
    echo -e "  ${GREEN}[OK]${NC} $name: $ver"
    return 0
  else
    echo -e "  ${RED}[MISSING]${NC} $name — please install $name ($min_label+)"
    return 1
  fi
}

install_file() {
  local src="$1" dest="$2" label="$3"
  if [[ -f "$dest" ]]; then
    echo -e "  ${YELLOW}[SKIP]${NC} $label (already exists)"
    ((skipped++)) || true
  else
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    echo -e "  ${GREEN}[INSTALL]${NC} $label"
    ((installed++)) || true
  fi
}

install_dir() {
  local src_dir="$1" dest_dir="$2" label="$3"
  if [[ -d "$dest_dir" ]]; then
    echo -e "  ${YELLOW}[SKIP]${NC} $label (already exists)"
    ((skipped++)) || true
  else
    mkdir -p "$dest_dir"
    cp -r "$src_dir"/. "$dest_dir"/
    echo -e "  ${GREEN}[INSTALL]${NC} $label"
    ((installed++)) || true
  fi
}

banner

# --- Prerequisites ---
echo -e "${CYAN}Checking prerequisites...${NC}"
prereq_ok=true
check_prereq "Claude Code" "claude" "v2.1.80" || prereq_ok=false
check_prereq "Node.js" "node" "v18" || prereq_ok=false
check_prereq "Python 3" "python3" "3.10" || prereq_ok=false
check_prereq "Git" "git" "2.0" || prereq_ok=false
check_prereq "npm" "npm" "8.0" || prereq_ok=false
echo ""

if [[ "$prereq_ok" == false ]]; then
  echo -e "${RED}Missing prerequisites. Please install them and re-run.${NC}"
  exit 1
fi

# --- Confirmation ---
echo -e "${YELLOW}This will install Claude Apex V${APEX_VERSION} to ~/.claude/.${NC}"
echo "Your existing configuration will be backed up first."
echo ""
read -rp "Continue? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Aborted."
  exit 0
fi
echo ""

# --- Backup ---
echo -e "${CYAN}Creating backup...${NC}"
mkdir -p "$BACKUP_DIR"
[[ -f "$CLAUDE_DIR/settings.json" ]] && cp "$CLAUDE_DIR/settings.json" "$BACKUP_DIR/"
[[ -f "$CLAUDE_DIR/CLAUDE.md" ]] && cp "$CLAUDE_DIR/CLAUDE.md" "$BACKUP_DIR/"
[[ -f "$CLAUDE_DIR/PRIMER.md" ]] && cp "$CLAUDE_DIR/PRIMER.md" "$BACKUP_DIR/"
[[ -d "$CLAUDE_DIR/agents" ]] && cp -r "$CLAUDE_DIR/agents" "$BACKUP_DIR/"
[[ -d "$CLAUDE_DIR/commands" ]] && cp -r "$CLAUDE_DIR/commands" "$BACKUP_DIR/"
[[ -d "$CLAUDE_DIR/hooks" ]] && cp -r "$CLAUDE_DIR/hooks" "$BACKUP_DIR/"
[[ -d "$CARL_DIR" ]] && cp -r "$CARL_DIR" "$BACKUP_DIR/carl-backup"
echo -e "  ${GREEN}[OK]${NC} Backup saved to $BACKUP_DIR"
echo ""

# --- Install Agents (25 specialist agents) ---
echo -e "${CYAN}Installing agents (25 specialists)...${NC}"
mkdir -p "$CLAUDE_DIR/agents"
for agent_file in "$SCRIPT_DIR"/agents/*.md; do
  [[ "$(basename "$agent_file")" == "README.md" ]] && continue
  name=$(basename "$agent_file")
  install_file "$agent_file" "$CLAUDE_DIR/agents/$name" "$name"
done
echo ""

# --- Install Commands (~45 top-level + 3 subdirs) ---
echo -e "${CYAN}Installing commands...${NC}"
mkdir -p "$CLAUDE_DIR/commands"
for cmd_file in "$SCRIPT_DIR"/commands/*.md; do
  [[ "$(basename "$cmd_file")" == "README.md" ]] && continue
  name=$(basename "$cmd_file")
  install_file "$cmd_file" "$CLAUDE_DIR/commands/$name" "$name"
done
# Subdirs
for subdir in paul seed autoresearch; do
  if [[ -d "$SCRIPT_DIR/commands/$subdir" ]]; then
    install_dir "$SCRIPT_DIR/commands/$subdir" "$CLAUDE_DIR/commands/$subdir" "commands/$subdir"
  fi
done
echo ""

# --- Install Hooks (7 hook scripts, V7 fixed versions) ---
echo -e "${CYAN}Installing hooks (V7 fixed versions)...${NC}"
mkdir -p "$CLAUDE_DIR/hooks"
for hook_file in "$SCRIPT_DIR"/hooks/*; do
  [[ "$(basename "$hook_file")" == "README.md" ]] && continue
  name=$(basename "$hook_file")
  install_file "$hook_file" "$CLAUDE_DIR/hooks/$name" "$name"
  chmod +x "$CLAUDE_DIR/hooks/$name" 2>/dev/null || true
done
echo ""

# --- Install Skills (9 custom Apex skills) ---
echo -e "${CYAN}Installing Apex skills (9 custom)...${NC}"
mkdir -p "$CLAUDE_DIR/skills"
for skill in dream-consolidation autoresearch premium-web-design 21st-dev-magic instagram-access graphify graphic-design-studio impeccable fireworks-tech-graph; do
  if [[ -d "$SCRIPT_DIR/skills/$skill" ]]; then
    install_dir "$SCRIPT_DIR/skills/$skill" "$CLAUDE_DIR/skills/$skill" "skill: $skill"
  fi
done
echo ""

# --- Install CARL ---
echo -e "${CYAN}Installing CARL domains (9 domains, 40 rules)...${NC}"
if [[ -f "$CARL_DIR/carl.json" ]]; then
  echo -e "  ${YELLOW}[SKIP]${NC} carl.json (already exists)"
  ((skipped++)) || true
else
  mkdir -p "$CARL_DIR"
  cp "$SCRIPT_DIR/config/carl-domains.json" "$CARL_DIR/carl.json"
  echo -e "  ${GREEN}[INSTALL]${NC} carl.json (9 domains, 40 rules)"
  ((installed++)) || true
fi
echo ""

# --- Install Config Files ---
echo -e "${CYAN}Installing config files (V7 three-layer routing)...${NC}"
install_file "$SCRIPT_DIR/config/orchestration-engine.md" "$CLAUDE_DIR/ORCHESTRATION-ENGINE.md" "ORCHESTRATION-ENGINE.md"
install_file "$SCRIPT_DIR/config/capability-registry.md" "$CLAUDE_DIR/CAPABILITY-REGISTRY.md" "CAPABILITY-REGISTRY.md"
install_file "$SCRIPT_DIR/config/command-registry.md" "$CLAUDE_DIR/COMMAND-REGISTRY.md" "COMMAND-REGISTRY.md"
install_file "$SCRIPT_DIR/config/agents.md" "$CLAUDE_DIR/AGENTS.md" "AGENTS.md"
install_file "$SCRIPT_DIR/config/auto-activation-matrix.md" "$CLAUDE_DIR/AUTO-ACTIVATION-MATRIX.md" "AUTO-ACTIVATION-MATRIX.md"
echo ""

# --- CLAUDE.md / PRIMER.md Templates ---
echo -e "${CYAN}Checking CLAUDE.md and PRIMER.md...${NC}"
if [[ ! -f "$CLAUDE_DIR/CLAUDE.md" ]]; then
  cp "$SCRIPT_DIR/config/claude-md-template.md" "$CLAUDE_DIR/CLAUDE.md"
  echo -e "  ${GREEN}[INSTALL]${NC} Created CLAUDE.md from template"
  ((installed++)) || true
else
  echo -e "  ${YELLOW}[SKIP]${NC} CLAUDE.md already exists (edit manually if needed)"
fi
if [[ ! -f "$CLAUDE_DIR/PRIMER.md" ]]; then
  cp "$SCRIPT_DIR/config/primer-template.md" "$CLAUDE_DIR/PRIMER.md"
  echo -e "  ${GREEN}[INSTALL]${NC} Created PRIMER.md from template (edit with your profile)"
  ((installed++)) || true
else
  echo -e "  ${YELLOW}[SKIP]${NC} PRIMER.md already exists"
fi
echo ""

# --- .env template ---
echo -e "${CYAN}Setting up .env template...${NC}"
if [[ ! -f "$CLAUDE_DIR/.env" ]]; then
  cp "$SCRIPT_DIR/config/env.template" "$CLAUDE_DIR/.env"
  chmod 600 "$CLAUDE_DIR/.env" 2>/dev/null || true
  echo -e "  ${GREEN}[INSTALL]${NC} Created ~/.claude/.env from template (chmod 600)"
  echo -e "  ${YELLOW}[ACTION]${NC} Edit ~/.claude/.env and add your real API keys"
  ((installed++)) || true
else
  echo -e "  ${YELLOW}[SKIP]${NC} ~/.claude/.env already exists"
fi
echo ""

# --- Third-Party Dependencies ---
echo -e "${CYAN}Checking third-party dependencies...${NC}"
if command -v bun &>/dev/null; then
  echo -e "  ${GREEN}[OK]${NC} Bun already installed"
else
  echo -e "  ${YELLOW}[INFO]${NC} Installing Bun (optional)..."
  npm install -g bun 2>/dev/null && echo -e "  ${GREEN}[OK]${NC} Bun installed" || echo -e "  ${YELLOW}[SKIP]${NC} Bun install failed (optional)"
fi
echo ""

# --- Configure MCP Servers ---
echo -e "${CYAN}Configuring MCP servers (4 Apex defaults)...${NC}"
python3 <<PYEOF
import json, os, sys
settings_path = os.path.expanduser("~/.claude/settings.json")
if not os.path.exists(settings_path):
    # Seed a minimal settings.json from the template
    import shutil
    shutil.copy(os.path.expanduser("$SCRIPT_DIR/config/settings-template.json"), settings_path)
    print("  [INSTALL] Created settings.json from V7 template")
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

print("")
print("  NOTE: Add your API keys to ~/.claude/.env:")
print("    FAL_KEY, GITHUB_PERSONAL_ACCESS_TOKEN, EXA_API_KEY, TWENTY_FIRST_DEV_API_KEY")
PYEOF
echo ""

# --- Configure Hooks (V7 five-event chain) ---
echo -e "${CYAN}Configuring hooks in settings.json (5 events)...${NC}"
python3 <<PYEOF
import json, os, sys
settings_path = os.path.expanduser("~/.claude/settings.json")
if not os.path.exists(settings_path):
    print("  [SKIP] No settings.json")
    sys.exit(0)

with open(settings_path) as f:
    settings = json.load(f)
settings.setdefault("hooks", {})
changed = False
HOOK_HOME = "\$HOME/.claude/hooks"

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

# UserPromptSubmit — CARL
settings["hooks"].setdefault("UserPromptSubmit", [])
if not has_cmd(settings["hooks"]["UserPromptSubmit"], "carl-hook"):
    settings["hooks"]["UserPromptSubmit"].append({
        "hooks": [{"type": "command", "command": f"python3 {HOOK_HOME}/carl-hook.py"}]
    })
    print("  [INSTALL] UserPromptSubmit hook (CARL)"); changed = True

# SessionStart — chain
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

# --- Plugin Installation Instructions ---
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "  ${GREEN}IMPORTANT: Complete these steps in Claude Code${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo "  Open Claude Code and run these to unlock 1,000+ more skills"
echo "  and 19 OMC agents:"
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
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""

# --- Post-Install Verification ---
echo "[APEX] Running post-install verification..."
echo ""
if [ -f "$SCRIPT_DIR/verify.sh" ]; then
  bash "$SCRIPT_DIR/verify.sh" || true
fi

# --- Summary ---
echo -e "${CYAN}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}  Claude Apex V${APEX_VERSION} installed!${NC}"
echo -e "${CYAN}═══════════════════════════════════════════${NC}"
echo ""
echo -e "  ${GREEN}Installed:${NC} $installed"
echo -e "  ${YELLOW}Skipped:${NC}   $skipped (already existed)"
[[ $failed -gt 0 ]] && echo -e "  ${RED}Failed:${NC}    $failed"
echo ""
echo -e "  Backup at: ${CYAN}$BACKUP_DIR${NC}"
echo ""
echo -e "  ${GREEN}Next steps:${NC}"
echo "  1. Edit ~/.claude/.env with your API keys"
echo "  2. Edit ~/.claude/PRIMER.md with your profile"
echo "  3. Restart Claude Code"
echo "  4. Run /healthcheck inside Claude Code"
echo "  5. Try: autopilot: build me a landing page"
echo ""
echo "  Never used Claude Code? Start with: docs/00-START-HERE.md"
echo "  To uninstall: bash uninstall.sh"
echo ""
