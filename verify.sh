#!/usr/bin/env bash
set +e

# Claude Pantheon V6 -- Post-Install Verification
# Checks 30+ components across 9 categories
# Works on Mac, Linux, and Windows Git Bash

echo ""
echo "==========================================================="
echo "  CLAUDE PANTHEON V6 -- Post-Install Verification"
echo "==========================================================="
echo ""

CLAUDE_DIR="$HOME/.claude"
CARL_DIR="$HOME/.carl"

PASS=0
WARN=0
FAIL=0

check_pass() {
  echo "  [PASS]  $1 -- $2"
  PASS=$((PASS + 1))
}

check_warn() {
  echo "  [WARN]  $1 -- $2"
  WARN=$((WARN + 1))
}

check_fail() {
  echo "  [FAIL]  $1 -- $2"
  FAIL=$((FAIL + 1))
}

# =============================================================
# CATEGORY 1: AGENTS
# =============================================================
echo "--- AGENTS ---"
echo ""

if [ -d "$CLAUDE_DIR/agents" ]; then
  agent_count=$(find "$CLAUDE_DIR/agents" -maxdepth 1 -name "*.md" ! -name "README.md" 2>/dev/null | wc -l | tr -d ' ')
else
  agent_count=0
fi

if [ "$agent_count" -ge 25 ]; then
  check_pass "Agent count" "$agent_count agents installed"
elif [ "$agent_count" -ge 15 ]; then
  check_warn "Agent count" "$agent_count agents (some were skipped)"
else
  check_fail "Agent count" "$agent_count agents (expected 25+)"
fi

# Critical agents (FAIL if missing)
for agent in architect.md code-reviewer.md security-reviewer.md planner.md tdd-guide.md; do
  if [ -f "$CLAUDE_DIR/agents/$agent" ]; then
    check_pass "Critical agent" "$agent"
  else
    check_fail "Critical agent" "$agent missing"
  fi
done

# Additional agents (WARN if missing)
for agent in database-reviewer.md e2e-runner.md doc-updater.md python-reviewer.md refactor-cleaner.md; do
  if [ -f "$CLAUDE_DIR/agents/$agent" ]; then
    check_pass "Additional agent" "$agent"
  else
    check_warn "Additional agent" "$agent missing (non-critical)"
  fi
done

echo ""

# =============================================================
# CATEGORY 2: SLASH COMMANDS
# =============================================================
echo "--- SLASH COMMANDS ---"
echo ""

if [ -f "$CLAUDE_DIR/commands/healthcheck.md" ]; then
  check_pass "Command" "healthcheck.md"
else
  check_fail "Command" "healthcheck.md missing"
fi

if [ -f "$CLAUDE_DIR/commands/switch-project.md" ]; then
  check_pass "Command" "switch-project.md"
else
  check_fail "Command" "switch-project.md missing"
fi

if [ -f "$CLAUDE_DIR/commands/templates.md" ]; then
  check_pass "Command" "templates.md"
else
  check_fail "Command" "templates.md missing"
fi

