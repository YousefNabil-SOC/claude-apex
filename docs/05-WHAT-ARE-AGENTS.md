# What Are Agents?

## The kid-friendly analogy

**Agents are like specialist coworkers Claude can delegate tasks to.**

Think of Claude as a project manager. When a big job comes in, instead of doing everything alone, Claude can say:

- "Hey Security Specialist, check this code for vulnerabilities"
- "Hey Frontend Engineer, build the login page"
- "Hey QA Tester, run all tests and report"

Each agent is a specialist. They come back with structured results. Claude combines them and you get a better answer than if Claude did it alone.

## Skills vs Agents — the difference

| Skills | Agents |
|---|---|
| Recipe books | Specialist coworkers |
| Information Claude reads | Separate AI instances doing work |
| "Here's how to cook pizza" | "You: go cook the pizza" |
| Zero extra tokens if not read | Each agent uses its own context |
| Always available | Spawn them on demand |

Skills are *knowledge*. Agents are *hands*.

## A real example

You ask: *"review this authentication code for security issues"*

**Without agents**: Claude reads the code itself, notices some issues, reports them. Good — but one perspective.

**With agents** (Apex approach): Claude spawns THREE agents **in parallel**:
1. `security-reviewer` agent — focuses on vulnerabilities (auth, input validation, secrets, OWASP Top 10)
2. `code-reviewer` agent — focuses on quality (style, conventions, bugs)
3. `tdd-guide` agent — focuses on test coverage

All three read the code at the same time. They each report findings. Claude combines them into one structured report.

**Result**: three experts working in parallel — more thorough review, same wall-clock time as a single review.

## The 108 agents — grouped

Once fully installed, you have 108 agents in four groups.

### Apex Custom (25) — ship with this repo

#### Engineering (9)
| Agent | Purpose |
|---|---|
| **architect** | System design, component relationships, architectural decisions (Opus) |
| **planner** | Implementation planning, phase breakdown, risk identification (Opus) |
| **code-reviewer** | Code quality, conventions, maintainability (Sonnet) |
| **build-error-resolver** | Fixes failing builds, resolves dependency issues (Sonnet) |
| **refactor-cleaner** | Dead code removal, duplicate consolidation (Sonnet) |
| **tdd-guide** | Enforces write-tests-first, drives 80%+ coverage (Sonnet) |
| **go-reviewer** | Idiomatic Go, concurrency patterns, error handling (Sonnet) |
| **go-build-resolver** | Fixes Go build/vet/linter errors (Sonnet) |
| **python-reviewer** | PEP 8, Pythonic idioms, type hints, security (Sonnet) |

#### Review & Quality (3)
| Agent | Purpose |
|---|---|
| **security-reviewer** | Vulnerability detection, secrets, injection, OWASP Top 10 (Sonnet) |
| **database-reviewer** | PostgreSQL optimization, schema design, query performance (Sonnet) |
| **e2e-runner** | End-to-end testing with Vercel Browser / Playwright (Sonnet) |

#### SEO (7 specialists)
| Agent | Purpose |
|---|---|
| **seo-content** | E-E-A-T, readability, AI citation readiness, thin content (Sonnet) |
| **seo-geo** | AI search optimization for ChatGPT, Perplexity, AI Overviews (Sonnet) |
| **seo-performance** | Core Web Vitals, page load, perf measurement (Sonnet) |
| **seo-schema** | Schema.org JSON-LD generation and validation (Sonnet) |
| **seo-sitemap** | XML sitemap validation, generation, quality gates (Sonnet) |
| **seo-technical** | Crawlability, indexability, robots, canonical, JS rendering (Sonnet) |
| **seo-visual** | Above-the-fold analysis, mobile rendering (Sonnet) |

#### Business & Advisory (3)
| Agent | Purpose |
|---|---|
| **cs-ceo-advisor** | Vision, strategy, board, investor relations, culture (Opus) |
| **cs-cto-advisor** | Tech strategy, team scaling, architecture decisions (Opus) |
| **chief-of-staff** | Multi-channel comms triage (email/Slack/messaging) (Sonnet) |

#### Documentation & Ops (3)
| Agent | Purpose |
|---|---|
| **doc-updater** | README, codemap, guide updates (Sonnet) |
| **loop-operator** | Operate autonomous agent loops, intervene when stalled (Sonnet) |
| **harness-optimizer** | Tune local agent harness for reliability/cost/throughput (Sonnet) |

### RuFlo (51) — via the `claude-flow` MCP server

