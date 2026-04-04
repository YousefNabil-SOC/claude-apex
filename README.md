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

**1,308 skills. 108 agents. One unified intelligence.**

*The absolute top of Claude Code.*

*Two months of continuous development. 15/15 health checks. Zero compromises.*

![Version](https://img.shields.io/badge/version-6.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Mac%20%7C%20Linux-lightgrey)
![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-purple)
![Health](https://img.shields.io/badge/health-15%2F15-brightgreen)

</div>

---

## What Is This?

Most Claude Code users run a vanilla setup — maybe a few skills, default settings, no custom agents. They're using 10% of what Claude Code can do. Every session starts cold. Every task is ad-hoc. There's no memory between sessions, no structured execution, no specialist agents, and no way to verify the system is even working.

**Claude Apex** is an enterprise-grade environment that took 2+ months to build, test, and integrate. It adds 25 specialist agents, 7 JIT rule domains, structured execution loops, memory consolidation, inter-terminal communication, and a decision engine that automatically routes any request to the right combination of tools. Every component was tested individually and as part of the whole. The system verifies itself with 15 automated health checks.

One-command install. Non-destructive — your existing setup stays intact. Everything is backed up before any changes. Works on Windows, Mac, and Linux.

---

## Quick Demo

After installing Apex, this is what `/healthcheck` looks like:

```
System Health Check V6

 #  | System              | Status | Details
----|---------------------|--------|--------------------------------
 1  | OMC Plugin          | OK     | oh-my-claudecode@omc enabled
 2  | Claude Peers        | OK     | Broker healthy, 1 peer
 3  | PAUL Framework      | OK     | 28 commands
 4  | Dream Skill         | OK     | SKILL.md present
 5  | CARL                | OK     | 7 domains configured
 6  | Autoresearch        | OK     | SKILL.md present
 7  | SEED                | OK     | seed.md present
 8  | PostCompact Hook    | OK     | V6 verified
 9  | Sound Notification  | OK     | Hook present
 10 | Peers Auto-Register | OK     | Hook present
 11 | Settings JSON       | OK     | Valid JSON
 12 | MCP Servers         | OK     | 12 servers
 13 | Skills Count        | OK     | 1,308 skills
 14 | Agents Count        | OK     | 25 agents
 15 | Memory Health       | OK     | 112 lines (limit: 200)

Result: 15/15 OK — all systems green
```

And this is autopilot mode in action:

```
> autopilot: explain this codebase

Activating autopilot pipeline...
  Stage 1: Expansion (reading project files)
  Stage 2: Planning (identifying key areas)
  Stage 3: Execution (analyzing with specialist agents)
  Stage 4: QA (verifying findings)
  Stage 5: Validation (architect review)

[Full structured analysis delivered in 48 seconds]
```

---

## The Numbers

| Resource | Count |
|----------|------:|
| Installed Skills | **1,308** |
| Available Agents | **108** (25 custom + 19 OMC + 60+ RuFlo + plugin agents) |
| MCP Servers | **12** |
| Plugins | **19** |
| Slash Commands | **107** |
| PAUL Execution Commands | **28** |
| CARL Rule Domains | **7** domains, **33** rules |
| Task Templates | **5** ready-to-use workflows |
| Automated Health Checks | **15** |
| Hook Scripts | **6** |
| Documentation Guides | **14** |

---

## What's Inside

| Layer | What It Does | How You Use It |
|-------|-------------|----------------|
| **OMC** (oh-my-claudecode) | Multi-agent orchestration with 19 specialized agents | `autopilot: [task]` for full autonomous execution |
| **PAUL** Framework | Structured Plan-Apply-Unify execution loop | `/paul:plan` → `/paul:apply` → `/paul:unify` |
| **CARL** | Just-In-Time rule loading — only relevant rules load | Automatic — rules activate by keyword detection |
| **Claude Peers** | Inter-terminal communication via localhost broker | Terminals auto-discover each other and exchange messages |
| **Auto Dream** | Memory consolidation between sessions | Say "consolidate memory" or trigger manually |
| **SEED** | Project incubator — idea to structured plan | `/seed` to start guided brainstorming |
| **Autoresearch** | Autonomous optimization loops | Modify → measure → keep/discard → repeat on any metric |
| **Orchestration Engine** | Decision brain — classifies requests, routes to right tools | Automatic — reads your intent and picks the best approach |
| **25 Custom Agents** | Specialist workforce (architect, security, SEO, TDD, etc.) | Referenced by name or auto-selected by OMC |
| **Health Monitor** | System verification across 15 checks | `/healthcheck` for instant status report |
| **Project Switcher** | Instant context switching between projects | `/switch-project [name]` |
| **Task Templates** | Pre-built workflows for recurring tasks | `template: [name]` |

---

## Architecture

```
                    ┌─────────────────────┐
                    │    Your Request     │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │   CARL (JIT Rules)  │
                    │  Loads only what's  │
                    │     relevant        │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │    Orchestration    │
                    │      Engine        │
                    │  (classifies &     │
                    │    routes)         │
                    └──────────┬──────────┘
                               │
          ┌────────┬───────────┼───────────┬────────┐
          │        │           │           │        │
          ▼        ▼           ▼           ▼        ▼
       ┌──────┐ ┌──────┐ ┌────────┐ ┌──────┐ ┌──────┐
       │Direct│ │ PAUL │ │  SEED  │ │ Auto │ │ OMC  │
       │ Exec │ │Plan/ │ │Incubt. │ │Resrch│ │Team  │
       │      │ │Apply/│ │        │ │      │ │Mode  │
       │      │ │Unify │ │        │ │      │ │      │
       └──┬───┘ └──┬───┘ └───┬────┘ └──┬───┘ └──┬───┘
          │        │         │         │        │
          └────────┴─────────┼─────────┴────────┘
                             │
                    ┌────────▼────────┐
                    │   Execution     │
                    │ Skills + Agents │
                    │ + MCP Servers   │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │  Verification   │
                    │ Build / Test /  │
                    │ Screenshot      │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │     Memory      │
                    │  Auto-save +    │
                    │  Dream Cycle    │
                    └─────────────────┘
```

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the full breakdown.

---

## Is It Safe?

Yes. The installer is non-destructive by design:

1. Creates a timestamped backup of your entire ~/.claude/ directory BEFORE any changes
2. Skips any file that already exists (never overwrites)
3. Third-party tools are installed from their official sources
4. Includes an uninstaller that restores your backup with one command
5. Zero API keys or credentials are included — you add your own
6. The repository passed automated security scanning for leaked secrets

---

## Compatibility and Existing Setups

Already have agents, skills, or hooks? No problem.

Apex is designed to work alongside your existing Claude Code setup, not replace it:

**Existing agents are NEVER overwritten.** If you already have an architect.md agent, Apex skips it and keeps yours. You only get agents you are missing.

**Existing skills stay untouched.** If you have 500 skills from another plugin, Apex adds its custom skills alongside them. No conflicts, no duplicates.

**Settings.json is MERGED, not replaced.** Apex adds MCP servers and hooks to your existing configuration. It never removes or changes anything that is already there.

**Everything is backed up first.** Before any changes, the installer creates a timestamped backup of your entire ~/.claude/ directory. If anything goes wrong, run uninstall.sh to restore instantly.

**Post-install verification catches issues.** After installation, a 30+ point verification script automatically checks every component and reports what was installed, what was skipped (because you already had it), and if anything needs attention.

**Conflict detection is built in.** The verification script checks for corrupted JSON files, missing critical components, and configuration conflicts. If anything is wrong, it tells you exactly what to fix.

The bottom line: your environment gets Apex capabilities added on top of what you already have. Nothing is lost. Nothing is overwritten. Nothing breaks.

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
I just installed Claude Apex. Please complete the setup by running these plugin installations for me:
1. Add the everything-claude-code marketplace and install it
2. Add the oh-my-claudecode marketplace and install it
3. Run the OMC setup
After all three are done, run /healthcheck to verify everything is green.
```

Done. Two pastes. Full environment. 1,308 skills, 108 agents, 15/15 health checks.

Both steps include automatic verification. You will see a detailed report of what was installed and what needs attention.

### Option 2 — One Command (Mac/Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/YousefNabil-SOC/claude-apex/master/install.sh | bash
```

The installer runs a 30+ point verification automatically.

### Option 3 — One Command (Windows PowerShell)

```powershell
irm https://raw.githubusercontent.com/YousefNabil-SOC/claude-apex/master/install.ps1 | iex
```

The installer runs a 30+ point verification automatically.

### Option 4 — Interactive (All Platforms)

```bash
git clone https://github.com/YousefNabil-SOC/claude-apex.git
cd claude-apex
bash install-interactive.sh
```

> The installer backs up your entire `~/.claude/` directory before making any changes. If anything goes wrong, run `uninstall.sh` to restore your original configuration.

Verification runs automatically after installation completes.

### Verify Your Installation

Already installed Apex? Run the verification anytime:

```bash
cd claude-apex
bash verify.sh
```

This runs 30+ checks covering agents, commands, hooks, skills, configuration, MCP servers, third-party tools, backup status, and conflict detection. Results are shown as PASS, WARN, or FAIL with specific instructions for fixing any issues.

---

## Before vs After

| Capability | Without Apex | With Apex |
|-----------|-----------------|---------------|
| Agent orchestration | You manually pick agents | OMC autopilot self-organizes 19 agents |
| Execution structure | No structure, plans drift | PAUL enforces Plan-Apply-Unify with quality gates |
| Rule management | All rules loaded every session | CARL loads rules JIT by intent (saves tokens) |
| Memory hygiene | Grows forever, gets stale | Dream auto-consolidates between sessions |
| Multi-terminal | Each terminal is isolated | Claude Peers: terminals discover and message each other |
| Health monitoring | No way to check | `/healthcheck` verifies 15 systems in 10 seconds |
| Project context | Manual cd and re-explain | `/switch-project` loads full context instantly |
| Starting new projects | Blank page | SEED incubates ideas through guided questioning |
| Optimization | Manual trial and error | Autoresearch: autonomous improve-measure-keep loops |
| Agents | 0 custom specialists | 25 battle-tested specialists + 83 from plugins |

---

## What You Can Do After Install

```bash
# Full autonomous task execution
autopilot: build a React dashboard with user authentication

# Persistent execution (won't stop until done)
ralph: refactor the entire authentication module

# Structured multi-phase development
/paul:plan → /paul:apply → /paul:unify

# Brainstorm a new project idea
/seed

# Optimize anything measurable
/autoresearch

# Verify all systems are healthy
/healthcheck

# Switch project context instantly
/switch-project myapp

# Use a pre-built workflow template
template: research
```

---

## What Gets Installed

Apex installs these components to your `~/.claude/` directory:

**From this repository (original work):**
- 25 custom agent definitions
- 3 custom slash commands
- 5 hook scripts
- 2 custom skills
- CARL domain configuration (7 domains, 33 rules)
- Orchestration engine
- CLAUDE.md enhancements

**Installed via their official sources (third-party, open source):**
- [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) plugin (Yeachan-Heo) — via Claude Code plugin marketplace
- [PAUL](https://github.com/ChristopherKahler/paul) framework (ChristopherKahler) — via npm
- [SEED](https://github.com/ChristopherKahler/seed) incubator (ChristopherKahler) — via npm
- [Claude Peers](https://github.com/louislva/claude-peers-mcp) MCP (louislva) — via git clone
- [Bun](https://bun.sh) runtime — via npm

All third-party tools are installed from their original repositories and are covered by their own licenses.

**Manual plugin install required for full experience (run in Claude Code after install):**

These plugins are installed through Claude Code's built-in plugin marketplace,
not through the shell installer. Open Claude Code after running the installer
and run these commands:

```
# Install ~1,000+ community skills
/plugin marketplace add https://github.com/anthropic-community/everything-claude-code
/plugin install everything-claude-code

# Install 19-agent orchestration with autopilot mode
/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
/plugin install oh-my-claudecode
/oh-my-claudecode:omc-setup
```

Without these plugins, you get the core Apex experience (25 agents,
custom commands, hooks, CARL, orchestration engine). With them, you get
the FULL 1,308 skills + 108 agents experience.

---

## Documentation

| Guide | Description |
|-------|-------------|
| [Getting Started](docs/GETTING-STARTED.md) | Your first 5 minutes with Apex |
| [Architecture](docs/ARCHITECTURE.md) | How the 5-layer system works |
| [Agents Guide](docs/AGENTS-GUIDE.md) | Working with 25 specialist agents |
| [CARL Guide](docs/CARL-GUIDE.md) | JIT rule loading explained |
| [PAUL Integration](docs/PAUL-INTEGRATION.md) | Plan-Apply-Unify structured execution |
| [OMC Integration](docs/OMC-INTEGRATION.md) | Multi-agent autopilot modes |
| [Peers Setup](docs/PEERS-SETUP.md) | Multi-terminal communication |
| [Memory System](docs/MEMORY-SYSTEM.md) | Auto memory and Dream consolidation |
| [Orchestration](docs/ORCHESTRATION.md) | The decision engine |
| [Customization](docs/CUSTOMIZATION.md) | Add your own agents, skills, and rules |
| [Windows Guide](docs/WINDOWS-GUIDE.md) | Windows-specific setup notes |
| [Troubleshooting](docs/TROUBLESHOOTING.md) | Common issues and fixes |
| [Uninstall](docs/UNINSTALL.md) | How to cleanly remove Apex |
| [FAQ](docs/FAQ.md) | Frequently asked questions |

---

## Built By

Built by **[Yousef Nabil](https://github.com/YousefNabil-SOC)** — a 22-year-old developer and Digital & IT Coordinator based in Qatar.

What started as customizing Claude Code for daily work turned into a 2+ month deep dive into building the most comprehensive Claude Code environment in existence. Every component was hand-configured, tested against real projects, and integrated into a unified system.

The environment was battle-tested across web development (React + TypeScript + Tailwind), document generation (PDF, PPTX, DOCX in Arabic and English), OSINT research, legal analysis, cybersecurity workflows, and multi-agent parallel execution.

It scores **15/15** on its own health check — a health check it built itself.

If this helped you, consider giving it a star. It means a lot.

---

## Acknowledgments

- [Anthropic](https://anthropic.com) — for building Claude Code
- [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) by Yeachan-Heo — multi-agent orchestration
- [PAUL Framework](https://github.com/ChristopherKahler/paul) by ChristopherKahler — structured execution
- [CARL](https://github.com/ChristopherKahler/carl) by ChristopherKahler — JIT rule loading
- [SEED](https://github.com/ChristopherKahler/seed) by ChristopherKahler — project incubation
- [Claude Peers](https://github.com/louislva/claude-peers-mcp) by louislva — inter-instance communication
- The Claude Code community for skills, plugins, and inspiration

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=YousefNabil-SOC/claude-apex&type=Date)](https://star-history.com/#YousefNabil-SOC/claude-apex&Date)

---

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines. Whether it's a new agent, a new CARL domain, a bug fix, or documentation improvement — PRs are appreciated.

---

## License

MIT — see [LICENSE](LICENSE) for details.
