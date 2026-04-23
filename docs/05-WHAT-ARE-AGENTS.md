# What Are Agents?

## The kid-friendly analogy

**Agents are like specialist coworkers Claude can delegate tasks to.**

Think of Claude as a project manager. When a big job comes in, instead of doing everything alone, Claude can say:

- "Hey Security Specialist, check this code for vulnerabilities"
- "Hey Frontend Engineer, build the login page"
- "Hey QA Tester, run all tests and report"

Each agent is a specialist. They come back with results, Claude combines them, and you get a better answer than if Claude did it alone.

## Skills vs Agents — the difference

| Skills | Agents |
|---|---|
| Recipe books | Specialist coworkers |
| Information Claude reads | Separate AI instances that do work |
| "Here's how to cook pizza" | "You: go cook the pizza" |
| Uses zero extra tokens if not read | Each agent uses its own tokens |
| Always available | Spawn them on demand |

Another way to say it: skills are *knowledge*, agents are *hands*.

## A real example

You ask: *"review this authentication code for security issues"*

**Without agents**: Claude reads the code itself, notices some issues, reports them. Good, but one perspective.

**With agents** (Apex approach): Claude spawns THREE agents in parallel:
1. `security-reviewer` agent — focuses on vulnerabilities (auth, input validation, secrets)
2. `code-reviewer` agent — focuses on quality (style, conventions, bugs)
3. `tdd-guide` agent — focuses on test coverage

All three read the code at the same time. They each report their findings. Claude combines them into one structured report for you.

**Result**: you got three experts working in parallel, producing a more thorough review.

## The 108 agents in Apex

Once fully installed, you have 108 agents in four groups:

### Apex Custom (25) — ship with this repo
architect, build-error-resolver, chief-of-staff, code-reviewer, cs-ceo-advisor, cs-cto-advisor, database-reviewer, doc-updater, e2e-runner, go-build-resolver, go-reviewer, harness-optimizer, loop-operator, planner, python-reviewer, refactor-cleaner, security-reviewer, seo-content, seo-geo, seo-performance, seo-schema, seo-sitemap, seo-technical, seo-visual, tdd-guide

### RuFlo (51) — via the claude-flow MCP server
coder, reviewer, tester, planner, researcher, security-architect, security-auditor, memory-specialist, performance-engineer, hierarchical-coordinator, mesh-coordinator, byzantine-coordinator, raft-manager, perf-analyzer, performance-benchmarker, task-orchestrator, github-modes, pr-manager, code-review-swarm, issue-tracker, release-manager, sparc-coord, sparc-coder, specification, pseudocode, architecture, refinement, backend-dev, mobile-dev, ml-developer, cicd-engineer, api-docs, system-architect, code-analyzer, tdd-london-swarm, production-validator, and more

### OMC (19) — via the oh-my-claudecode plugin
analyst, architect, code-reviewer, code-simplifier, critic, debugger, designer, document-specialist, executor, explore, git-master, planner, qa-tester, scientist, security-reviewer, test-engineer, tracer, verifier, writer

### Plugin-provided (13 unique) — via other plugins
agent-sdk-verifier, code-architect, code-explorer, comment-analyzer, pr-test-analyzer, silent-failure-hunter, type-design-analyzer, and more

## How Claude picks agents

When you submit a task, Claude consults:
- **CAPABILITY-REGISTRY** — "what agents are listed for this task pattern?"
- **AGENTS.md** — "who has the right specialty?"
- **Parallel vs sequential** — "can these run at the same time?"

For independent tasks, Claude launches 2-5 agents in parallel (in one tool call batch). For dependent tasks, it sequences them.

## Dynamic model routing (V7 feature)

Each agent has a `model:` setting in its frontmatter:
- **Opus** — deepest reasoning (architect, planner, critic, analyst)
- **Sonnet** — execution, debugging, most specialist work
- **Haiku** — quick lookups, exploration, writing

Apex respects these so expensive models only fire when needed. Cheap agents (Haiku) do exploration; expensive agents (Opus) do hard thinking.

This is how you get max capability without burning money.

## When NOT to use agents

Don't spawn agents for trivial tasks. Agents have startup overhead (each agent reads its own context).

Rule of thumb:
- ≤ 3 tool calls: Claude does it directly
- 4-9 independent tasks: spawn 2-5 agents in parallel
- 10+ tasks: use RuFlo swarm or OMC team mode

## Can I make my own agent?

Yes. Create a file at `~/.claude/agents/my-agent.md`:

```markdown
---
name: My Custom Agent
description: What this agent does in one sentence
tools: Read, Edit, Bash, Grep
model: haiku
---

# System Prompt

You are a specialist in <topic>. When invoked, you:
1. Read the relevant files
2. Analyze for <criteria>
3. Report structured findings in format: [format]

Do NOT do: <boundaries>
```

Invoke it with the Task tool or by name in conversation.

## What's next

- [06-WHAT-ARE-MCP-SERVERS.md](06-WHAT-ARE-MCP-SERVERS.md) — MCP servers are Claude's tools (browser, GitHub, web search, etc.)
