# Claude Apex

**A three-layer auto-routing environment for Claude Code.**

Apex turns a default Claude Code install into a structured, self-routing workspace.
It reads your natural-language prompt and activates the right rules, skills, agents,
and MCP servers automatically -- no slash command required. The repository ships a
curated core of original tooling plus an installer that composes cleanly with the
wider Claude Code plugin ecosystem.

![version](https://img.shields.io/badge/version-8.0.0-blue)
![license](https://img.shields.io/badge/license-MIT-green)
![platform](https://img.shields.io/badge/platform-Windows%20%7C%20Mac%20%7C%20Linux-lightgrey)
![routing](https://img.shields.io/badge/auto--routing-3%20layers-orange)
![claude code](https://img.shields.io/badge/Claude%20Code-compatible-purple)

---

## What it is

A vanilla Claude Code setup is stateless and ad-hoc: a few skills, default settings,
no custom agents, no memory between sessions, no structured execution. Apex adds the
missing layer -- a routing brain plus a curated set of agents, skills, hooks, and
registries -- so the environment configures itself per task instead of being driven
by hand.

The install is non-destructive: it backs up your existing `~/.claude/` directory,
never overwrites files you already have, and ships an uninstaller and a verification
script.

---

## The core innovation -- three-layer auto-routing

```
  User prompt: "build me a premium landing page with scroll animations"
        |
        v
  +--------------------------------------------------------------+
  | Layer 1  CARL  (just-in-time rule injection)                 |
  | carl-hook.py matches keywords on UserPromptSubmit and        |
  | injects only the relevant rules from 10 domains into context |
  | e.g. WEB-DEVELOPMENT + DEVELOPMENT rules loaded              |
  +-----------------------------+--------------------------------+
                                v
  +--------------------------------------------------------------+
  | Layer 2  CAPABILITY-REGISTRY  (task pattern -> stack)        |
  | matches "premium landing page" -> loads skills               |
  | (premium-web-design, react/tailwind patterns)                |
  | + MCP servers (21st.dev Magic, Playwright) + agents          |
  +-----------------------------+--------------------------------+
                                v
  +--------------------------------------------------------------+
  | Layer 3  COMMAND-REGISTRY  (intent -> slash commands)        |
  | intent "build website" maps to /feature-dev, then            |
  | /code-review, then /commit -- invoked at the right moment    |
  +--------------------------------------------------------------+
```

You never typed `/premium-web-design`, `/21st-dev-magic`, or `/feature-dev`. The
system read your sentence and activated all of them. The same routing handles code
review, debugging, deployment, document generation, research, and more.

---

## Quick demo

Natural language in -- Apex routes automatically, no slash command typed:

```
> build me a landing page for a luxury coffee brand

[Apex routes automatically]
  Layer 1 (CARL):                WEB-DEVELOPMENT + DEVELOPMENT rules injected
  Layer 2 (CAPABILITY-REGISTRY): premium-web-design, react/tailwind skills loaded;
                                 21st.dev Magic + Playwright MCP servers active
  Layer 3 (COMMAND-REGISTRY):    /feature-dev invoked

Generating components via 21st.dev Magic...
Applying premium-web-design scroll patterns...
Running npm run build... clean
Ready for review.
```

And a health snapshot (`/healthcheck` verifies the install against what ships here):

```
System Health Check

  System              | Status | Detail
  --------------------|--------|-------------------------------
  CARL routing        | OK     | 10 domains configured
  Specialist agents   | OK     | 25 agent definitions present
  Skills              | OK     | 28 skills (9 original + 19 gs-*)
  Slash commands      | OK     | 108 command files indexed
  Hooks               | OK     | 7 hook scripts wired
  MCP servers         | OK     | 4 default (Playwright/GitHub/Exa/21st.dev)
  effortLevel         | OK     | high (self-healing enforced)
  Settings JSON       | OK     | valid
```

---

## What ships in this repository

Verified counts of the components vendored in this repo (not post-install totals --
see "On the numbers" below):

| Component | Count | Examples |
|-----------|------:|----------|
| Specialist agents | 25 | architect, code-reviewer, security-reviewer, tdd-guide, database-reviewer, build-error-resolver, doc-updater, planner, refactor-cleaner, seo-* |
| Skills | 28 | 9 original (premium-web-design, graphify, 21st-dev-magic, autoresearch, dream-consolidation, graphic-design-studio, impeccable, fireworks-tech-graph, instagram-access) + 19 gstack-derived `gs-*` |
| Slash commands | 108 files | 45 top-level + the `paul/`, `seed/`, and `autoresearch/` command suites |
| Automation hooks | 7 | carl-hook.py, session-start-check, session-end-save, post-compact-recovery, project-auto-graph, peers-auto-register, task-complete-sound |
| CARL rule domains | 10 | GLOBAL, DEVELOPMENT, WEB-DEVELOPMENT, DOCUMENT-CREATION, RESEARCH-OSINT, DEPLOYMENT, LEGAL, BROWSER, PROJECT-NAVIGATION, GSTACK-INTEGRATED |
| Default MCP servers | 4 | Playwright, GitHub, Exa web-search, 21st.dev Magic (wired into settings, extensible) |

Plus the three routing registries (CARL config, CAPABILITY-REGISTRY,
COMMAND-REGISTRY), an orchestration engine, CLAUDE.md / PRIMER templates, and a
`.env` template listing every API key name (no secrets are shipped).

### On the numbers

This repository is the **routing brain and a curated core**, not a dump of a
thousand skills. The full running environment is larger than the repo because the
installer also pulls in established open-source marketplaces (oh-my-claudecode,
PAUL, SEED, and Claude Code community plugins). Those are third-party, installed
from their own official sources, and are **not** vendored here -- so the counts
above reflect only what Apex itself provides. Any larger aggregate is "environment
after optional plugins," and depends on whatever those upstream projects ship at
install time, so it is deliberately not claimed here as a fixed number.

---

## MCP integration

Apex wires a default set of MCP servers into `settings.json` and routes prompts to
them automatically through the capability registry:

- **Playwright** -- browser automation, E2E testing, visual capture
- **GitHub** -- PRs, issues, repository operations
- **Exa web-search** -- semantic web research and data ingestion
- **21st.dev Magic** -- generate React + TypeScript + Tailwind UI components from
  natural language

API keys are referenced as `${VAR}` and resolved from `~/.claude/.env`; nothing is
hard-coded. The set is extensible -- add a server to `settings.json` and a routing
rule to the capability registry and it joins the auto-activation flow. Optional
plugins (e.g. context7 for library docs) add more servers when enabled.

---

## What is inside

| Layer / System | What it does | How you use it |
|----------------|--------------|----------------|
| **CARL** | Just-in-time rule injection -- loads only the rules relevant to your prompt | Automatic -- `carl-hook.py` matches keywords on every UserPromptSubmit |
| **CAPABILITY-REGISTRY** | Task-pattern routing -- "build website" -> skills + MCP + agents | Automatic -- read at session start, consulted per task |
| **COMMAND-REGISTRY** | Intent routing -- user intent -> the right slash commands | Automatic -- commands mapped to intent keywords |
| **OMC** (oh-my-claudecode) | Multi-agent orchestration (installed upstream) | `autopilot: [task]` for autonomous execution |
| **PAUL** framework | Structured Plan-Apply-Unify execution loop | `/paul:plan` -> `/paul:apply` -> `/paul:unify` |
| **SEED** | Project incubator -- idea to structured plan | `/seed` to start guided brainstorming |
| **Autoresearch** | Autonomous optimize-measure-keep loops on any metric | `/autoresearch` |
| **Premium Web Design** | Curated luxury animation patterns + reference analyses | Auto-activates on "premium", "luxury", "animation" |
| **21st.dev Magic MCP** | Generate React+TS+Tailwind components from language | Auto-activates on "component", "ui", "generate" |
| **Graphify** | Knowledge-graph navigation -- big token savings vs raw file reads | Auto-activates on "where is X", "how does X work" |
| **Specialist agents** | 25 agents (architect, security, TDD, reviewers, SEO, ...) | Referenced by name or auto-selected per task |
| **Health monitor** | Verifies the install against what ships | `/healthcheck` |

---

## Before vs after

| Capability | Without Apex | With Apex |
|-----------|--------------|-----------|
| Tool activation | You manually pick skills/agents | 3-layer routing activates the right tools from natural language |
| Rule management | All rules loaded every session | CARL loads rules just-in-time by intent (saves tokens) |
| Execution structure | Plans drift | PAUL enforces Plan-Apply-Unify with quality gates |
| Memory hygiene | Grows forever, gets stale | Dream consolidates between sessions |
| Codebase navigation | Raw file reads | Graphify graph queries (far cheaper per lookup) |
| Component generation | Copy-paste from docs | 21st.dev Magic generates React+TS+Tailwind from language |
| Agents | 0 custom specialists | 25 specialists, plus more via optional plugins |
| Health monitoring | No way to check | `/healthcheck` verifies the install |

---

## Who it is for

- **Claude Code users who have outgrown the default setup** and want structured
  execution, memory, and specialist agents without wiring it all by hand.
- **Engineers who want auto-routing** -- describe the task in plain language and let
  the environment load the right skills, agents, and MCP servers.
- **People new to Claude Code** -- the beginner track in `docs/` assumes zero
  terminal experience and walks from install to first build.

It runs on Windows, macOS, and Linux.

---

## Install

### Option 1 -- ask your Claude Code (easiest)

Paste this into a Claude Code session:

```
Clone https://github.com/YousefNabil-SOC/claude-apex and install it to my Claude
Code environment. Read CLAUDE.md in the repo for instructions. Back up my existing
config first.
```

### Option 2 -- one command (macOS / Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/YousefNabil-SOC/claude-apex/master/install.sh | bash
```

### Option 3 -- one command (Windows PowerShell)

```powershell
irm https://raw.githubusercontent.com/YousefNabil-SOC/claude-apex/master/install.ps1 | iex
```

### Option 4 -- interactive (all platforms)

```bash
git clone https://github.com/YousefNabil-SOC/claude-apex.git
cd claude-apex
bash install-interactive.sh
```

### Post-install -- pull in the community plugins (optional, recommended)

Run these in Claude Code after installing to add the upstream marketplaces Apex
routes to:

```
/plugin marketplace add https://github.com/anthropic-community/everything-claude-code
/plugin install everything-claude-code

/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
/plugin install oh-my-claudecode
/oh-my-claudecode:omc-setup
```

Without these you get the core Apex experience; with them you get the full
plugin-extended environment.

### Verify

```bash
cd claude-apex
bash verify.sh
```

`verify.sh` checks agents, commands, hooks, skills, configuration, MCP servers,
third-party tools, backup status, and conflicts. Full step-by-step in
[INSTALL.md](INSTALL.md).

---

## Safety and compatibility

- **Non-destructive.** A timestamped backup of `~/.claude/` is made before any change.
- **Never overwrites.** Existing agents, skills, and files are skipped, not replaced.
- **Settings are merged, not replaced.** Apex adds MCP servers and hooks to your
  existing configuration without removing anything.
- **No secrets shipped.** You supply your own keys via `~/.claude/.env`; `.gitignore`
  enforces `.env` exclusion. See [SECURITY.md](SECURITY.md).
- **Reversible.** `uninstall.sh` restores your backup.

---

## Documentation

A tiered index so teammates at any level can navigate. Every link points to a file
that ships in this repo's `docs/`.

### Tier 1 -- new to Claude Code (start here)

| Doc | Covers |
|-----|--------|
| [00-START-HERE](docs/00-START-HERE.md) | What this is, no prior experience assumed |
| [01-WHAT-IS-CLAUDE-CODE](docs/01-WHAT-IS-CLAUDE-CODE.md) | Claude, Anthropic, CLI, terminal, context, tokens |
| [02-INSTALL-FROM-ZERO](docs/02-INSTALL-FROM-ZERO.md) | Every step from a brand-new machine to running Apex |
| [03-FIRST-TIME-USING](docs/03-FIRST-TIME-USING.md) | First commands, with expected output |
| [04-WHAT-ARE-SKILLS](docs/04-WHAT-ARE-SKILLS.md) | Skills explained |
| [05-WHAT-ARE-AGENTS](docs/05-WHAT-ARE-AGENTS.md) | Agents explained |
| [06-WHAT-ARE-MCP-SERVERS](docs/06-WHAT-ARE-MCP-SERVERS.md) | MCP servers explained |
| [07-WHAT-ARE-HOOKS](docs/07-WHAT-ARE-HOOKS.md) | Hooks explained |
| [08-WHAT-IS-CARL](docs/08-WHAT-IS-CARL.md) | CARL just-in-time rule routing |
| [09-GLOSSARY](docs/09-GLOSSARY.md) | Key terms |
| [10-TROUBLESHOOT-FOR-BEGINNERS](docs/10-TROUBLESHOOT-FOR-BEGINNERS.md) | Common beginner problems |

### Tier 2 -- comfortable, going deeper

| Doc | Description |
|-----|-------------|
| [GETTING-STARTED](docs/GETTING-STARTED.md) | Quick start after install |
| [ARCHITECTURE](docs/ARCHITECTURE.md) | Three-layer routing in depth |
| [AGENTS-GUIDE](docs/AGENTS-GUIDE.md) | The agents and model routing |
| [CARL-GUIDE](docs/CARL-GUIDE.md) | All 10 domains and routing examples |
| [PAUL-INTEGRATION](docs/PAUL-INTEGRATION.md) | Plan-Apply-Unify execution |
| [OMC-INTEGRATION](docs/OMC-INTEGRATION.md) | autopilot, ralph, team modes |
| [MEMORY-SYSTEM](docs/MEMORY-SYSTEM.md) | Auto memory and Dream consolidation |
| [ORCHESTRATION](docs/ORCHESTRATION.md) | Decision tree for routing tasks |
| [PEERS-SETUP](docs/PEERS-SETUP.md) | Multi-terminal coordination |
| [CUSTOMIZATION](docs/CUSTOMIZATION.md) | Add your own agents, skills, rules |
| [GSTACK-INTEGRATION](docs/GSTACK-INTEGRATION.md) | The gstack-derived gs-* skills |
| [WINDOWS-GUIDE](docs/WINDOWS-GUIDE.md) | Windows-specific setup |
| [TROUBLESHOOTING](docs/TROUBLESHOOTING.md) | Common issues and fixes |
| [FAQ](docs/FAQ.md) | Frequently asked questions |
| [UNINSTALL](docs/UNINSTALL.md) | Clean removal |

### Tier 3 -- building on top of Apex

| Doc | Description |
|-----|-------------|
| [ADVANCED-CUSTOMIZATION](docs/ADVANCED-CUSTOMIZATION.md) | Custom CARL domains, agents, skills, MCP, hooks |
| [ADVANCED-TOKEN-OPTIMIZATION](docs/ADVANCED-TOKEN-OPTIMIZATION.md) | Cut token usage without losing capability |
| [ADVANCED-MULTI-SESSION](docs/ADVANCED-MULTI-SESSION.md) | Peers, agent teams, session handoff |
| [ADVANCED-BUILDING-WEBSITES](docs/ADVANCED-BUILDING-WEBSITES.md) | premium-web-design + 21st.dev, the full stack |

---

## Credits and license

Apex is original integration and routing work -- CARL, the three registries, the
agents, the hooks, and the documentation -- built on top of, and crediting, several
open-source projects. The 19 `gs-*` skills are renamed derivatives of
[gstack](https://github.com/garrytan/gstack) by Garry Tan (MIT); the installer pulls
in [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode),
[PAUL](https://github.com/ChristopherKahler/paul),
[SEED](https://github.com/ChristopherKahler/seed), and
[21st.dev](https://21st.dev/). Full attribution is in
[ATTRIBUTIONS.md](ATTRIBUTIONS.md) and [docs/GSTACK-INTEGRATION.md](docs/GSTACK-INTEGRATION.md).

Created and maintained by **Yousef Nabil** ([@YousefNabil-SOC](https://github.com/YousefNabil-SOC)).

Licensed under the MIT License -- see [LICENSE](LICENSE).
