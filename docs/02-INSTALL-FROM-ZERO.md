# Install From Zero

> You have a brand-new computer (or you've never done this before). Here is every single step.

## What you'll install, in order

1. Node.js (for Claude Code)
2. Python 3 (for Apex hooks)
3. Git (for downloading this repo)
4. Claude Code itself
5. Claude Apex (this repo)
6. API keys (optional but recommended)
7. Plugins (for the full experience)

## Pick your OS

- Using **Windows** → follow the Windows column below
- Using **macOS** → follow the Mac column
- Using **Linux** → follow the Linux column

## Step 1: Install Node.js

**Windows**:
1. Go to https://nodejs.org
2. Click the big green "LTS" button
3. Download the `.msi` installer
4. Double-click it, click Next through everything, finish
5. Close your terminal if it was open, open a new one
6. Type `node --version` and press Enter
7. You should see something like `v20.11.0`. Done.

**macOS**:
1. Open Terminal (press Cmd+Space, type "Terminal", press Enter)
2. If you have Homebrew: `brew install node`
3. If you don't: go to https://nodejs.org, download the LTS `.pkg`, install
4. Run `node --version`
5. Done when you see `v20.11.0` or similar.

**Linux (Ubuntu/Debian)**:
```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
node --version
```

## Step 2: Install Python 3

**Windows**:
1. Go to https://www.python.org/downloads/
2. Click "Download Python 3.x" (the yellow button)
3. Run the installer
4. **IMPORTANT**: check the box "Add Python to PATH" before clicking Install
5. Click Install Now, finish
6. Open a new terminal, run `python --version`
7. Expect `Python 3.12.x` or similar.

**macOS**: Usually already installed. Check with `python3 --version`. If missing, `brew install python3`.

**Linux**: Usually already installed. Check with `python3 --version`. If missing: `sudo apt install python3 python3-pip`.

## Step 3: Install Git

**Windows**:
1. Go to https://git-scm.com/download/win
2. Download and run the installer
3. Click Next through everything (defaults are fine)
4. After install, you have a new program: "Git Bash" — this is a better terminal for Windows. We'll use it going forward.

**macOS**: Run `git --version` in Terminal. If prompted, macOS will offer to install developer tools — accept. Otherwise: `brew install git`.

**Linux**: `sudo apt install git`

## Step 4: Install Claude Code

Open your terminal (Git Bash on Windows, Terminal on Mac/Linux), then run:

```bash
npm install -g @anthropic-ai/claude-code
```

Wait for it to finish (could be 30 seconds). Then type:

```bash
claude --version
```

You should see a version number like `2.1.80`. You now have Claude Code installed.

First time you run `claude`, it will ask you to log in. Follow the prompts — it opens a browser and links your terminal to your Claude account. If you don't have a Claude account, sign up free at https://claude.ai.

## Step 5: Install Claude Apex (this repo)

Still in your terminal, run:

```bash
git clone https://github.com/YousefNabil-SOC/claude-apex.git
cd claude-apex
```

On **Mac/Linux**:
```bash
bash install.sh
```

On **Windows** (use PowerShell, not Git Bash, for this one):
```powershell
./install.ps1
```

The installer asks for confirmation, then installs everything in about 1-2 minutes. You'll see a lot of `[INSTALL]` and `[SKIP]` messages — that's normal.

**What the installer does**:
1. Backs up your existing `~/.claude/` folder to a timestamped backup
2. Adds 25 new agents, 44+ commands, 7 hooks, 9 skills
3. Configures 4 MCP servers in settings.json
4. Configures 5 hooks (CARL, SessionStart, Stop, PostCompact)
5. Prints instructions for the final 2 plugin installs

## Step 6: Add your API keys (optional but recommended)

Several MCP servers need API keys. Skip this step if you just want to try Claude Code — the basic version works without these.

1. Copy the env template:
   ```bash
   cp config/env.template ~/.claude/.env
   ```

2. Open `~/.claude/.env` in any text editor. On Windows:
   ```bash
   notepad ~/.claude/.env
   ```
   On Mac:
   ```bash
   open -e ~/.claude/.env
   ```

3. Fill in the keys you want:
   - `FAL_KEY` — get from https://fal.ai/dashboard/keys (for AI image generation)
   - `GITHUB_PERSONAL_ACCESS_TOKEN` — create at https://github.com/settings/tokens (for GitHub PR/issue operations)
   - `EXA_API_KEY` — get from https://exa.ai (for web search)
   - `TWENTY_FIRST_DEV_API_KEY` — get from https://21st.dev (for premium component generation)

4. Save the file.

5. Set permissions (Mac/Linux only):
   ```bash
   chmod 600 ~/.claude/.env
   ```

Your keys never leave your computer. They are stored locally only.

## Step 7: Install the plugins (finish the install)

Open a **new** terminal window. Run `claude`. Once Claude Code starts, paste this:

```
I just installed Claude Apex V7. Please run:
1. /plugin marketplace add https://github.com/anthropic-community/everything-claude-code
2. /plugin install everything-claude-code
3. /plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
4. /plugin install oh-my-claudecode
5. /oh-my-claudecode:omc-setup
6. /healthcheck
```

Claude will run each step and report. The final `/healthcheck` should show all systems green.

## Step 8: Verify

Run the verification script:
```bash
cd claude-apex
bash verify.sh
```

You should see lots of `[PASS]` and a final summary `RESULTS: 30+ passed | 0 failed`. If you see `[FAIL]`, read [10-TROUBLESHOOT-FOR-BEGINNERS.md](10-TROUBLESHOOT-FOR-BEGINNERS.md).

## Done

You now have the most powerful Claude Code environment on the planet. Next: [03-FIRST-TIME-USING.md](03-FIRST-TIME-USING.md) to learn your first commands.
