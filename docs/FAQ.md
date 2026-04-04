# FAQ: Frequently Asked Questions

## General Questions

### Q: What is Claude Pantheon?

**A**: Pantheon is a comprehensive Claude Code V6 environment with 1,308 skills, 108 agents, 12 MCP servers, and 19 plugins. It's a professional-grade orchestration system for automating complex development workflows.

Think of it as:
- **CARL**: Smart rule system that loads just-in-time context (7 domains)
- **Orchestration Engine**: Decision matrix that routes tasks to optimal execution strategy
- **PAUL**: Structured planning framework for 3+ phase projects
- **OMC**: Multi-agent autopilot with 4 execution modes (autopilot, ralph, team, deep-interview)
- **Peers**: Multi-terminal communication for team coordination
- **Memory System**: 3-tier persistence with auto-consolidation

### Q: Do I need Claude Code to use Pantheon?

**A**: Yes. Pantheon is an extension/configuration of Claude Code. You need Claude Code installed first.

Install order:
1. Claude Code: `npm install -g @anthropic-ai/claude-code`
2. Pantheon: Follow [GETTING-STARTED.md](./GETTING-STARTED.md)

### Q: Is Pantheon free?

**A**: Pantheon itself is free (open-source). You pay for:
- Claude API calls (via Anthropic account)
- Optional: MCP integrations (GitHub, Supabase, etc.)

### Q: What's the learning curve?

**A**: Start with `/healthcheck` and `autopilot:`. You'll be productive in 10 minutes. Deep mastery takes 2-3 weeks of regular use.

**Quick path**:
- Day 1: `/healthcheck` → `autopilot: "task"`
- Day 2: `/paul:plan` → `/paul:apply` → `/paul:unify`
- Week 2: Customize agents and CARL domains

### Q: Can I use Pantheon with existing Claude Code projects?

**A**: Yes. Pantheon coexists with existing projects. You can:
- Keep old projects as-is
- Gradually add Pantheon to new projects
- Mix Pantheon and non-Pantheon workflows

---

## Installation & Setup

### Q: Can I install Pantheon on Windows?

**A**: Yes. Use Git Bash (includes Unix shell). See [WINDOWS-GUIDE.md](./WINDOWS-GUIDE.md) for full setup.

WSL2 also works but is optional.

### Q: What if I don't have Git Bash?

**A**: Install Git for Windows from https://git-scm.com/download/win (includes Git Bash).

Pantheon doesn't work in PowerShell alone (needs Unix shell).

### Q: Can I install on macOS?

**A**: Yes. Install via Homebrew:
```bash
brew install claude-code
```

Then follow [GETTING-STARTED.md](./GETTING-STARTED.md).

### Q: Can I install on Linux?

**A**: Yes. Install via npm:
```bash
npm install -g @anthropic-ai/claude-code
```

Then follow [GETTING-STARTED.md](./GETTING-STARTED.md).

### Q: Do I need Docker?

**A**: No. Pantheon runs natively. Docker is optional if you use container-based agents.

### Q: How much disk space do I need?

**A**: Minimum 500MB for Pantheon + Node.js dependencies.

If you use all plugins: 1-2GB.

---

## Configuration & Customization

### Q: Can I customize Pantheon?

**A**: Completely. See [CUSTOMIZATION.md](./CUSTOMIZATION.md).

You can:
- Create custom agents (10 lines YAML)
- Add CARL domains (trigger keywords + rules)
- Adjust orchestration routing
- Create project templates
- Set custom shortcuts

### Q: Can I use Pantheon for team projects?

**A**: Yes. Use **Claude Peers** for multi-terminal coordination.

See [PEERS-SETUP.md](./PEERS-SETUP.md).

One team member can:
- Plan in Terminal 1
- Execute in Terminals 2-3 (in parallel)
- All coordinate via shared memory

### Q: Can I integrate Pantheon with my existing tools?

**A**: Yes, via MCP servers. Pantheon integrates with:
- GitHub (PRs, issues, code search)
- Vercel (deployments)
- Supabase (database)
- Slack (notifications)
- AWS, Google Cloud, Azure

Add integrations in `~/.claude/settings.json`.

### Q: Can I use Pantheon offline?

**A**: Partially. You can:
- Read documentation offline
- Use local agents (no API calls needed)
- View memory files

