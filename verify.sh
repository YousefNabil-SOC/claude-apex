#!/usr/bin/env bash
set +e

# Claude Apex V7 -- Post-Install Verification
# Checks 35+ components across 9 categories

echo ""
echo "==========================================================="
echo "  CLAUDE APEX V7 -- Post-Install Verification"
echo "==========================================================="
echo ""

CLAUDE_DIR="$HOME/.claude"
CARL_DIR="$HOME/.carl"

PASS=0
WARN=0
FAIL=0

check_pass() { echo "  [PASS]  $1 -- $2"; PASS=$((PASS + 1)); }
check_warn() { echo "  [WARN]  $1 -- $2"; WARN=$((WARN + 1)); }
check_fail() { echo "  [FAIL]  $1 -- $2"; FAIL=$((FAIL + 1)); }

# =============================================================
# CATEGORY 1: AGENTS
# =============================================================
echo "--- AGENTS (target: 25) ---"
echo ""
agent_count=$(find "$CLAUDE_DIR/agents" -maxdepth 1 -name "*.md" ! -name "README.md" 2>/dev/null | wc -l | tr -d ' ')
if [ "$agent_count" -ge 25 ]; then
  check_pass "Agent count" "$agent_count agents installed"
elif [ "$agent_count" -ge 15 ]; then
  check_warn "Agent count" "$agent_count agents (some were skipped)"
else
  check_fail "Agent count" "$agent_count agents (expected 25+)"
fi

for agent in architect.md code-reviewer.md security-reviewer.md planner.md tdd-guide.md; do
  if [ -f "$CLAUDE_DIR/agents/$agent" ]; then
    check_pass "Critical agent" "$agent"
  else
    check_fail "Critical agent" "$agent missing"
  fi
done
echo ""

# =============================================================
# CATEGORY 2: SLASH COMMANDS
# =============================================================
echo "--- SLASH COMMANDS ---"
echo ""
for cmd in healthcheck.md switch-project.md templates.md; do
  [ -f "$CLAUDE_DIR/commands/$cmd" ] && check_pass "Apex command" "$cmd" || check_fail "Apex command" "$cmd missing"
done
[ -d "$CLAUDE_DIR/commands/paul" ] && check_pass "PAUL commands" "directory present" || check_warn "PAUL" "not installed (optional)"
[ -d "$CLAUDE_DIR/commands/seed" ] && check_pass "SEED commands" "directory present" || check_warn "SEED" "not installed (optional)"
[ -d "$CLAUDE_DIR/commands/autoresearch" ] && check_pass "Autoresearch commands" "directory present" || check_warn "Autoresearch" "not installed"
echo ""

# =============================================================
# CATEGORY 3: HOOKS (V7 — 7 hooks expected)
# =============================================================
echo "--- HOOKS (V7 — fixed versions) ---"
echo ""
for hook in carl-hook.py post-compact-recovery.sh session-end-save.sh task-complete-sound.sh session-start-check.sh project-auto-graph.sh; do
  if [ -f "$CLAUDE_DIR/hooks/$hook" ]; then
    check_pass "Hook" "$hook"
  else
    check_warn "Hook" "$hook missing"
  fi
done

# Verify V7 fixes are in place
if [ -f "$CLAUDE_DIR/hooks/carl-hook.py" ]; then
  utf8_count=$(grep -c 'io.TextIOWrapper' "$CLAUDE_DIR/hooks/carl-hook.py" 2>/dev/null)
  if [ "$utf8_count" -ge 2 ]; then
    check_pass "UTF-8 fix" "carl-hook.py has UTF-8 TextIOWrapper on stdout and stderr"
  else
    check_fail "UTF-8 fix" "carl-hook.py missing UTF-8 fix — non-Latin content may corrupt"
  fi
fi

if [ -f "$CLAUDE_DIR/hooks/task-complete-sound.sh" ]; then
  if grep -q '\-lt 60' "$CLAUDE_DIR/hooks/task-complete-sound.sh"; then
    check_pass "Sound cooldown" "60s cooldown present"
  else
    check_warn "Sound cooldown" "no 60s cooldown (sounds may spam)"
  fi
fi
echo ""

# =============================================================
# CATEGORY 4: APEX CUSTOM SKILLS (9 expected)
# =============================================================
echo "--- APEX CUSTOM SKILLS (9 expected) ---"
echo ""
for skill in dream-consolidation autoresearch premium-web-design 21st-dev-magic instagram-access graphify graphic-design-studio impeccable fireworks-tech-graph; do
  if [ -f "$CLAUDE_DIR/skills/$skill/SKILL.md" ]; then
    check_pass "Skill" "$skill"
  else
    check_warn "Skill" "$skill missing (install script copies all 9)"
  fi
done

