# Troubleshooting: Common Issues and Solutions

## Overview

This guide covers the most common Apex issues and how to fix them. Check symptoms first, then apply the fix.

## OMC Not Activating

### Symptom
```bash
autopilot: "Task"
# Returns: "autopilot is not recognized"
```

### Fix

**Step 1: Verify OMC is enabled**
```bash
grep -i "omcEnabled\|omc" ~/.claude/settings.json
# Should show: "omcEnabled": true
```

**Step 2: Restart Claude Code**
```bash
# Close all Claude Code instances
# Reopen in terminal
claude
```

**Step 3: Check health**
```bash
/healthcheck
# Look for: "OMC agents: ✓ LOADED"
```

### If still failing
- Read error: `/omc-reference`
- Check settings.json syntax: `cat ~/.claude/settings.json | jq`
- Rebuild: `bash ~/.claude/hooks/rebuild-OMC.sh`

---

## CARL Domain Not Loading

### Symptom
```bash
"Task with keyword1"
# Domain should load but doesn't (no rule output)
```

### Fix — Windows Path Issue

On Windows, CARL keywords trigger but domain INDEX.md fails because of `~` path expansion:

**Step 1: Check INDEX.md path**
```bash
# BAD (on Windows):
cat ~/.claude/rules/INDEX.md
# May expand to: C:\Users\YOU\~\.claude\rules\INDEX.md (WRONG)

# GOOD:
cat /c/Users/YOU/.claude/rules/INDEX.md
# Or use full path:
cat "$HOME/.claude/rules/INDEX.md"
```

**Step 2: Fix all domain files to use `$HOME` instead of `~`**
```bash
# Find all domain files
ls ~/.claude/rules/*.md

# In each domain file, replace:
❌ touch ~/.claude/rules/my-domain.md
✅ touch "$HOME/.claude/rules/my-domain.md"
```

**Step 3: Update INDEX.md**
```bash
# Make sure INDEX.md uses full paths:
cat "$HOME/.claude/rules/INDEX.md"
# NOT: ~/.claude/rules/INDEX.md
```

**Step 4: Test domain loading**
```bash
"Task with keyword1"
# Should now load domain
```

### If still not loading
- Check trigger keywords: `grep "trigger_keywords" ~/.claude/rules/my-domain.md`
- Verify YAML frontmatter: `---` (must be on line 1-2)
- Check domain name matches INDEX.md entry: `grep "my-domain" ~/.claude/rules/INDEX.md`

---

## Peers Broker Connection Failed

### Symptom
```bash
list_peers
# Error: "Broker not found at localhost:7899"
```

### Fix

**Step 1: Verify broker is running**
```bash
# Check if 7899 is listening
lsof -i :7899
# OR on Windows:
netstat -ano | grep 7899
```

**Step 2: Start broker manually**
```bash
cd ~/.claude
bash hooks/peers-auto-register.sh

# Output should show:
# ✓ Peers broker started on localhost:7899
```

**Step 3: Try listing peers again**
```bash
list_peers
# Should list all connected terminals
```

### If port already in use
```bash
# Find what's using 7899
netstat -ano | grep 7899
# Note the PID

# Kill the process (Windows):
taskkill /PID <PID> /F

# Or (Unix):
kill -9 <PID>

# Restart broker
bash ~/.claude/hooks/peers-auto-register.sh
```

---

## Settings.json Corruption

### Symptom
```bash
# Any command fails with:
# "SyntaxError: Unexpected token in JSON at position X"
```

### Fix

**Step 1: Backup corrupted file**
```bash
cp ~/.claude/settings.json ~/.claude/settings.json.bak
```

**Step 2: Validate JSON**
```bash
cat ~/.claude/settings.json | jq . > /dev/null
# Shows exact line with error
```

**Step 3: Edit and fix**
```bash
nano ~/.claude/settings.json
# Look for: missing commas, trailing commas, mismatched quotes
```

**Step 4: Validate again**
```bash
cat ~/.claude/settings.json | jq . > /dev/null
# Should show: (no output) = valid
```

**Step 5: Restart**
```bash
# Close and reopen Claude Code
claude
```

---

## Skills Not Loading

### Symptom
```bash
agent:my-specialist "Task"
# Error: "agent:my-specialist not found"
```

### Fix

**Step 1: Verify agent file exists**
```bash
ls ~/.claude/agents/my-specialist.md
# If not found, create it (see AGENTS-GUIDE.md)
```

**Step 2: Check AGENTS.md registry**
```bash
grep "my-specialist" ~/.claude/AGENTS.md
# Should have entry in format:
# | my-specialist | Description | agent:my-specialist | Tags |
```

**Step 3: Reload agents**
```bash
/healthcheck --reload-agents
```

**Step 4: Try again**
```bash
agent:my-specialist "Task"
# Should now work
```

### If still failing
- Check agent YAML frontmatter: `head -10 ~/.claude/agents/my-specialist.md`
- Verify enabled flag: `grep "enabled:" ~/.claude/agents/my-specialist.md` (should be `true`)
- Check trigger keywords: `grep "trigger_keywords:" ~/.claude/agents/my-specialist.md`

---

## Memory.md Exceeds Limit

### Symptom
```bash
wc -l ~/.claude/memory/MEMORY.md
# Output: 200+ lines (limit is 150)
```

### Fix

**Step 1: Run consolidation**
```bash
consolidate memory
```

**Step 2: Verify size reduced**
```bash
wc -l ~/.claude/memory/MEMORY.md
# Should now be: <150 lines
```

**Step 3: If consolidation didn't work**
```bash
# Aggressive mode
consolidate memory --aggressive
```

