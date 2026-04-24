# Glossary

> Every term you'll encounter in Claude Apex, alphabetically sorted and defined in one line.

## A

**Agent** — An AI specialist Claude can delegate work to. Each has a specific role (architect, security-reviewer, etc.) and its own model tier.

**AGENTS.md** — Apex's agent directory at `~/.claude/AGENTS.md`, listing all 108 agents grouped by division (Engineering, Review, SEO, Business, Documentation, Cybersecurity, RuFlo, OMC).

**Anthropic** — The AI safety company that makes Claude. San Francisco-based. https://anthropic.com

**API key** — A secret string that authenticates you to a third-party service (GitHub, Exa, 21st.dev, fal.ai, etc.). Stored in `~/.claude/.env`, never in git.

**Apex** — This repository. An enterprise-grade upgrade pack for Claude Code.

**Auto-activation matrix** — A table at `~/.claude/AUTO-ACTIVATION-MATRIX.md` mapping task types to the skills, MCPs, agents, CLI tools, and plugins that activate.

**Autopilot** — OMC's fully autonomous mode: research → plan → execute → QA → validate, all without human input. Syntax: `autopilot: <task>`.

**Autoresearch** — An execution mode for measurable optimization loops (modify → measure → keep/discard → repeat until the metric converges).

## B

**Bash** — A Unix shell used on Mac and Linux. Available on Windows via Git Bash.

**Bun** — A fast JavaScript runtime, used as an alternative to Node.js for Claude Peers.

## C

**CAPABILITY-REGISTRY.md** — Apex's Layer 2 routing table at `~/.claude/CAPABILITY-REGISTRY.md`. Maps task patterns to the skills, MCPs, agents, and CLI tools that handle them.

**CARL** — Context Augmentation & Reinforcement Layer. The Layer 1 hook at `~/.claude/hooks/carl-hook.py` that injects domain-specific rules JIT based on prompt keywords.

**carl.json** — CARL's config at `~/.carl/carl.json`. Contains 9 domains, 40 rules, 117+ recall keywords.

**CLAUDE.md** — A configuration file Claude reads at session start. Global version at `~/.claude/CLAUDE.md`; project-specific versions live in each project folder.

**claude-flow** — See "RuFlo".

**claude-mem** — A memory plugin that indexes past sessions for `/mem-search`.

**Claude** — The AI model made by Anthropic. Versions: Opus (smartest), Sonnet (balanced), Haiku (fast).

**Claude Code** — The CLI program that lets you talk to Claude from your terminal. Can read your files and run commands.

**Claude Peers** — An optional MCP server (port 7899) that lets multiple Claude Code terminals discover each other and exchange messages.

**CLI** — Command-Line Interface. A text-based program you interact with by typing commands.

**COMMAND-REGISTRY.md** — Apex's Layer 3 routing table at `~/.claude/COMMAND-REGISTRY.md`. Maps user intent keywords to the right slash commands (182 indexed).

**compact** (`/compact`) — A slash command that compresses your conversation to free up context window space.

**context window** — The total amount of text Claude can consider at once (200,000 tokens, about a short novel). `/compact` shrinks it when it fills up.

## D

**Dev mode** — A CARL setting (`config.devmode: true` in carl.json) that appends debug blocks to every response.

**Dream** — A memory consolidation skill (`dream-consolidation`) that runs a 4-phase memory cleanup. Trigger: "consolidate memory".

## E

**effortLevel** — Claude Code setting controlling reasoning depth. Apex defaults to `high`. Don't use `xhigh` or `max` casually — they burn tokens.

**env template** — `config/env.template` lists every API key name Apex uses. Copy to `~/.claude/.env` and fill in.

**everything-claude-code** — A plugin that ships 1,267 community skills. Install via `/plugin install everything-claude-code`.

**Exa** — Semantic web search service. Requires `EXA_API_KEY` in `.env` for the `exa-web-search` MCP.

## F

**fal.ai** — An image generation service. Requires `FAL_KEY` in `.env`. Apex defaults to SVG/CSS (free) before using fal.

## G

**gh** — GitHub's official CLI tool. Used by several Apex agents.

**Git** — Version control system. Required to clone this repo.

