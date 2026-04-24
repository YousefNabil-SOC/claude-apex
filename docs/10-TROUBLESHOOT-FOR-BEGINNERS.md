# Troubleshoot for Beginners

> When something breaks. Each problem below has a Symptom (what you see), Cause (why it happens), and Fix (exact commands to run).

## First step always — run `/healthcheck`

Open Claude Code and type:
```
/healthcheck
```

Anything that shows `FAIL` tells you exactly what's broken. Fix that first.

---

## Top 10 problems beginners face

### Problem 1 — "command not found: claude"

**Symptom:**
```bash
$ claude
bash: claude: command not found
```

**Cause:** Claude Code isn't installed, or Node's global bin directory isn't in your PATH.

**Fix:**
```bash
npm install -g @anthropic-ai/claude-code
```

If that gives a permission error on Mac/Linux:
```bash
sudo npm install -g @anthropic-ai/claude-code
```

Close your terminal and reopen it. Then:
```bash
claude --version
```

Should show `2.1.80` or higher.

---

### Problem 2 — "permission denied" when running install.sh

**Symptom:**
```bash
$ bash install.sh
bash: ./install.sh: Permission denied
```

**Cause:** The script isn't marked executable after git clone (happens on some filesystems).

**Fix:**
```bash
chmod +x install.sh
bash install.sh
```