Core (5): coder, reviewer, tester, planner, researcher
V3 Specialized (4): security-architect, security-auditor, memory-specialist, performance-engineer
Swarm Coordination (5): hierarchical-coordinator, mesh-coordinator, adaptive-coordinator, collective-intelligence-coordinator, swarm-memory-manager
Consensus (7): byzantine-coordinator, raft-manager, gossip-coordinator, consensus-builder, crdt-synchronizer, quorum-manager, security-manager
Performance (5): perf-analyzer, performance-benchmarker, task-orchestrator, memory-coordinator, smart-agent
GitHub (9): github-modes, pr-manager, code-review-swarm, issue-tracker, release-manager, workflow-automation, project-board-sync, repo-architect, multi-repo-swarm
SPARC (6): sparc-coord, sparc-coder, specification, pseudocode, architecture, refinement
Specialized Dev (8): backend-dev, mobile-dev, ml-developer, cicd-engineer, api-docs, system-architect, code-analyzer, base-template-generator
Testing (2): tdd-london-swarm, production-validator

### OMC (19) — via the `oh-my-claudecode` plugin

analyst, architect, code-reviewer, code-simplifier, critic, debugger, designer, document-specialist, executor, explore, git-master, planner, qa-tester, scientist, security-reviewer, test-engineer, tracer, verifier, writer

### Plugin-provided (13 unique) — via various plugins

agent-sdk-verifier, code-architect, code-explorer, comment-analyzer, pr-test-analyzer, silent-failure-hunter, type-design-analyzer, and more.

## How Claude picks agents

When you submit a task, Claude consults:
- **CAPABILITY-REGISTRY** — "what agents does this task pattern recommend?"
- **AGENTS.md** — "who has the right specialty?"
- **Parallel vs sequential** — "can these run at the same time?"

For independent tasks, Claude launches 2-5 agents in parallel (in one tool call batch). For dependent tasks, it sequences them.

## Dynamic model routing (V7 feature)

Each agent has a `model:` field in its frontmatter:
- **Opus** — deepest reasoning (architect, planner, critic, analyst, CEO/CTO advisors)
- **Sonnet** — execution, debugging, most specialist work (code-reviewer, security-reviewer, tdd-guide, SEO agents)
- **Haiku** — quick lookups, exploration, writing (explore, writer)

Apex respects these so expensive models only fire when deep reasoning is worth it. Cheap agents (Haiku) do exploration; expensive agents (Opus) do architectural thinking.

This is how you get max capability without max spend.

## Example — autopilot trace

You type:
```
autopilot: review my authentication code
```

**What happens internally:**

1. Apex classifies the task: "review" + "authentication" → security review + code review.
2. Agents activated **in parallel**:
   - `security-reviewer` (Sonnet) — reads auth files, checks OWASP Top 10, flags injection/secrets
   - `code-reviewer` (Sonnet) — reads auth files, checks quality, conventions, style
   - `tdd-guide` (Sonnet) — checks test coverage for auth module
3. Each agent reports structured findings.
4. The main Claude instance synthesizes:
   - CRITICAL issues: from security-reviewer (e.g. "password stored in plaintext at line 47")
   - HIGH issues: from security-reviewer + code-reviewer
   - MEDIUM/LOW issues: from all three
5. You see one combined report in 60 seconds. If all three had run sequentially, it would take 3 minutes.

## When NOT to use agents

Don't spawn agents for trivial tasks. Each agent has startup overhead (reads its own context).

Rule of thumb:
- ≤ 3 tool calls: Claude does it directly, no agents
- 4-9 independent tasks: spawn 2-5 agents in parallel (Apex does this automatically)
- 10+ tasks: use RuFlo swarm or OMC team mode

## Can I make my own agent?

Yes. Create `~/.claude/agents/my-agent.md`:

```markdown
---
name: my-agent
description: What this agent does in one sentence
tools: Read, Edit, Bash, Grep
model: haiku
---

# System Prompt

You are a specialist in <topic>. When invoked:
1. Read the relevant files
2. Analyze for <criteria>
3. Report findings in this format: [format]

Do NOT do: <boundaries>
```

Invoke it by name in conversation, or via the Task tool.

## What You Learned

- Agents are separate AI instances, not Claude reading more knowledge.
- Apex has 25 custom agents, OMC adds 19, RuFlo adds 51, plugins add 13 more — total 108.
- Each agent has a model tier (Haiku/Sonnet/Opus) to balance capability and cost.
- Parallel agent dispatch gives you multiple perspectives without waiting for each one.
- Don't spawn agents for tasks under 3 tool calls — overhead isn't worth it.

## Next Step

- **[06-WHAT-ARE-MCP-SERVERS.md](06-WHAT-ARE-MCP-SERVERS.md)** — MCP servers are Claude's external tools (browser, GitHub, web search).

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