**GitHub** — The code hosting site where this repo lives. Requires `GITHUB_PERSONAL_ACCESS_TOKEN` for the github MCP.

**Graphify** — An Apex skill that builds knowledge graphs of projects, saving ~90% of file-reading tokens. Invoke with `/graphify`.

## H

**Haiku** — Claude's fastest, cheapest model. Used for quick lookups, exploration, writing, and explorer subagents.

**Health check** (`/healthcheck`) — Apex's 18-point system verification. Runs in under 10 seconds.

**Hook** — A script that fires automatically on Claude Code events (SessionStart, UserPromptSubmit, Stop, PostCompact, Notification, PreToolUse, PostToolUse).

## I

**Impeccable** — An Apex skill that adds the design-polish layer to a finished UI: hover states, micro-interactions, focus rings, empty states.

**Instagram-access** — An Apex skill that uses instaloader for authenticated Instagram scraping.

## J

**JIT** — Just-In-Time. CARL loads rules JIT so only relevant rules sit in context.

## L

**LEGAL domain** — A CARL domain that activates on legal keywords (contract, law, counsel, agreement, arbitration, liability).

**LLM** — Large Language Model. The underlying tech behind Claude.

## M

**MCP** — Model Context Protocol. An open standard by Anthropic for AI tool integration.

**MCP server** — A program that provides tools to Claude via the MCP protocol (playwright, github, exa-web-search, @21st-dev/magic, etc.).

**MEMORY.md** — A file where Claude persists notes between sessions.

## N

**Node.js** — JavaScript runtime. Required to run Claude Code. Apex needs version 20+.

**npm** — Node.js package manager. Comes with Node.js.

## O

**OMC** — Oh-My-ClaudeCode. A plugin by Yeachan-Heo providing 19 agents and 4 execution modes (autopilot, ralph, team, deep-interview).

**Opus** — Claude's most capable model. Used for architecture, planning, and the hardest reasoning.

**Orchestration Engine** — The decision brain at `~/.claude/ORCHESTRATION-ENGINE.md`. Picks between direct, PAUL, SEED, Autoresearch, OMC modes.

## P

**PAT** — Personal Access Token. A GitHub credential used by the github MCP.

**PAUL** — Plan-Apply-Unify framework by ChristopherKahler. Use `/paul:plan` → `/paul:apply` → `/paul:unify` for multi-phase structured work.

**Playwright** — A browser automation library. Apex configures the playwright MCP by default.

**Plugin** — A bundle of agents, commands, skills, and hooks extending Claude Code. Install via `/plugin install`.

**PostCompact** — A hook event that fires after `/compact` compresses the conversation. Apex uses it to remind Claude to re-read CAPABILITY-REGISTRY.md.

**PostToolUse** — A hook event that fires after Claude uses a tool.

**preToolUse** — A hook event that fires before Claude uses a tool. Useful for validation/blocking.

**Premium-web-design** — An Apex skill with 36 animation patterns and 10 reference site analyses.

**PRIMER.md** — A file describing who the user is, active projects, stakeholders. Claude reads it at session start.

**Prompt caching** — A performance feature where Claude caches parts of its context to reduce cost. Apex enables 1-hour caching via `ENABLE_PROMPT_CACHING_1H=1`.

## R

**Ralph** — OMC's persistent-loop mode. Keeps retrying until a "done" promise is met. Syntax: `ralph: <task>`.

**Recall keywords** — The array of strings in a CARL domain's `recall` field that trigger the domain when they appear in a prompt.

**RTL** — Right-To-Left. Text direction for Arabic, Hebrew, Urdu, etc.

**RuFlo** — The `claude-flow` MCP server's branding. Provides 51 swarm agents for large-scale parallel work.

## S

**SEED** — A typed project incubator by ChristopherKahler. `/seed` guides ideation into a PLANNING.md.

**session-handoff.md** — A memory file at `~/.claude/memory/session-handoff.md` that records what each session ended with, so the next session knows where to pick up.

**settings.json** — Claude Code's main config file at `~/.claude/settings.json`. Defines MCP servers, hooks, plugins, env, effort level.

**Skill** — A markdown file (`SKILL.md`) Claude reads on demand. Apex has 1,276+.

**SKILL.md** — The primary file inside every skill. Contains `recall_keywords` and guidance.

