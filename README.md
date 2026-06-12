<div align="center">

# Claude Apex

### A three-layer auto-routing environment for Claude Code

**The public mirror and installer of a working, battle-tested Claude Code setup.**
Describe a task in plain language; Apex activates the right rules, skills, agents, and
MCP servers automatically -- no slash command required.

![version](https://img.shields.io/badge/version-8.0.0-6f42c1?style=for-the-badge)
![license](https://img.shields.io/badge/license-MIT-1f883d?style=for-the-badge)
![platform](https://img.shields.io/badge/Windows%20%7C%20macOS%20%7C%20Linux-0969da?style=for-the-badge)

![skills](https://img.shields.io/badge/skills-1%2C276-6f42c1)
![agents](https://img.shields.io/badge/agents-185-0969da)
![commands](https://img.shields.io/badge/commands-235-1f883d)
![MCP servers](https://img.shields.io/badge/MCP%20servers-6-cf222e)
![CARL domains](https://img.shields.io/badge/CARL%20domains-10-bf8700)
![auto-routing](https://img.shields.io/badge/auto--routing-3%20layers-fb8500)

</div>

---

## What it is

A vanilla Claude Code install is stateless and ad-hoc: a few skills, default settings,
no custom agents, no memory between sessions, no structured execution. **Apex is the
public mirror and installer of my own daily-driver Claude Code environment** -- a
routing brain plus a large, curated toolset that configures itself per task instead of
being driven by hand.

It is built for the world AI-coding agents actually live in -- Claude Code, and the
MCP servers, skills, and sub-agents that extend it -- so the environment loads exactly
what each task needs, the moment it needs it.

---

## By the numbers (verified on disk)

These are the totals my live environment resolves to, counted directly from
`~/.claude` (skills = `SKILL.md` files; agents/commands = definition files):

| Resource | Count | Where it lives |
|----------|------:|----------------|
| **Skills** | **1,276** | `~/.claude/skills/` (plus ~300 more from installed marketplaces) |
| **Agents** | **185** | own + claude-flow / swarm + plugin agents (distinct) |
| **Slash commands** | **235** | own + plugin command suites (distinct) |
| **MCP servers** | **6** | Playwright, GitHub, Exa, 21st.dev Magic, Claude Video Vision, Scrapling -- extensible |
| **CARL rule domains** | **10** | just-in-time rule routing |
| **Enabled plugins** | **10** | from a wider set of installable marketplaces |

> **How to read these honestly.** This repository **vendors a curated original core**
> -- 28 skills (9 original + 19 gstack-derived `gs-*`), 25 specialist agents, 108
> command files, 7 hooks, and the routing brain (CARL + two registries). The larger
> totals above are what my **full installed environment** resolves to: the original
> core, plus the open Claude Code plugin/marketplace ecosystem the installer pulls in,
> plus skills I have collected and authored over time. Everything upstream is credited
> in [ATTRIBUTIONS.md](ATTRIBUTIONS.md). Clone the repo and you get the core + the
> installer; run it and connect the marketplaces and you approach the full set. Nothing
> here is invented -- the counts come from a real directory you can count yourself.

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

You never typed `/premium-web-design`, `/21st-dev-magic`, or `/feature-dev`. The system
read your sentence and activated all of them. The same routing handles code review,
debugging, deployment, document generation, research, and more.

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

A health snapshot (`/healthcheck` verifies the environment):

```
System Health Check

  System              | Status | Detail
  --------------------|--------|-------------------------------
  CARL routing        | OK     | 10 domains configured
  Skills              | OK     | 1,276 in ~/.claude/skills
  Agents              | OK     | 185 available
  Slash commands      | OK     | 235 indexed
  MCP servers         | OK     | 6 wired (Playwright/GitHub/Exa/21st.dev/Video/Scrapling)
  effortLevel         | OK     | high (self-healing enforced)
  Settings JSON       | OK     | valid
```

---

## MCP integration -- agents that reach real tools

Apex wires MCP servers into `settings.json` and routes prompts to them automatically
through the capability registry. This is the same surface modern AI-coding agents
(Claude Code, Cursor, Codex) plug into -- MCP is how an agent reaches the outside world.

| MCP server | What it gives the agent |
|------------|-------------------------|
| **Playwright** | Browser automation, E2E testing, visual capture |
| **GitHub** | PRs, issues, repository operations |
| **Exa web-search** | Semantic web research and data ingestion |
| **21st.dev Magic** | Generate React + TS + Tailwind UI from natural language |
| **Claude Video Vision** | Frame-level video understanding |
| **Scrapling** | Resilient, stealth web scraping |

API keys are referenced as `${VAR}` and resolved from `~/.claude/.env` -- nothing is
hard-coded. Add a server to `settings.json` plus a capability-registry rule and it joins
the auto-activation flow.

---

<details>
<summary><b>What is inside (click to expand)</b></summary>

<br>

| Layer / System | What it does | How you use it |
|----------------|--------------|----------------|
| **CARL** | Just-in-time rule injection -- loads only the rules relevant to your prompt | Automatic -- `carl-hook.py` on every UserPromptSubmit |
| **CAPABILITY-REGISTRY** | Task-pattern routing -- "build website" -> skills + MCP + agents | Automatic -- consulted per task |
| **COMMAND-REGISTRY** | Intent routing -- user intent -> the right slash commands | Automatic -- commands mapped to intent keywords |
| **OMC** (oh-my-claudecode) | Multi-agent orchestration | `autopilot: [task]` for autonomous execution |
| **claude-flow / swarm** | Large agent fleet for hierarchical/parallel work | Routed for multi-agent tasks |
| **PAUL** framework | Structured Plan-Apply-Unify execution loop | `/paul:plan` -> `/paul:apply` -> `/paul:unify` |
| **SEED** | Project incubator -- idea to structured plan | `/seed` |
| **Autoresearch** | Autonomous optimize-measure-keep loops | `/autoresearch` |
| **Premium Web Design** | Curated luxury animation patterns + references | Auto-activates on "premium", "luxury", "animation" |
| **21st.dev Magic MCP** | Generate React+TS+Tailwind components | Auto-activates on "component", "ui", "generate" |
| **Graphify** | Knowledge-graph navigation -- big token savings vs raw file reads | Auto-activates on "where is X" |
| **Specialist agents** | architect, security, TDD, reviewers, SEO, and more | By name or auto-selected |
| **Health monitor** | Verifies the environment | `/healthcheck` |

</details>

<details>
<summary><b>Before vs after (click to expand)</b></summary>

<br>

| Capability | Without Apex | With Apex |
|-----------|--------------|-----------|
| Tool activation | You manually pick skills/agents | 3-layer routing activates the right tools from natural language |
| Rule management | All rules loaded every session | CARL loads rules just-in-time by intent (saves tokens) |
| Execution structure | Plans drift | PAUL enforces Plan-Apply-Unify with quality gates |
| Memory hygiene | Grows forever, gets stale | Dream consolidates between sessions |
| Codebase navigation | Raw file reads | Graphify graph queries (far cheaper per lookup) |
| Component generation | Copy-paste from docs | 21st.dev Magic generates from language |
| Agents | 0 custom specialists | 185 available across the environment |
| Health monitoring | No way to check | `/healthcheck` |

</details>

---

## Install

> **Prerequisites:** Claude Code installed, plus `git` and `bash`. The installer is
> **non-destructive** -- it backs up your existing `~/.claude/` first, never overwrites
> files you already have, and ships an uninstaller.

### Option 1 -- ask your Claude Code (easiest, recommended)

**Step 1** -- paste this into a Claude Code session:

```
Clone https://github.com/YousefNabil-SOC/claude-apex and install it to my Claude
Code environment. Read CLAUDE.md in the repo for instructions. Back up my existing
config first.
```

Wait for it to finish, then restart Claude Code.

**Step 2** -- open a fresh session and paste this to pull in the community plugin set:

```
Complete the Apex setup:
1. /plugin marketplace add https://github.com/anthropic-community/everything-claude-code
2. /plugin install everything-claude-code
3. /plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
4. /plugin install oh-my-claudecode
5. /oh-my-claudecode:omc-setup
6. /healthcheck   (verify everything is green)
```

<details>
<summary><b>Option 2 -- one command (macOS / Linux)</b></summary>

```bash
curl -fsSL https://raw.githubusercontent.com/YousefNabil-SOC/claude-apex/master/install.sh | bash
```
</details>

<details>
<summary><b>Option 3 -- one command (Windows PowerShell)</b></summary>

```powershell
irm https://raw.githubusercontent.com/YousefNabil-SOC/claude-apex/master/install.ps1 | iex
```
</details>

<details>
<summary><b>Option 4 -- interactive (all platforms)</b></summary>

```bash
git clone https://github.com/YousefNabil-SOC/claude-apex.git
cd claude-apex
bash install-interactive.sh
```
</details>

### Verify

```bash
cd claude-apex
bash verify.sh
```

`verify.sh` runs 30+ checks across agents, commands, hooks, skills, configuration, MCP
servers, third-party tools, backup status, and conflicts. Full walkthrough in
[INSTALL.md](INSTALL.md).

<details>
<summary><b>What gets installed (click to expand)</b></summary>

<br>

**From this repository (original work):**
- 25 specialist agent definitions
- ~45 top-level commands + the `paul/`, `seed/`, and `autoresearch/` suites
- 7 hook scripts (carl-hook.py, session-start-check, session-end-save, post-compact-recovery, project-auto-graph, peers-auto-register, task-complete-sound)
- 9 original skills (premium-web-design, graphify, 21st-dev-magic, autoresearch, dream-consolidation, graphic-design-studio, impeccable, fireworks-tech-graph, instagram-access)
- 19 gstack-derived `gs-*` skills (MIT -- see ATTRIBUTIONS.md)
- CARL configuration (10 domains), CAPABILITY-REGISTRY, COMMAND-REGISTRY, orchestration engine
- CLAUDE.md / PRIMER templates and a `.env` template (key names only, no secrets)

**Pulled from their official sources (third-party, open source, credited):**
- [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode), [PAUL](https://github.com/ChristopherKahler/paul), [SEED](https://github.com/ChristopherKahler/seed), the everything-claude-code marketplace, and more.

This split is why the repo shows a curated core while the running environment resolves
to the larger totals at the top.

</details>

---

## Documentation -- three tiers

Pick your level. Every link points to a file that ships in this repo's `docs/`.

<details open>
<summary><b>Tier 1 -- new to Claude Code (start here)</b></summary>

<br>

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

</details>

<details>
<summary><b>Tier 2 -- intermediate (comfortable, going deeper)</b></summary>

<br>

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

</details>

<details>
<summary><b>Tier 3 -- advanced (building on top of Apex)</b></summary>

<br>

| Doc | Description |
|-----|-------------|
| [ADVANCED-CUSTOMIZATION](docs/ADVANCED-CUSTOMIZATION.md) | Custom CARL domains, agents, skills, MCP, hooks |
| [ADVANCED-TOKEN-OPTIMIZATION](docs/ADVANCED-TOKEN-OPTIMIZATION.md) | Cut token usage without losing capability |
| [ADVANCED-MULTI-SESSION](docs/ADVANCED-MULTI-SESSION.md) | Peers, agent teams, session handoff |
| [ADVANCED-BUILDING-WEBSITES](docs/ADVANCED-BUILDING-WEBSITES.md) | premium-web-design + 21st.dev, the full stack |

</details>

---

## Safety and compatibility

- **Non-destructive.** A timestamped backup of `~/.claude/` is made before any change.
- **Never overwrites.** Existing agents, skills, and files are skipped, not replaced.
- **Settings are merged, not replaced.** Apex adds MCP servers and hooks without removing anything.
- **No secrets shipped.** You supply your own keys via `~/.claude/.env`; `.gitignore` enforces `.env` exclusion. See [SECURITY.md](SECURITY.md).
- **Reversible.** `uninstall.sh` restores your backup.

---

## Credits and license

Apex is original integration and routing work -- CARL, the two registries, the agents,
the hooks, and the documentation -- built on top of, and crediting, the open Claude Code
ecosystem. The 19 `gs-*` skills are renamed derivatives of
[gstack](https://github.com/garrytan/gstack) by Garry Tan (MIT); the installer pulls in
[oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode),
[PAUL](https://github.com/ChristopherKahler/paul),
[SEED](https://github.com/ChristopherKahler/seed),
[21st.dev](https://21st.dev/), and the community marketplaces. Full attribution is in
[ATTRIBUTIONS.md](ATTRIBUTIONS.md) and [docs/GSTACK-INTEGRATION.md](docs/GSTACK-INTEGRATION.md).

Created and maintained by **Yousef Nabil** ([@YousefNabil-SOC](https://github.com/YousefNabil-SOC)).

Licensed under the MIT License -- see [LICENSE](LICENSE).