if [ -d "$CLAUDE_DIR/commands/paul" ]; then
  paul_count=$(find "$CLAUDE_DIR/commands/paul" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
  if [ "$paul_count" -ge 20 ]; then
    check_pass "PAUL commands" "$paul_count commands"
  elif [ "$paul_count" -ge 1 ]; then
    check_warn "PAUL commands" "$paul_count commands (expected 20+)"
  else
    check_warn "PAUL commands" "directory exists but empty"
  fi
else
  check_warn "PAUL commands" "PAUL not installed (optional)"
fi

if [ -f "$CLAUDE_DIR/commands/seed/seed.md" ] || [ -f "$CLAUDE_DIR/commands/seed.md" ]; then
  check_pass "SEED command" "found"
else
  check_warn "SEED command" "SEED not installed (optional)"
fi

echo ""

# =============================================================
# CATEGORY 3: HOOKS
# =============================================================
echo "--- HOOKS ---"
echo ""

for hook in post-compact-recovery.sh session-end-save.sh task-complete-sound.sh peers-auto-register.sh carl-hook.py; do
  if [ -f "$CLAUDE_DIR/hooks/$hook" ]; then
    check_pass "Hook" "$hook"
  else
    check_warn "Hook" "$hook missing (optional)"
  fi
done

echo ""

# =============================================================
# CATEGORY 4: CUSTOM SKILLS
# =============================================================
echo "--- CUSTOM SKILLS ---"
echo ""

if [ -f "$CLAUDE_DIR/skills/dream-consolidation/SKILL.md" ]; then
  check_pass "Skill" "dream-consolidation"
else
  check_fail "Skill" "dream-consolidation -- core Pantheon skill missing"
fi

if [ -f "$CLAUDE_DIR/skills/autoresearch/SKILL.md" ]; then
  check_pass "Skill" "autoresearch"
else
  check_fail "Skill" "autoresearch -- core Pantheon skill missing"
fi

if [ -d "$CLAUDE_DIR/skills" ]; then
  skill_count=$(find "$CLAUDE_DIR/skills" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
else
  skill_count=0
fi

if [ "$skill_count" -ge 1000 ]; then
  check_pass "Total skills" "$skill_count -- full installation"
elif [ "$skill_count" -ge 100 ]; then
  check_warn "Total skills" "$skill_count -- install everything-claude-code plugin for 1300+"
else
  check_warn "Total skills" "$skill_count -- install plugins in Claude Code for more skills"
fi

echo ""

# =============================================================
# CATEGORY 5: CONFIGURATION
# =============================================================
echo "--- CONFIGURATION ---"
echo ""

if [ -f "$CARL_DIR/carl.json" ]; then
  domain_count=""
  if command -v python3 &>/dev/null; then
    domain_count=$(python3 -c "
import json
try:
    with open('$CARL_DIR/carl.json') as f:
        data = json.load(f)
    if 'domains' in data:
        print(len(data['domains']))
    elif isinstance(data, list):
        print(len(data))
    else:
        print('unknown structure')
except:
    print('parse error')
" 2>/dev/null)
  fi
  if [ -n "$domain_count" ] && [ "$domain_count" != "parse error" ]; then
    check_pass "CARL config" "carl.json ($domain_count domains)"
  else
    check_pass "CARL config" "carl.json exists"
  fi
else
  check_fail "CARL config" "CARL not configured -- ~/.carl/carl.json missing"
fi

if [ -f "$CLAUDE_DIR/ORCHESTRATION-ENGINE.md" ]; then
  check_pass "Orchestration" "ORCHESTRATION-ENGINE.md"
else
  check_fail "Orchestration" "ORCHESTRATION-ENGINE.md missing"
fi

if [ -f "$CLAUDE_DIR/CAPABILITY-REGISTRY.md" ]; then
  check_pass "Capability" "CAPABILITY-REGISTRY.md"
else
  check_warn "Capability" "CAPABILITY-REGISTRY.md missing (optional but recommended)"
fi

if [ -f "$CLAUDE_DIR/settings.json" ]; then
  if command -v python3 &>/dev/null; then
    python3 -c "import json; json.load(open('$CLAUDE_DIR/settings.json'))" 2>/dev/null
    if [ $? -eq 0 ]; then
      check_pass "Settings" "settings.json is valid JSON"
    else
      check_fail "Settings" "settings.json CORRUPTED -- restore from backup"
    fi
  else
    check_pass "Settings" "settings.json exists (no python3 to validate)"
  fi
else
  check_warn "Settings" "settings.json not found"
fi

if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  line_count=$(wc -l < "$CLAUDE_DIR/CLAUDE.md" | tr -d ' ')
  check_pass "CLAUDE.md" "$line_count lines"
else
  check_warn "CLAUDE.md" "not found"
fi

echo ""

# =============================================================
# CATEGORY 6: MCP SERVERS
# =============================================================
echo "--- MCP SERVERS ---"
echo ""

if [ -f "$CLAUDE_DIR/settings.json" ] && command -v python3 &>/dev/null; then
  mcp_count=$(python3 -c "
import json
try:
    with open('$CLAUDE_DIR/settings.json') as f:
        data = json.load(f)
    servers = data.get('mcpServers', {})
    print(len(servers))
except:
    print(0)
" 2>/dev/null)

  if [ "$mcp_count" -ge 8 ]; then
    check_pass "MCP server count" "$mcp_count servers configured"
  elif [ "$mcp_count" -ge 4 ]; then
    check_warn "MCP server count" "$mcp_count servers (expected 8+)"
  else
    check_warn "MCP server count" "$mcp_count servers (expected 8+)"
  fi

  for server in context7 playwright memory; do
    has_server=$(python3 -c "
import json
try:
    with open('$CLAUDE_DIR/settings.json') as f:
        data = json.load(f)
    print('yes' if '$server' in data.get('mcpServers', {}) else 'no')
except:
    print('no')
" 2>/dev/null)
    if [ "$has_server" = "yes" ]; then
      check_pass "MCP server" "$server"
    else
      check_warn "MCP server" "$server not configured"
    fi
  done
else
  check_warn "MCP servers" "cannot check (settings.json or python3 missing)"
fi

echo ""

# =============================================================
# CATEGORY 7: THIRD-PARTY TOOLS
# =============================================================
echo "--- THIRD-PARTY TOOLS ---"
echo ""

if command -v bun &>/dev/null; then
  bun_ver=$(bun --version 2>&1 | head -1)
  check_pass "Bun" "v$bun_ver"
else
  check_warn "Bun" "not installed (optional)"
fi

if [ -d "$HOME/claude-peers-mcp" ]; then
  check_pass "Claude Peers" "directory exists"
else
  check_warn "Claude Peers" "~/claude-peers-mcp not found (optional)"
fi

if command -v node &>/dev/null; then
  node_ver=$(node --version 2>&1 | head -1)
  check_pass "Node.js" "$node_ver"
else
  check_fail "Node.js" "not installed (required)"
fi

if command -v python3 &>/dev/null; then
  py_ver=$(python3 --version 2>&1 | head -1)
  check_pass "Python" "$py_ver"
else
  check_fail "Python" "python3 not installed (required)"
fi

if command -v git &>/dev/null; then
  git_ver=$(git --version 2>&1 | head -1)
  check_pass "Git" "$git_ver"
else
  check_fail "Git" "not installed (required)"
fi

echo ""

# =============================================================
# CATEGORY 8: BACKUP STATUS
# =============================================================
echo "--- BACKUP STATUS ---"
echo ""

backup_found=""
if [ -d "$CLAUDE_DIR/backups" ]; then
  backup_found=$(find "$CLAUDE_DIR/backups" -maxdepth 1 -type d -name "pre-pantheon-*" 2>/dev/null | head -1)
fi

if [ -n "$backup_found" ]; then
  check_pass "Backup" "$(basename "$backup_found")"
else
  check_warn "Backup" "no Pantheon backup found"
fi

echo ""

# =============================================================
# CATEGORY 9: CONFLICT DETECTION
# =============================================================
echo "--- CONFLICT DETECTION ---"
echo ""

conflict_found=false

if [ -f "$CLAUDE_DIR/settings.json" ]; then
  if command -v python3 &>/dev/null; then
    python3 -c "import json; json.load(open('$CLAUDE_DIR/settings.json'))" 2>/dev/null
    if [ $? -ne 0 ]; then
      check_fail "Conflict" "settings.json corrupted"
      conflict_found=true
    fi
  fi
fi

if [ -f "$CARL_DIR/carl.json" ]; then
  if command -v python3 &>/dev/null; then
    python3 -c "import json; json.load(open('$CARL_DIR/carl.json'))" 2>/dev/null
    if [ $? -ne 0 ]; then
      check_fail "Conflict" "carl.json corrupted"
      conflict_found=true
    fi
  fi
fi

if [ "$conflict_found" = false ]; then
  check_pass "Conflicts" "no conflicts detected"
fi

echo ""

# =============================================================
# FINAL SUMMARY
# =============================================================
echo "==========================================================="
echo "  RESULTS: $PASS passed | $WARN warnings | $FAIL failed"
echo "==========================================================="
echo ""

if [ "$FAIL" -eq 0 ] && [ "$WARN" -eq 0 ]; then
  echo "  PERFECT -- Your environment fully matches Pantheon V6."
  echo "  Run /healthcheck inside Claude Code for 15-point check."
elif [ "$FAIL" -eq 0 ]; then
  echo "  GOOD -- Core installation is complete."
  echo "  Warnings are for optional components or plugins."
  echo ""
  echo "  To get the FULL experience (1,308 skills, 108 agents),"
  echo "  open a NEW Claude Code session and paste this:"
  echo ""
  echo "  I just installed Claude Pantheon. Please complete the"
  echo "  setup by running these plugin installations for me:"
  echo "  1. Add the everything-claude-code marketplace and install it"
  echo "  2. Add the oh-my-claudecode marketplace and install it"
  echo "  3. Run the OMC setup"
  echo "  After all three are done, run /healthcheck to verify."
else
  echo "  ISSUES FOUND -- Some core components failed to install."
  echo "  Review the [FAIL] items above and either:"
  echo "  1. Re-run the installer: bash install.sh"
  echo "  2. Install missing components manually"
  echo "  3. Restore from backup: bash uninstall.sh"
fi

echo ""
