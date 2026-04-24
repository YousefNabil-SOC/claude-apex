# Install From Zero

> You have a brand-new computer (or you've never done this before). Every step is here, on all three operating systems, with verification commands after each step.

## The install order

1. Node.js 20+ (required by Claude Code)
2. Python 3.10+ (required by Apex hooks)
3. Git (required to download this repo)
4. Claude Code (the CLI)
5. Claude Apex (this repo)
6. API keys (optional but recommended)
7. Plugins (for the full 1,276+ skill experience)

Total time: 15-20 minutes.

---

## Step 1 — Install Node.js

Node.js runs Claude Code. You need version 20 or higher.

### Windows, Mac, and Linux side by side

| Windows | macOS | Linux (Ubuntu/Debian) |
|---|---|---|
| 1. Go to https://nodejs.org | 1. Open Terminal (Cmd+Space, type "Terminal") | 1. Open Terminal |
| 2. Click the LTS button | 2. `brew install node` — or download `.pkg` from nodejs.org | 2. `curl -fsSL https://deb.nodesource.com/setup_lts.x \| sudo -E bash -` |
| 3. Download and run the `.msi` | 3. Run installer if using `.pkg` | 3. `sudo apt install -y nodejs` |
| 4. Click Next through defaults | 4. Close and reopen Terminal | 4. Verify below |

### Verify

```bash
node --version
```

**Expected output:**
```
v20.11.0
```

If you see `v18.x` or lower, upgrade. If you see "command not found", Node didn't install correctly — close and reopen your terminal, or reinstall.

---

## Step 2 — Install Python 3

Apex hooks (like the CARL injector) are written in Python.

### Windows

1. Go to https://www.python.org/downloads/
2. Click the yellow "Download Python 3.x" button
3. Run the installer
4. **IMPORTANT**: tick the box "Add Python to PATH" before clicking Install
5. Click "Install Now" and let it finish

### macOS

Usually already installed. Check with `python3 --version`. If missing:
```bash
brew install python3
```

### Linux

Usually already installed. Check with `python3 --version`. If missing:
```bash
sudo apt install python3 python3-pip
```

### Verify (all OSes)

```bash
python3 --version
```

**Expected output:**
```
Python 3.12.1
```

Anything 3.10 or higher is fine. Older than 3.10, upgrade.

---

## Step 3 — Install Git

### Windows

1. Go to https://git-scm.com/download/win
2. Download and run the installer
3. Click Next through all the defaults
4. After install you have a new program: **Git Bash** — a Linux-style terminal for Windows. We'll use it from here on.

### macOS

Run `git --version` in Terminal. If it's missing, macOS offers to install developer tools — accept. Or:
```bash
brew install git
```

### Linux

```bash
sudo apt install git
```

### Verify (all OSes)

```bash
git --version
```

**Expected output:**
```
git version 2.43.0
```

---

## Step 4 — Install Claude Code

Now for the main program. Open your terminal (Git Bash on Windows, Terminal on Mac/Linux) and run:

```bash
npm install -g @anthropic-ai/claude-code
```

This downloads and installs Claude Code globally. Takes about 30 seconds.

### Verify

```bash
claude --version
```

**Expected output:**
```
Claude Code 2.1.80
```

Any 2.1.x or higher is fine.

### First run — log in

```bash
claude
```

**Expected output (first time):**
```
Welcome to Claude Code

To continue, please log in to your Claude account.
Opening browser...

[Browser opens to claude.ai/login]

Waiting for authentication...
```

Complete the login in your browser, then come back to the terminal. Claude Code shows its welcome prompt:

```
Claude Code v2.1.80
Type /help for commands, or just ask a question.

>
```

Type `/exit` and press Enter to quit for now. Continue to Step 5.

If you don't have a Claude account yet, sign up free at https://claude.ai.

---

## Step 5 — Install Claude Apex (this repo)

Still in your terminal:

```bash
git clone https://github.com/YousefNabil-SOC/claude-apex.git
cd claude-apex
```

**Expected output:**
```
Cloning into 'claude-apex'...
remote: Enumerating objects: 847, done.
Receiving objects: 100% (847/847), 1.23 MiB | 2.1 MiB/s, done.
Resolving deltas: 100% (421/421), done.
```

Now run the installer. Pick your OS:

### Mac / Linux / Windows Git Bash
```bash
bash install.sh
```

### Windows PowerShell (if you prefer)
```powershell
./install.ps1
```

The installer will:
1. Check prerequisites
2. Ask for your confirmation
3. Back up your existing `~/.claude/` folder
4. Install 25 agents, ~45 commands, 7 hooks, 9 skills
5. Configure 4 MCP servers and 5 hook events in `settings.json`
6. Print what to do next

**Expected output (abbreviated):**
```
==============================================
  Claude Apex V7 — Installation
  by Engineer Yousef Nabil
  github.com/YousefNabil-SOC/claude-apex
==============================================

Checking prerequisites...
  [OK] Claude Code: 2.1.80
  [OK] Node.js: v20.11.0
  [OK] Python 3: 3.12.1
  [OK] Git: 2.43.0
  [OK] npm: 10.2.4

Continue? (y/n): y

Creating backup...
  [OK] Backup saved to /home/you/.claude/backups/pre-apex-20260424-103015

Installing agents (25 specialists)...
  [INSTALL] architect.md
  [INSTALL] code-reviewer.md
  ... (23 more) ...

Installing commands...
  [INSTALL] healthcheck.md
  [INSTALL] switch-project.md
  ... (43 more) ...

Installing hooks (V7 fixed versions)...
  [INSTALL] carl-hook.py
  [INSTALL] session-start-check.sh
  ... (5 more) ...

Installing Apex skills (9 custom)...
  [INSTALL] skill: premium-web-design
  [INSTALL] skill: 21st-dev-magic
  ... (7 more) ...

Installing CARL domains (9 domains, 40 rules)...
  [INSTALL] carl.json (9 domains, 40 rules)

Installing config files (V7 three-layer routing)...
  [INSTALL] ORCHESTRATION-ENGINE.md
  [INSTALL] CAPABILITY-REGISTRY.md
  [INSTALL] COMMAND-REGISTRY.md
  [INSTALL] AGENTS.md
  [INSTALL] AUTO-ACTIVATION-MATRIX.md

Configuring MCP servers (4 Apex defaults)...
  [INSTALL] MCP: playwright
  [INSTALL] MCP: github
  [INSTALL] MCP: exa-web-search
  [INSTALL] MCP: @21st-dev/magic

Configuring hooks in settings.json (5 events)...
  [INSTALL] PostCompact hook
  [INSTALL] Stop hooks (session-end-save + task-complete-sound)
  [INSTALL] UserPromptSubmit hook (CARL)
  [INSTALL] SessionStart hook chain

==============================================
  Claude Apex V7 installed successfully!
  Prepared by Engineer Yousef Nabil
  Star the repo: github.com/YousefNabil-SOC/claude-apex
==============================================

  Installed: 87
  Skipped:   0 (already existed)

  Backup at: /home/you/.claude/backups/pre-apex-20260424-103015
```

---

## Step 6 — Add your API keys (optional, recommended)

Some MCP servers need API keys. Skip this step if you want to try Apex without them — the core works without keys.

### Copy the template

```bash
cp config/env.template ~/.claude/.env
```

### Open the file

Windows Git Bash:
```bash
notepad ~/.claude/.env
```

macOS:
```bash
open -e ~/.claude/.env
```

Linux:
```bash
nano ~/.claude/.env
```

### Fill in the keys you want

```
FAL_KEY=your_fal_ai_key_here           # https://fal.ai/dashboard/keys — AI image generation
GITHUB_PERSONAL_ACCESS_TOKEN=ghp_...    # https://github.com/settings/tokens — GitHub PRs/issues
EXA_API_KEY=...                         # https://exa.ai — web search
TWENTY_FIRST_DEV_API_KEY=...            # https://21st.dev — React component generation
```

Save the file.

### Set permissions (Mac/Linux only)

```bash
chmod 600 ~/.claude/.env
```

This prevents other users on the machine from reading your keys.

Your keys stay on your computer. They are never uploaded anywhere by Apex.

---

## Step 7 — Install plugins (unlock the full 1,276+ skills)

Apex ships with 9 custom skills. Two plugins add 1,267 more.

Open a **new** terminal. Run:
```bash
claude
```

Once Claude Code starts, paste this whole block:

```
I just installed Claude Apex V7. Please run:
1. /plugin marketplace add https://github.com/anthropic-community/everything-claude-code
2. /plugin install everything-claude-code
3. /plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
4. /plugin install oh-my-claudecode
5. /oh-my-claudecode:omc-setup
6. /healthcheck
```

Claude Code will run each step and report. After this, you have 1,276+ skills and 108 agents available.

---

## Step 8 — Verify

Go back to your terminal in the claude-apex folder:

```bash
cd claude-apex
bash verify.sh
```

**Expected output (abbreviated):**
```
===========================================================
  CLAUDE APEX V7 -- Post-Install Verification
===========================================================

--- AGENTS (target: 25) ---
  [PASS]  Agent count -- 25 agents installed
  [PASS]  Critical agent -- architect.md
  [PASS]  Critical agent -- code-reviewer.md
  ...

--- APEX CUSTOM SKILLS (9 expected) ---
  [PASS]  Skill -- premium-web-design
  [PASS]  Skill -- 21st-dev-magic
  ...

--- CONFIGURATION ---
  [PASS]  CARL -- 9 domains, 40 rules (V7 target met)
  [PASS]  Config -- ORCHESTRATION-ENGINE.md
  ...

===========================================================
  RESULTS: 35 passed | 0 warnings | 0 failed
===========================================================

  PERFECT -- Your environment fully matches Apex V7.

Claude Apex V7 — by Engineer Yousef Nabil
https://github.com/YousefNabil-SOC/claude-apex
```

If you see `[FAIL]`, go to **[10-TROUBLESHOOT-FOR-BEGINNERS.md](10-TROUBLESHOOT-FOR-BEGINNERS.md)**.

---

## Done — final verification

Open Claude Code:

```bash
claude
```

Type and press Enter:

```
/healthcheck
```

**Expected output:**
```
System Health Check V7

 #  | System              | Status | Details
----|---------------------|--------|--------------------------------
 1  | OMC Plugin          | OK     | oh-my-claudecode@omc enabled
 2  | PAUL Framework      | OK     | 28 commands
 3  | CARL                | OK     | 9 domains, 40 rules configured
 ... (15 more checks) ...

Result: 18/18 OK — all systems green
```

If you see `18/18 OK`, congratulations — you now have the most powerful Claude Code environment that exists on a consumer computer.

## What You Learned

- Node.js 20+, Python 3.10+, Git, and a Claude account are the four prerequisites.
- The installer is non-destructive — your old `~/.claude/` is backed up with a timestamp before any changes.
- Skipped files are safe — the installer never overwrites.
- Two plugins (everything-claude-code and oh-my-claudecode) unlock the full 1,276+ skills and 108 agents.
- `verify.sh` catches install issues before you hit them in Claude Code.

## Next Step

You now have Apex installed. Go to **[03-FIRST-TIME-USING.md](03-FIRST-TIME-USING.md)** to learn your first 10 commands.

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
