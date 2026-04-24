# What Are Hooks?

## The kid-friendly analogy

**Hooks are like automatic reflexes Claude has.**

You don't tell your hand to pull back when you touch something hot. It just happens. A reflex.

Hooks are reflexes for Claude. When something happens (session starts, prompt submitted, session ends), a script fires automatically to do a useful thing.

## What hooks look like

A hook is a little shell script or Python script at `~/.claude/hooks/`. Claude Code runs it when the trigger event fires.

**Simplest possible hook — plays a sound when Claude finishes a task:**
```bash
#!/bin/bash
# task-complete-sound.sh
powershell.exe -c "[System.Media.SystemSounds]::Asterisk.Play()"
```

That's it. 2 lines. Every time Claude finishes ("Stop" event), your computer chimes.

## The hook events Claude Code supports

| Event | When it fires | Example use |
|---|---|---|
| **UserPromptSubmit** | Every time you press Enter after typing | Inject rules (this is how CARL works) |
| **SessionStart** | When you open `claude` | Print a health check, load context |
| **Stop** | When Claude finishes responding | Play a sound, save a session summary |
| **PostCompact** | After `/compact` compresses the conversation | Remind Claude to re-read CAPABILITY-REGISTRY |
| **Notification** | When Claude needs your attention | Pop a notification, log it |
| **PreToolUse** / **PostToolUse** | Before/after Claude uses a tool | Validate or log tool calls |

## Apex's 7 hooks (the fixed V7 versions)

### 1. `carl-hook.py` (UserPromptSubmit)
**When it fires:** Every time you press Enter.
**What it does:** Matches keywords in your prompt to the 9 CARL domains and injects matching rules into Claude's context before it responds. Has the UTF-8 encoding fix on all 4 `open()` calls so non-Latin file content doesn't corrupt.

### 2. `session-start-check.sh` (SessionStart)
**When it fires:** When you open `claude`.
**What it does:** Reads ONLY the 4 essential files at startup (CLAUDE.md, PRIMER.md, CAPABILITY-REGISTRY.md, AGENTS.md) plus memory markers. Previously read everything, which was slow; the V7 version is optimized.

### 3. `project-auto-graph.sh` (SessionStart)
**When it fires:** When you open `claude`, chained after session-start-check.
**What it does:** Detects if your current folder is a new project without a knowledge graph. If so, queues it and tells you to run `graphify .` when ready. Never auto-runs (protects your token budget).

### 4. `post-compact-recovery.sh` (PostCompact)
**When it fires:** After `/compact` or autocompact compresses your conversation.
**What it does:** Prints a reminder to Claude to re-read CAPABILITY-REGISTRY.md and PRIMER.md, so it doesn't forget what tools exist after compression.

### 5. `session-end-save.sh` (Stop)
**When it fires:** When Claude finishes responding and you exit, or on any Stop event.
**What it does:** Appends a session-end timestamp to `memory/session-handoff.md`. Keeps the last 50 lines only so the file doesn't grow forever.

### 6. `task-complete-sound.sh` (Stop)
**When it fires:** Stop event, same as above, chained after session-end-save.
**What it does:** Plays a chime. Has a **60-second cooldown** so it doesn't spam during fast back-and-forth exchanges.

### 7. `peers-auto-register.sh.disabled` (SessionStart, optional)
**When it fires:** If enabled, on SessionStart.
**What it does:** Registers this terminal with the Claude Peers MCP broker for inter-terminal communication. Disabled by default — rename to `.sh` (remove `.disabled`) to activate.

## How hooks are wired up

Hooks are registered in `~/.claude/settings.json`. The V7 chain:

```json
"hooks": {
  "UserPromptSubmit": [{
    "hooks": [
      { "type": "command", "command": "python3 $HOME/.claude/hooks/carl-hook.py" }
    ]
  }],
  "SessionStart": [{
    "matcher": "",
    "hooks": [
      { "type": "command", "command": "bash $HOME/.claude/hooks/session-start-check.sh" },
      { "type": "command", "command": "bash $HOME/.claude/hooks/project-auto-graph.sh" }
    ]
  }],
  "Stop": [{
    "matcher": "",
    "hooks": [
      { "type": "command", "command": "bash $HOME/.claude/hooks/session-end-save.sh" },
      { "type": "command", "command": "bash $HOME/.claude/hooks/task-complete-sound.sh" }
    ]
  }],
  "PostCompact": [{
    "matcher": "",
    "hooks": [
      { "type": "command", "command": "bash $HOME/.claude/hooks/post-compact-recovery.sh" }
    ]
  }]
}
```