# Total skill count (includes plugin-provided ones)
skill_count=$(find "$CLAUDE_DIR/skills" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
if [ "$skill_count" -ge 1000 ]; then
  check_pass "Total skills" "$skill_count -- full installation (plugins installed)"
elif [ "$skill_count" -ge 9 ]; then
  check_warn "Total skills" "$skill_count -- install everything-claude-code plugin for 1,276+"
else
  check_fail "Total skills" "$skill_count -- run the installer"
fi
echo ""

# =============================================================
# CATEGORY 5: CONFIGURATION
# =============================================================
echo "--- CONFIGURATION ---"
echo ""
if [ -f "$CARL_DIR/carl.json" ]; then
  domain_count=$(python3 -c "
import json
try:
    d = json.load(open('$CARL_DIR/carl.json'))
    print(len(d.get('domains', {})))
except Exception:
    print(0)
" 2>/dev/null)
  rules_count=$(python3 -c "
import json
try:
    d = json.load(open('$CARL_DIR/carl.json'))
    total = sum(len(v.get('rules', [])) for v in d.get('domains', {}).values())
    print(total)
except Exception:
    print(0)
" 2>/dev/null)
  if [ "$domain_count" = "9" ] && [ "$rules_count" -ge 40 ]; then
    check_pass "CARL" "$domain_count domains, $rules_count rules (V7 target met)"
  elif [ "$domain_count" -ge 7 ]; then
    check_warn "CARL" "$domain_count domains, $rules_count rules (V7 target: 9 domains / 40+ rules)"
  else
    check_fail "CARL" "$domain_count domains (V7 requires 9)"
  fi
else
  check_fail "CARL" "carl.json missing"
fi

for file in ORCHESTRATION-ENGINE.md CAPABILITY-REGISTRY.md COMMAND-REGISTRY.md AGENTS.md AUTO-ACTIVATION-MATRIX.md; do
  if [ -f "$CLAUDE_DIR/$file" ]; then
    check_pass "Config" "$file"
  else
    check_warn "Config" "$file missing"
  fi
done

if [ -f "$CLAUDE_DIR/settings.json" ]; then
  python3 -c "import json; json.load(open('$CLAUDE_DIR/settings.json'))" 2>/dev/null
  if [ $? -eq 0 ]; then
    check_pass "settings.json" "valid JSON"
    # effort level
    effort=$(python3 -c "
import json
try:
    d = json.load(open('$CLAUDE_DIR/settings.json'))
    print(d.get('effortLevel', 'not set'))
except Exception:
    print('error')
")
    case "$effort" in
      high) check_pass "effortLevel" "high (safe default)" ;;
      xhigh|max) check_warn "effortLevel" "$effort (self-healing should lower to 'high')" ;;
      *) check_warn "effortLevel" "$effort (recommend 'high')" ;;
    esac
  else
    check_fail "settings.json" "CORRUPTED -- restore from backup"
  fi
fi

if [ -f "$CLAUDE_DIR/.env" ]; then
  # Check that the template placeholders have been replaced (at least one real key set)
  if grep -Eq 'your_.*_here' "$CLAUDE_DIR/.env"; then
    check_warn ".env" "placeholder values present — edit with your real API keys"
  else
    check_pass ".env" "template replaced with real values"
  fi
else
  check_warn ".env" "not found (copy from config/env.template)"
fi
echo ""

# =============================================================
# CATEGORY 6: MCP SERVERS (V7 — 4 defaults)
# =============================================================
echo "--- MCP SERVERS (V7 defaults: playwright, github, exa-web-search, @21st-dev/magic) ---"
echo ""
if [ -f "$CLAUDE_DIR/settings.json" ]; then
  mcp_count=$(python3 -c "
import json
try:
    d = json.load(open('$CLAUDE_DIR/settings.json'))
    print(len(d.get('mcpServers', {})))
except Exception:
    print(0)
" 2>/dev/null)
  if [ "$mcp_count" -ge 4 ]; then
    check_pass "MCP count" "$mcp_count servers configured"
  else
    check_warn "MCP count" "$mcp_count (V7 default: 4)"
  fi

  for server in playwright github exa-web-search "@21st-dev/magic"; do
    has=$(python3 -c "
import json
try:
    d = json.load(open('$CLAUDE_DIR/settings.json'))
    print('yes' if '$server' in d.get('mcpServers', {}) else 'no')
except Exception:
    print('no')
")
    if [ "$has" = "yes" ]; then
      check_pass "MCP" "$server"
    else
      check_warn "MCP" "$server not configured"
    fi
  done
fi
echo ""

# =============================================================
# CATEGORY 7: THIRD-PARTY TOOLS
# =============================================================
echo "--- THIRD-PARTY TOOLS ---"
echo ""
for tool in node python3 git; do
  if command -v "$tool" &>/dev/null; then
    ver=$($tool --version 2>&1 | head -1)
    check_pass "$tool" "$ver"
  else
    check_fail "$tool" "not installed (required)"
  fi
done

for tool in bun gh; do
  command -v "$tool" &>/dev/null && check_pass "$tool" "$($tool --version 2>&1 | head -1)" || check_warn "$tool" "not installed (optional)"
done
echo ""

# =============================================================
# CATEGORY 8: DOCS
# =============================================================
echo "--- DOCUMENTATION ---"
echo ""
# Apex docs/ don't go into ~/.claude — they live in the repo. Just note they exist.
# Skip — this check is about the installed state.

# =============================================================
# FINAL SUMMARY
# =============================================================
echo "==========================================================="
echo "  RESULTS: $PASS passed | $WARN warnings | $FAIL failed"
echo "==========================================================="
echo ""

if [ "$FAIL" -eq 0 ] && [ "$WARN" -eq 0 ]; then
  echo "  PERFECT -- Your environment fully matches Apex V7."
  echo "  Run /healthcheck inside Claude Code for the 18-point runtime check."
elif [ "$FAIL" -eq 0 ]; then
  echo "  GOOD -- Core installation complete. Warnings are for optional components."
  echo ""
  echo "  To unlock the FULL 1,276+ skills + 108 agents experience, in Claude Code:"
  echo "  1. /plugin marketplace add https://github.com/anthropic-community/everything-claude-code"
  echo "  2. /plugin install everything-claude-code"
  echo "  3. /plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode"
  echo "  4. /plugin install oh-my-claudecode"
  echo "  5. /oh-my-claudecode:omc-setup"
  echo "  6. /healthcheck"
else
  echo "  ISSUES FOUND -- Some core components failed."
  echo "  Review [FAIL] items above. Options:"
  echo "  1. Re-run the installer: bash install.sh"
  echo "  2. Install missing components manually"
  echo "  3. Restore from backup: bash uninstall.sh"
fi

echo ""
