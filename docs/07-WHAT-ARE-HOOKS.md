# What Are Hooks?

## The kid-friendly analogy

**Hooks are like automatic reflexes Claude has.**

You don't tell your hand to pull back when you touch something hot. It just happens. A reflex.

Hooks are reflexes for Claude. When something happens (like a session starts, or Claude finishes a task), a script fires automatically to do a useful thing.

## What hooks look like

A hook is a little shell script or Python script stored at `~/.claude/hooks/`. Claude Code runs it when a trigger fires.

Example hook — plays a sound when Claude finishes a task:
```bash
#!/bin/bash
# task-complete-sound.sh
powershell.exe -c "[System.Media.SystemSounds]::Asterisk.Play()"
```

That's it. 2 lines. Every time Claude finishes ("Stop" event), your computer chimes.

## The 5 hook events in Claude Code

| Event | When it fires | Example use |
|---|---|---|
| **UserPromptSubmit** | Every time you press Enter after typing | Inject rules (this is how CARL works) |
| **SessionStart** | When you open `claude` | Print a health check, load context |
| **Stop** | When Claude finishes responding | Play a sound, save a summary |
| **PostCompact** | After `/compact` compresses the conversation | Remind Claude to re-read CAPABILITY-REGISTRY |
| **Notification** | When Claude needs your attention | Pop a notification, log to a file |
| **PreToolUse** / **PostToolUse** | Before/after Claude uses a tool | Validate tool calls, log them |

## Apex's 7 hooks (the fixed V7 versions)

1. **carl-hook.py** (UserPromptSubmit) — injects CARL domain rules before Claude responds. Has the UTF-8 encoding fix on all 4 `open()` calls, so non-Latin file content doesn't corrupt.

2. **session-start-check.sh** (SessionStart) — reads ONLY the 4 essential files at startup (CLAUDE.md, PRIMER.md, CAPABILITY-REGISTRY.md, AGENTS.md) + memory files. Previously read everything; now optimized.

3. **project-auto-graph.sh** (SessionStart) — detects if your current folder is a new project without a knowledge graph. If so, queues it and tells you to run `graphify .` when ready. Never auto-runs (protects your token budget).

4. **post-compact-recovery.sh** (PostCompact) — after `/compact` compresses the conversation, prints a reminder to Claude to re-read the CAPABILITY-REGISTRY so it doesn't forget what tools exist.

5. **session-end-save.sh** (Stop) — appends a session-end timestamp to `memory/session-handoff.md`. Keeps the last 50 lines only so it doesn't grow forever.

6. **task-complete-sound.sh** (Stop) — chimes when Claude is done. Has a 60-second cooldown so it doesn't spam during fast back-and-forth exchanges.

7. **peers-auto-register.sh.disabled** — disabled by default. Used to register this terminal with the Claude Peers MCP broker. Re-enable if you want inter-terminal communication.

## How hooks are wired up

Hooks are registered in `~/.claude/settings.json`. The relevant section:

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
  }]
}
```

When Claude sees a UserPromptSubmit, it runs `carl-hook.py`. When a session starts, it runs both SessionStart hooks in order.

## Writing your own hook

Say you want Claude to write to a log every time you run a command. Create `~/.claude/hooks/log-all.sh`:

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
    { "type": "command", "command": "bash $HOME/.claude/hooks/log-all.sh" }
  ]
}]
```

Done. Every time you submit a prompt, your log file grows.

## Common hook use cases

- **Inject context** — auto-load rules (CARL's purpose)
- **Notify** — sound, pop-up, Slack message on task complete
- **Log** — track commands, token usage, tool calls
- **Validate** — block dangerous commands before they run (PreToolUse)
- **Sync** — commit changes automatically after edits
- **Health check** — verify environment at session start

## Gotchas

- Hooks run on your real system. Bugs = real damage. Test carefully.
- Hooks have a timeout (usually 30 seconds). Long-running hooks get killed.
- Windows path quirks: use literal paths (`C:/Users/you/...`) not `~/...` in hook commands. Claude Code doesn't always expand `~`.
- Syntax errors in a hook can block your terminal. Keep a backup.

## What's next

- [08-WHAT-IS-CARL.md](08-WHAT-IS-CARL.md) — CARL is the most important hook. It injects the right rules into Claude's context at the right time.
