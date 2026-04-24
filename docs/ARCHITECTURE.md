# Claude Apex Architecture

## Overview

Claude Apex V7 is a layered autonomous agent system built on Anthropic's Claude Code. It combines 1,276+ skills, 108 agents, 4 default MCP servers (up to 15 with optional), 9 CARL domains, and automated decision-making via the three-layer auto-routing system.

## The V7 Innovation — Three-Layer Auto-Routing

The V7 core innovation is **three-layer auto-routing**. A user types natural language; the system activates the right stack of skills, MCP servers, agents, and commands — no slash commands required.

```
User prompt ("build me a premium landing page with scroll animations")
      │
      ▼
┌──────────────────────────────────────────────────┐
│ LAYER 1 — CARL (JIT rule injection)              │
│                                                  │
│ carl-hook.py fires on every UserPromptSubmit.    │
│ Matches keywords against 9 domains.              │
│ Injects matching rules into context BEFORE       │
│ Claude reads the prompt.                         │
│                                                  │
│ This example: WEB-DEVELOPMENT matched on         │
│ "landing page", "scroll", "animation" →          │
│ 9 rules injected.                                │
└────────────────────┬─────────────────────────────┘
                     ▼
┌──────────────────────────────────────────────────┐
│ LAYER 2 — CAPABILITY-REGISTRY (task → stack)     │
│                                                  │
│ Claude reads CAPABILITY-REGISTRY.md at session   │
│ start. On each task, looks up the matching task  │
│ pattern row.                                     │
│                                                  │
│ "premium landing page" →                         │
│   Skills: frontend-design, premium-web-design,   │
│     tailwind-patterns, react-patterns,           │
│     typescript-pro, ui-ux-pro-max                │
│   MCPs:   playwright, github, context7,          │
│     @21st-dev/magic                              │
│   Agents: architect, code-reviewer + RuFlo       │
│     coder, tester, reviewer                      │
│   CLI:    Playwright CLI, gh, npm                │
└────────────────────┬─────────────────────────────┘
                     ▼
┌──────────────────────────────────────────────────┐
│ LAYER 3 — COMMAND-REGISTRY (intent → commands)   │
│                                                  │
│ User intent maps to slash commands. 182 indexed. │
│                                                  │
│ "build a landing page" → auto-invokes            │
│ /feature-dev. Later, after implementation,       │
│ auto-invokes /review + /commit-push-pr.          │
└──────────────────────────────────────────────────┘
```

**You never typed a slash command.** The system read your sentence and activated all the right tools.

### Detailed explanation of each layer

**Layer 1 — CARL (Context Augmentation & Reinforcement Layer)**

CARL is Python hook `carl-hook.py` registered on the `UserPromptSubmit` event. It runs *before* Claude processes each prompt.

- Config: `~/.carl/carl.json` — 9 domains, 40 rules, 117+ recall keywords
- Cost: ~200 tokens per prompt (only matching rules — typically 3-8 rules load)
- UTF-8 fixed on all 4 `open()` calls to prevent non-Latin content corruption
- Always-on: the `GLOBAL` domain (3 rules) injects on every prompt
- On-demand: the other 8 domains fire only when their recall keywords appear

Why it matters: loading all 40 rules every prompt would waste ~2,000 tokens. CARL's JIT approach keeps the relevant 3-8 rules focused.

**Layer 2 — CAPABILITY-REGISTRY.md**

