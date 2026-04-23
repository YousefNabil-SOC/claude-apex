# First Time Using Claude Apex

> You installed everything. Now what do you actually do?

## Starting Claude Code

Open your terminal. Type:

```bash
claude
```

You'll see a big welcome banner, then a `>` prompt. This is where you talk to Claude.

## Your first 10 things to try

### 1. Say hi

Just type:
```
hi
```

Press Enter. Claude will greet you.

### 2. Ask a question

```
what version of node do i have installed?
```

Claude will run `node --version` and tell you. Notice it ran a real command on your computer.

### 3. Run the health check

```
/healthcheck
```

The `/` means "run a command". `/healthcheck` shows you which systems in Apex are working. You should see about 18 green checkmarks.

### 4. See what agents are available

```
/agents
```

Lists all specialists Claude has to delegate work to.

### 5. See what slash commands exist

```
/help
```

Shows all available slash commands. There are about 200 once everything is installed.

### 6. Try natural language (the fun one)

Apex's three-layer routing means you don't need slash commands for most things. Try:

```
can you help me create a simple hello-world website?
```

Claude will:
- Detect this is a web dev task (Layer 1: CARL activates WEB-DEVELOPMENT rules)
- Look up what skills and MCP servers apply (Layer 2: CAPABILITY-REGISTRY)
- Decide which commands to invoke (Layer 3: COMMAND-REGISTRY)
- Do the work

You never typed a single `/command`. The system figured it out.

### 7. Ask about your own code

If you have a code project, `cd` into it first, then start `claude`. Then ask:

```
what does this project do?
```

Claude reads your files and explains. It's great for exploring unfamiliar codebases.

### 8. Fix a bug

```
there's a bug in src/auth.ts where login always fails, can you find and fix it?
```

Claude reads the file, figures out the bug, fixes it, runs tests to verify. If tests aren't already set up, it might ask.

### 9. Try autopilot mode (OMC)

```
autopilot: add a dark mode toggle to this website
```

This triggers the full OMC autopilot pipeline: research → plan → execute → QA → validate. Claude will spin up multiple agents working in parallel.

### 10. End the session cleanly

Type:
```
/compact
```

This compresses your conversation (saves context for later). Then when you're ready to close:

```
/exit
```

## What NOT to do

- **Don't paste passwords or API keys directly into chat**. Put them in `~/.claude/.env` instead.
- **Don't skip the verification step**. `/healthcheck` tells you if something is broken.
- **Don't run `autopilot:` on unfamiliar code without a git backup**. It's powerful but it WILL make changes.
- **Don't set effort to `max` casually**. Max mode burns tokens. `high` is usually enough.

## Slash commands that save you time

| Command | What it does |
|---|---|
| `/healthcheck` | Verify all systems green |
| `/plan` | Start a structured plan before coding |
| `/feature-dev` | Full feature dev workflow |
| `/commit` | Smart git commit |
| `/review` | Code review with specialist agents |
| `/security-review` | Security audit |
| `/paul:plan` → `/paul:apply` → `/paul:unify` | Multi-phase execution |
| `/seed` | Brainstorm a new project from scratch |
| `/graphify` | Build a knowledge graph of your project |
| `/compact` | Compress conversation to save context |
| `/resume` | Pick up a past session |
| `/memory` | See what Claude remembers about you |

## Natural-language triggers

These activate automatically — no slash command needed:

- "build me a ..."
- "fix the bug in ..."
- "review this code"
- "research this company"
- "create a pdf / pptx / docx"
- "where is the auth code?"
- "what did we do last session?"
- "deploy this to production"
- "optimize this for speed"

## Tips from power users

1. **`cd` into the right directory first**. If your project is in `~/my-webapp`, `cd` there before running `claude`. Claude sees the folder you started in.

2. **Edit your CLAUDE.md**. After install, open `~/.claude/CLAUDE.md` and add your preferences. Claude reads it every session.

3. **Edit your PRIMER.md**. Describe who you are, what projects you work on. Helps Claude tailor answers to you.

4. **Use `/memory` after big tasks**. Claude will save context for next session.

5. **When stuck, run `/healthcheck`**. 90% of problems show up here.

## What's next

- [04-WHAT-ARE-SKILLS.md](04-WHAT-ARE-SKILLS.md) — Understand skills (the 1,276 recipes Claude reads on demand)
- [05-WHAT-ARE-AGENTS.md](05-WHAT-ARE-AGENTS.md) — Understand agents (the 108 specialists)

You're now officially using Apex. Welcome.
