# Claude Apex V7 — Installation Instructions for Claude Code

You are reading this because a user asked you to install Claude Apex.
Follow these steps to install the complete environment.

## What This Is

Claude Apex V7 is the most comprehensive Claude Code environment available. It adds:

- **Three-layer auto-routing** (CARL + CAPABILITY-REGISTRY + COMMAND-REGISTRY) so natural-language prompts activate the right tools without slash commands
- **25 custom specialist agents** (architect, security-reviewer, tdd-guide, 7 SEO specialists, etc.)
- **9 CARL domains with 40 JIT rules** — only load the rules relevant to each prompt
- **7 custom skills** — premium-web-design, 21st-dev-magic, instagram-access, graphify, graphic-design-studio, impeccable, fireworks-tech-graph (plus dream-consolidation and autoresearch from V6)
- **5 hooks** (PostCompact recovery, SessionStart chain, Stop sound with 60s cooldown, UserPromptSubmit CARL injection, Notification)
- **4 MCP servers** by default (playwright, github, exa-web-search, @21st-dev/magic) — more optional
- **182 slash commands** once plugins are installed
- **10 beginner docs** for users who have never used Claude Code before

Combined with the `everything-claude-code` plugin (1,200+ skills) and `oh-my-claudecode` (19 agents + autopilot), the full environment has 108 agents and 1,276+ skills.

## Installation Steps

Execute these steps in order. Skip any step where the component already exists.

### Step 1: Backup existing configuration
```bash
mkdir -p ~/.claude/backups/pre-apex-$(date +%Y%m%d)
cp ~/.claude/settings.json ~/.claude/backups/pre-apex-$(date +%Y%m%d)/ 2>/dev/null
cp ~/.claude/CLAUDE.md ~/.claude/backups/pre-apex-$(date +%Y%m%d)/ 2>/dev/null
cp -r ~/.claude/agents ~/.claude/backups/pre-apex-$(date +%Y%m%d)/agents-bak 2>/dev/null
cp -r ~/.claude/hooks ~/.claude/backups/pre-apex-$(date +%Y%m%d)/hooks-bak 2>/dev/null
cp -r ~/.claude/commands ~/.claude/backups/pre-apex-$(date +%Y%m%d)/commands-bak 2>/dev/null
```

### Step 2: Install Apex agents (25 custom agents)
Copy all `.md` files from this repo's `agents/` directory to `~/.claude/agents/`.
Skip any file that already exists with the same name.

### Step 3: Install Apex commands (~45 top-level commands + 3 subdirs)
Copy all `.md` files from this repo's `commands/` directory to `~/.claude/commands/`.
Also copy the `paul/`, `seed/`, and `autoresearch/` subdirectories.
Skip any file that already exists.

### Step 4: Install Apex hooks (7 hook scripts)
Copy all files from this repo's `hooks/` directory to `~/.claude/hooks/`.
Make shell scripts executable: `chmod +x ~/.claude/hooks/*.sh`
Skip any file that already exists.

