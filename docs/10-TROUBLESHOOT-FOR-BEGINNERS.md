# Troubleshoot for Beginners

> When something breaks. Step-by-step fixes with no jargon.

## First step always: run `/healthcheck`

Open Claude Code and type:
```
/healthcheck
```

Anything that shows `FAIL` tells you exactly what's broken. Fix that first.

## Common problems and fixes

### "command not found: claude"

You haven't installed Claude Code, or your terminal can't find it.

**Fix**:
```bash
npm install -g @anthropic-ai/claude-code
```

If that gives a permission error on Mac/Linux:
```bash
sudo npm install -g @anthropic-ai/claude-code
```

Then close your terminal and open a new one. Try `claude --version`.

### "command not found: node" or "node: not recognized"

You haven't installed Node.js.

**Fix**: Go to https://nodejs.org, download the LTS version, install it. Close terminal, reopen, try `node --version`.

### "/healthcheck fails on CARL"

CARL hook isn't loading.

**Fix**:
1. Check the file exists: `ls ~/.claude/hooks/carl-hook.py`
2. Check it's executable: `chmod +x ~/.claude/hooks/carl-hook.py`
3. Check Python is installed: `python3 --version`
4. Check `settings.json` has the hook:
   ```json
   "UserPromptSubmit": [{
     "hooks": [{ "type": "command", "command": "python3 $HOME/.claude/hooks/carl-hook.py" }]
   }]
   ```
5. Restart Claude Code.

### "settings.json is corrupt"

You accidentally saved an invalid JSON file.

**Fix**:
1. Validate it: `python3 -c "import json; json.load(open('$HOME/.claude/settings.json'))"`
2. If it errors, it shows you the line. Fix that line.
3. If you can't figure it out, restore from backup: `~/.claude/backups/pre-apex-<date>/settings.json`

### "MCP servers not connecting"

Usually API key is missing or wrong.

**Fix**:
1. Check `~/.claude/.env` exists
2. Check the key for the failing MCP server is filled in (not `your_key_here`)
3. Check the key is valid (try it against the service's API directly)
4. Restart Claude Code

### "sounds keep firing every 2 seconds"

Cooldown not working.

**Fix**: Your `task-complete-sound.sh` is the old version without the 60-second cooldown. Re-run the installer — the V7 hook has cooldown built in.

### "Arabic text shows as garbled characters"

UTF-8 encoding bug.

**Fix**: Your `carl-hook.py` is the old version missing the UTF-8 fix. Re-run the installer. The V7 hook has the fix on all 4 `open()` calls.

### "Claude seems dumb today"

Several possible causes:

1. **effort level too low**: Type `/effort high` (never `max` unless you really need it)
2. **Context is full**: Type `/compact` to compress
3. **Wrong model**: Type `/model` to see/change
4. **Missing context**: Update `~/.claude/PRIMER.md` with your info

### "I installed plugins but they don't show up"

Plugins install per Claude Code version. If you updated Claude Code recently, plugins might need reinstall.

**Fix**:
```
/plugin
```

See which plugins are enabled. If missing, reinstall:
```
/plugin install <name>
```

### "I broke everything"

Every Apex installer makes a backup.

**Fix**:
```bash
cd claude-apex
bash uninstall.sh
```

This restores `~/.claude/settings.json` and `~/.claude/CLAUDE.md` from the most recent backup.

### "I want to start completely over"

1. Delete everything:
   ```bash
   rm -rf ~/.claude
   rm -rf ~/.carl
   ```
   (On Windows Git Bash, use `/c/Users/you/.claude` etc.)

2. Restart Claude Code — it creates fresh defaults.

3. Run the Apex installer again.

## Problems the installer can't fix

### "My Claude account isn't working"

Go to https://claude.ai and sign in. If that works, log out and log in to Claude Code via `claude login`.

### "Anthropic API says I'm out of credits"

Go to https://console.anthropic.com, add credits or upgrade your plan.

### "WSL / Windows path mismatch"

WSL uses Linux paths (`/home/you/.claude`). Git Bash uses Windows-style paths via Unix prefix (`/c/Users/you/.claude`). Mixing them can confuse scripts.

**Fix**: Pick ONE shell environment and stick to it. Don't run Apex install in Git Bash, then try to run hooks from WSL — they disagree on where `~/.claude` is.

### "Hook fires too slow"

SessionStart takes > 30 seconds?

**Fix**: The hook is reading too many files. Check `~/.claude/hooks/session-start-check.sh` — the V7 version reads only 4 files. If yours reads more, re-run the installer.

## When to ask for help

If after all this you're still stuck:

1. **Check the repo issues**: https://github.com/YousefNabil-SOC/claude-apex/issues — someone may have reported the same thing
2. **Open a new issue**: Include your OS, Node version, Python version, and the full `/healthcheck` output
3. **Check Anthropic docs**: https://docs.anthropic.com/en/docs/claude-code
4. **Ask Claude itself**: Many errors can be debugged by pasting the error into Claude Code and saying "what does this mean?"

## Essential commands to remember

- `/healthcheck` — what's broken?
- `/doctor` — Claude Code built-in diagnostics
- `/compact` — free up context
- `/model` — change model
- `/effort high` — reset effort to safe default
- `/mcp` — see MCP server status
- `/plugin` — see plugin status
- `/memory` — see Claude's memory

## You made it this far

Most people quit at install. You didn't. You're now in a tiny percentage of users who have a fully working Apex environment. Build something.

Go back to: **[00-START-HERE.md](00-START-HERE.md)** | Or explore any other doc.