But core features (autopilot, PAUL, deep-interview) need Claude API.

### Q: Can I export my memory?

**A**: Yes. Your memory is plain text:
```bash
cat ~/.claude/memory/MEMORY.md
cat ~/.claude/memory/SESSION-MEMORY.md
cat ~/.claude/memory/lessons.md
```

Export to PDF/Word/JSON as needed.

---

## Agents & Skills

### Q: What's the difference between agents and skills?

**A**: 
- **Agents**: Autonomous specialists with personality and constraints (e.g., "code-reviewer")
- **Skills**: Discrete capabilities/commands (e.g., "/healthcheck")

An agent might use 5 skills to complete a task.

### Q: Can I create custom agents?

**A**: Yes. See [AGENTS-GUIDE.md](./AGENTS-GUIDE.md).

Simple 10-line YAML:
```yaml
---
name: my-specialist
role: Your role here
model: sonnet
trigger_keywords:
  - keyword1
  - keyword2
enabled: true
---

# Agent Description
...
```

### Q: How do I know which agent to use?

**A**: Orchestration Engine decides automatically. Or see [AGENTS-GUIDE.md](./AGENTS-GUIDE.md) for the 25 core agents.

Quick reference:
- **Complex feature**: Use `planner` agent
- **After writing code**: Use `code-reviewer` agent
- **Bug fix or test**: Use `tdd-guide` agent
- **Security**: Use `security-reviewer` agent

### Q: Can multiple agents work together?

**A**: Yes. Pantheon chains agents:
```bash
autopilot: "Task"
# Runs: analyst → planner → tdd-guide → code-reviewer → e2e-runner
```

Or manually:
```bash
agent:planner "Create plan"
agent:code-reviewer "Review output"
```

### Q: What if an agent fails?

**A**: Pantheon falls back to manual mode. See [TROUBLESHOOTING.md](./TROUBLESHOOTING.md).

Check: `/healthcheck` to see agent status.

---

## PAUL Framework

### Q: When should I use PAUL?

**A**: Use PAUL for any task with 3+ phases.

Examples:
- Refactoring (assess → plan → implement → verify)
- Database migrations
- Architecture redesigns
- Feature development (plan → implement → test → deploy)

**Don't use PAUL for**:
- Quick fixes (<5 minutes)
- Single-file changes
- Simple bugs

### Q: What if I forget to run `/paul:unify`?

**A**: PAUL stays "open" until you unify. Memory from apply phase stays in working memory.

Always unify when done:
```bash
/paul:unify
# Consolidates plan vs reality
# Updates memory
# Closes the loop
```

### Q: Can I pause and resume PAUL?

**A**: Yes:
```bash
/paul:pause
# ... do other work ...
/paul:resume
```

Your PAUL state persists in `~/.claude/memory/paul-state.json`.

### Q: How many phases can PAUL handle?

**A**: 3-10 phases. Beyond 10, break into multiple PAUL cycles.

Example:
- PAUL 1: Plan (1 phase)
- PAUL 2: Implement (3 phases)
- PAUL 3: Deploy (2 phases)

---

## OMC & Execution Modes

### Q: What's the difference between autopilot and PAUL?

**A**:
- **PAUL**: *You* decide structure. 3+ phases you define. Better for custom workflows.
- **autopilot**: Pantheon decides structure. 5 fixed stages (research → plan → implement → review → verify).

Use PAUL when you want control. Use autopilot when you want hands-off.

### Q: Can I interrupt autopilot?

**A**: Yes:
```bash
# Ctrl+C stops autopilot
# Current phase is saved
# Resume later:
autopilot: "Task" --resume
```

### Q: What's ralph mode?

**A**: "Never-quit" persistent retry. Best for flaky tests or bugs that need multiple attempts.

```bash
ralph: "Fix flaky test"
# Tries up to 5 times with different strategies
# Escalates to higher models if needed
```

### Q: Can I run team mode with more than 5 workers?

**A**: Yes, up to 10 (configurable):
```bash
team 8:executor "Task1" "Task2" ... "Task8"

# Configure max:
/update-config omc.parallelization.maxWorkers 10
```

### Q: How much faster is team mode?

**A**: ~2-3x speedup for independent tasks.

Example:
- Sequential: 2 hours for 3 tasks
- Team mode: 45 minutes for 3 tasks (2.7x faster)

---

## Memory System

