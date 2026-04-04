#!/usr/bin/env bash
set -euo pipefail

# Claude Pantheon V6 Installer (Mac/Linux)
# Non-destructive: backs up everything before changes

PANTHEON_VERSION="6.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
CARL_DIR="$HOME/.carl"
BACKUP_DIR="$CLAUDE_DIR/backups/pre-pantheon-$(date +%Y%m%d-%H%M%S)"

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
  echo -e "${CYAN}╔═══════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║       CLAUDE PANTHEON V${PANTHEON_VERSION}            ║${NC}"
  echo -e "${CYAN}║  1,308 skills. 108 agents. One brain.     ║${NC}"
  echo -e "${CYAN}╚═══════════════════════════════════════════╝${NC}"
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
    ((skipped++))
  else
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    echo -e "  ${GREEN}[INSTALL]${NC} $label"
    ((installed++))
  fi
}

install_dir() {
  local src_dir="$1" dest_dir="$2" label="$3"
  if [[ -d "$dest_dir" ]]; then
    echo -e "  ${YELLOW}[SKIP]${NC} $label (already exists)"
    ((skipped++))
  else
    mkdir -p "$dest_dir"
    cp -r "$src_dir"/* "$dest_dir"/
    echo -e "  ${GREEN}[INSTALL]${NC} $label"
    ((installed++))
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
echo -e "${YELLOW}This will install Claude Pantheon V${PANTHEON_VERSION} to ~/.claude/.${NC}"
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
[[ -d "$CLAUDE_DIR/agents" ]] && cp -r "$CLAUDE_DIR/agents" "$BACKUP_DIR/"
[[ -d "$CLAUDE_DIR/commands" ]] && cp -r "$CLAUDE_DIR/commands" "$BACKUP_DIR/"
[[ -d "$CLAUDE_DIR/hooks" ]] && cp -r "$CLAUDE_DIR/hooks" "$BACKUP_DIR/"
[[ -d "$CARL_DIR" ]] && cp -r "$CARL_DIR" "$BACKUP_DIR/carl-backup"
echo -e "  ${GREEN}[OK]${NC} Backup saved to $BACKUP_DIR"
echo ""

# --- Install Agents ---
echo -e "${CYAN}Installing agents...${NC}"
mkdir -p "$CLAUDE_DIR/agents"
for agent_file in "$SCRIPT_DIR"/agents/*.md; do
  [[ "$(basename "$agent_file")" == "README.md" ]] && continue
  name=$(basename "$agent_file")
  install_file "$agent_file" "$CLAUDE_DIR/agents/$name" "$name"
done
echo ""

# --- Install Commands ---
echo -e "${CYAN}Installing commands...${NC}"
mkdir -p "$CLAUDE_DIR/commands"
for cmd_file in "$SCRIPT_DIR"/commands/*.md; do
  [[ "$(basename "$cmd_file")" == "README.md" ]] && continue
  name=$(basename "$cmd_file")
  install_file "$cmd_file" "$CLAUDE_DIR/commands/$name" "$name"
done
echo ""

# --- Install Hooks ---
echo -e "${CYAN}Installing hooks...${NC}"
mkdir -p "$CLAUDE_DIR/hooks"
for hook_file in "$SCRIPT_DIR"/hooks/*; do
  [[ "$(basename "$hook_file")" == "README.md" ]] && continue
  name=$(basename "$hook_file")
  install_file "$hook_file" "$CLAUDE_DIR/hooks/$name" "$name"
  chmod +x "$CLAUDE_DIR/hooks/$name" 2>/dev/null || true
done
echo ""

# --- Install Skills ---
echo -e "${CYAN}Installing skills...${NC}"
mkdir -p "$CLAUDE_DIR/skills"
install_dir "$SCRIPT_DIR/skills/dream-consolidation" "$CLAUDE_DIR/skills/dream-consolidation" "dream-consolidation skill"
install_dir "$SCRIPT_DIR/skills/autoresearch" "$CLAUDE_DIR/skills/autoresearch" "autoresearch skill"
echo ""

# --- Install CARL ---
echo -e "${CYAN}Installing CARL domains...${NC}"
if [[ -f "$CARL_DIR/carl.json" ]]; then
  echo -e "  ${YELLOW}[SKIP]${NC} carl.json (already exists)"
  ((skipped++))
else
  mkdir -p "$CARL_DIR"
  cp "$SCRIPT_DIR/config/carl-domains.json" "$CARL_DIR/carl.json"
  echo -e "  ${GREEN}[INSTALL]${NC} carl.json (7 domains, 33 rules)"
  ((installed++))
fi
echo ""

# --- Install Config ---
echo -e "${CYAN}Installing config templates...${NC}"
install_file "$SCRIPT_DIR/config/orchestration-engine.md" "$CLAUDE_DIR/ORCHESTRATION-ENGINE.md" "orchestration-engine.md"
install_file "$SCRIPT_DIR/config/capability-registry.md" "$CLAUDE_DIR/CAPABILITY-REGISTRY.md" "capability-registry.md"
echo ""

# --- CLAUDE.md Enhancement ---
echo -e "${CYAN}Checking CLAUDE.md...${NC}"
if [[ -f "$CLAUDE_DIR/CLAUDE.md" ]]; then
  if grep -q "Pantheon" "$CLAUDE_DIR/CLAUDE.md" 2>/dev/null; then
    echo -e "  ${YELLOW}[SKIP]${NC} CLAUDE.md already contains Pantheon section"
    ((skipped++))
  else
    cat >> "$CLAUDE_DIR/CLAUDE.md" << 'CLAUDEEOF'

## Pantheon V6 Environment
- Agents: 25 custom specialists in ~/.claude/agents/
- CARL: 7 domains, 33 JIT rules in ~/.carl/carl.json
- Orchestration: ~/.claude/ORCHESTRATION-ENGINE.md
- Health: /healthcheck for 15-system verification
- Projects: /switch-project for instant context loading
CLAUDEEOF
    echo -e "  ${GREEN}[INSTALL]${NC} Appended Pantheon section to CLAUDE.md"
    ((installed++))
  fi
else
  cp "$SCRIPT_DIR/config/claude-md-template.md" "$CLAUDE_DIR/CLAUDE.md"
  echo -e "  ${GREEN}[INSTALL]${NC} Created CLAUDE.md from template"
  ((installed++))
fi
echo ""

# --- Third-Party Dependencies ---
echo -e "${CYAN}Checking third-party dependencies...${NC}"

if command -v bun &>/dev/null; then
  echo -e "  ${GREEN}[OK]${NC} Bun already installed"
else
  echo -e "  ${YELLOW}[INFO]${NC} Installing Bun..."
  npm install -g bun 2>/dev/null && echo -e "  ${GREEN}[OK]${NC} Bun installed" || echo -e "  ${YELLOW}[SKIP]${NC} Bun install failed (optional)"
fi

if [[ -d "$HOME/claude-peers-mcp" ]]; then
  echo -e "  ${GREEN}[OK]${NC} Claude Peers already cloned"
else
  echo -e "  ${YELLOW}[INFO]${NC} Cloning Claude Peers MCP..."
  git clone https://github.com/louislva/claude-peers-mcp.git "$HOME/claude-peers-mcp" 2>/dev/null \
    && echo -e "  ${GREEN}[OK]${NC} Claude Peers cloned" \
    || echo -e "  ${YELLOW}[SKIP]${NC} Claude Peers clone failed (optional)"
fi

echo ""
echo -e "${CYAN}Manual steps needed:${NC}"
echo "  To install oh-my-claudecode, open Claude Code and run:"
echo "    /install-plugin oh-my-claudecode@omc"
echo "  To install PAUL framework:"
echo "    npx paul-framework --global"
echo ""

# --- Summary ---
echo -e "${CYAN}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}  Claude Pantheon V${PANTHEON_VERSION} installed!${NC}"
echo -e "${CYAN}═══════════════════════════════════════════${NC}"
echo ""
echo -e "  ${GREEN}Installed:${NC} $installed"
echo -e "  ${YELLOW}Skipped:${NC}   $skipped (already existed)"
if [[ $failed -gt 0 ]]; then
  echo -e "  ${RED}Failed:${NC}    $failed"
fi
echo ""
echo -e "  Backup at: ${CYAN}$BACKUP_DIR${NC}"
echo ""
echo -e "  ${GREEN}Next steps:${NC}"
echo "  1. Restart Claude Code"
echo "  2. Run /healthcheck to verify"
echo "  3. Try: autopilot: explain this codebase"
echo ""
echo "  To uninstall: bash uninstall.sh"
echo ""
