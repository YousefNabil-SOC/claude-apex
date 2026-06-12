<div align="center">

<img src="https://readme-typing-svg.demolab.com/?font=JetBrains+Mono&weight=600&size=22&duration=2800&pause=900&color=A371F7&center=true&vCenter=true&width=760&height=55&lines=1%2C276+Skills+-+185+Agents+-+235+Commands;Three-Layer+Auto-Routing+for+Claude+Code;8+MCP+Servers%2C+Wired+and+Extensible;Install+in+Minutes+-+Built+to+be+Taught" alt="Claude Apex" />

# Claude Apex

### A three-layer auto-routing environment for Claude Code

**The public mirror -- and the teaching install -- of a working, battle-tested setup.**
Describe a task in plain language; Apex activates the right rules, skills, agents, and
MCP servers automatically. No slash command required.

![version](https://img.shields.io/badge/version-8.0.0-6f42c1?style=for-the-badge)
![license](https://img.shields.io/badge/license-MIT-1f883d?style=for-the-badge)
![platform](https://img.shields.io/badge/Windows%20%7C%20macOS%20%7C%20Linux-0969da?style=for-the-badge)

![skills](https://img.shields.io/badge/skills-1%2C276-6f42c1)
![agents](https://img.shields.io/badge/agents-185-0969da)
![commands](https://img.shields.io/badge/commands-235-1f883d)
![MCP servers](https://img.shields.io/badge/MCP%20servers-8%20wired-cf222e)
![CARL domains](https://img.shields.io/badge/CARL%20domains-10-bf8700)
![auto-routing](https://img.shields.io/badge/auto--routing-3%20layers-fb8500)

[Install](#install) -
[Proof of concept](#proof-of-concept) -
[How it works](#how-it-works) -
[Docs](#documentation) -
[Make it yours](#make-it-yours)

</div>

---

## What it is

A vanilla Claude Code install is stateless and ad-hoc: a few skills, default settings,
no custom agents, no memory between sessions, no structured execution. **Apex is the
public mirror, and the step-by-step install, of my own daily-driver Claude Code
environment** -- a routing brain plus a large, curated toolset that configures itself
per task instead of being driven by hand.

It targets the world AI-coding agents actually live in -- Claude Code, plus the MCP
servers, skills, and sub-agents that extend it -- so the environment loads exactly what
each task needs, the moment it needs it. The goal of this README is not just to show you
what I built: it is to teach you to run the same environment yourself, and then extend it.

---

## By the numbers (verified on disk)

These are the totals my live environment resolves to, counted directly from
`~/.claude` (skills = `SKILL.md` files; agents/commands = definition files):

| Resource | Count | Where it lives |
|----------|------:|----------------|
| **Skills** | **1,276** | `~/.claude/skills/` (the clean floor; hundreds more across projects + marketplaces) |
| **Agents** | **185** | own + claude-flow / swarm + plugin agents (distinct) |
| **Slash commands** | **235** | own + plugin command suites (distinct) |
| **MCP servers** | **8 wired** | Playwright, GitHub, Exa, 21st.dev Magic, Claude Video Vision, Scrapling, context7, claude-flow |
| **+ connectors** | **4** | Canva, Gmail, Google Calendar, Google Drive (account connectors) |
| **+ installable** | **~15** | asana, discord, firebase, gitlab, linear, telegram, serena, terraform, greptile, ... from marketplaces |
| **CARL rule domains** | **10** | just-in-time rule routing |

> **How to read these honestly.** This repository **vendors a curated original core**
> -- 28 skills (9 original + 19 gstack-derived `gs-*`), 25 specialist agents, 108
> command files, 7 hooks, and the routing brain (CARL + two registries). The larger
> totals are what my **full installed environment** resolves to: the original core,
> plus the open Claude Code plugin/marketplace ecosystem the installer pulls in, plus
> skills I have collected and authored over time. Everything upstream is credited in
> [ATTRIBUTIONS.md](ATTRIBUTIONS.md). Clone the repo and you get the core + the
> installer; follow the walkthrough below and you build the rest. Nothing here is
> invented -- the counts come from a real directory you can count yourself with one
> command (shown below).

<details>
<summary><b>Count it yourself (copy/paste)</b></summary>

<br>

```bash
# skills in your environment
find ~/.claude/skills -name SKILL.md | wc -l
# distinct agents
find ~/.claude -path '*/agents/*.md' ! -name README.md | xargs -n1 basename | sort -u | wc -l
# wired MCP servers (from settings + project configs)
grep -ro '"mcpServers"' ~/.claude.json ~/.claude/settings.json | wc -l
```
</details>

---

## Proof of concept

These are real prompts. Paste any one into a Claude Code session running Apex and watch
the three layers fire -- no slash command typed. Each one exercises a different part of
the environment.

<details open>
<summary><b>1. Build a UI from a sentence</b></summary>

```
> build me a premium pricing page with scroll-reveal animations
```
```
Layer 1 (CARL):    WEB-DEVELOPMENT + DEVELOPMENT rules injected
Layer 2 (REGISTRY): premium-web-design + react/tailwind skills,
                    21st.dev Magic + Playwright MCP servers
Layer 3 (COMMAND):  /feature-dev -> (later) /code-review
=> components generated, scroll patterns applied, npm run build clean
```
</details>

<details>
<summary><b>2. Review a pull request, adversarially</b></summary>

```
> review this branch for bugs and security issues
```
```
CARL routes GSTACK-INTEGRATED -> gs-review (staff-eng review) + gs-cso (OWASP/STRIDE)
+ the security-reviewer and code-reviewer agents, with findings verified before report.
```
</details>

<details>
<summary><b>3. Debug by root cause, not guesswork</b></summary>

```
> why is the webhook handler dropping events under load?
```
```
CARL -> gs-investigate (scientific-method debugging): reproduce -> hypothesize ->
instrument -> isolate -> fix, with the debugger agent and a written root-cause note.
```
</details>

<details>
<summary><b>4. Research with citations, then write the doc</b></summary>

```
> research OAuth 2.0 device-code flow for CRM connectors and draft the integration doc
```
```
CARL RESEARCH-OSINT -> Exa MCP (semantic search) + context7 MCP (library docs),
cross-referenced, then gs-doc-generate writes a Diataxis-structured doc.
```
</details>

<details>
<summary><b>5. Navigate a codebase for ~1/10th the tokens</b></summary>

```
> where is the auth middleware and how does session refresh work?
```
```
CARL PROJECT-NAVIGATION -> Graphify queries the knowledge graph (~1k tokens)
instead of raw file reads (~10k+), then answers with exact file:line.
```
</details>

---

## How it works

**The core innovation: three-layer auto-routing.** You describe the task; Apex assembles
the stack.

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
read your sentence and activated all of them.

---

## MCP integration -- agents that reach real tools

MCP is how an AI-coding agent reaches the outside world. Apex wires MCP servers into
`settings.json` and routes prompts to them automatically -- the same surface Claude Code,
Cursor, and Codex plug into.

| MCP server | What it gives the agent |
|------------|-------------------------|
| **Playwright** | Browser automation, E2E testing, visual capture |
| **GitHub** | PRs, issues, repository operations |
| **Exa web-search** | Semantic web research and data ingestion |
| **21st.dev Magic** | Generate React + TS + Tailwind UI from natural language |
| **Claude Video Vision** | Frame-level video understanding |
| **Scrapling** | Resilient, stealth web scraping |
| **context7** | Up-to-date library/framework documentation |
| **claude-flow** | Multi-agent swarm orchestration |

Plus account connectors (Canva, Gmail, Google Calendar, Google Drive) and ~15 more
installable from the marketplaces (asana, discord, firebase, gitlab, linear, telegram,
serena, terraform, ...). Keys are referenced as `${VAR}` and resolved from
`~/.claude/.env` -- nothing is hard-coded.

---

## Install

The aim here is not "run this and hope." It is: **understand each step, end up with the
same environment I run, and know how to extend it.** Pick the path that fits you.

> **Prerequisites**
> - **Claude Code** installed and working (run `claude` once).
> - **git** and **bash** (built in on macOS/Linux; on Windows use Git Bash or WSL).
> - That is all. No API keys are required to install -- you add your own later, only for
>   the MCP servers you actually want.
>
> **What the installer guarantees**
> - It **backs up** your entire `~/.claude/` to a timestamped folder first.
> - It **never overwrites** a file you already have (your agents/skills stay yours).
> - It **merges** settings -- it adds MCP servers and hooks, it removes nothing.
> - It ships an **uninstaller** that restores your backup in one command.

### Path A -- let Claude Code install it (recommended for everyone)

This is the fastest path and the best demonstration of the environment: you ask in
plain English, and Claude Code does the work.

**Step 1.** Open Claude Code and paste this. It clones, reads the repo's own
instructions, backs you up, and installs:

```
Clone https://github.com/YousefNabil-SOC/claude-apex and install it into my Claude
Code environment. Read CLAUDE.md in the repo and follow it exactly. Back up my
existing ~/.claude first, and do not overwrite anything I already have.
```

When it finishes, **restart Claude Code** (close and reopen the session) so the new
hooks and settings load.

**Step 2.** In a fresh session, paste this to pull in the community plugin set -- this is
where the bulk of the 1,276 skills and 185 agents come from:

```
Finish my Claude Apex setup:
1. /plugin marketplace add https://github.com/anthropic-community/everything-claude-code
2. /plugin install everything-claude-code
3. /plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
4. /plugin install oh-my-claudecode
5. /oh-my-claudecode:omc-setup
6. /healthcheck     (confirm every system reports OK)
```

> **Tip.** If `/healthcheck` flags anything, paste the exact line back to Claude Code and
> say "fix this." The environment is self-healing by design.

### Path B -- one command (you prefer the terminal)

<details>
<summary><b>macOS / Linux</b></summary>

```bash
curl -fsSL https://raw.githubusercontent.com/YousefNabil-SOC/claude-apex/master/install.sh | bash
```
</details>

<details>
<summary><b>Windows (PowerShell)</b></summary>

```powershell
irm https://raw.githubusercontent.com/YousefNabil-SOC/claude-apex/master/install.ps1 | iex
```
</details>

<details>
<summary><b>Interactive (asks before each step)</b></summary>

```bash
git clone https://github.com/YousefNabil-SOC/claude-apex.git
cd claude-apex
bash install-interactive.sh
```
</details>

### Step 3 -- turn on the MCP servers you want

MCP servers need their own keys. Copy the template and fill in only the ones you use:

```bash
cp ~/.claude/.env.template ~/.claude/.env
# then edit ~/.claude/.env -- e.g. GITHUB_PERSONAL_ACCESS_TOKEN, EXA_API_KEY,
# TWENTY_FIRST_DEV_API_KEY -- leave the rest blank; unused servers simply stay off.
```

> **Why it is safe.** No key is ever committed: `.gitignore` excludes `.env`, and the repo
> ships only the template (variable names, no values). See [SECURITY.md](SECURITY.md).

### Step 4 -- verify

```bash
cd claude-apex
bash verify.sh
```

`verify.sh` runs 30+ checks across agents, commands, hooks, skills, configuration, MCP
servers, third-party tools, backup status, and conflict detection. Green across the
board means your environment matches mine. Full walkthrough: [INSTALL.md](INSTALL.md).

<details>
<summary><b>What exactly gets installed (transparency)</b></summary>

<br>

**From this repository (original work):** 25 specialist agents; ~45 top-level commands
plus the `paul/`, `seed/`, `autoresearch/` suites; 7 hook scripts; 9 original skills; 19
gstack-derived `gs-*` skills (MIT); CARL config (10 domains), CAPABILITY-REGISTRY,
COMMAND-REGISTRY, orchestration engine; CLAUDE.md / PRIMER templates; a `.env` template
(key names only).

**Pulled from official sources (third-party, open source, credited):**
[oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode),
[PAUL](https://github.com/ChristopherKahler/paul),
[SEED](https://github.com/ChristopherKahler/seed), the everything-claude-code
marketplace, and the MCP servers above. This split is why the repo shows a curated core
while the running environment resolves to the larger totals.

</details>

---

## Make it yours

The environment is meant to be extended. Here is the whole pattern.

<details>
<summary><b>Add a skill</b> (a reusable recipe Claude reads on demand)</summary>

<br>

```bash
mkdir -p ~/.claude/skills/my-skill
cat > ~/.claude/skills/my-skill/SKILL.md <<'EOF'
---
name: my-skill
description: One line on when this skill should fire.
---
# My Skill
Steps, examples, and rules go here. Claude loads this only when relevant.
EOF
```
Then add a recall keyword for it in `config/capability-registry.md` so the router knows
when to load it.
</details>

<details>
<summary><b>Add an agent</b> (a specialist sub-agent)</summary>

<br>

```bash
cat > ~/.claude/agents/my-reviewer.md <<'EOF'
---
name: my-reviewer
description: When to use this agent.
model: sonnet
tools: Read, Grep, Glob, Bash
---
You are a focused reviewer. Your job is ...
EOF
```
Apex auto-discovers it; reference it by name or let the registry select it per task.
</details>

<details>
<summary><b>Add an MCP server</b> (a new tool the agent can reach)</summary>

<br>

Add to `~/.claude/settings.json` under `mcpServers`, and one recall rule in the
capability registry:

```json
"mcpServers": {
  "my-server": {
    "command": "npx",
    "args": ["-y", "my-mcp-package"],
    "env": { "MY_API_KEY": "${MY_API_KEY}" }
  }
}
```
Put the real `MY_API_KEY` in `~/.claude/.env`. Done -- it joins the auto-activation flow.
</details>

---

## Documentation

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
