# Uninstall: How to Remove Apex

## Overview

This guide covers clean uninstallation of Apex. You can uninstall completely or partially (keep memory/settings, remove code only).

## Full Uninstall (Remove Everything)

### Step 1: Backup Your Work

Before uninstalling, save anything important:

```bash
# Backup memory files
cp -r ~/.claude/memory ~/claude-backup-memory

# Backup custom agents
cp -r ~/.claude/agents ~/claude-backup-agents

# Backup project settings
cp ~/.claude/settings.json ~/claude-backup-settings.json

# Backup MEMORY.md
cp ~/.claude/MEMORY.md ~/claude-backup-MEMORY.md
```

### Step 2: Stop Running Instances

```bash
# Close all Claude Code terminals
# Kill any running processes:
pkill -f "claude"
pkill -f "peers-broker"
```

### Step 3: Run Uninstall Script

```bash
cd ~/.claude
bash uninstall.sh

# Prompts:
# "Remove ~/.claude directory? (y/n)"
# "Remove ~/.claude/settings.json? (y/n)"
# "Remove ~/.claude/memory? (y/n)"
```

### Step 4: Manual Cleanup (if uninstall script missing)

```bash
# Remove Apex directory
rm -rf ~/.claude

# Verify it's gone
ls ~/.claude
# Should return: "No such file or directory"
```

### Step 5: Remove Claude Code

If you want to remove Claude Code itself (not just Apex):

```bash
# macOS:
brew uninstall claude-code

# Windows (via npm):
npm uninstall -g @anthropic-ai/claude-code

# Or (if installed via installer):
# Control Panel → Programs → Uninstall Claude Code
```

### Step 6: Verify Uninstall

```bash
# These should all fail:
which claude
# Should return: (no output)

ls ~/.claude
# Should return: "No such file or directory"

claude
# Should return: "command not found"
```

---

## Partial Uninstall (Keep Settings, Remove Code)

Use this if you want to keep your memory/settings but reinstall later.

### Step 1: Backup ~/.claude

```bash
# Create backup
cp -r ~/.claude ~/claude-backup-$(date +%Y%m%d)
```

### Step 2: Remove Only Code/Agents

```bash
# Keep: settings.json, memory/, MEMORY.md
# Remove: agents/, rules/, skills/, hooks/

rm -rf ~/.claude/agents
rm -rf ~/.claude/rules
rm -rf ~/.claude/skills
rm -rf ~/.claude/hooks
rm -rf ~/.claude/config/orchestration.yaml
```

### Step 3: Keep Settings

```bash
# Verify these files still exist:
ls ~/.claude/settings.json
ls ~/.claude/MEMORY.md
ls -d ~/.claude/memory

# All three should be present
```

### Step 4: Reinstall When Ready

```bash
# Later, you can reinstall:
npm install -g @anthropic-ai/claude-code

# Your settings and memory will still be there
claude
# Uses your backed-up configuration
```

---

## Uninstall by Platform

### macOS

```bash
# Via Homebrew (recommended):
brew uninstall claude-code

# Via npm:
npm uninstall -g @anthropic-ai/claude-code

# Complete cleanup:
rm -rf ~/.claude
rm -rf ~/Library/Application\ Support/claude-code
```

### Windows

**Via npm (Git Bash):**
```bash
npm uninstall -g @anthropic-ai/claude-code

# Then:
rm -rf ~/.claude
```

**Via Program Manager (PowerShell):**
```powershell
# If installed via Windows installer:
Control Panel → Programs → Programs and Features
# Find "Claude Code" → Uninstall

# Then remove config:
rm -r $env:USERPROFILE\.claude
```

### Linux

```bash
# Via npm:
npm uninstall -g @anthropic-ai/claude-code

# Complete cleanup:
rm -rf ~/.claude
rm -rf ~/.local/share/claude-code
```

---

## What Gets Removed vs. Stays

### Removed by Full Uninstall

```
~/.claude/                          ❌ REMOVED
  ├── agents/                       ❌ Removed
  ├── rules/                        ❌ Removed
  ├── skills/                       ❌ Removed
  ├── hooks/                        ❌ Removed
  ├── config/                       ❌ Removed
  ├── memory/                       ❌ Removed (unless backed up)
  └── settings.json                 ❌ Removed (unless backed up)

/usr/local/bin/claude              ❌ REMOVED (CLI executable)
~/.npm/                             ⚠️ May remain (npm cache)
```

### Stays After Uninstall

```
~/claude-backup-*                   ✅ STAYS (if you backed up)
git repositories                    ✅ STAYS (your projects)
$PROJECTS/*/                        ✅ STAYS (project folders)
~/.git/                             ✅ STAYS (git config)
environment variables              ✅ STAYS (unless you manually deleted)
```

---

## Cleanup Checklist

After uninstalling, verify:

- [ ] `which claude` returns nothing
- [ ] `ls ~/.claude` returns "No such file or directory"
- [ ] `claude` command fails with "command not found"
- [ ] Backup files exist: `ls ~/claude-backup-*`
- [ ] Projects still intact: `ls ~/$PROJECTS/`
- [ ] Git config preserved: `git config user.name`

---

## Reinstalling After Uninstall

### From Full Uninstall

```bash
# Reinstall Claude Code
npm install -g @anthropic-ai/claude-code

# Apex will auto-initialize with defaults
claude

# Restore your settings from backup
cp ~/claude-backup-settings.json ~/.claude/settings.json
cp ~/claude-backup-MEMORY.md ~/.claude/MEMORY.md
cp -r ~/claude-backup-memory/* ~/.claude/memory/

# Restart
claude
```

