---
name: healthcheck
description: Verify all V6 systems are operational. Run at session start or when things feel broken.
---

# System Health Check V6

Run these checks and report results in a table:

IMPORTANT: Use `$HOME` (not `~`) in ALL path checks to avoid Windows/MSYS2 path resolution issues.

1. **OMC Plugin**: Check if oh-my-claudecode is in enabledPlugins in $HOME/.claude/settings.json
2. **Claude Peers**: Run `curl -s http://localhost:7899/health` — should return ok
3. **PAUL Framework**: Check if $HOME/.claude/commands/paul/ directory exists with .md files
4. **Dream Skill**: Check if $HOME/.claude/skills/dream-consolidation/SKILL.md exists
5. **CARL**: Check if $HOME/.carl/carl.json exists and has domains configured
6. **Autoresearch**: Check if $HOME/.claude/skills/autoresearch/SKILL.md exists
7. **SEED**: Check if $HOME/.claude/commands/seed.md exists
8. **PostCompact Hook**: Check $HOME/.claude/hooks/post-compact-recovery.sh exists and contains "V6"
9. **Sound Notification**: Check if $HOME/.claude/hooks/task-complete-sound.sh exists
10. **Peers Auto-Register**: Check if $HOME/.claude/hooks/peers-auto-register.sh exists and is executable
11. **Settings JSON**: Run `python3 -c "import json,os; json.load(open(os.path.expanduser('~/.claude/settings.json'))); print('VALID')"` to validate
12. **MCP Servers**: Count mcpServers keys in settings.json
13. **Skills Count**: Count SKILL.md files recursively in $HOME/.claude/skills/
14. **Agents Count**: Count .md files in $HOME/.claude/agents/
15. **Memory Health**: Count lines in the project's MEMORY.md (should be under 200)

Present results as:

| # | System | Status | Details |
|---|--------|--------|---------|
| 1 | OMC Plugin | OK/FAIL | version if available |
| 2 | Claude Peers | OK/FAIL | broker response |
| ... | ... | ... | ... |

After the table:
- Count total OK vs FAIL
- If any system shows FAIL, suggest a specific fix
- Show environment totals: skills, agents, MCP servers, plugins, PAUL commands, CARL domains
