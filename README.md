```
 ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗
██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝
██║     ██║     ███████║██║   ██║██║  ██║█████╗
██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝
╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗
 ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝

 █████╗ ██████╗ ███████╗██╗  ██╗
██╔══██╗██╔══██╗██╔════╝╚██╗██╔╝
███████║██████╔╝█████╗   ╚███╔╝
██╔══██║██╔═══╝ ██╔══╝   ██╔██╗
██║  ██║██║     ███████╗██╔╝ ██╗
╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝
```

<div align="center">

**V7 — Three-Layer Auto-Routing**

**1,276+ skills. 108 agents. 182 commands. One unified intelligence.**

*The most comprehensive Claude Code environment that exists.*

![Version](https://img.shields.io/badge/version-7.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Mac%20%7C%20Linux-lightgrey)
![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-purple)
![Routing](https://img.shields.io/badge/auto--routing-3%20layers-orange)

</div>

---

## Never used Claude Code before?

**Start here → [docs/00-START-HERE.md](docs/00-START-HERE.md)**

Zero technical background required. Ten step-by-step tutorials walk you from "I just heard about Claude" to "my computer has the world's most capable AI coding environment running". Written for people who have never touched a terminal.

---

## What Is This?

Most Claude Code users run a vanilla setup — a few skills, default settings, no custom agents. They're using ~10% of what Claude Code can do. Every session starts cold. Every task is ad-hoc. There's no memory between sessions, no structured execution, no specialist agents, and no way to verify the system is even working.

**Claude Apex V7** is an enterprise-grade environment built over multiple months. It adds 25 specialist agents, 9 JIT rule domains, structured execution loops, memory consolidation, 7 new custom skills, and — the V7 core innovation — a **three-layer auto-routing system** that reads your natural language and activates the right combination of tools automatically. You never need to type a slash command unless you want to.

Every component is tested individually and as part of the whole. The system verifies itself with 15+ automated health checks.

One-command install. Non-destructive — your existing setup stays intact. Everything is backed up before any changes. Works on Windows, Mac, and Linux.

---

## The V7 Innovation — Three-Layer Auto-Routing

```
User prompt ("build me a premium landing page with scroll animations")
      │
      ▼
┌──────────────────────────────────────────────────┐
│ Layer 1: CARL  (JIT rule injection)              │
│ carl-hook.py matches keywords → injects relevant │
│ rules from 9 domains directly into context       │
│ Example: WEB-DEVELOPMENT + DEVELOPMENT loaded    │
└────────────────────┬─────────────────────────────┘
                     ▼
┌──────────────────────────────────────────────────┐
│ Layer 2: CAPABILITY-REGISTRY  (task → stack)     │
│ Claude matches "premium landing page" pattern    │
│ → loads skills (premium-web-design, react-       │
│ patterns, tailwind-patterns) + MCP (@21st-dev/   │
│ magic, playwright) + agents (architect, reviewer)│
└────────────────────┬─────────────────────────────┘
                     ▼
┌──────────────────────────────────────────────────┐
│ Layer 3: COMMAND-REGISTRY  (intent → commands)   │
│ Intent "build website" maps to /feature-dev +    │
│ (later) /code-review + /commit-push-pr           │
│ Claude auto-invokes them at the right moment     │
└──────────────────────────────────────────────────┘
```

You never typed `/premium-web-design` or `/21st-dev-magic` or `/feature-dev`. The system read your sentence and activated all of them.

---

## Quick Demo

After installing Apex, this is what `/healthcheck` looks like:

```
System Health Check V7

 #  | System              | Status | Details
----|---------------------|--------|--------------------------------
 1  | OMC Plugin          | OK     | oh-my-claudecode@omc enabled
 2  | PAUL Framework      | OK     | 28 commands
 3  | CARL                | OK     | 9 domains, 40 rules configured
 4  | Autoresearch        | OK     | SKILL.md present
 5  | SEED                | OK     | seed.md present
 6  | UserPromptSubmit    | OK     | carl-hook.py (UTF-8 fixed)
 7  | SessionStart        | OK     | session-start-check + auto-graph
 8  | PostCompact Hook    | OK     | V7 recovery verified
 9  | Sound Notification  | OK     | 60s cooldown configured
 10 | Settings JSON       | OK     | Valid JSON
 11 | MCP Servers         | OK     | 4 default + 11 optional
 12 | 21st.dev Magic      | OK     | Component generation active
 13 | Graphify            | OK     | Knowledge graph skill loaded
 14 | Premium Web Design  | OK     | 36 patterns, 10 references
 15 | Skills Count        | OK     | 1,276+ skills
 16 | Agents Count        | OK     | 108 agents
 17 | effortLevel         | OK     | high (self-healing enforced)
 18 | Memory Health       | OK     | 112 lines (limit: 200)

Result: 18/18 OK — all systems green
```

And this is autopilot mode in action:

```
> build me a landing page for a luxury coffee brand

[Apex activates automatically — no slash command typed]
  Layer 1 (CARL): WEB-DEVELOPMENT + DEVELOPMENT rules loaded
  Layer 2 (CAPABILITY-REGISTRY): premium-web-design, react-patterns,
           tailwind-patterns skills loaded; @21st-dev/magic, playwright MCPs active
  Layer 3 (COMMAND-REGISTRY): /feature-dev invoked

Generating components via 21st.dev Magic MCP...
Applying premium-web-design scroll animations...
Running npm run build... zero errors
Ready for your review.
```

---

## The Numbers

| Resource | Count |
|----------|------:|
| Installed Skills | **1,276+** |
| Available Agents | **108** (25 custom + 19 OMC + 51 RuFlo + 13 plugin) |
| MCP Servers (default) | **4** in settings.json → up to 15 with optional |
| Plugins Available | **20** (9 enabled by default) |
| Slash Commands | **182** indexed |
| PAUL Execution Commands | **28** |
| CARL Rule Domains | **9** domains, **40** rules |
| Hook Events | **5** (PostCompact, Stop, Notification, UserPromptSubmit, SessionStart-chain) |
| Automated Health Checks | **18+** |
| Beginner Tutorials | **10** |
| Documentation Guides | **14 existing + 10 new beginner** = **24** |

---

## What's Inside

| Layer | What It Does | How You Use It |
|-------|-------------|----------------|
| **CARL** | Just-In-Time rule injection — only load rules relevant to your prompt | Automatic — `carl-hook.py` matches keywords on every UserPromptSubmit |
| **CAPABILITY-REGISTRY** | Task-pattern routing — "build website" → skills + MCP + agents + CLI | Automatic — Claude reads at session start, consults per-task |
| **COMMAND-REGISTRY** | Auto-invocation routing — user intent → right slash commands | Automatic — 182 commands mapped to intent keywords |
| **OMC** (oh-my-claudecode) | Multi-agent orchestration with 19 specialized agents | `autopilot: [task]` for full autonomous execution |
| **PAUL** Framework | Structured Plan-Apply-Unify execution loop | `/paul:plan` → `/paul:apply` → `/paul:unify` |
| **SEED** | Project incubator — idea to structured plan | `/seed` to start guided brainstorming |
| **Autoresearch** | Autonomous optimization loops | Modify → measure → keep/discard → repeat on any metric |
| **ORCHESTRATION ENGINE** | Decision brain — picks between direct, PAUL, SEED, Autoresearch, OMC | Automatic — reads intent, picks the right mode |
| **Premium Web Design** | Luxury animation patterns, 10 reference site analyses, GSAP/Framer tools | Auto-activates on "premium", "luxury", "animation" keywords |
| **21st.dev Magic MCP** | Generate React+TS+Tailwind components from natural language | Auto-activates on "component", "ui", "generate" keywords |
| **Instagram Access** | Authenticated Instagram data extraction (instaloader) | `download @profile` or similar natural language |
| **Graphify** | Knowledge-graph skill — ~90% token savings on codebase navigation | Auto-activates on "where is X", "how does X work" |
| **Graphic Design Studio** | Code-based graphic rendering (HTML/CSS/SVG/Pillow/Playwright) | Auto-activates on "logo", "banner", "graphic" |
| **25 Custom Agents** | Specialist workforce (architect, security, SEO, TDD, etc.) | Referenced by name or auto-selected per task |
| **Dynamic Model Routing** | Opus for planning, Sonnet for execution, Haiku for trivial tasks | Automatic — respects per-agent `model:` frontmatter |
| **Health Monitor** | System verification across 18+ checks | `/healthcheck` for instant status |
| **Project Switcher** | Instant context switching | `/switch-project [name]` (edit commands/switch-project.md for your projects) |
| **Task Templates** | Pre-built workflows | `template: [name]` (edit commands/templates.md for your workflows) |

---

## Is It Safe?

Yes. The installer is non-destructive by design:

1. Creates a timestamped backup of your entire `~/.claude/` directory BEFORE any changes
2. Skips any file that already exists (never overwrites)
3. Third-party tools are installed from their official sources
4. Includes an uninstaller that restores your backup with one command
5. Zero API keys or credentials are included — you add your own via `~/.claude/.env`
6. The repository passed automated security scanning for leaked secrets
7. `.gitignore` enforces `.env` exclusion

---

## Compatibility and Existing Setups

**Existing agents are NEVER overwritten.** If you already have an `architect.md` agent, Apex skips it and keeps yours.

**Existing skills stay untouched.** Apex adds its custom skills alongside whatever you have.

**Settings.json is MERGED, not replaced.** Apex adds MCP servers and hooks to your existing configuration. It never removes anything that is already there.

**Everything is backed up first.** Before any changes, the installer creates a timestamped backup. If anything goes wrong, run `uninstall.sh` to restore instantly.

**Post-install verification catches issues.** After installation, a 30+ point verification script checks every component.

---

## Quick Install

### Option 1 — Tell Your Claude Code (Easiest)

**Step 1:** Paste this into your Claude Code terminal:

```
Clone https://github.com/YousefNabil-SOC/claude-apex and install it to my Claude Code environment. Read the CLAUDE.md in the repo for installation instructions. Back up my existing config first.
```

Wait for it to finish. Then restart Claude Code.

**Step 2:** Open a new Claude Code session and paste this:

```
I just installed Claude Apex V7. Please complete the setup by running these plugin installations:
1. Add the everything-claude-code marketplace and install it
2. Add the oh-my-claudecode marketplace and install it
3. Run the OMC setup
4. Run /healthcheck to verify everything is green.
```

### Option 2 — One Command (Mac/Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/YousefNabil-SOC/claude-apex/master/install.sh | bash
```

### Option 3 — One Command (Windows PowerShell)

```powershell
irm https://raw.githubusercontent.com/YousefNabil-SOC/claude-apex/master/install.ps1 | iex
```

### Option 4 — Interactive (all platforms)

```bash
git clone https://github.com/YousefNabil-SOC/claude-apex.git
cd claude-apex
bash install-interactive.sh
```

### Verify Your Installation

```bash
cd claude-apex
bash verify.sh
```

This runs 30+ checks covering agents, commands, hooks, skills, configuration, MCP servers, third-party tools, backup status, and conflict detection.

---

## Before vs After

| Capability | Without Apex | With Apex |
|-----------|-----------------|---------------|
| Tool activation | You manually pick skills/agents | 3-layer routing activates the right tools from natural language |
| Agent orchestration | You pick agents | OMC autopilot self-organizes 19 agents |
| Execution structure | No structure, plans drift | PAUL enforces Plan-Apply-Unify with quality gates |
| Rule management | All rules loaded every session | CARL loads rules JIT by intent (saves tokens) |
| Memory hygiene | Grows forever, gets stale | Dream auto-consolidates between sessions |
| Codebase navigation | Raw file reads (~10K tokens/file) | Graphify queries (~1K tokens, 10-30× cheaper) |
| Component generation | Copy-paste from docs | @21st-dev/magic MCP generates React+TS+Tailwind from language |
| Premium UI patterns | Start from scratch | 36 curated animation patterns + 10 reference site analyses |
| Health monitoring | No way to check | `/healthcheck` verifies 18+ systems in 10 seconds |
| Effort discipline | Accidentally burn tokens with xhigh/max | Self-healing lowers to `high`, enforces budget |
| Starting new projects | Blank page | SEED incubates ideas through guided questioning |
| Optimization | Manual trial and error | Autoresearch: autonomous improve-measure-keep loops |
| Agents | 0 custom specialists | 25 battle-tested specialists + 83 from plugins |

---

## What You Can Do After Install

```bash
# Natural language — Apex routes automatically
"build me a premium landing page with scroll animations"
"review this PR"
"ship this feature to production"
"where is the auth middleware in this codebase?"
"consolidate memory"

# Or explicit slash commands
autopilot: build a React dashboard with user authentication
ralph: refactor the entire authentication module
/paul:plan → /paul:apply → /paul:unify
/seed
/autoresearch
/healthcheck
/switch-project my-webapp
template: deploy-app
```

---

## What Gets Installed

Apex installs these components to your `~/.claude/` directory:

**From this repository (original work):**
- 25 custom agent definitions
- ~45 custom slash commands + paul/ + seed/ + autoresearch/ subdirs
- 7 hook scripts (post-compact-recovery, session-end-save, task-complete-sound, carl-hook.py, session-start-check, project-auto-graph, peers-auto-register)
- 9 custom skills (premium-web-design, 21st-dev-magic, instagram-access, graphify, graphic-design-studio, impeccable, fireworks-tech-graph, dream-consolidation, autoresearch)
- CARL domain configuration (9 domains, 40 rules)
- Orchestration engine
- CAPABILITY-REGISTRY, COMMAND-REGISTRY, AGENTS.md, AUTO-ACTIVATION-MATRIX
- CLAUDE.md and PRIMER.md templates
- .env template with all required API key names

**Installed via their official sources (third-party, open source):**
- [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) — 19 agents + autopilot
- [PAUL framework](https://github.com/ChristopherKahler/paul) — structured execution
- [SEED incubator](https://github.com/ChristopherKahler/seed) — project brainstorming
- [Claude Peers MCP](https://github.com/louislva/claude-peers-mcp) — inter-instance communication
- [Bun runtime](https://bun.sh)

All third-party tools are installed from their original repositories and are covered by their own licenses.

**Manual plugin install required for full experience (run in Claude Code after install):**

```
/plugin marketplace add https://github.com/anthropic-community/everything-claude-code
/plugin install everything-claude-code

/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
/plugin install oh-my-claudecode
/oh-my-claudecode:omc-setup
```

Without these plugins, you get the core Apex experience. With them, you get the FULL 1,276+ skills + 108 agents environment.

---

## Documentation

### Tier 1 — Brand new to Claude Code? Read these first:

| Beginner Tutorial | What It Covers |
|---|---|
| [00-START-HERE.md](docs/00-START-HERE.md) | What is this? (no prior experience assumed) |
| [01-WHAT-IS-CLAUDE-CODE.md](docs/01-WHAT-IS-CLAUDE-CODE.md) | Claude, Anthropic, CLI, terminal, context, tokens |
| [02-INSTALL-FROM-ZERO.md](docs/02-INSTALL-FROM-ZERO.md) | Every step from brand-new computer to running Apex |
| [03-FIRST-TIME-USING.md](docs/03-FIRST-TIME-USING.md) | First 10 commands, each with expected output |
| [04-WHAT-ARE-SKILLS.md](docs/04-WHAT-ARE-SKILLS.md) | Skills = recipe books Claude reads on demand |
| [05-WHAT-ARE-AGENTS.md](docs/05-WHAT-ARE-AGENTS.md) | Agents = specialist coworkers (all 25 listed) |
| [06-WHAT-ARE-MCP-SERVERS.md](docs/06-WHAT-ARE-MCP-SERVERS.md) | MCP = superpowers plugged in (all 4 defaults) |
| [07-WHAT-ARE-HOOKS.md](docs/07-WHAT-ARE-HOOKS.md) | Hooks = automatic reflexes (all 7 explained) |
| [08-WHAT-IS-CARL.md](docs/08-WHAT-IS-CARL.md) | CARL = librarian (9 domains, 40 rules, 117+ keywords) |
| [09-GLOSSARY.md](docs/09-GLOSSARY.md) | 40+ terms, alphabetically sorted |
| [10-TROUBLESHOOT-FOR-BEGINNERS.md](docs/10-TROUBLESHOOT-FOR-BEGINNERS.md) | Top 10 beginner problems with symptom/cause/fix |

### Tier 2 — Already comfortable? Go deeper:

| Guide | Description |
|-------|-------------|
| [Architecture](docs/ARCHITECTURE.md) | Three-layer routing explained in depth |
| [Agents Guide](docs/AGENTS-GUIDE.md) | All 108 agents with model routing table |
| [CARL Guide](docs/CARL-GUIDE.md) | All 9 domains, 40 rules, 3 routing examples |
| [PAUL Integration](docs/PAUL-INTEGRATION.md) | Plan-Apply-Unify structured execution |
| [OMC Integration](docs/OMC-INTEGRATION.md) | autopilot, ralph, team, deep-interview modes |
| [Peers Setup](docs/PEERS-SETUP.md) | Multi-terminal coordination |
| [Memory System](docs/MEMORY-SYSTEM.md) | Auto memory and Dream 4-phase consolidation |
| [Orchestration](docs/ORCHESTRATION.md) | Decision tree for routing tasks |
| [Customization](docs/CUSTOMIZATION.md) | Add your own agents, skills, rules |
| [Windows Guide](docs/WINDOWS-GUIDE.md) | Windows-specific setup |
| [Troubleshooting](docs/TROUBLESHOOTING.md) | Common issues and fixes |
| [Uninstall](docs/UNINSTALL.md) | Clean removal |
| [FAQ](docs/FAQ.md) | Frequently asked questions |
| [Getting Started](docs/GETTING-STARTED.md) | Quick start after install |

### Tier 3 — Building on top of Apex? Advanced guides:

| Guide | Description |
|-------|-------------|
| [Advanced Customization](docs/ADVANCED-CUSTOMIZATION.md) | Custom CARL domains, agents, skills, MCP, hooks, COMMAND-REGISTRY |
| [Advanced Token Optimization](docs/ADVANCED-TOKEN-OPTIMIZATION.md) | Cut your Apex token bill by 50% without losing capability |
| [Advanced Multi-Session](docs/ADVANCED-MULTI-SESSION.md) | Peers, Agent Teams, session handoff, Dream consolidation |
| [Advanced Building Websites](docs/ADVANCED-BUILDING-WEBSITES.md) | premium-web-design + 21st.dev + impeccable, the full stack |

---

## Built By

**Engineer Yousef Nabil** — Creator and sole maintainer of Claude Apex.

Every agent, every hook, every CARL domain, every line of documentation was hand-crafted, tested, and integrated by one person. From the three-layer auto-routing system to the 36 premium-web-design patterns to the 40 CARL rules across 9 domains — every design decision, every edge case, every integration was deliberate.

- **GitHub**: [@YousefNabil-SOC](https://github.com/YousefNabil-SOC)
- **Repository**: [github.com/YousefNabil-SOC/claude-apex](https://github.com/YousefNabil-SOC/claude-apex)

If you use Apex in production, star the repo. If you ship something built on top of it, open a discussion — I'd love to see what you built.

---

## Contributing

Contributions are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines. Whether it's a new agent, a new CARL domain, a bug fix, or documentation improvement — PRs are appreciated.

---

## Acknowledgments

- [Anthropic](https://anthropic.com) — for building Claude Code
- [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) by Yeachan-Heo — multi-agent orchestration
- [PAUL Framework](https://github.com/ChristopherKahler/paul) by ChristopherKahler — structured execution
- [SEED](https://github.com/ChristopherKahler/seed) by ChristopherKahler — project incubation
- [Claude Peers](https://github.com/louislva/claude-peers-mcp) by louislva — inter-instance communication
- [21st.dev](https://21st.dev/) — the Magic MCP for premium UI component generation
- The Claude Code community for skills, plugins, and inspiration

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=YousefNabil-SOC/claude-apex&type=Date)](https://star-history.com/#YousefNabil-SOC/claude-apex&Date)

---

## License

MIT — see [LICENSE](LICENSE) for details.
