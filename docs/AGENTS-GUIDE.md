# Agents Guide — Working with 108 Specialist Agents

## Quick Start

Find the right agent for your task:

```bash
# List all agents
/agents

# Let Apex auto-select (recommended)
autopilot: "Your task here"

# Manually trigger a specific agent
agent:code-reviewer "Review my PR"
```

## The 25 Apex Custom Agents (shipped with this repo)

Grouped by division. Each row shows the agent's model tier and when to use it.

### Engineering Division (9 agents)

| Agent | Model | Purpose | Typical trigger |
|---|---|---|---|
| **architect** | Opus | System design, component relationships, architectural decisions | New features, refactors, scaling decisions |
| **planner** | Opus | Implementation planning, phase breakdown, risk identification | Complex multi-phase work |
| **code-reviewer** | Sonnet | Code quality, conventions, maintainability | After any code change |
| **build-error-resolver** | Sonnet | Fix failing builds, resolve dependency conflicts | When `npm run build` fails |
| **refactor-cleaner** | Sonnet | Dead code removal, duplicate consolidation | Maintenance cycles |
| **tdd-guide** | Sonnet | Write tests first, drive 80%+ coverage | New features, bug fixes |
| **go-reviewer** | Sonnet | Idiomatic Go, concurrency, error handling | Go code changes |
| **go-build-resolver** | Sonnet | Go build/vet/linter errors | Go build fails |
| **python-reviewer** | Sonnet | PEP 8, Pythonic idioms, type hints, security | Python code changes |

### Review & Quality Division (3 agents)

| Agent | Model | Purpose | Typical trigger |
|---|---|---|---|
| **security-reviewer** | Sonnet | OWASP Top 10, secrets, injection, auth flaws | Before commits, auth/API code |
| **database-reviewer** | Sonnet | PostgreSQL optimization, schema, query perf | SQL migrations, slow queries |
| **e2e-runner** | Sonnet | End-to-end tests via Vercel Browser / Playwright | Critical user flows, regression prevention |

### SEO Division (7 specialists)

| Agent | Model | Purpose |
|---|---|---|
| **seo-content** | Sonnet | E-E-A-T, readability, AI citation readiness, thin-content detection |
| **seo-geo** | Sonnet | AI search optimization (AI Overviews, ChatGPT, Perplexity, Bing Copilot) |
| **seo-performance** | Sonnet | Core Web Vitals, page load, performance measurement |
| **seo-schema** | Sonnet | Schema.org JSON-LD generation and validation |
| **seo-sitemap** | Sonnet | XML sitemap validation, generation, quality gates |
| **seo-technical** | Sonnet | Crawlability, indexability, robots, canonical, JS rendering |
| **seo-visual** | Sonnet | Above-the-fold analysis, mobile rendering, Playwright screenshots |

### Business & Strategy Division (3 agents)

| Agent | Model | Purpose |
|---|---|---|
| **cs-ceo-advisor** | Opus | Vision, strategy, board, investor relations, org culture |
| **cs-cto-advisor** | Opus | Technology strategy, team scaling, architecture decisions |
| **chief-of-staff** | Sonnet | Multi-channel comms triage (email/Slack/LINE/Messenger) |

### Documentation & Operations (3 agents)

| Agent | Model | Purpose |
|---|---|---|
| **doc-updater** | Sonnet | README, codemap, guide updates; generates `docs/CODEMAPS/` |
| **loop-operator** | Sonnet | Operate autonomous agent loops, intervene when stalled |
| **harness-optimizer** | Sonnet | Tune local agent harness for reliability, cost, throughput |

## The Other 83 Agents

### RuFlo (51 via `claude-flow` MCP server)

Core (5): coder, reviewer, tester, planner, researcher
V3 Specialized (4): security-architect, security-auditor, memory-specialist, performance-engineer
Swarm Coordination (5): hierarchical-coordinator, mesh-coordinator, adaptive-coordinator, collective-intelligence-coordinator, swarm-memory-manager
Consensus (7): byzantine-coordinator, raft-manager, gossip-coordinator, consensus-builder, crdt-synchronizer, quorum-manager, security-manager
Performance (5): perf-analyzer, performance-benchmarker, task-orchestrator, memory-coordinator, smart-agent
GitHub (9): github-modes, pr-manager, code-review-swarm, issue-tracker, release-manager, workflow-automation, project-board-sync, repo-architect, multi-repo-swarm
SPARC (6): sparc-coord, sparc-coder, specification, pseudocode, architecture, refinement
Specialized Dev (8): backend-dev, mobile-dev, ml-developer, cicd-engineer, api-docs, system-architect, code-analyzer, base-template-generator
Testing (2): tdd-london-swarm, production-validator