A static markdown file at `~/.claude/CAPABILITY-REGISTRY.md`. Claude reads it once at session start (as part of the session-start hook's essential-file list) and consults it per task.

Contains:
- A task-pattern → tool-stack routing table (30+ rows)
- MCP server inventory with status
- Tool fallback table (self-healing)
- 25-agent custom registry
- RuFlo (51) and OMC (19) agent lists
- Post-compact recovery instructions

**Layer 3 — COMMAND-REGISTRY.md**

A static markdown file at `~/.claude/COMMAND-REGISTRY.md`. Claude reads it on demand when user intent matches a command-invocation pattern.

Contains:
- 182 slash commands indexed by plugin
- Auto-invocation routing table (intent keywords → top commands)
- Conflict resolution rules (priority order when two commands match)
- "Don't-Use" list (deprecated or special-case commands)

## The Full Stack — 5 Layers

Above the three routing layers, Apex has the full Claude Code execution stack:

```
┌─────────────────────────────────────────────────────────────────┐
│ Layer 5: Skills & Agents (Workers)                              │
│ 1,276+ skills | 108 specialist agents | Task executors          │
├─────────────────────────────────────────────────────────────────┤
│ Layer 4: OMC Multi-Agent Orchestration                          │
│ autopilot | ralph | team | ultrawork | deep-interview           │
│ Model routing: Haiku / Sonnet / Opus (per agent frontmatter)    │
├─────────────────────────────────────────────────────────────────┤
│ Layer 3: PAUL Structured Execution                              │
│ /paul:plan → /paul:apply → /paul:unify                          │
│ Quality gates, phase tracking, milestone management             │
├─────────────────────────────────────────────────────────────────┤
│ Layer 2: Orchestration Engine (Decision Classifier)             │
│ Task classification → route to direct / PAUL / SEED /           │
│   autoresearch / OMC / subagents                                │
├─────────────────────────────────────────────────────────────────┤
│ Layer 1: CARL + CAPABILITY-REGISTRY + COMMAND-REGISTRY          │
│ Three-layer auto-routing (JIT rules + task stack + commands)    │
└─────────────────────────────────────────────────────────────────┘
```

## How a Request Flows

Example: "refactor the authentication module"

1. **CARL fires** (Layer 1 of three-layer routing)
   - Keywords `refactor`, `authentication` match DEVELOPMENT + WEB-DEVELOPMENT domains
   - 3 (GLOBAL) + 9 (WEB-DEVELOPMENT) = 12 rules injected

2. **CAPABILITY-REGISTRY consulted** (Layer 2)
   - "refactor code" pattern row → skills: clean-code, code-simplifier; agents: refactor-cleaner, code-reviewer

3. **COMMAND-REGISTRY consulted** (Layer 3)
   - No explicit slash match for "refactor", so direct execution path chosen

4. **Orchestration Engine classifies** (stack Layer 2)
   - Multi-phase work (assess → plan → execute → test) → routes to PAUL framework

5. **PAUL executes** (stack Layer 3)
   - `/paul:plan` creates structured plan
   - `/paul:apply` runs phases with quality gates

6. **Agents dispatched** (stack Layer 4 via OMC or direct subagents)
   - refactor-cleaner (Sonnet) removes dead code
   - code-reviewer (Sonnet) validates
   - tdd-guide (Sonnet) adds tests in parallel

7. **Memory updated** (Layer 5)
   - `session-handoff.md` appended on Stop event
   - `decisions.md` updated if architectural choices were made

## Memory Persistence

### Session Memory (Auto-Save)

- **MEMORY.md** — main memory file (~200 line soft limit, triggers consolidation)
- **session-handoff.md** — last 50 lines of session-end timestamps (kept small on purpose)
- **tool-health.md** — tool failures and fallback choices
- **decisions.md** — durable decisions across sessions
- **learning-log.md** — patterns to repeat or avoid

### Memory Tiers

1. **Working Memory** — current session (auto-prune at session end)
2. **Episodic Memory** — project-level context in per-project `SESSION-MEMORY.md`
3. **Semantic Memory** — patterns, skills, lessons (permanent; in `lessons.md`)

### Dream Consolidation

- **Trigger**: manual "consolidate memory", or auto at session end
- **4-Phase Cycle**: Orient → Gather → Consolidate → Prune

## Layer Details

### CARL Domains (9 total, 40 rules)

| Domain | Always-on | Rule count | Sample keywords |
|---|---|---:|---|
| GLOBAL | yes | 3 | (universal) |
| DEVELOPMENT | no | 0 (routing signal) | write code, fix bug, refactor, implement |
| WEB-DEVELOPMENT | no | 9 | react, typescript, tailwind, component, animation, 21st |
| DOCUMENT-CREATION | no | 7 | pdf, pptx, docx, presentation, report |
| RESEARCH-OSINT | no | 5 | research, osint, investigate, competitor |
| DEPLOYMENT | no | 6 | deploy, vercel, git push, production |
| LEGAL | no | 5 | contract, law, counsel, agreement, arbitration |
| BROWSER | no | 2 | browse, chrome, instagram, scrape |
| PROJECT-NAVIGATION | no | 3 | where is, how does, architecture, resume |

### Orchestration Engine Decision Matrix

| Task | Characteristics | Route | Why |
|---|---|---|---|
| Quick fix | <5 min, single file | Direct | No ceremony needed |
| Multi-step | 3+ phases, dependencies | PAUL | Structure prevents missed steps |
| Vague | Unclear scope | SEED / `/deep-interview` | Interview clarifies |
| Optimize | Measurable target metric | Autoresearch | Modify-measure-keep loop |
| Parallel | 3+ independent tracks | OMC team / subagents | Saves wall-clock time |
| Persistent | Needs retries | OMC ralph | Never quits |

### PAUL 28 Commands

See [PAUL-INTEGRATION.md](./PAUL-INTEGRATION.md).

### OMC 4 Execution Modes

- `autopilot: <task>` — full 5-stage pipeline (research → plan → execute → QA → validate)
- `ralph: <task>` — persistent loop until completion
- `team N: <tasks>` — N parallel workers in git worktrees
- `/deep-interview <idea>` — Socratic planning

Model routing: Haiku (explore, writer) / Sonnet (most) / Opus (architect, planner, critic, analyst, code-reviewer, code-simplifier).

### Skills & Agents

- **Skills**: 1,276+ — 9 Apex custom + 1,267 via everything-claude-code plugin
- **Agents**: 108 — 25 Apex custom + 51 RuFlo + 19 OMC + 13 plugin-unique
- **Auto-Selection**: CAPABILITY-REGISTRY's task patterns map to the right agents

## Cross-Cutting Concerns

### Error Recovery (Self-Healing)

1. Catch error immediately
2. Log to `memory/tool-health.md`
3. Check fallback table (CAPABILITY-REGISTRY.md)
4. Switch to alternative tool
5. Continue

### Context Management

- Claude Code context window: 200,000 tokens
- `/compact` compresses history (typically 90%+ reduction)
- `/clear` only for unrelated project switches
- MAX_THINKING_TOKENS capped at 10,000 (set in env) to prevent runaway

### Token Efficiency Rules

- Compact between major phases
- Subagents use Haiku (`CLAUDE_CODE_SUBAGENT_MODEL=haiku`)
- Graphify query (~1K tokens) before raw file read (~10K tokens)
- Prompt caching 1h enabled (`ENABLE_PROMPT_CACHING_1H=1`)

## Configuration

See `~/.claude/settings.json`. Key sections:

```json
{
  "env": {
    "MAX_THINKING_TOKENS": "10000",
    "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "50",
    "CLAUDE_CODE_SUBAGENT_MODEL": "haiku",
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1",
    "ENABLE_PROMPT_CACHING_1H": "1"
  },
  "hooks": { /* 5 events — see docs/07-WHAT-ARE-HOOKS.md */ },
  "mcpServers": { /* 4 defaults: playwright, github, exa-web-search, @21st-dev/magic */ },
  "effortLevel": "high"
}
```

## When to Use Each Layer

| Scenario | Use |
|---|---|
| "Write a React component" | Direct (simple) or `autopilot:` (complex) |
| "Refactor legacy code" | PAUL (3-step: assess → plan → execute) |
| "Fix CI/CD pipeline" | `ralph:` (persistent, retry-heavy) |
| "Design database schema" | `/deep-interview` + architect agent |
| "Run 10 performance tests" | `team 10:executor` |
| "Unclear request" | `/deep-interview` Socratic Q&A |
| "Where is X in the codebase?" | Graphify query (not raw reads) |
| "Ship to production" | `/deploy` + DEPLOYMENT CARL rules |

## Example Workflows

### Workflow 1 — Build a premium landing page

```
> build me a landing page for a luxury coffee brand with scroll animations

[CARL] WEB-DEVELOPMENT loaded (9 rules)
[Layer 2] Skills: premium-web-design, react-patterns, tailwind-patterns, ui-ux-pro-max
[Layer 2] MCPs: @21st-dev/magic, playwright, context7
[Layer 3] /feature-dev auto-invoked
[Orchestration] Multi-phase → PAUL route
[PAUL] /paul:plan creates 3 phases (components, animations, polish)
[OMC team 3] Frontend agent + Animation agent + QA agent in parallel
[OMC] impeccable skill runs polish pass
Result: Landing page built in 15 minutes across 3 parallel agents
```

### Workflow 2 — Review a PR

```
> review PR #234

[CARL] DEVELOPMENT loaded
[Layer 2] Agents: code-reviewer + security-reviewer in parallel (Sonnet)
[Layer 3] /review + /review-pr auto-invoked
Result: Two structured reviews combined into one report in 60s
```

## Pro Tips

- **Run `/healthcheck` before any big task.** 10 seconds to confirm all 18 systems green.
- **Let CARL work.** If you see `LOADED DOMAINS:` in the first response, the three-layer routing is firing correctly.
- **Use Graphify for navigation.** "Where is X" queries on a graphified project cost ~1K tokens vs ~10K for raw reads.
- **Don't force PAUL for trivial work.** The 3-phase overhead only pays off for 30+ minute tasks.
- **Respect effort level = `high`.** Apex auto-lowers `xhigh`/`max` for a reason — they burn tokens.
- **Read CAPABILITY-REGISTRY.md once.** It's the authoritative routing table; when in doubt, check there.

## Next Steps

- [GETTING-STARTED.md](./GETTING-STARTED.md) — First 5 minutes
- [CARL-GUIDE.md](./CARL-GUIDE.md) — Deep dive on CARL rules and domains
- [AGENTS-GUIDE.md](./AGENTS-GUIDE.md) — Work with the 108 agents
- [PAUL-INTEGRATION.md](./PAUL-INTEGRATION.md) — Structured execution
- [OMC-INTEGRATION.md](./OMC-INTEGRATION.md) — Multi-agent modes

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
