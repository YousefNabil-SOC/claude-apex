# Automation Hooks

Hook scripts that Claude Code executes at specific lifecycle events.

| Hook | Event | Purpose |
|------|-------|---------|
| `post-compact-recovery.sh` | PostCompact | Re-reads capability registry after /compact |
| `session-end-save.sh` | Stop | Saves session state and updates handoff file |
| `task-complete-sound.sh` | Stop | Plays notification sound when session ends |
| `peers-auto-register.sh` | Session start | Auto-registers with Claude Peers broker |
| `carl-hook.py` | UserPromptSubmit | Loads CARL domain rules based on prompt content |

## How Hooks Work

Hooks are configured in `~/.claude/settings.json` under the `hooks` key. Each hook type fires at a specific event:

- **PostCompact**: After `/compact` clears context
- **Stop**: When a Claude Code session ends
- **Notification**: When a background task completes
- **UserPromptSubmit**: Before every user message is processed

## Adding Your Own Hook

1. Create a script in `~/.claude/hooks/`
2. Add the hook to `settings.json`:

```json
{
  "hooks": {
    "EventType": [{
      "matcher": "",
      "hooks": [{
        "type": "command",
        "command": "bash $HOME/.claude/hooks/your-hook.sh"
      }]
    }]
  }
}
```
