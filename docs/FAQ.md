# FAQ — Frequently Asked Questions

## General

### Q: What is Claude Apex?

**A:** Claude Apex V7 is an enterprise-grade Claude Code environment with:

- **Three-layer auto-routing** (CARL + CAPABILITY-REGISTRY + COMMAND-REGISTRY) so natural-language prompts activate the right tools without slash commands
- **25 specialist agents** + 51 RuFlo + 19 OMC + 13 plugin-unique = **108 total**
- **1,276+ skills** (9 Apex custom + 1,267 via everything-claude-code plugin)
- **4 default MCP servers** (playwright, github, exa-web-search, @21st-dev/magic) → up to 15 with optional
- **9 CARL domains with 40 JIT rules**
- **7 hooks** covering PostCompact, Stop, UserPromptSubmit, SessionStart-chain

### Q: Do I need Claude Code to use Apex?

**A:** Yes. Apex extends Claude Code; you need Claude Code installed first:

```bash
npm install -g @anthropic-ai/claude-code
```

Then follow [02-INSTALL-FROM-ZERO.md](./02-INSTALL-FROM-ZERO.md).

### Q: Is Apex free?

**A:** Yes, MIT-licensed. You pay only for:
- Claude API usage (via Anthropic; Haiku $0.80/M input, Sonnet $3/M, Opus $15/M)
- Optional MCP integrations (GitHub PAT, Exa key, 21st.dev key, fal.ai credits)

### Q: What's the learning curve?

**A:** Productive in 10 minutes with `/healthcheck` and `autopilot:`. Full mastery takes 2-3 weeks of regular use.

**Quick path:**
- Day 1: `/healthcheck` → `autopilot: "task"`
- Day 2: `/paul:plan` → `/paul:apply` → `/paul:unify`
- Week 2: Customize agents and CARL domains

### Q: Can I use Apex with existing Claude Code projects?

**A:** Yes. Apex coexists with existing projects:
- Existing files are never overwritten
- Existing settings.json is merged, not replaced
- Uninstall restores backup in one command

## Installation & Setup

### Q: What are the exact prerequisites?