### OMC (19 via `oh-my-claudecode` plugin)

analyst, architect, code-reviewer, code-simplifier, critic, debugger, designer, document-specialist, executor, explore, git-master, planner, qa-tester, scientist, security-reviewer, test-engineer, tracer, verifier, writer

### Plugin-provided (13 unique across various plugins)

agent-sdk-verifier, code-architect, code-explorer, comment-analyzer, pr-test-analyzer, silent-failure-hunter, type-design-analyzer, and more.

## Model Routing Table

Apex routes each agent to the right model based on task complexity. Model choice is in each agent's frontmatter.

### Opus — deepest reasoning (most expensive, slowest)

| Agent | Why Opus |
|---|---|
| architect | Architectural decisions require synthesis across many files and tradeoffs |
| planner | Planning needs to anticipate edge cases and surface assumptions |
| critic | Critique requires multi-perspective evaluation |
| analyst | Business/market analysis benefits from deep reasoning |
| code-reviewer (OMC) | High-stakes reviews on critical paths |
| code-simplifier (OMC) | Refactoring requires holistic understanding |
| cs-ceo-advisor | Strategic decisions benefit from nuanced reasoning |
| cs-cto-advisor | Tech strategy requires evaluating architectural implications |

### Sonnet — balanced (default for most specialist work)

Most Apex custom agents use Sonnet: code-reviewer, security-reviewer, tdd-guide, build-error-resolver, database-reviewer, python-reviewer, go-reviewer, all 7 SEO agents, doc-updater, chief-of-staff, loop-operator, harness-optimizer, e2e-runner, refactor-cleaner.

OMC Sonnet agents: executor, debugger, designer, verifier, tracer, security-reviewer, test-engineer, qa-tester, scientist, git-master, document-specialist.

### Haiku — fast and cheap (exploration, writing)

| Agent | Why Haiku |
|---|---|
| explore (OMC) | Exploratory searches across codebase, low-stakes |
| writer (OMC) | Drafting docs, low reasoning, high volume |
| Default subagent | Env var `CLAUDE_CODE_SUBAGENT_MODEL=haiku` makes all subagents Haiku by default |

### Why this matters

Running everything on Opus is expensive: an autopilot task spawning 5 Opus agents costs 5× a Sonnet run. Running everything on Haiku misses nuance: architectural decisions need more than Haiku's quick reads.

V7 model routing means you pay for depth only where depth pays off.

## Agent Anatomy (Frontmatter)

Every agent file has this structure:

```yaml
---
description: One-line description of what this agent does
model: sonnet
tools: Read, Grep, Glob, Bash
---

# Code Reviewer

Expert code review specialist. Proactively reviews code for quality, 
security, and maintainability. Use immediately after writing or 
modifying code. MUST BE USED for all code changes.
```

**Required fields:**
- `description` — shown in `/agents` list
- `model` — `haiku` / `sonnet` / `opus`

**Optional fields:**
- `tools` — comma-separated allowed tools (default: all)

**Body** — the system prompt for the agent. Written in second person ("You are a code reviewer...").

## Creating New Agents

### Step 1 — Create the agent file

```bash
touch ~/.claude/agents/my-specialist.md
```

### Step 2 — Add frontmatter + instructions

```markdown
---
description: My custom specialist for X
model: sonnet
tools: Read, Edit, Bash, Grep
---

# My Specialist

You are a specialist in X. When invoked:

1. Read the relevant files
2. Analyze for <criteria>
3. Report findings in this format:
   - Issues found (severity: CRITICAL, HIGH, MEDIUM, LOW)
   - Recommended fixes
   - Code examples

Constraints:
- Stay focused on X only
- Never recommend changes outside scope
```

### Step 3 — Invoke it

```
agent:my-specialist "Your task"
```

Or let Apex auto-select: if the task matches your agent's domain, it'll be picked.

## Auto-Selection vs Manual Triggering

### Auto-Selection (recommended for most tasks)

```
autopilot: Refactor authentication
```

Apex picks the best agents:
- architect (Opus) — plans the refactor
- security-reviewer (Sonnet) — audits auth
- tdd-guide (Sonnet) — writes tests
- code-reviewer (Sonnet) — validates output