### Q: How does memory work?

**A**: 3-tier system:

1. **Working** (MEMORY.md, 150 lines): Current session summary
2. **Episodic** (SESSION-MEMORY.md): Project-level context
3. **Semantic** (lessons.md): Permanent learnings

Auto-saves after major tasks.

### Q: What happens when MEMORY.md exceeds 150 lines?

**A**: Dream consolidation auto-triggers:
```bash
consolidate memory
# Phases: Orient → Gather → Consolidate → Prune
# Result: MEMORY.md reduced, old entries archived
```

### Q: Can I manually update MEMORY.md?

**A**: Yes. Edit directly:
```bash
nano ~/.claude/memory/MEMORY.md
```

Pantheon respects your edits.

### Q: What if I lose my memory?

**A**: Check archive:
```bash
ls ~/.claude/memory/archive/
# Find recent session
cat ~/.claude/memory/archive/session-42.md
```

Or restore from backup:
```bash
cp ~/claude-backup-MEMORY.md ~/.claude/MEMORY.md
```

### Q: Can I share memory between projects?

**A**: Yes. Global lessons in `lessons.md` apply to all projects.

Project-specific memory in:
```bash
~/.claude/projects/[PROJECT]/SESSION-MEMORY.md
~/.claude/projects/[PROJECT]/lessons.md
```

### Q: How long is memory kept?

**A**: 
- Working memory (MEMORY.md): Current + last 3-5 sessions
- Episodic (SESSION-MEMORY.md): Project lifetime (or until archived)
- Semantic (lessons.md): Forever (permanent learnings)

Archive old sessions after 30 days.

---

## Orchestration Engine

### Q: How does routing work?

**A**: Orchestration Engine classifies tasks and routes to optimal strategy:

- **DIRECT**: Simple fixes (<5 min)
- **PAUL**: Multi-phase work (3+ phases)
- **Team**: Parallel tasks (3+ independent)
- **SEED**: Vague requirements (needs clarification)
- **autoresearch**: Unknown root cause
- **ralph**: Flaky/retry-heavy
- **deep-interview**: Exploratory discovery

See [ORCHESTRATION.md](./ORCHESTRATION.md) for decision matrix.

### Q: Can I override routing?

**A**: Yes. Force a route:
```bash
# Default routing (auto):
"Your task"

# Force DIRECT:
direct: "Quick fix"

# Force PAUL:
/paul:init "Your task"

# Force team:
team 3:executor "Task 1" "Task 2" "Task 3"
```

### Q: What if routing chooses wrong?

**A**: Report in memory and adjust:
```bash
# Add to memory:
echo "Task X was routed to DIRECT but needed PAUL" >> ~/.claude/memory/MEMORY.md

# Then adjust rules:
/update-config orchestration.routes.PAUL.min_phases 2
```

---

## CARL (Context Auto-Recall Library)

### Q: What does CARL do?

**A**: CARL loads context just-in-time based on keywords in your task.

You say: "Optimize React component performance"

CARL loads: libraries (React) + performance rules → 2.7x faster execution

### Q: Can I create custom CARL domains?

**A**: Yes. See [CARL-GUIDE.md](./CARL-GUIDE.md).

```bash
# Create domain file:
touch ~/.claude/rules/my-domain.md

# Add trigger keywords:
trigger_keywords:
  - keyword1
  - keyword2

# Add rules:
## Rule 1: ...
## Rule 2: ...
```

### Q: How many domains can I have?

**A**: Unlimited. Pantheon loads matching domains on every task.

Keep them focused (5-10 keywords per domain).

---

## Peers & Multi-Terminal

### Q: How do Peers work?

**A**: Claude Peers connects multiple Claude Code instances (terminals) via localhost:7899 broker.

Terminal 1: Plan
Terminal 2: Execute Task 1
Terminal 3: Execute Task 2

All share memory and messages.

### Q: Can Peers work across machines?

**A**: Only on same local network (localhost:7899).

For remote teams, use shared git repos + memory files.

### Q: How do I send messages between peers?

**A**:
```bash
# List peers:
list_peers

# Send message:
send_message peer-terminal-2 "Your task is ready"

# Receive:
receive_message

# Broadcast to all:
send_message all "Update for everyone"
```

See [PEERS-SETUP.md](./PEERS-SETUP.md).

---

## Troubleshooting & Support