If chmod fails on Windows (NTFS filesystems sometimes can't chmod), just prefix with `bash`:
```bash
bash install.sh
```

---

### Problem 3 — "settings.json invalid" / JSON syntax error

**Symptom:**
```
Error loading settings.json: Unexpected token } at position 847
```

**Cause:** Hand-edited `settings.json` has a trailing comma, missing quote, or mismatched bracket.

**Fix:**
```bash
# Validate
python3 -c "import json; json.load(open('$HOME/.claude/settings.json'))"
```

Error output tells you the exact line:
```
json.decoder.JSONDecodeError: Expecting value: line 23 column 5 (char 847)
```

Open and fix that line. Common mistakes:
- Trailing comma after last item in array/object
- Missing quotes around a string
- Copy-paste with curly quotes instead of straight quotes

If you can't find it, restore from backup:
```bash
ls ~/.claude/backups/pre-apex-*/settings.json | head -1
cp <that-path> ~/.claude/settings.json
```

---

### Problem 4 — "MCP server won't start"

**Symptom:**
```bash
/mcp
```
Shows a red X next to one or more MCP servers:
```
  ✗ github    (error: GITHUB_PERSONAL_ACCESS_TOKEN not set)
```

**Cause:** API key missing or wrong in `~/.claude/.env`.

**Fix:**
```bash
# 1. Check .env exists
ls ~/.claude/.env

# 2. If missing, create it from template
cp config/env.template ~/.claude/.env

# 3. Open it
notepad ~/.claude/.env  # Windows
open -e ~/.claude/.env  # Mac
nano ~/.claude/.env     # Linux

# 4. Replace 'your_xxx_here' placeholders with real keys
# 5. Save, then restart Claude Code
```

Get keys here:
- GitHub PAT: https://github.com/settings/tokens (scopes: repo, read:org)
- Exa: https://exa.ai
- 21st.dev: https://21st.dev
- fal.ai: https://fal.ai/dashboard/keys

---

### Problem 5 — "stuck thinking for 10+ minutes"

**Symptom:** Claude hangs mid-response, spinner keeps turning.

**Cause:** One of:
1. Effort level is `xhigh` or `max` (too much extended thinking)
2. Task is genuinely huge and Claude is working through it
3. Your API credits ran out and Claude is stuck on rate-limiting

**Fix:**
```
# Press Ctrl+C to cancel
# Then check effort level
/effort
```

If showing `xhigh` or `max`, reset:
```
/effort high
```

If credits issue, check at https://console.anthropic.com — add credits or wait for rate limit to reset.

For genuinely huge tasks, split them: use PAUL framework to break into phases.

---

### Problem 6 — "/healthcheck fails on CARL"

**Symptom:**
```
 6  | UserPromptSubmit    | FAIL   | carl-hook.py not found
```

**Cause:** CARL hook isn't installed, or `settings.json` doesn't reference it.

**Fix:**
```bash
# 1. Check file exists
ls ~/.claude/hooks/carl-hook.py

# 2. Make it executable
chmod +x ~/.claude/hooks/carl-hook.py

# 3. Check Python is installed
python3 --version

# 4. Check settings.json has the hook entry
grep -A 3 "UserPromptSubmit" ~/.claude/settings.json
```

Should show:
```json
"UserPromptSubmit": [
  {
    "hooks": [
      { "type": "command", "command": "python3 $HOME/.claude/hooks/carl-hook.py" }
    ]
  }
]
```

If missing, re-run `bash install.sh` — the installer will add it.

---

### Problem 7 — "sounds keep firing every 2 seconds"

**Symptom:** Chime plays constantly during fast exchanges.

**Cause:** You have an old version of `task-complete-sound.sh` without the 60-second cooldown.

**Fix:**
```bash
# Check for cooldown in the hook
grep "\-lt 60" ~/.claude/hooks/task-complete-sound.sh
```

If no output, the cooldown is missing. Re-run the installer:
```bash
cd claude-apex
bash install.sh
```

The V7 hook has cooldown built in. The installer copies the new version.

---

### Problem 8 — "non-latin text shows as garbled characters"

**Symptom:** Arabic, Hebrew, CJK, or emoji in files shows as `??` or mojibake.

**Cause:** UTF-8 bug in old `carl-hook.py`.

**Fix:**
```bash
# Check for the fix
grep -c "io.TextIOWrapper" ~/.claude/hooks/carl-hook.py
```

Should output `2` or more (the V7 hook has 2 `io.TextIOWrapper` calls for stdout and stderr).

If output is `0` or `1`, re-run the installer:
```bash
cd claude-apex
bash install.sh
```

---

### Problem 9 — "Claude seems dumb today / wrong answers"

**Symptom:** Claude gives shallow answers, misses context, or contradicts itself.

**Cause:** One of:
1. Context window is full (too much history)
2. Effort level dropped to `low`
3. Wrong model selected
4. PRIMER.md missing or stale

**Fix:**
```
# 1. Free up context
/compact

# 2. Check effort
/effort high

# 3. Check model (Sonnet is default, change if needed)
/model claude-sonnet-4-6

# 4. Update your PRIMER.md with current info
/memory
```

If `/memory` shows stale project info, edit `~/.claude/PRIMER.md` with what you're currently working on. Claude uses it every session.

---

### Problem 10 — "I installed plugins but they don't show up"

**Symptom:**
```
/plugin
```
Shows plugins as "not installed" even though you ran `/plugin install`.

**Cause:** Plugins install per Claude Code version. If you updated Claude Code recently, plugins may need reinstall.

**Fix:**
```
# 1. See current plugin state
/plugin

# 2. Add marketplaces if missing
/plugin marketplace add https://github.com/anthropic-community/everything-claude-code
/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode

# 3. Install
/plugin install everything-claude-code
/plugin install oh-my-claudecode
/oh-my-claudecode:omc-setup

# 4. Verify
/healthcheck
```

After `/healthcheck`, line 1 should show `OMC Plugin: OK`.

---

## Bonus — when you want to start completely over

1. Delete everything:
   ```bash
   rm -rf ~/.claude
   rm -rf ~/.carl
   ```
   (On Windows Git Bash, use `/c/Users/you/.claude` etc.)

2. Restart Claude Code — it creates fresh defaults.

3. Run the Apex installer again:
   ```bash
   cd claude-apex
   bash install.sh
   ```

If you have a backup you want to preserve first:
```bash
cp -r ~/.claude ~/claude-backup-$(date +%Y%m%d)
```

---

## Problems the installer can't fix

### "My Claude account isn't working"
Go to https://claude.ai and sign in. If that works, log out and log back into Claude Code via `claude login`.

### "Anthropic API says I'm out of credits"
Go to https://console.anthropic.com — add credits or upgrade your plan.

### "WSL / Windows path mismatch"
WSL uses Linux paths (`/home/you/.claude`). Git Bash uses Windows-style paths via Unix prefix (`/c/Users/you/.claude`). Mixing them confuses scripts.

**Fix**: Pick ONE shell environment and stick to it. Don't run Apex install in Git Bash, then try to run hooks from WSL — they disagree on where `~/.claude` is.

### "Hook fires too slow / SessionStart takes 30+ seconds"
The hook is reading too many files. The V7 `session-start-check.sh` reads only 4 files. If yours reads more:
```bash
cd claude-apex
bash install.sh
```
Installer copies the optimized V7 version.

---

## When to ask for help

If after all this you're still stuck:

1. **Check repo issues**: https://github.com/YousefNabil-SOC/claude-apex/issues
2. **Open a new issue**: Include OS, Node version, Python version, and full `/healthcheck` output
3. **Check Anthropic docs**: https://docs.anthropic.com/en/docs/claude-code
4. **Ask Claude itself**: Many errors can be debugged by pasting the error into Claude Code and asking "what does this mean?"

## Essential commands to remember

| Command | What it does |
|---|---|
| `/healthcheck` | What's broken? (18-point Apex check) |
| `/doctor` | Claude Code built-in diagnostics |
| `/compact` | Free up context window |
| `/model` | See / change model |
| `/effort high` | Reset effort to safe default |
| `/mcp` | See MCP server status |
| `/plugin` | See plugin status |
| `/memory` | See Claude's memory |
| `/exit` | Clean session end |

## What You Learned

- `/healthcheck` is your first debugging tool — always run it.
- 90% of beginner problems fall into these 10 categories.
- The installer is idempotent — re-running `bash install.sh` fixes missing/outdated hooks.
- `~/.claude/.env` holds your API keys; placeholders look like `your_xxx_here`.
- If totally stuck, nuke `~/.claude` and `~/.carl`, then reinstall — takes 2 minutes.

## Most people quit at install. You didn't.

You're now in the small percentage of users with a fully working Apex environment. Build something.

## Next Step

- **[00-START-HERE.md](00-START-HERE.md)** — Back to the top
- **[03-FIRST-TIME-USING.md](03-FIRST-TIME-USING.md)** — Your first 10 commands

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