**SKILL-INDEX.md** — Apex's skill index (generated at install). Lists every skill by category.

**Slash command** — A command typed with `/` (e.g., `/healthcheck`). 182 available when Apex is fully installed.

**Sonnet** — Claude's workhorse model. Used for code execution, reviews, debugging, most specialist agents.

**StatusLine** — The bar at the bottom of Claude Code showing model, token count, effort level.

**Stop event** — Fires when Claude finishes responding. Apex runs `session-end-save.sh` and `task-complete-sound.sh` on Stop.

**subagent** — A secondary Claude instance spawned to do a focused sub-task. Default subagent model: Haiku.

## T

**TDD** — Test-Driven Development. Write tests first, then code until tests pass. Apex's `tdd-guide` agent enforces this.

**Terminal** — The text-based window where you type commands. Required for Claude Code.

**Token** — The unit Claude measures text in. 1 token ≈ 4 characters of English. Anthropic bills per token.

**TWENTY_FIRST_DEV_API_KEY** — API key for the @21st-dev/magic MCP server.

## U

**UserPromptSubmit** — The hook event that fires every time you press Enter. CARL listens on this event.

**UTF-8** — The text encoding used for non-English scripts. `carl-hook.py` has a UTF-8 fix on all 4 file opens to prevent corruption.

## V

**V7** — The current Apex version (7.0.0). Introduced the three-layer auto-routing system.

**Vercel** — A web hosting service. `vercel --prod` deploys; ALWAYS follow with `vercel alias set` if you use a canonical domain.

## W

**WSL** — Windows Subsystem for Linux. Runs Linux inside Windows. Apex works in WSL.

## X

**xhigh** — A high effort level in Claude Code. Apex auto-lowers to `high` at session start to prevent token burn.

## Numbers / Symbols

**21st.dev** — A service generating premium React+TS+Tailwind components from natural language. Exposed via the `@21st-dev/magic` MCP.

**`~`** — Shorthand for your home directory. `~/.claude/` means `C:\Users\you\.claude\` on Windows or `/Users/you/.claude/` on macOS.

**`$HOME`** — Shell environment variable pointing to your home directory. Preferred over `~` in scripts for portability.

**`${VAR}`** — Environment variable reference. `${FAL_KEY}` in settings.json pulls the value from `~/.claude/.env`.

**200,000** — The number of tokens Claude's context window holds. Roughly a short novel.

**1,276+** — The number of skills after installing the `everything-claude-code` plugin.

**108** — The number of agents after full install (25 Apex + 51 RuFlo + 19 OMC + 13 plugin-unique).

**182** — The number of slash commands indexed in COMMAND-REGISTRY.md.

**9** — The number of CARL domains: GLOBAL, DEVELOPMENT, WEB-DEVELOPMENT, DOCUMENT-CREATION, RESEARCH-OSINT, DEPLOYMENT, LEGAL, BROWSER, PROJECT-NAVIGATION.

**40** — The total number of CARL rules across all 9 domains.

**117+** — The number of CARL recall keywords across all 9 domains.

**4** — The number of default MCP servers Apex configures: playwright, github, exa-web-search, @21st-dev/magic.

**7** — The number of hook scripts Apex ships: carl-hook.py, session-start-check.sh, project-auto-graph.sh, post-compact-recovery.sh, session-end-save.sh, task-complete-sound.sh, peers-auto-register.sh (disabled by default).

**5** — The number of hook events Apex wires up: PostCompact, Stop, Notification, UserPromptSubmit, SessionStart-chain.

## What You Learned

- This glossary is a quick reference — bookmark it while you're learning.
- Key abbreviations: MCP (tools), CARL (rules), OMC (plugin), PAUL (framework), SEED (incubator), RuFlo (swarm).
- Three-layer routing maps to three real files: CARL (carl-hook.py), CAPABILITY-REGISTRY.md, COMMAND-REGISTRY.md.
- If a term isn't here, open an issue — we add them as users ask.

## Next Step

- **[10-TROUBLESHOOT-FOR-BEGINNERS.md](10-TROUBLESHOOT-FOR-BEGINNERS.md)** — When something breaks, start here.
- **[00-START-HERE.md](00-START-HERE.md)** — Go back to the top.

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
