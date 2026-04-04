# Claude Pantheon V6 — Installation Instructions for Claude Code

You are reading this because a user asked you to install Claude Pantheon.
Follow these steps to install the complete environment.

## What This Is
Claude Pantheon is a comprehensive Claude Code environment with 1,308 skills,
108 agents, 12 MCP servers, 7 CARL domains, structured execution (PAUL),
multi-agent orchestration (OMC), inter-terminal communication (Claude Peers),
and memory consolidation (Dream). It is the most complete Claude Code
environment available.

## Installation Steps

Execute these steps in order. Skip any step where the component already exists.

### Step 1: Backup existing configuration
```bash
mkdir -p ~/.claude/backups/pre-pantheon-$(date +%Y%m%d)
cp ~/.claude/settings.json ~/.claude/backups/pre-pantheon-$(date +%Y%m%d)/ 2>/dev/null
cp ~/.claude/CLAUDE.md ~/.claude/backups/pre-pantheon-$(date +%Y%m%d)/ 2>/dev/null
cp -r ~/.claude/agents/ ~/.claude/backups/pre-pantheon-$(date +%Y%m%d)/agents-bak/ 2>/dev/null
cp -r ~/.claude/hooks/ ~/.claude/backups/pre-pantheon-$(date +%Y%m%d)/hooks-bak/ 2>/dev/null
```

### Step 2: Install Pantheon agents (25 custom agents)
Copy all .md files from this repo's agents/ directory to ~/.claude/agents/
Skip any file that already exists with the same name.

### Step 3: Install Pantheon commands
Copy all .md files from this repo's commands/ directory to ~/.claude/commands/
Skip any file that already exists.

### Step 4: Install Pantheon hooks
Copy all files from this repo's hooks/ directory to ~/.claude/hooks/
Make them executable: chmod +x ~/.claude/hooks/*.sh
Skip any file that already exists.

### Step 5: Install Pantheon skills
Copy skills/dream-consolidation/ to ~/.claude/skills/dream-consolidation/
Copy skills/autoresearch/ to ~/.claude/skills/autoresearch/
Skip if they already exist.

### Step 6: Install Pantheon config
Copy config/carl-domains.json to ~/.carl/carl.json (create ~/.carl/ if needed)
Copy config/orchestration-engine.md to ~/.claude/ORCHESTRATION-ENGINE.md
Copy config/capability-registry.md to ~/.claude/CAPABILITY-REGISTRY.md
Skip any file that already exists.

### Step 7: Install third-party plugins and tools

7a. Install Bun runtime (needed for Claude Peers):
```bash
npm install -g bun 2>/dev/null || echo "Bun install failed — Claude Peers will have limited functionality"
```

7b. Install everything-claude-code plugin (brings ~1,000+ skills):
Tell the user to run these commands in a NEW Claude Code session:
```
/plugin marketplace add https://github.com/anthropic-community/everything-claude-code
/plugin install everything-claude-code
```

7c. Install oh-my-claudecode (OMC) plugin:
Tell the user to run in Claude Code:
```
/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
/plugin install oh-my-claudecode
```
Then run: /oh-my-claudecode:omc-setup

7d. Install PAUL framework:
```bash
npx paul-framework --global 2>/dev/null || echo "PAUL install needs manual intervention"
```

7e. Install SEED incubator:
```bash
npm install -g @chrisai/seed 2>/dev/null || echo "SEED install needs manual intervention"
```

7f. Clone Claude Peers MCP:
```bash
if [ ! -d "$HOME/claude-peers-mcp" ]; then
  git clone https://github.com/louislva/claude-peers-mcp.git ~/claude-peers-mcp
  cd ~/claude-peers-mcp && bun install 2>/dev/null
fi
```

### Step 8: Configure MCP servers in settings.json

Read the user's current ~/.claude/settings.json.
Add these MCP servers if they don't already exist in the mcpServers section:

```json
{
  "context7": {
    "command": "npx",
    "args": ["-y", "@context7/mcp-server"]
  },
  "exa-web-search": {
    "command": "npx",
    "args": ["-y", "exa-mcp-server"],
    "env": {
      "EXA_API_KEY": "USER_MUST_SET_THIS"
    }
  },
  "playwright": {
    "command": "npx",
    "args": ["-y", "@playwright/mcp"]
  },
  "github": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-github"],
    "env": {
      "GITHUB_PERSONAL_ACCESS_TOKEN": "USER_MUST_SET_THIS"
    }
  },
  "memory": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-memory"]
  },
  "sequential-thinking": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
  },
  "filesystem": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-filesystem", "$HOME/Desktop"]
  },
  "claude-peers": {
    "command": "bun",
    "args": ["run", "$HOME/claude-peers-mcp/server.ts"]
  }
}
```

IMPORTANT: Do NOT overwrite existing MCP server entries. Only ADD missing ones.
IMPORTANT: For servers requiring API keys (exa, github, firecrawl, supabase),
set the value to "USER_MUST_SET_THIS" and tell the user they need to add their own keys.

### Step 9: Add Pantheon section to CLAUDE.md

If ~/.claude/CLAUDE.md exists and does NOT contain "Pantheon", append
the Pantheon configuration section from this repo's config/claude-md-template.md.

If ~/.claude/CLAUDE.md does not exist, copy config/claude-md-template.md as the starting point.

### Step 10: Configure hooks in settings.json

Add these hooks to the user's settings.json if they don't already exist:

PostCompact hook: bash ~/.claude/hooks/post-compact-recovery.sh
Stop hook: bash ~/.claude/hooks/session-end-save.sh
Stop hook: bash ~/.claude/hooks/task-complete-sound.sh
UserPromptSubmit hook: python3 ~/.claude/hooks/carl-hook.py

### Step 11: Verify installation

Run the healthcheck logic:
- Check if agents exist in ~/.claude/agents/
- Check if commands exist in ~/.claude/commands/
- Check if hooks exist in ~/.claude/hooks/
- Check if skills exist in ~/.claude/skills/
- Check if CARL config exists at ~/.carl/carl.json
- Check if settings.json is valid JSON
- Count total skills, agents, MCP servers

Report the results to the user.

### Step 12: Tell the user what to do next

Print:
"Claude Pantheon installed successfully!

To complete the installation:
1. Restart Claude Code (close and reopen)
2. Run /healthcheck to verify all systems
3. For the full 1,308 skill experience, run in Claude Code:
   /plugin marketplace add https://github.com/anthropic-community/everything-claude-code
   /plugin install everything-claude-code
4. For OMC multi-agent orchestration, run in Claude Code:
   /plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
   /plugin install oh-my-claudecode

Your backup is at: ~/.claude/backups/pre-pantheon-[date]/
To uninstall: bash [repo-path]/uninstall.sh"

## Important Notes for Claude Code
- NEVER overwrite files that already exist — skip them
- ALWAYS back up before making changes
- The user's existing Claude Code setup must not be broken
- API keys are NEVER included — user must add their own
- After installation, recommend the user restarts Claude Code