Two SessionStart hooks fire in order (check first, then auto-graph). Two Stop hooks fire in order (save first, then chime).

## Writing your own hook

Say you want Claude to log every prompt submission. Create `~/.claude/hooks/log-all.sh`:

```bash
#!/bin/bash
echo "[$(date)] User prompt submitted" >> ~/claude-log.txt
```

Make it executable:
```bash
chmod +x ~/.claude/hooks/log-all.sh
```

Register it in `~/.claude/settings.json`:
```json
"UserPromptSubmit": [{
  "hooks": [
    { "type": "command", "command": "python3 $HOME/.claude/hooks/carl-hook.py" },
    { "type": "command", "command": "bash $HOME/.claude/hooks/log-all.sh" }
  ]
}]
```

Done. Every prompt submission now appends a line to your log.

## Common hook use cases

- **Inject context** — auto-load rules (CARL's purpose)
- **Notify** — sound, pop-up, Slack message on task complete
- **Log** — track commands, token usage, tool calls
- **Validate** — block dangerous commands before they run (PreToolUse)
- **Sync** — auto-commit changes after edits
- **Health check** — verify environment at session start

## Example — what a full SessionStart chain prints

When you run `claude` in an Apex-installed environment:

```
[SessionStart hook 1/2: session-start-check.sh]
=== SESSION START HEALTH CHECK ===
OK: CLAUDE.md (95 lines)
OK: PRIMER.md (68 lines)
OK: CAPABILITY-REGISTRY.md (212 lines)
OK: AGENTS.md (168 lines)
OK: memory/session-handoff.md
OK: memory/decisions.md
OK: memory/learning-log.md
=== END HEALTH CHECK ===

[SessionStart hook 2/2: project-auto-graph.sh]
GRAPH: Known project detected. Graph exists at graphify-out/graph.json.
       Token cost for navigation queries: ~1,000 per query.

Claude Code v2.1.80 — Apex V7 loaded.
```

## Gotchas

- **Hooks run on your real system.** Bugs cause real damage. Test carefully.
- **Hooks have a timeout** (usually 30 seconds). Long-running hooks get killed.
- **Windows path quirks**: use literal paths (`$HOME/.claude/...`) or `C:/Users/you/...`, not `~/...` in hook commands. Claude Code doesn't always expand `~`.
- **Syntax errors in a hook can block your terminal.** Keep a backup of settings.json before editing.
- **The 60-second cooldown** in `task-complete-sound.sh` prevents sound spam — don't remove it.
- **The UTF-8 fix** in `carl-hook.py` is on all 4 `open()` calls. If you edit the hook, keep it.

## Checking hook status

Run `/healthcheck` in Claude Code. Look for lines like:
```
 6  | UserPromptSubmit    | OK     | carl-hook.py (UTF-8 fixed)
 7  | SessionStart        | OK     | session-start-check + auto-graph
 8  | PostCompact Hook    | OK     | V7 recovery verified
 9  | Sound Notification  | OK     | 60s cooldown configured
```

If any show FAIL, the hook isn't running. Go to **[10-TROUBLESHOOT-FOR-BEGINNERS.md](10-TROUBLESHOOT-FOR-BEGINNERS.md)**.

## What You Learned

- Hooks are scripts that fire on Claude Code events (SessionStart, UserPromptSubmit, Stop, PostCompact, Notification).
- Apex ships 7 hooks, each solving a specific problem (CARL injection, sound cooldown, session handoff, etc.).
- SessionStart and Stop events can chain multiple hooks in order.
- Hooks are just scripts in `~/.claude/hooks/`, wired up in `settings.json`.
- Two V7 fixes matter: UTF-8 on carl-hook.py's 4 file opens, and 60s cooldown on task-complete-sound.sh.

## Next Step

- **[08-WHAT-IS-CARL.md](08-WHAT-IS-CARL.md)** — CARL is the most important hook. It injects the right rules at the right time.

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