### From Partial Uninstall

```bash
# Apex should work as-is (settings preserved)
claude

# If not, reinstall agents/rules:
bash ~/.claude/hooks/bootstrap.sh
```

---

## Troubleshooting Uninstall

### Issue: "Permission Denied" When Removing ~/.claude

```bash
# On Windows or with permission issues:
sudo rm -rf ~/.claude

# Or change permissions first:
chmod -R 755 ~/.claude
rm -rf ~/.claude
```

### Issue: Claude Code Still Runs After Uninstall

```bash
# Kill any running processes:
pkill -f "claude"

# Find where it's installed:
which claude
# If output appears, it's still in PATH

# Remove it:
npm uninstall -g @anthropic-ai/claude-code
# Or (if Homebrew):
brew uninstall claude-code
```

### Issue: Settings.json Won't Delete

```bash
# File may be locked by running process
# Step 1: Close all Claude Code instances
pkill -f "claude"

# Step 2: Try removing again
rm ~/.claude/settings.json

# Step 3: If still locked (Windows):
# Use File Explorer → Properties → Unblock
# Then try delete again
```

### Issue: Backup Files Taking Up Space

```bash
# Clean up old backups (keep recent):
ls -ldt ~/claude-backup-* | tail -n +4

# Remove old ones:
rm -rf ~/claude-backup-20250101
rm -rf ~/claude-backup-20250102
```

---

## Keeping Apex but Resetting Everything

If you want to keep Claude Code but reset Apex to factory defaults:

```bash
# Option 1: Reset settings only
rm ~/.claude/settings.json
claude
# Will prompt for initial setup

# Option 2: Reset memory only
rm -rf ~/.claude/memory/*
# But keep settings.json

# Option 3: Reset agents/rules only
rm -rf ~/.claude/agents
rm -rf ~/.claude/rules
# But keep settings.json and memory

# Option 4: Full reset (keep Claude Code)
rm -rf ~/.claude
claude
# Will reinitialize Apex from scratch
```

---

## Data Recovery After Uninstall

### If You Accidentally Deleted Everything

**Recover from Backup:**
```bash
# If you kept ~/claude-backup-:
cp -r ~/claude-backup-20260404/* ~/.claude/

# If backup is compressed:
tar -xzf ~/claude-backup-20260404.tar.gz -C ~
```

**Recover from Git History:**
```bash
# If .claude was in git repo:
git checkout HEAD -- .claude/

# Or restore specific file:
git checkout HEAD -- .claude/MEMORY.md
```

**Recover from Cloud Sync:**
```bash
# If you synced to OneDrive/Google Drive:
# Browse to: OneDrive → Claude → memory/
# Download recovered files
```

**If All Else Fails:**
```bash
# Reinstall and configure from scratch
npm install -g @anthropic-ai/claude-code
claude
/omc-setup
/paul:init
```

---

## Uninstall Scripts

### Uninstall.sh (Included in Apex)

Located at: `~/.claude/uninstall.sh`

```bash
#!/bin/bash

echo "=== Claude Apex Uninstall ==="
echo ""

# Backup option
read -p "Backup ~/.claude before removing? (y/n) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  BACKUP_DIR="$HOME/claude-backup-$(date +%Y%m%d-%H%M%S)"
  cp -r ~/.claude "$BACKUP_DIR"
  echo "✓ Backed up to: $BACKUP_DIR"
fi

# Confirm removal
read -p "Remove ~/.claude completely? (y/n) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  rm -rf ~/.claude
  echo "✓ Uninstalled Apex"
  echo ""
  echo "To remove Claude Code itself:"
  echo "  macOS: brew uninstall claude-code"
  echo "  npm: npm uninstall -g @anthropic-ai/claude-code"
fi
```

### Custom Uninstall Script

Create `~/uninstall-apex-custom.sh`:

```bash
#!/bin/bash

echo "=== Custom Apex Uninstall ==="

# Remove only specific parts
read -p "Remove agents? (y/n) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  rm -rf ~/.claude/agents
fi

read -p "Remove rules? (y/n) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  rm -rf ~/.claude/rules
fi

read -p "Remove memory? (y/n) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  rm -rf ~/.claude/memory
fi

read -p "Remove settings.json? (y/n) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  rm ~/.claude/settings.json
fi

echo "✓ Selective uninstall complete"
```

---

## Important Notes

**IMPORTANT**: Uninstalling removes your configuration and memory. Back up first!

**WARNING**: Never use `rm -rf ~/.` (removes your entire home directory). Always specify `~/.claude`.

**CRITICAL**: If you have custom agents or rules, save them before uninstalling:
```bash
cp -r ~/.claude/agents ~/my-custom-agents
cp -r ~/.claude/rules ~/my-custom-rules
```

---

**Need help?** See [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) for common issues, or [FAQ.md](./FAQ.md) for frequently asked questions.

## Pro Tips

- **Run `bash uninstall.sh`, not `rm -rf`.** The script restores from backup; `rm -rf` just deletes.
- **Back up memory before uninstalling.** `cp -r ~/.claude/memory ~/claude-memory-$(date +%Y%m%d)`. Memory files are portable across installs.
- **Keep `~/.claude/.env`** when switching Apex versions. The installer never touches it after creation.
- **Partial uninstalls are safer.** Remove only the agents or hooks you don't want, keep the rest.
- **If you reinstall later, your memory picks up where it left off.** session-handoff.md, lessons.md, and decisions.md survive uninstall if you backed them up.

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
