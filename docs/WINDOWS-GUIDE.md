# Windows Guide: Setup and Troubleshooting

## Overview

Apex runs on Windows via Git Bash or Windows Subsystem for Linux (WSL). This guide covers Windows-specific setup, path handling, and common issues.

## Prerequisites

### Minimum Requirements
- Windows 10 or later (Windows 11 recommended)
- Git for Windows (includes Git Bash)
- Node.js 18+ installed
- npm or yarn

### Installation Steps

**Step 1: Install Git for Windows**
```bash
# Download from: https://git-scm.com/download/win
# Run installer, choose default options
# Includes: Git Bash, Git GUI, Git Credential Manager
```

**Step 2: Install Node.js**
```bash
# Download from: https://nodejs.org (LTS version)
# Run installer
# Choose: Add to PATH (default)
```

**Step 3: Verify installations**
```bash
# In Git Bash:
node -v      # Should show: v18.x or higher
npm -v       # Should show: 9.x or higher
git --version # Should show: git version 2.x
```

---

## Opening Claude Code on Windows

### Option 1: Git Bash (Recommended)
```bash
# Open Git Bash from Start Menu
# Or right-click folder → "Git Bash Here"

cd "/c/Claude code/claude-apex"
claude
```

### Option 2: Windows Terminal
```bash
# Open Windows Terminal (Microsoft Store)
# Click dropdown → "Git Bash"

cd "/c/Claude code/claude-apex"
claude
```

### Option 3: PowerShell (Not Recommended)
```powershell
# PowerShell does NOT understand Unix paths well
# If you must use PowerShell:
# Install WSL2 and run: wsl
# Then use Unix commands

# Better: Use Git Bash instead
```

---

## Path Format Rules

### Critical: Windows Paths Don't Work in Unix Shell

| Format | Status | Example | Usage |
|--------|--------|---------|-------|
| Windows style | ❌ DON'T use | `C:\Users\YOU\Claude code` | Only in PowerShell |
| Unix forward slashes | ✅ ALWAYS use | `/c/Users/YOU/Claude code` | Git Bash, Claude Code |
| Tilde expansion | ⚠️ Use `$HOME` in scripts | `~/.claude/settings.json` | OK for interactive commands |
| Variables with spaces | ✅ Quote paths | `"/c/Users/YOU/Claude code"` | Always when spaces exist |

### Example Conversions

**Path with spaces:**
```bash
❌ /c/Users/Jane Doe/my project
✅ "/c/Users/Jane Doe/my project"
```

**Home directory reference:**
```bash
❌ In scripts: ~/.claude/settings.json (may fail on Windows)
✅ In scripts: $HOME/.claude/settings.json (portable)
```

**Network paths:**
```bash
❌ \\SERVER\share\folder (Windows UNC path)
✅ Map to drive first in PowerShell:
   New-PSDrive -Name Z -PSProvider FileSystem -Root \\SERVER\share
   Then in Git Bash: /z/folder
```

---

## Git Bash Tips & Tricks

### Tab Completion
```bash
# Press TAB to auto-complete
cd /c/Claude<TAB>  # Completes to: /c/Claude\ code/

# Type 'code' directory with space:
cd "/c/Claude code"
# Then TAB works
```

### Copy/Paste
```bash
# Right-click → Paste (or Shift+Insert)
# NOT Ctrl+V (that doesn't work in Git Bash)

# Alternatively, use Windows Terminal instead (Ctrl+V works)
```

### Finding Your Home Directory
```bash
echo $HOME
# Output: /c/Users/yourname

# Apex config:
ls $HOME/.claude/settings.json
```

### Viewing Files with Spaces
```bash
❌ cat C:\Users\Jane Doe\file.md
   # Error: "Jane: command not found"

✅ cat "/c/Users/Jane Doe/file.md"
✅ cat "$HOME/file.md"
```

---

## Multi-Terminal Apex on Windows

### Using Windows Terminal (Recommended)

Windows Terminal allows multiple tabs/panes in one window:

**Step 1: Open Windows Terminal**
```bash
# Start → Windows Terminal
# Or: Win+Alt+T
```

**Step 2: Create new tabs**
```bash
# Click "+" button to add tabs
# Each tab auto-opens in Git Bash
```

**Step 3: Navigate in each tab**
```bash
# Tab 1 (Planner):
cd "/c/Claude code/claude-apex"
claude
set_summary "Planner: Creating sprint structure"

# Tab 2 (Executor 1):
cd "/c/Claude code/claude-apex"
claude
set_summary "Executor 1: Implementing Story 1"

# Tab 3 (Executor 2):
cd "/c/Claude code/claude-apex"
claude
set_summary "Executor 2: Implementing Story 2"
```

