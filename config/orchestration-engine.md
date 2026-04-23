# ORCHESTRATION ENGINE — The Decision Brain

> This file is the logic that routes any request to the right execution mode.
> Claude Code reads this when choosing between direct execution, PAUL, SEED, Autoresearch, or OMC Team mode.

## Decision Tree — Which Execution Mode?

```
User request arrives
        │
        ▼
Is it a question / quick fact / trivial edit?
        │ YES
        └──→ DIRECT EXECUTION (no framework overhead)
        │
        │ NO
        ▼
Is the request a brand-new project idea with no shape yet?
        │ YES
        └──→ SEED incubator (/seed)
        │        Guided ideation → PROJECT.md → ready to build
        │
        │ NO
        ▼
Is it a measurable optimization task (improve X metric)?
        │ YES
        └──→ AUTORESEARCH (/autoresearch)
        │        modify → measure → keep/discard → repeat
        │
        │ NO
        ▼
Does the task span multiple phases with dependencies between them?
        │ YES
        ▼
        Is there 1 clear execution path (sequential)?
                │ YES
                └──→ PAUL (/paul:plan → /paul:apply → /paul:unify)
                │        Structured Plan-Apply-Unify with quality gates
                │
                │ NO — multiple independent tracks
                ▼
        Do the tracks need to share findings mid-execution?
                │ YES
                └──→ OMC TEAM MODE (autopilot / ralph / team N:executor)
                │        Parallel agents in git worktrees, can message each other
                │
                │ NO — truly independent tasks
                └──→ SUBAGENTS (dispatch 2-5 parallel, no inter-talk)
```

## When to Use DIRECT EXECUTION

Use when:
- Single file edit, single bug fix, quick lookup
- User asks a factual question ("what does React useReducer do?")
- Reading a log, running a known command, formatting a file
- The answer is ≤ 3 tool calls

**Signal**: If planning would take longer than executing, skip planning.

## When to Use SEED

Use when:
- User has an *idea* but no spec
- "I want to build something that..." with no file yet
- Early-stage exploration
- Multiple variants need to be weighed before committing

**Command**: `/seed`
**Output**: A structured PLANNING.md ready for PAUL or direct build.

## When to Use AUTORESEARCH

Use when:
- Task has a **measurable metric** (performance, bundle size, test coverage, token cost, conversion rate)
- Needs iterative trial-and-error with verification between attempts
- "Optimize X" or "make Y faster"

**Commands**: `/autoresearch`, `/autoresearch:fix`, `/autoresearch:debug`, `/autoresearch:security`, `/autoresearch:predict`, `/autoresearch:ship`

**Loop**: Modify → verify → keep (if improved) or discard (if not) → repeat until goal met or max iterations.

## When to Use PAUL

Use when:
- Multi-phase implementation (research → plan → build → test → ship)
- Need quality gates between phases
- Work spans multiple sessions (handoff-friendly)
- Risk is high enough to warrant surfacing assumptions

**Commands**:
- `/paul:init` — set up PAUL for project
- `/paul:plan` — create PLAN.md
- `/paul:apply` — execute PLAN.md
- `/paul:unify` — MANDATORY close step (never skip)
- `/paul:pause` / `/paul:resume` — session breaks
- `/paul:milestone` — version boundaries

## When to Use OMC TEAM MODE

Use when:
- 3+ parallel tracks that need coordination
- Long autonomous work (refactor an entire module, rebuild auth)
- Each track needs its own git worktree
- Tracks need to message each other mid-flight

**Commands**:
- `autopilot: <task>` — full autonomous pipeline (expansion → plan → execute → QA → validate)
- `ralph: <task>` — persistent loop until "done" promise is met
- `team N:executor <task>` — N parallel executor agents
- `/oh-my-claudecode:ultrawork` — max-capability deep work

**Prereq**: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` in settings.json

## When to Use SUBAGENTS (No framework)

Use when:
- 2-5 independent sub-tasks (research A, research B, research C)
- Each is focused and reports a summary
- No need for inter-agent talk
- Want to protect main context window from bulk data

**Signal**: "Go find X, Y, Z" — launch 3 subagents in parallel (single message, multiple Agent tool calls).

## Model Routing Policy

| Task Type | Model |
|---|---|
| Architecture decisions, planning, hardest reasoning | **Opus** |
| Execution, debugging, code review, test writing | **Sonnet** |
| Docs, explore, quick fixes, explorer subagents | **Haiku** |

Respect each agent's declared `model:` frontmatter. Default subagent: **Haiku** (via `CLAUDE_CODE_SUBAGENT_MODEL=haiku`).

## When NOT to Use a Framework

**Skip PAUL/SEED/Autoresearch when:**
- Task is < 30 minutes and well-scoped
- User asks a direct question
- You're clarifying requirements
- One-off fix with no follow-up

Frameworks add overhead. Use them when the overhead pays for itself in quality and coordination.

## Conflict Resolution (two modes match)

Prefer in this order:
1. **Scope match** — PAUL for multi-phase; direct for single-step
2. **Locality** — project-level triggers (defined in CLAUDE.md) override generic routing
3. **Cost** — graph/memory query before raw file read; Haiku-eligible before Opus; skill before MCP when equivalent
4. **Completion guarantee** — PAUL requires `/paul:unify`; Autoresearch requires metric convergence
5. **Parallelism** — independent reviews (code-reviewer + security-reviewer) run in parallel; sequential reviews waste tokens

## Self-Check Before Executing

Before spawning a framework:
- [ ] Is there an MCP / skill / subagent that solves this in one shot? (If yes, skip framework)
- [ ] Does the user care about process visibility, or just the outcome? (If outcome, go direct)
- [ ] Have I read `CAPABILITY-REGISTRY.md` for the task pattern routing? (If no, do that first)
- [ ] Are there dependencies between sub-tasks? (If no, parallelize instead of sequencing)