Advantages: optimal agent combo, saves thinking time, enables parallel execution.

### Manual Triggering (precise control)

```
agent:security-reviewer "Audit password hashing in auth.ts"
```

Advantages: focused single-agent output, faster for narrow tasks.

## Parallel Agent Dispatch

For independent tasks, Apex launches multiple agents in parallel via a single tool-call batch:

```
review this PR
```

Internally:
```
Agent call 1: code-reviewer    ─┐
Agent call 2: security-reviewer ├─ all run at the same time
Agent call 3: tdd-guide        ─┘

Then synthesize into one combined report.
```

Wall-clock time: ~60 seconds for all three vs ~3 minutes sequential.

## Agent Teams (OMC team mode)

For 3+ independent tasks, use `team N:`:

```bash
team 3:executor \
  "Write unit tests for auth module" \
  "Generate API docs for payment service" \
  "Optimize image loading in product grid"
```

Creates 3 git worktrees, spawns 3 executor agents in parallel, opens 3 PRs.

## Agent Capabilities

### What ALL agents can do

- Read files & codebases
- Execute commands (bash)
- Access configured MCP servers
- Call 1,276+ skills
- Use extended thinking (up to 10K tokens via MAX_THINKING_TOKENS)

### Special capabilities (tool restrictions)

Some agents have restricted tool sets in their frontmatter:
- `architect`: Read, Grep, Glob (read-only — for design decisions)
- `code-reviewer`: Read, Grep, Glob, Bash (read + run tests, no edits)
- `tdd-guide`: full toolset (writes tests + implementation)

## Agent Output Format

Most Apex agents return structured reports:

```markdown
## Review: src/auth/login.ts

### CRITICAL (1)
- Password compared with `==` on line 47 (timing attack)
  Fix: Use `crypto.timingSafeEqual`

### HIGH (2)
- No rate limiting on login endpoint
  Fix: Add express-rate-limit middleware
- Session tokens stored in localStorage (XSS risk)
  Fix: Use httpOnly cookies

### MEDIUM (1)
- Error messages leak whether user exists ("user not found" vs "wrong password")

## Summary
3 issues require immediate fix. Run tests before committing.
```

## Best Practices

### 1. Give context

```
# Bad
agent:architect "Design database"

# Good  
agent:architect "Design database for my-webapp — 100K users, read-heavy, 
needs real-time notifications, running on Supabase"
```

### 2. Single focus per invocation

```
# Bad
agent:code-reviewer "Review everything"

# Good
agent:code-reviewer "Review src/auth/ for security issues"
```

### 3. Sequence dependent tasks

```
# Bad — running in parallel on untested code
tdd-guide + code-reviewer + security-reviewer simultaneously

# Good — sequence matters
tdd-guide (writes tests) → code-reviewer (validates) → security-reviewer (audits)
```

### 4. Match agent to task

```
# Wrong agent
agent:cs-ceo-advisor "Fix this React bug"

# Right agent
agent:build-error-resolver "Fix this React bug"
```

## Pro Tips

- **Check the model routing table.** If you're running lots of Opus agents, costs add up. Downgrade to Sonnet where reasoning isn't deep.
- **Let autopilot pick.** It knows which agents work well together and dispatches in parallel.
- **Use `team N:` for >3 independent tasks.** Anything less is subagent territory.
- **Read `~/.claude/AGENTS.md`.** Apex's full agent routing lives there — more detail than this doc.
- **Keep custom agents narrow.** A 300-line system prompt beats a 2000-line one.
- **Test your custom agent before relying on it.** Spawn it manually on a test case; verify output format.

## Troubleshooting

### Agent not responding

```
/healthcheck
```

Check the agent count (should be 108 after full install). If lower, re-run `bash install.sh`.

### Agent giving wrong advice

Try a different agent:
```
# Was using code-reviewer but needed architect
agent:architect "Reconsider this refactor"
```

Or escalate the model:
```
# Edit ~/.claude/agents/my-agent.md
# Change: model: sonnet → model: opus
```

### Too many agents activated

Apex limits to 5 parallel agents by default. If you want fewer:
```
# In settings.json:
"omc": { "parallelization": { "maxWorkers": 3 } }
```

## Next Step

- [OMC-INTEGRATION.md](./OMC-INTEGRATION.md) — autopilot, ralph, team, deep-interview modes
- [ARCHITECTURE.md](./ARCHITECTURE.md) — Where agents fit in the full stack

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