**Step 4: Use Peers to coordinate**
```bash
# In Tab 1 (Planner):
send_message all "Sprint plan ready, see shared memory"

# In Tab 2 & 3:
receive_message
list_peers
```

### Alternative: Multiple Git Bash Windows

If you don't have Windows Terminal:

**Step 1: Open multiple Git Bash windows**
```bash
# Right-click desktop → Git Bash
# Do this 3 times (one window per terminal)
```

**Step 2: Navigate in each**
```bash
cd "/c/Claude code/claude-apex"
claude
```

**Step 3: Use Peers (works across windows)**
```bash
# Same peer commands as above
list_peers  # See all windows connected
```

---

## Line Endings: CRLF vs LF

### What is This?

Windows uses CRLF (`\r\n`) for line endings. Unix uses LF (`\n`). This can cause issues in git.

### Fix: Configure Git

```bash
# Set global Git config to auto-convert
git config --global core.autocrlf true

# For existing repo, normalize:
cd "/c/Claude code/claude-apex"
git rm -r --cached .
git reset --hard HEAD
```

### For Apex Files

If you see "LF will be replaced by CRLF" warnings:

```bash
# It's OK, just commit normally
git add .
git commit -m "normalize line endings"
```

---

## WSL2: Running Linux Natively

### When to Use WSL2

Use WSL2 if:
- You want native Linux environment on Windows
- You need Docker containers
- You prefer bash over Git Bash
- You develop for Linux servers

### Installation

**Step 1: Enable WSL2**
```powershell
# Run as Administrator in PowerShell:
wsl --install
# Then restart Windows
```

**Step 2: Install Ubuntu**
```powershell
# After restart, in PowerShell:
wsl --install -d Ubuntu-22.04
# Then follow Ubuntu setup
```

**Step 3: Access files from WSL**
```bash
# From WSL bash, access Windows files:
cd /mnt/c/Users/yourname/projects/claude-apex
claude
```

### WSL vs Git Bash: Decision Table

| Feature | Git Bash | WSL2 |
|---------|----------|------|
| Installation | Easy (one download) | Medium (WSL2 + distro) |
| Performance | Fast | Very Fast |
| Docker support | No | Yes |
| Linux tools | Limited | Full |
| File access | `/c/Users/...` | `/mnt/c/Users/...` |
| Recommendation | Apex use | Advanced users |

---

## Windows-Specific Apex Issues

### Issue 1: Permission Denied on Scripts

**Symptom:**
```bash
bash ~/.claude/hooks/peers-auto-register.sh
# Error: Permission denied
```

**Fix:**
```bash
# Make script executable
chmod +x ~/.claude/hooks/peers-auto-register.sh

# Then run again
bash ~/.claude/hooks/peers-auto-register.sh
```

### Issue 2: npm Commands Not Found

**Symptom:**
```bash
npm run build
# Error: npm: command not found
```

**Fix:**
```bash
# Node.js not in PATH
# Reinstall Node.js and check "Add to PATH"

# Or manually add to PATH:
# 1. Start → Edit environment variables
# 2. Add: C:\Program Files\nodejs
# 3. Restart Git Bash
```

### Issue 3: Git Credential Manager Issues

**Symptom:**
```bash
git push
# Hangs at "Askpass program not found"
```

**Fix:**
```bash
# Disable Git Credential Manager temporarily:
GIT_ASKPASS="" git push

# Or fix credential manager:
# 1. Start → Credential Manager
# 2. Find GitHub entry
# 3. Delete and re-add token
```

### Issue 4: Home Directory Path Confusion

**Symptom:**
```bash
ls ~/.claude/settings.json
# Works interactively

# But in script:
# Error: cannot find ~/.claude/settings.json
```

**Fix:**
```bash
# In scripts, always use $HOME:
ls "$HOME/.claude/settings.json"  # ✅ Portable

# NOT:
ls ~/.claude/settings.json        # ❌ May fail in scripts
```

### Issue 5: Long Paths (Windows Limitation)

**Symptom:**
```bash
npm install
# Error: ENAMETOOLONG or path too long
```

**Fix — Windows has 260-char path limit (even in modern versions)**

```bash
# Option 1: Enable long paths in Windows 10/11
# Run as Administrator in PowerShell:
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" `
  -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force

# Then restart Windows

