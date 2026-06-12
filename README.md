# Claude Apex

**A three-layer auto-routing environment for Claude Code.**

Apex turns a default Claude Code install into a structured, self-routing workspace:
it reads your natural-language prompt and activates the right rules, skills, agents,
and MCP servers automatically -- no slash command required. It ships a curated core
of original tooling and an installer that composes cleanly with the wider Claude Code
plugin ecosystem.

![version](https://img.shields.io/badge/version-8.0.0-blue)
![license](https://img.shields.io/badge/license-MIT-green)
![platform](https://img.shields.io/badge/platform-Windows%20%7C%20Mac%20%7C%20Linux-lightgrey)
![routing](https://img.shields.io/badge/auto--routing-3%20layers-orange)

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

## What ships in this repository

These are the components vendored in this repo (verified counts, not post-install
totals -- see "On the numbers" below):

| Component | Count | Examples |
|-----------|------:|----------|
| Specialist agents | 25 | architect, code-reviewer, security-reviewer, tdd-guide, database-reviewer, build-error-resolver, doc-updater, seo-* |
| Skills | 28 | 9 original (premium-web-design, graphify, 21st-dev-magic, autoresearch, dream-consolidation, ...) + 19 gstack-derived `gs-*` |
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
above reflect only what Apex itself provides. Treat any larger aggregate as
"environment after optional plugins," which depends on whatever those upstream
projects ship at install time.

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
rule to the capability registry and it joins the auto-activation flow. Additional
servers (e.g. context7 for library docs) ship as optional plugins.

---

## Who it is for

- **Claude Code users who have outgrown the default setup** and want structured
  execution, memory, and specialist agents without wiring it all by hand.
- **Engineers who want auto-routing** -- describe the task in plain language and let
  the environment load the right skills, agents, and MCP servers.
- **People new to Claude Code** -- the `docs/00-START-HERE.md` track assumes zero
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

### Verify

```bash
cd claude-apex
bash verify.sh
```

`verify.sh` checks agents, commands, hooks, skills, configuration, MCP servers,
third-party tools, backup status, and conflicts. For the full plugin set, see the
post-install plugin commands in [INSTALL.md](INSTALL.md).

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