### Q: Where do I find help?

**A**: 
1. See [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) for common issues
2. Run `/healthcheck` for system status
3. Check `~/.claude/memory/tool-health.md` for failed tools
4. Read relevant guide (AGENTS-GUIDE.md, PAUL-INTEGRATION.md, etc.)

### Q: How do I report bugs?

**A**: GitHub issues:
1. Describe what happened
2. Show error message
3. Include: OS, Node version, Claude Code version
4. Attach: `~/.claude/settings.json` (scrubbed)

### Q: Is there a community?

**A**: GitHub Discussions + Discord (if available).

Share custom agents, CARL domains, and tips.

### Q: Can I contribute improvements?

**A**: Yes! Pull requests welcome.

See Contributing section in README.md.

---

## Compatibility & Versions

### Q: What Claude Code versions work with Pantheon?

**A**: Claude Code V6+.

Check:
```bash
claude --version
# Should show: v6.x or higher
```

### Q: Can I use Pantheon with older Claude Code?

**A**: No. V6 requires:
- Extended thinking support
- Multi-agent capabilities
- MCP server framework

Upgrade to V6:
```bash
npm install -g @anthropic-ai/claude-code@latest
```

### Q: Will Pantheon work on M1 Mac?

**A**: Yes. Node.js and Git support M1 natively.

### Q: Does Pantheon work on Windows ARM?

**A**: Yes. Windows 11 ARM is supported (via node-arm64).

### Q: Can I use Pantheon in Docker?

**A**: Yes. Create Dockerfile:
```dockerfile
FROM node:18-alpine
RUN npm install -g @anthropic-ai/claude-code
ENTRYPOINT ["claude"]
```

Then:
```bash
docker build -t pantheon .
docker run -it pantheon
```

---

## Billing & Costs

### Q: How much does Pantheon cost to run?

**A**: Only Claude API charges (Anthropic).

- Haiku: $0.80/M input tokens
- Sonnet: $3/M input tokens
- Opus: $15/M input tokens

Pantheon optimizes model selection (uses Haiku when possible).

### Q: Can I monitor token usage?

**A**: Yes:
```bash
# View usage statistics:
/orchestration:stats

# Check model routing decisions:
/paul:plan "Task" --explain-model
```

### Q: How do I reduce costs?

**A**: 
1. Prefer Haiku (auto-selected for simple tasks)
2. Use `consolidate memory` to compress context
3. Avoid re-running same task (memory helps)
4. Use `/compact` between phases to reduce context window

### Q: Can I set a token budget?

**A**: Yes:
```bash
# Set max tokens per session:
/update-config context.maxTokensPerSession 50000

# Pantheon will warn before exceeding
```

---

## Data & Privacy

### Q: Where is my data stored?

**A**: Local machine only:
```
~/.claude/memory/          # Your memories
~/.claude/settings.json    # Your config
~/claude-pantheon/         # Your projects
```

Nothing is sent to Anthropic except API calls (text you submit).

### Q: Is Pantheon secure?

**A**: Yes. Security features:
- CARL loads rules locally (no remote fetch)
- Memory stays on-disk (no cloud sync)
- Git credentials stored securely (via git-credential)
- No telemetry (unless you enable it)

### Q: Can I use Pantheon with proprietary code?

**A**: Yes. Everything stays local. No code is sent to Anthropic except:
- Text you paste into Claude
- File contents you explicitly share

Memory files are never sent anywhere.

---

## Uninstalling

### Q: How do I uninstall Pantheon?

**A**: See [UNINSTALL.md](./UNINSTALL.md).

Quick version:
```bash
rm -rf ~/.claude
npm uninstall -g @anthropic-ai/claude-code
```

### Q: Can I keep my memory after uninstalling?

**A**: Yes. Backup first:
```bash
cp -r ~/.claude/memory ~/claude-backup-memory
```

Then uninstall. Memory is portable text files.

### Q: What if I want to reinstall later?

**A**: Just reinstall:
```bash
npm install -g @anthropic-ai/claude-code
# Your memory will still be there (if you backed up)
```

---

**Still have questions?** Check the full documentation:
- [GETTING-STARTED.md](./GETTING-STARTED.md) — Quick start
- [ARCHITECTURE.md](./ARCHITECTURE.md) — System design
- [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) — Common issues

Or open an issue on GitHub.