# Option 2: Use shorter paths
cd "/c/Claude code/claude-apex"
# NOT: "/c/Users/yourname/Documents/Projects/Development/ActiveProjects/Claude/Code/claude-apex"
```

---

## Environment Variables

### Common Variables on Windows

```bash
# Check these are set:
echo $HOME        # Should be: /c/Users/yourname
echo $PATH        # Should include Node.js and git
echo $TEMP        # Temporary directory
echo $USERPROFILE # Windows user path
```

### Setting Custom Variables

**Option 1: In Git Bash session**
```bash
# Temporary (lasts until you close Git Bash):
export MY_VAR="value"
echo $MY_VAR  # Outputs: value
```

**Option 2: Permanent (in ~/.bashrc)**
```bash
# Edit your Git Bash config:
nano ~/.bashrc

# Add at end:
export MY_VAR="value"
export ANOTHER_VAR="another"

# Save: Ctrl+O, Enter, Ctrl+X

# Reload:
source ~/.bashrc
```

**Option 3: Windows Environment Variables (affects all tools)**
```powershell
# Run as Administrator in PowerShell:
[Environment]::SetEnvironmentVariable("MY_VAR", "value", "User")

# Restart Git Bash to see change
```

---

## Windows Firewall & Network

### Apex Peers on Network

If you have multiple machines and want Peers to work across network:

**Step 1: Open port 7899 in Windows Firewall**
```powershell
# Run as Administrator in PowerShell:
New-NetFirewallRule -DisplayName "Claude Peers" `
  -Direction Inbound -Protocol TCP -LocalPort 7899 -Action Allow
```

**Step 2: Configure broker to listen on all interfaces**
```bash
# Edit: ~/.claude/hooks/peers-auto-register.sh
# Change: localhost:7899
# To: 0.0.0.0:7899
```

**Step 3: From another machine, connect**
```bash
# Replace localhost with your Windows machine IP:
export PEERS_BROKER="192.168.1.100:7899"
list_peers
```

---

## Keyboard Shortcuts on Windows

| Action | Windows | macOS | Linux |
|--------|---------|-------|-------|
| Submit (extended thinking) | Ctrl+Enter | Cmd+Enter | Ctrl+Enter |
| Toggle thinking | Alt+T | Option+T | Alt+T |
| Show thinking output | Ctrl+O | Cmd+O | Ctrl+O |
| Copy in Git Bash | Right-click | Cmd+C | Ctrl+Shift+C |
| Paste in Git Bash | Right-click or Shift+Insert | Cmd+V | Ctrl+Shift+V |

---

## Antivirus & Performance

### If Apex Runs Slowly

Windows Defender or other antivirus may scan Node.js processes:

**Fix: Exclude Apex from scanning**
```powershell
# Run as Administrator in PowerShell:
Add-MpPreference -ExclusionPath "$env:USERPROFILE\code\claude-apex"  # or wherever you cloned the repo
Add-MpPreference -ExclusionPath "$env:USERPROFILE\.claude"
Add-MpPreference -ExclusionPath "$env:APPDATA\npm"
```

This speeds up `npm install` and `npm run build` significantly.

---

## Troubleshooting Checklist

- [ ] Node.js 18+ installed: `node -v`
- [ ] npm in PATH: `npm -v`
- [ ] Git for Windows installed: `git --version`
- [ ] Using Git Bash (not PowerShell)
- [ ] Paths use forward slashes: `/c/Users/...` not `C:\Users\...`
- [ ] Paths with spaces are quoted: `"/c/Path With Spaces"`
- [ ] `$HOME` used in scripts instead of `~`
- [ ] Git line ending config: `git config core.autocrlf` (should be `true`)
- [ ] Claude Code starts: `claude` in Git Bash
- [ ] Peers broker runs: `list_peers` shows connected instances

---

## Pro Tips

- **Git Bash > PowerShell for Apex.** PowerShell struggles with Unix path conventions the hooks assume.
- **Use `$HOME`, not `~`, in scripts.** Hook commands fire outside interactive shells where `~` may not expand.
- **Quote paths with spaces.** `"/c/Claude code/project"` — always quoted, always forward slashes.
- **Enable long paths on Windows 10/11.** The LongPathsEnabled registry value saves headaches with deep `node_modules/` trees.
- **Exclude `.claude/` and your project folder from Windows Defender.** `Add-MpPreference -ExclusionPath ...` cuts build times dramatically.
- **Windows Terminal > Git Bash for multi-tab.** One window, multiple tabs, faster peer discovery.

**Next**: [UNINSTALL.md](./UNINSTALL.md) → How to uninstall Apex cleanly

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