**A:**
- Node.js 20+
- Python 3.10+
- Git 2.0+
- Claude Code 2.1.80+
- A Claude account (free at https://claude.ai)
- Windows 10+, macOS 12+, or Linux

### Q: Can I install on Windows?

**A:** Yes. Use Git Bash (ships with Git for Windows) or PowerShell. See [WINDOWS-GUIDE.md](./WINDOWS-GUIDE.md) for detailed setup.

WSL2 also works if you prefer native Linux inside Windows.

### Q: Do I need Docker?

**A:** No. Apex runs natively. Docker is optional.

### Q: How much disk space?

**A:** ~500 MB for Apex + Node dependencies. 1-2 GB with all plugins including everything-claude-code.

### Q: What if my settings.json already has things in it?

**A:** The installer **merges** — it only adds Apex entries that don't already exist. Your MCP servers, hooks, and other config stay intact. A timestamped backup is created before any changes.

## Three-Layer Routing

### Q: How does auto-routing actually work?

**A:** Three layers fire on every prompt:

**Layer 1 — CARL:** `carl-hook.py` matches prompt keywords to 9 domains, injects 3-8 matching rules into context (average ~200 tokens).

**Layer 2 — CAPABILITY-REGISTRY:** Claude reads `~/.claude/CAPABILITY-REGISTRY.md` at session start. On each task, looks up the matching task-pattern row to pick skills, MCP servers, agents, CLI tools.

**Layer 3 — COMMAND-REGISTRY:** Claude reads `~/.claude/COMMAND-REGISTRY.md` on demand. Maps user intent keywords to the best 1-3 slash commands.

### Q: Do I ever need to type a slash command?

**A:** Rarely. The three-layer routing activates the right tools from natural language. But you *can* force specific behavior with slash commands (e.g., `/paul:plan` when you explicitly want PAUL).

## Configuration & Customization

### Q: Can I customize Apex?

**A:** Fully. See [CUSTOMIZATION.md](./CUSTOMIZATION.md). You can:

- Add custom agents (10-line frontmatter + system prompt)
- Add CARL domains (keywords + rules in `~/.carl/carl.json`)
- Add MCP servers (`settings.json`)
- Add hooks (script + `settings.json` entry)
- Create project templates
- Override routing rules

### Q: Can I use Apex for team projects?

**A:** Yes, via **Claude Peers** for multi-terminal coordination. See [PEERS-SETUP.md](./PEERS-SETUP.md).

One team member plans in Terminal 1; others execute in Terminals 2-3. All coordinate via shared memory at `~/.claude/memory/peers/shared/`.

### Q: Can I integrate Apex with external tools?

**A:** Yes via MCP servers. Apex integrates with:
- GitHub (PRs, issues, code search) — `github` MCP
- Web search — `exa-web-search` MCP
- Browser automation — `playwright` MCP
- Component generation — `@21st-dev/magic` MCP

Add more via `settings.json`.

### Q: Can I export my memory?

**A:** Yes. Memory is plain text:
```bash
cat ~/.claude/memory/MEMORY.md
cat ~/.claude/memory/session-handoff.md
cat ~/.claude/memory/learning-log.md
```

## Agents & Skills

### Q: What's the difference between agents and skills?

**A:**
- **Agents** are separate AI instances. They do work and report results.
- **Skills** are recipe books. Claude reads them before acting.

An agent might read 5 skills before completing a task.

### Q: How do I know which agent to use?

**A:** The Orchestration Engine picks automatically. Or pick manually:
- **Complex feature:** `architect` + `planner`
- **After writing code:** `code-reviewer`
- **Bug fix with tests:** `tdd-guide`
- **Security audit:** `security-reviewer`
- **SEO work:** one of 7 `seo-*` agents

### Q: Can multiple agents work together?

**A:** Yes — this is Apex's superpower. Three common patterns:

**Parallel (same task, different perspectives):**
```
agent:code-reviewer + agent:security-reviewer + agent:tdd-guide
# All review the same code simultaneously
```

**Sequential (pipeline):**
```
architect → tdd-guide → code-reviewer → security-reviewer
```

**Team mode (independent tasks):**
```
team 3:executor "Task 1" "Task 2" "Task 3"
```

### Q: What if an agent fails?

**A:** The Orchestration Engine logs the failure to `memory/tool-health.md` and tries a fallback. If no fallback, it surfaces the error with context.

Check: `/healthcheck` to see agent status.

## PAUL Framework

### Q: When should I use PAUL?

**A:** Tasks with 3+ phases. Examples:
- Refactoring
- Database migrations
- Architecture redesigns
- Feature development spanning multiple days

**Don't** use PAUL for quick fixes (<5 minutes), single-file changes, or simple bugs.

### Q: What if I forget to run `/paul:unify`?

**A:** PAUL stays "open" until you unify. State persists in `~/.claude/memory/paul-state.json`. Always run `/paul:unify` to close — it's where the plan-vs-reality reconciliation and lessons-learned get persisted.

### Q: Can I pause and resume PAUL?

**A:** Yes:
```
/paul:pause
# ... later ...
/paul:resume
```

State is in `memory/paul-state.json`.

### Q: How many phases can PAUL handle?

**A:** 3-10 ideal. Beyond 10, split into multiple PAUL cycles.

## OMC & Execution Modes

### Q: What's the difference between autopilot and PAUL?

**A:**
- **PAUL** = YOU decide structure. 3+ phases you define. Better for custom workflows.
- **autopilot** = APEX decides structure. 5 fixed stages (research → plan → implement → review → verify).

Use PAUL when you want control. Use autopilot when you want hands-off.

### Q: Can I interrupt autopilot?

**A:** Yes. Ctrl+C cancels. Current phase is saved. Resume later with `autopilot: "same task" --resume`.

### Q: What's ralph mode?

**A:** "Never-quit" persistent retry. Best for flaky tests or bugs that need multiple attempts.

```
ralph: "Fix flaky test"
# Tries up to 5 times, escalates models on repeated failure
```

### Q: How much faster is team mode?

**A:** ~2-3× for independent tasks. 3 tasks that take 1 hour each sequentially take ~25 minutes in team mode (roughly the slowest-task time + small coordination overhead).

## Memory System

### Q: How does memory work?

**A:** 4-file system at `~/.claude/memory/`:

- **MEMORY.md** — main memory (200-line soft limit)
- **session-handoff.md** — session-end timestamps
- **tool-health.md** — tool failures + fallbacks
- **decisions.md** / **learning-log.md** — durable decisions and lessons

Auto-save after major tasks. Dream consolidation triggers when MEMORY.md grows too large.

### Q: Can I manually update MEMORY.md?

**A:** Yes. Edit directly. Apex respects your edits.

### Q: What happens when MEMORY.md exceeds 200 lines?

**A:** Dream consolidation auto-triggers (or manual: "consolidate memory"):
- Phase 1: Orient — resume from last checkpoint
- Phase 2: Gather — collect session events
- Phase 3: Consolidate — abstract patterns
- Phase 4: Prune — archive old entries

Result: MEMORY.md shrinks, durable lessons move to `lessons.md`.

## CARL

### Q: What does CARL do?

**A:** Context Augmentation & Reinforcement Layer. Loads domain-specific rules just-in-time based on keywords in your prompt.

Example: "Deploy to Vercel" → DEPLOYMENT domain loads (6 rules) automatically.

### Q: How many domains can I have?

**A:** Unlimited. Apex ships 9. Add more in `~/.carl/carl.json`.

Keep each domain focused (5-30 keywords, 1-10 rules).

### Q: Can I disable a domain?

**A:** Yes. Set `state: "disabled"` in `carl.json` for that domain.

## Peers & Multi-Terminal

### Q: How do Peers work?

**A:** Claude Peers MCP runs a broker on `localhost:7899`. Multiple Claude Code terminals auto-register. They share messages and shared memory files.

### Q: Can Peers work across machines?

**A:** Only on the same local network (broker is localhost). For remote teams, use shared git repos + memory files.

### Q: How do I send messages between peers?

**A:**
```
list_peers
send_message peer-terminal-2 "Your task is ready"
receive_message
send_message all "Update for everyone"
```

See [PEERS-SETUP.md](./PEERS-SETUP.md).

## Troubleshooting & Support

### Q: Where do I find help?

**A:**
1. [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) — common issues
2. `/healthcheck` — system status
3. `~/.claude/memory/tool-health.md` — failed tools
4. Relevant guide (AGENTS-GUIDE.md, PAUL-INTEGRATION.md)

### Q: How do I report bugs?

**A:** GitHub issues. Include:
- OS (Windows/Mac/Linux)
- Node version (`node -v`)
- Python version (`python3 --version`)
- Full `/healthcheck` output
- Scrubbed `~/.claude/settings.json` (remove any keys)

### Q: Is there a community?

**A:** GitHub Discussions and Issues at https://github.com/YousefNabil-SOC/claude-apex. Share custom agents, CARL domains, and tips.

### Q: Can I contribute?

**A:** Pull requests welcome. See [CONTRIBUTING.md](../CONTRIBUTING.md).

## Compatibility & Versions

### Q: What Claude Code versions work with Apex V7?

**A:** Claude Code 2.1.80 and higher.

### Q: Will Apex work on M1/M2 Mac?

**A:** Yes. All components support Apple Silicon natively.

### Q: Does Apex work on Windows ARM?

**A:** Yes. Node.js supports Windows ARM64.

### Q: Can I use Apex in Docker?

**A:** Yes. Minimal Dockerfile:
```dockerfile
FROM node:20-alpine
RUN apk add python3 py3-pip git bash
RUN npm install -g @anthropic-ai/claude-code
WORKDIR /workspace
ENTRYPOINT ["claude"]
```

## Billing & Costs

### Q: How much does Apex cost to run?

**A:** Only Anthropic API charges:

| Model | Input cost | Use case |
|---|---|---|
| Haiku | $0.80/M tokens | Explore, writer, subagents |
| Sonnet | $3/M tokens | Most specialist work |
| Opus | $15/M tokens | Architect, planner, critic |

Apex optimizes model selection (uses Haiku for explore; Sonnet default; Opus only for deep reasoning).

Typical moderate user: $5-$20/month. Heavy autopilot users: $50-$200/month.

### Q: Can I set a token budget?

**A:** Indirectly via settings:
```json
{
  "env": {
    "MAX_THINKING_TOKENS": "10000",
    "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "50"
  },
  "effortLevel": "high"
}
```

Apex defaults to these V7 values to prevent runaway spend.

### Q: How do I reduce costs?

**A:**
1. Keep effort at `high`, never `max`
2. Let subagents use Haiku (default)
3. Use Graphify instead of raw file reads (10-30× cheaper for navigation)
4. Enable prompt caching (`ENABLE_PROMPT_CACHING_1H=1` — Apex default)
5. Use `/compact` between phases

## Data & Privacy

### Q: Where is my data stored?

**A:** Local only:
- `~/.claude/memory/` — your memory
- `~/.claude/settings.json` — config
- `~/.carl/carl.json` — CARL rules
- `~/.claude/.env` — API keys (chmod 600)

Nothing syncs to cloud unless you configure a cloud-backed MCP server.

### Q: Is Apex secure?

**A:**
- CARL rules load locally (no remote fetch)
- Memory stays on disk
- Git credentials via standard `git-credential`
- No telemetry
- `.env` is excluded from git via `.gitignore`
- API keys reference as `${VAR}` in `settings.json`, never inline

### Q: Can I use Apex with proprietary code?

**A:** Yes. Everything stays local. Code sent to Anthropic is only what you paste or what Claude explicitly reads during a conversation. Memory files never leave your machine.

## Uninstalling

### Q: How do I uninstall Apex?

**A:**
```bash
cd claude-apex
bash uninstall.sh
```

This restores your pre-Apex backup. See [UNINSTALL.md](./UNINSTALL.md).

### Q: Can I keep my memory after uninstalling?

**A:** Yes. Back up first:
```bash
cp -r ~/.claude/memory ~/claude-backup-memory
```

Then uninstall. Memory files are portable.

## Pro Tips

- **Read [02-INSTALL-FROM-ZERO.md](./02-INSTALL-FROM-ZERO.md) side-by-side** on your screen as you install — it shows expected output at every step.
- **Bookmark `/healthcheck`.** It answers "is my install working?" in 10 seconds.
- **Trust auto-routing.** The three-layer system knows more combinations of tools than you can hold in your head.
- **Don't skip `/paul:unify`.** It's where lessons-learned get captured.
- **Check `verify.sh` after every install.** 35+ checks beat "it seemed to work."

---

**Still have questions?** Check the full documentation:
- [00-START-HERE.md](./00-START-HERE.md) — Start here for beginners
- [ARCHITECTURE.md](./ARCHITECTURE.md) — System design
- [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) — Common issues

Or open an issue on GitHub.

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
