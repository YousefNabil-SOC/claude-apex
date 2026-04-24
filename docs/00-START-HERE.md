# START HERE — What Is This?

> Written for someone who has never used Claude Code, never heard of Anthropic, and has never used a terminal. If any of that describes you, you are in the right place.

## In one sentence

This is an upgrade pack for a program called **Claude Code** that turns it from a basic AI coding assistant into the most powerful AI development environment that exists on a consumer computer.

## I don't know what any of those words mean

Fine. Let's go word by word.

### 1. What is Claude?

**Claude** is an AI made by a company called **Anthropic**. It is a very smart assistant that you talk to by typing. Like ChatGPT, but made by a different company. Many professional developers think Claude is the best AI in the world for writing code.

### 2. What is Claude Code?

**Claude Code** is a program you install on your computer. It is a chat window for Claude that lives in your **terminal** (see below). The difference from chatting with Claude in a web browser: Claude Code can read your files, write new files, run programs, test things, and actually do real work on your computer. It is Claude with hands.

### 3. What is a terminal?

The **terminal** is a text window on your computer where you type commands instead of clicking buttons. It sounds scary but it is just a text box. On Windows it is called "Command Prompt", "PowerShell", or "Git Bash". On Mac it is called "Terminal". On Linux it is also "Terminal". The next tutorial shows you how to open it.

### 4. What is Claude Apex?

**Claude Apex** (this repository) is a large upgrade pack for Claude Code. When you install Apex, your Claude Code goes from "okay" to "enterprise-grade".

## What You Get

The top 10 things Apex gives you after install:

1. **Three-layer auto-routing** so typing "build me a landing page" automatically loads the right skills, MCP servers, agents, and commands — no slash commands needed.
2. **25 specialist agents** hand-crafted for architecture, code review, security, SEO, Python, Go, TDD, e2e testing, and more.
3. **9 CARL rule domains with 40 rules** that load just-in-time based on what you're actually doing — saving you tokens every prompt.
4. **9 custom skills** including premium-web-design (36 animation patterns), 21st-dev-magic (React component generation), graphify (knowledge-graph navigation), and instagram-access.
5. **7 automation hooks** that run on session start, session end, prompt submit, and post-compact — including a CARL injector, a sound cooldown, and a session-handoff saver.
6. **4 MCP servers** configured out of the box: playwright (browser automation), github (PRs/issues), exa-web-search (deep research), @21st-dev/magic (component generation).
7. **One unified health check** — run `/healthcheck` and you see 18+ systems verified in 10 seconds.
8. **Memory consolidation** that automatically compresses your session history so your context window never fills with stale notes.
9. **Structured execution frameworks** via PAUL (Plan-Apply-Unify) and OMC (autopilot/ralph/team) built in and ready to use.
10. **Zero-prerequisite tutorials** (the 10 docs in this folder) that walk you from "I have never used a terminal" to "I am running the most capable Claude Code environment on the planet".

## Estimated Install Time

**15-20 minutes total**, broken down as:
- 5 min: install Node.js, Python, Git (if not already installed)
- 2 min: install Claude Code itself (`npm install -g @anthropic-ai/claude-code`)
- 3 min: clone this repo and run the installer
- 5 min: install plugins inside Claude Code
- 5 min: add your API keys (optional but recommended)

## System Requirements

- **OS**: Windows 10+, macOS 12+, or Linux (Ubuntu 22.04 tested)
- **Node.js**: version 20 or later
- **Python**: version 3.10 or later
- **Git**: version 2.0 or later
- **Disk space**: about 500 MB for Apex + 1-2 GB with all plugins
- **Internet connection**: required
- A **Claude account** (sign up free at https://claude.ai)

You do NOT need coding experience, a fancy computer, or any specific IDE.

## Why would I want this?

Use this if you want to:
- Build websites without being a web developer
- Write code faster than you thought possible
- Have a pair programmer who never gets tired and never judges you
- Do research, write documents, design graphics, test software — all by describing what you want

## Will my computer explode?

No. Here is what happens when you install Apex:

1. It makes a timestamped backup of everything in your existing `~/.claude/` folder
2. It adds new files next to your old ones — never overwriting anything
3. If something goes wrong, you run `uninstall.sh` and everything reverts

It is as safe as installing any other software.

## What does it cost?

- **Claude Code itself**: free
- **Claude Apex** (this upgrade pack): free, MIT-licensed, forever
- **The AI responses** (Anthropic API): pay-as-you-go, typically $5-$20/month of moderate use. There is a free tier to try.

## Example — what it looks like after install

You type this in Claude Code:

```
build me a luxury landing page for a coffee brand
```

This is what happens in the background:

```
[CARL Layer 1] WEB-DEVELOPMENT + DEVELOPMENT domains loaded (9 rules)
[CAPABILITY-REGISTRY Layer 2] Loaded skills: premium-web-design, react-patterns,
  tailwind-patterns, typescript-pro, ui-ux-pro-max
[CAPABILITY-REGISTRY Layer 2] Activated MCPs: @21st-dev/magic, playwright, context7
[COMMAND-REGISTRY Layer 3] Auto-invoking /feature-dev

Generating hero section via 21st.dev Magic MCP...
Applying premium-web-design scroll-reveal pattern...
Writing src/components/Hero.tsx (187 lines)
Writing src/components/ProductGrid.tsx (142 lines)
Running npm run build... PASS (0 errors, 0 warnings)

Ready for your review at http://localhost:5173
```

You never typed a slash command. The system routed your sentence to the right tools.

## What You Learned

- Claude = the AI. Claude Code = the CLI program. Claude Apex = this upgrade pack.
- Claude Code lives in your terminal, reads your files, and runs commands for you.
- Apex adds 25 agents, 9 CARL domains, 9 custom skills, 7 hooks, 4 MCP servers, and three-layer auto-routing.
- Install is non-destructive, backed up, and reversible in under a minute.
- You do not need any prior coding experience to follow this tutorial series.

## Next Step

Go to **[01-WHAT-IS-CLAUDE-CODE.md](01-WHAT-IS-CLAUDE-CODE.md)** when you're ready. It takes 3 minutes to read. Each tutorial builds on the last.

Here is the full ordered list:

1. **[01-WHAT-IS-CLAUDE-CODE.md](01-WHAT-IS-CLAUDE-CODE.md)** — Deeper look at Claude Code
2. **[02-INSTALL-FROM-ZERO.md](02-INSTALL-FROM-ZERO.md)** — Install everything from scratch
3. **[03-FIRST-TIME-USING.md](03-FIRST-TIME-USING.md)** — Your first 10 commands with expected output
4. **[04-WHAT-ARE-SKILLS.md](04-WHAT-ARE-SKILLS.md)** — Skills = recipe books Claude reads on demand
5. **[05-WHAT-ARE-AGENTS.md](05-WHAT-ARE-AGENTS.md)** — Agents = specialist coworkers
6. **[06-WHAT-ARE-MCP-SERVERS.md](06-WHAT-ARE-MCP-SERVERS.md)** — MCP = superpowers plugged in
7. **[07-WHAT-ARE-HOOKS.md](07-WHAT-ARE-HOOKS.md)** — Hooks = automatic reflexes
8. **[08-WHAT-IS-CARL.md](08-WHAT-IS-CARL.md)** — CARL = the librarian
9. **[09-GLOSSARY.md](09-GLOSSARY.md)** — Every term you'll encounter
10. **[10-TROUBLESHOOT-FOR-BEGINNERS.md](10-TROUBLESHOOT-FOR-BEGINNERS.md)** — When something goes wrong

Welcome aboard.

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
