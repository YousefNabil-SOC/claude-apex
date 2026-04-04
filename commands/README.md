# Custom Slash Commands

Place `.md` files in `~/.claude/commands/` to create slash commands.

| Command | Description |
|---------|-------------|
| `/healthcheck` | Verify all Apex systems are operational (15 checks) |
| `/switch-project` | Instant context switching between projects |
| `/templates` | Pre-built task workflows for recurring work |

## Creating Your Own

```yaml
---
name: my-command
description: What this command does
argument-hint: "[optional-arg]"
---

# Instructions for Claude Code when this command runs
```