### Prevention
- Update MEMORY.md at session end with only last 3-5 summaries
- Archive old sessions regularly: `mv ~/.claude/memory/session-*.md ~/.claude/memory/archive/`

---

## Windows Path Issues

### Symptom 1: Path not found in commands
```bash
❌ C:\Users\YOU\Claude code\project
# Returns: "path not found" or "too many arguments"

✅ /c/Users/YOU/Claude code/project
# Or:
cd ~/Claude\ code/project
```

### Symptom 2: Spaces in paths cause issues
```bash
❌ cd C:\Users\YOU\Claude code\project
# Error: "code: command not found"

✅ cd "C:\Users\YOU\Claude code\project"
# Or use Unix path:
cd "/c/Users/YOU/Claude code/project"
```

### Symptom 3: Network paths fail
```bash
❌ \\SERVER\share\folder
# Not supported in Unix shell

✅ Map to drive letter first:
# PowerShell: New-PSDrive -Name Z -PSProvider FileSystem -Root \\SERVER\share
# Then: cd /z/folder
```

### Fix Summary
- Always use `/c/Users/...` format on Windows
- Quote paths with spaces: `"C:\path\to\folder"`
- Use `$HOME` instead of `~` in scripts (more portable)
- Use forward slashes in all paths (Unix style)

---

## Build Failures

### Symptom
```bash
npm run build
# Error: "src/main.ts is missing"
```

### Fix

**Step 1: Check file exists**
```bash
ls src/main.ts
# If not found, check git:
git status
```

**Step 2: Restore from git**
```bash
git checkout src/main.ts
```

**Step 3: Rebuild**
```bash
npm run build
```

### If build still fails
- Check NODE_VERSION: `node -v` (should be 18+)
- Clear cache: `rm -rf node_modules/.cache`
- Reinstall deps: `npm ci`
- Try again: `npm run build`

---

## Extended Thinking Not Working

### Symptom
```bash
# Alt+T (or Option+T) doesn't toggle thinking
# Or thinking output not visible
```

### Fix

**Step 1: Enable in settings**
```bash
grep "thinkingEnabled" ~/.claude/settings.json
# Should be: "alwaysThinkingEnabled": true
```

**Step 2: Toggle with keyboard**
```bash
# Windows/Linux: Alt+T
# macOS: Option+T
# No visible output, but thinking is active
```

**Step 3: View thinking output**
```bash
# Press: Ctrl+O (toggles verbose thinking display)
# Now you'll see [thinking] blocks in output
```

### If still not working
- Update Claude Code: `brew upgrade claude-code` (or your package manager)
- Check theme: dark mode enables extended thinking by default
- Restart Claude Code

---

## Team Mode Workers Not Creating PRs

### Symptom
```bash
team 3:executor "Task 1" "Task 2" "Task 3"
# Tasks complete but PRs don't appear in GitHub
```

### Fix

**Step 1: Verify autoPullRequests is enabled**
```bash
grep "autoPullRequests" ~/.claude/settings.json
# Should be: "autoPullRequests": true
```

**Step 2: Check git worktrees created**
```bash
git worktree list
# Should show 3 worktrees (one per task)
```

**Step 3: Check git config**
```bash
git config user.name
git config user.email
# Both should be set
```

**Step 4: Verify GitHub token**
```bash
gh auth status
# Should show: "✓ Logged in to github.com"
```

**Step 5: Manually create PR if needed**
```bash
# In worktree directory:
git push -u origin feature/task-worker1
gh pr create --title "Feature: Task 1" --body "Implementation of Task 1"
```

### Prevention
- Always verify `gh auth status` before team mode
- Check `git config --list` includes user.name and user.email
- Ensure GitHub token is current: `gh auth refresh`

---

## Orchestration Not Routing Correctly

### Symptom
```bash
"Complex refactor task"
# Routes to DIRECT instead of PAUL
```

### Fix

**Step 1: Check routing config**
```bash
cat ~/.claude/config/orchestration.yaml
# Verify PAUL.min_phases (default: 3)
```

**Step 2: Override for this task**
```bash
/paul:init "Complex refactor task"
# Forces PAUL route explicitly
```

**Step 3: Check routing stats**
```bash
/orchestration:stats
# Shows what route was chosen and why
```

**Step 4: Adjust rules if needed**
```bash
# Make PAUL more aggressive (2 phases instead of 3)
/update-config orchestration.routes.PAUL.min_phases 2
```

---

## Session Memory Lost

### Symptom
```bash
# Context from previous session not available
# /deepinterview result not remembered
```

### Fix

**Step 1: Check SESSION-HANDOFF.md**
```bash
cat ~/.claude/memory/SESSION-HANDOFF.md
# Should show: "Last session ended at: <timestamp>"
```

**Step 2: Check SESSION-MEMORY.md**
```bash
cat ~/.claude/memory/SESSION-MEMORY.md
# Should have project-specific context
```

**Step 3: If empty, restore from archive**
```bash
# List recent sessions
ls -lt ~/.claude/memory/archive/session-*.md | head -5

# Restore most recent
cat ~/.claude/memory/archive/session-42.md
```

**Step 4: Update MEMORY.md manually**
```bash
# Copy key points back to MEMORY.md
nano ~/.claude/memory/MEMORY.md
```

### Prevention
- Always save at session end: `consolidate memory --auto`
- Update MEMORY.md with each major task
- Archive important sessions: `cp MEMORY.md archive/session-$(date +%s).md`

---

**Next**: [WINDOWS-GUIDE.md](./WINDOWS-GUIDE.md) → Windows-specific setup and troubleshooting