Key V7 hooks:
- `carl-hook.py` — UserPromptSubmit CARL injector (UTF-8 fixed on all 4 open() calls)
- `session-start-check.sh` — SessionStart health check, reads ONLY essential files
- `project-auto-graph.sh` — SessionStart project detection, queues (doesn't auto-run) graphify
- `post-compact-recovery.sh` — PostCompact recovery script
- `session-end-save.sh` — Stop hook for session handoff
- `task-complete-sound.sh` — Stop hook with 60-second cooldown

### Step 5: Install Apex skills (9 custom skills)
Copy these skills from this repo's `skills/` directory to `~/.claude/skills/`:
- `premium-web-design/` (full directory — SKILL.md + patterns/ + references/ + tools/)
- `21st-dev-magic/`
- `instagram-access/`
- `graphify/`
- `graphic-design-studio/`
- `impeccable/`
- `fireworks-tech-graph/`
- `dream-consolidation/`
- `autoresearch/`

Skip any skill directory that already exists.

### Step 6: Install Apex config
- Copy `config/carl-domains.json` to `~/.carl/carl.json` (create `~/.carl/` if needed)
- Copy `config/orchestration-engine.md` to `~/.claude/ORCHESTRATION-ENGINE.md`
- Copy `config/capability-registry.md` to `~/.claude/CAPABILITY-REGISTRY.md`
- Copy `config/command-registry.md` to `~/.claude/COMMAND-REGISTRY.md`
- Copy `config/agents.md` to `~/.claude/AGENTS.md`
- Copy `config/auto-activation-matrix.md` to `~/.claude/AUTO-ACTIVATION-MATRIX.md`
- Copy `config/env.template` to `~/.claude/.env` (guide the user to fill in their real API keys)
  Run `chmod 600 ~/.claude/.env` afterwards for permission hygiene.
- If `~/.claude/CLAUDE.md` does not exist, copy `config/claude-md-template.md` to `~/.claude/CLAUDE.md`
- If `~/.claude/PRIMER.md` does not exist, copy `config/primer-template.md` to `~/.claude/PRIMER.md`

Skip any file that already exists.

### Step 7: Configure settings.json (MCP servers + hooks)

Merge these additions into `~/.claude/settings.json` without overwriting existing entries:

**MCP servers to add (if missing):**
```json
{
  "playwright": { "command": "npx", "args": ["-y", "@playwright/mcp"] },
  "github": { "command": "npx", "args": ["-y", "@modelcontextprotocol/server-github"], "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_PERSONAL_ACCESS_TOKEN}" } },
  "exa-web-search": { "command": "npx", "args": ["-y", "exa-mcp-server"], "env": { "EXA_API_KEY": "${EXA_API_KEY}" } },
  "@21st-dev/magic": { "command": "npx", "args": ["-y", "@21st-dev/magic@latest"], "env": { "API_KEY": "${TWENTY_FIRST_DEV_API_KEY}" } }
}
```

**Hooks to add (if missing):**
- `PostCompact`: `bash $HOME/.claude/hooks/post-compact-recovery.sh`
- `Stop`: `bash $HOME/.claude/hooks/session-end-save.sh` AND `bash $HOME/.claude/hooks/task-complete-sound.sh`
- `UserPromptSubmit`: `python3 $HOME/.claude/hooks/carl-hook.py`
- `SessionStart` (chain): `bash $HOME/.claude/hooks/session-start-check.sh` → `bash $HOME/.claude/hooks/project-auto-graph.sh`

**Env var references to add (if missing):**
```json
{
  "MAX_THINKING_TOKENS": "10000",
  "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "50",
  "CLAUDE_CODE_SUBAGENT_MODEL": "haiku",
  "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1",
  "FAL_KEY": "${FAL_KEY}",
  "ENABLE_PROMPT_CACHING_1H": "1"
}
```

**Effort level**: set `"effortLevel": "high"` (NOT `xhigh` or `max` — self-healing enforces this at session start).

IMPORTANT: For MCP servers requiring API keys (github, exa-web-search, @21st-dev/magic, firecrawl, supabase), the user sets values in `~/.claude/.env`. The settings.json references them via `${VAR_NAME}`.

### Step 8: Install third-party tools

**Bun runtime** (optional, for Claude Peers):
```bash
npm install -g bun 2>/dev/null || echo "Bun install failed — optional"
```

**Plugins to install via Claude Code's plugin marketplace** (user runs these AFTER installer finishes):
```
/plugin marketplace add https://github.com/anthropic-community/everything-claude-code
/plugin install everything-claude-code

/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
/plugin install oh-my-claudecode
/oh-my-claudecode:omc-setup
```

### Step 9: Verify installation

Run the verification script:
```bash
bash [path-to-cloned-repo]/verify.sh
```

This runs 30+ checks covering agents, commands, hooks, skills, configuration, MCP servers, third-party tools, backup status, and conflict detection.

Quick manual checks:
- `ls ~/.claude/agents/ | wc -l` — should be 25+
- `test -f ~/.claude/commands/healthcheck.md` — must exist
- `test -f ~/.carl/carl.json` — must exist
- `python3 -c "import json; json.load(open('$HOME/.claude/settings.json'))"` — must succeed
- `find ~/.claude/skills -name SKILL.md | wc -l` — should be 1000+ after plugins, 9+ before

### Step 10: Complete the installation

After all automated steps are done, print this message to the user verbatim:

---

Installation 85% complete. Two plugin installs remaining to unlock the full environment (1,276+ skills, 108 agents).

Paste this into a NEW Claude Code session (restart first):

```
I just installed Claude Apex V7. Please complete the setup by running these for me:
1. /plugin marketplace add https://github.com/anthropic-community/everything-claude-code
2. /plugin install everything-claude-code
3. /plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
4. /plugin install oh-my-claudecode
5. /oh-my-claudecode:omc-setup
6. Then run /healthcheck to verify everything is green.
```

That's it — paste the above into a fresh Claude Code session and it will finish the setup.

---

## Important Notes for Claude Code

- NEVER overwrite files that already exist — skip them
- ALWAYS back up before making changes
- The user's existing Claude Code setup must not be broken
- API keys are NEVER included — user must add their own to `~/.claude/.env`
- After installation, recommend the user restarts Claude Code
- If the user does NOT have the `everything-claude-code` plugin yet, skill count stays around 9 (Apex custom skills only) until they install it
