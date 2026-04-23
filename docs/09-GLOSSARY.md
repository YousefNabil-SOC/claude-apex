# Glossary

> Every term you'll encounter in Claude Apex, defined in one line.

## A

**Agent** — An AI specialist Claude can delegate work to. Each has a specific role (architect, security reviewer, etc.).

**Anthropic** — The AI safety company that makes Claude. Based in San Francisco. https://anthropic.com

**API key** — A secret string that authenticates you to a third-party service (GitHub, Exa, fal.ai, etc.).

**Apex** — This repository. An enterprise-grade upgrade pack for Claude Code.

**Autopilot** — OMC's fully autonomous mode: expansion → plan → execute → QA → validate, all without human input.

**Autoresearch** — An execution mode for measurable optimization loops (modify → measure → keep/discard → repeat).

## B

**Bash** — A shell (terminal language) used on Mac and Linux. Also available on Windows via Git Bash.

**Bun** — A fast JavaScript runtime, sometimes used as an alternative to Node.js for Claude Peers.

## C

**CARL** — Context Augmentation & Reinforcement Layer. A hook that injects domain-specific rules into Claude's context based on prompt keywords.

**CLAUDE.md** — A configuration file Claude reads at session start. Lives in `~/.claude/` (global) or in a project folder (project-specific).

**claude-flow** — See "RuFlo".

**Claude** — The AI model made by Anthropic. Versions include Opus (smartest), Sonnet (balanced), Haiku (fast).

**Claude Code** — The CLI program that lets you talk to Claude from your terminal. Can read your files and run commands.

**Claude Peers** — An optional MCP server that lets multiple Claude Code terminals discover each other and exchange messages.

**CLI** — Command-Line Interface. A text-based program you interact with by typing commands.

**compact** (`/compact`) — A command that compresses your conversation to save context window space.

**context window** — The total amount of text Claude can consider at once. When it fills up, `/compact` helps.

**CAPABILITY-REGISTRY.md** — Apex's tool routing table. Maps task patterns to the skills/MCP/agents that handle them.

**COMMAND-REGISTRY.md** — Apex's command index. Maps user intent keywords to the right slash commands (182 total).

## D

**devmode** — A CARL setting that makes Claude append debug blocks to every response.

**Dream** — A memory consolidation skill that runs 4-phase memory cleanup ("consolidate memory").

## E

**effortLevel** — Claude Code setting controlling reasoning depth. Apex defaults to `high`. Don't use `xhigh` or `max` casually (burns tokens).

**env template** — `config/env.template` lists every API key name Apex uses. Copy to `~/.claude/.env` and fill in.

**everything-claude-code** — A plugin that ships 1,000+ community skills. Install via `/plugin install`.

## F

**fal.ai** — An image generation service. Requires `FAL_KEY` in .env.

## G

**Git** — Version control system. Required to clone this repo.

**GitHub** — The code hosting site where this repo lives. Requires `GITHUB_PERSONAL_ACCESS_TOKEN` for the GitHub MCP.

**Graphify** — An Apex skill that builds knowledge graphs of your project, saving ~90% of file-reading tokens.

## H

**Haiku** — Claude's fastest, cheapest model. Used for quick lookups, exploration, writing.

**Health check** (`/healthcheck`) — Apex's 18-point system verification.

**Hook** — A script that fires automatically on events (SessionStart, UserPromptSubmit, Stop, etc.).

## J

**JIT** — Just-In-Time. CARL loads rules JIT so only relevant rules sit in context.

## L

**LLM** — Large Language Model. The underlying tech behind Claude.

## M

**MCP** — Model Context Protocol. An open standard by Anthropic for AI tool integration.

**MCP server** — A program that provides tools to Claude via the MCP protocol (playwright, github, exa-web-search, etc.).

**MEMORY.md** — A file where Claude persists notes between sessions.

## N

**Node.js** — JavaScript runtime. Required to run Claude Code.

**npm** — Node.js package manager. Comes with Node.js.

## O

**OMC** — Oh-My-ClaudeCode. A plugin by Yeachan-Heo that provides 19 agents, autopilot mode, ralph loops, and team commands.

**Opus** — Claude's most capable model. Used for planning, architecture, hardest reasoning.

## P

**PAT** — Personal Access Token. A GitHub credential for the github MCP.

**PAUL** — Plan-Apply-Unify. A structured execution framework by ChristopherKahler. Use `/paul:plan` → `/paul:apply` → `/paul:unify`.

**Playwright** — A browser automation library. Apex configures the playwright MCP by default.

**Plugin** — A bundle of agents, commands, skills, and hooks that extends Claude Code. Install via `/plugin install`.

**PRIMER.md** — A file that describes who the user is, what projects are active, and critical rules. Claude reads it at session start.

**PreToolUse / PostToolUse** — Hook events that fire before/after Claude uses a tool.

**PostCompact** — A hook event that fires after `/compact` compresses the conversation.

**Prompt caching** — A performance feature where Claude caches parts of its context to reduce cost. Apex enables 1-hour caching.

## R

**Ralph** — OMC's persistent-loop mode. Keeps running until a "done" promise is met.

**RTL** — Right-To-Left. Text direction for Arabic, Hebrew, Urdu, etc.

**RuFlo** — The `claude-flow` MCP server's branding. Provides 51 swarm agents.

## S

**SEED** — A typed project incubator by ChristopherKahler. `/seed` guides ideation → PLANNING.md.

**session-handoff.md** — A memory file that records what each session ended with, so the next session knows where to pick up.

**settings.json** — Claude Code's main config file at `~/.claude/settings.json`. Defines MCP servers, hooks, plugins.

**Skill** — A markdown file with guidance Claude reads on demand. Apex has 1,276+.

**SKILL.md** — The primary file inside every skill. Contains `recall_keywords` and guidance.

**SKILL-INDEX.md** — Apex's skill index (generated at install). Lists every skill by category.

**Slash command** — A command typed with `/` (e.g., `/healthcheck`). 182 available in Apex.

**Sonnet** — Claude's workhorse model. Used for code execution, reviews, debugging.

**StatusLine** — The bar at the bottom of Claude Code showing model, token count, effort level.

**Stop event** — Fires when Claude finishes responding. Apex runs session-end-save.sh and task-complete-sound.sh on Stop.

## T

**TDD** — Test-Driven Development. Write tests first, then code until tests pass. Apex's tdd-guide agent enforces this.

**Terminal** — The text-based window where you type commands. Required for Claude Code.

**TWENTY_FIRST_DEV_API_KEY** — API key for the @21st-dev/magic MCP server.

## U

**UserPromptSubmit** — The hook event that fires every time you press Enter. CARL listens on this event.

**UTF-8** — The text encoding used for non-English scripts. `carl-hook.py` has a UTF-8 fix on all file opens to prevent corruption.

## V

**Vercel** — A web hosting service. `vercel --prod` deploys; ALWAYS follow with `vercel alias set`.

## W

**WSL** — Windows Subsystem for Linux. Runs Linux inside Windows. Apex works in WSL.

## X

**xhigh** — A high effort level. Apex auto-lowers to `high` at session start to prevent token burn.

## Numbers / Symbols

**21st.dev** — A service that generates React+TS+Tailwind components from natural language. Exposed via the @21st-dev/magic MCP.

**`~`** — Shorthand for your home directory. `~/.claude/` means `C:\Users\you\.claude\` on Windows or `/Users/you/.claude/` on Mac.

**`${VAR}`** — Environment variable reference. `${FAL_KEY}` in settings.json pulls from `~/.claude/.env`.
