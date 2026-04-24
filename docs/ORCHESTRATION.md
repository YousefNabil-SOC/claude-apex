# Orchestration — The Decision Engine

## Overview

The Orchestration Engine is the brain that routes any task to the right execution strategy. It classifies tasks and decides: direct → PAUL → OMC → SEED → Autoresearch → subagents?

Live copy at `~/.claude/ORCHESTRATION-ENGINE.md`. Claude reads it when choosing how to execute.

## The Decision Tree

```
User request arrives
        │
        ▼
Is it a question / quick fact / trivial edit (<3 tool calls)?
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
                │        Structured with quality gates
                │
                │ NO — multiple independent tracks
                ▼
        Do the tracks need to share findings mid-execution?
                │ YES
                └──→ OMC TEAM MODE (autopilot / ralph / team N:)
                │        Parallel agents in git worktrees, can message each other
                │
                │ NO — truly independent tasks
                └──→ SUBAGENTS (dispatch 2-5 parallel, no inter-talk)
```

## Decision Matrix — Quick Reference

| Task | Characteristics | Route | Why |
|---|---|---|---|
| "Fix typo in README" | Single file, obvious fix, <2 min | **Direct** | No ceremony needed |
| "Refactor auth module" | 3+ files, planning needed, 1+ day | **PAUL** | Structure prevents missed steps |
| "Write 5 new endpoints" | 5 parallel tasks, independent | **team 5:** | Parallel saves time |
| "Unclear requirements" | Vague scope, conflicting info | **SEED** / `/deep-interview` | Interview clarifies intent |
| "Improve API performance" | Unknown root cause, data needed | **autoresearch** | Gather metrics first |
| "Fix flaky test" | Needs retries, retry-heavy | **ralph** | Never-quit persistence |
| "Build real-time feature" | New domain, exploration needed | `/deep-interview` | Discover via questions |
| "Where is auth code?" | Navigation query | **Graphify query** (not raw reads) | 10-30× cheaper |
| "Deploy to production" | Fixed workflow, single path | **Direct** with DEPLOYMENT CARL rules | No framework needed |

## Detailed Route Rules

### Route 1 — DIRECT EXECUTION

**Conditions:**
- Task completable in ≤ 3 tool calls
- Can be completed in under 5 minutes
- No dependencies on other tasks
- Doesn't require planning

**Examples:**
- "Fix typo in docs/README.md"
- "Update imports in src/utils.ts"
- "Add console.log for debugging"
- "What version of Node do I have?"

**Execution:**
Just do it. No PAUL, no agents. Run the edit, verify, move on.

### Route 2 — PAUL (Plan-Apply-Unify)

**Conditions:**
- Task has 3+ phases
- Planning prevents forgotten steps
- Work spans multiple files/components
- Risk of missing important steps is real
- Work may span multiple sessions

**Examples:**
- "Refactor authentication module"
- "Migrate from MySQL to PostgreSQL"
- "Add real-time notifications"
- "Modernize the admin dashboard"

**Execution:**
```
/paul:init "Your task"
/paul:plan           # creates structured plan
/paul:apply          # executes phase-by-phase
/paul:unify          # MANDATORY close step — reconciles plan vs reality
```

### Route 3 — OMC TEAM (Parallel Execution)

**Conditions:**
- 3+ independent tasks
- Tasks don't depend on each other
- Want to save wall-clock time (parallelism)
- Each can benefit from its own git worktree

**Examples:**
- "Build 3 API endpoints in parallel"
- "Implement auth + payments + UI simultaneously"
- "Write 5 user stories for this sprint"

**Execution:**
```
team 5:executor \
  "Task 1" \
  "Task 2" \
  "Task 3" \
  "Task 4" \
  "Task 5"
```

Each worker gets its own branch and git worktree. All 5 PRs open in parallel.

### Route 4 — SEED (Interactive Discovery)

**Conditions:**
- Requirements are vague or conflicting
- Need to clarify scope with user
- Risk of building the wrong thing
- Benefit from structured questions

**Examples:**
- "Build a dashboard" (vague — what metrics?)
- "Improve system performance" (unclear which metric)
- "Add user features" (which features?)

**Execution:**
```
/seed "Your vague idea"
# Agent asks clarifying questions until scope is concrete
# Generates PLANNING.md ready for PAUL or direct build
```

### Route 5 — AUTORESEARCH

**Conditions:**
- Root cause is unknown
- Need data/metrics to decide
- Benefit from research before action
- Complex optimization task with a measurable target

**Examples:**
- "API is slow" (need to find why)
- "Database queries taking too long" (need to profile)
- "Choose between two libraries" (need comparison)
- "Reduce bundle size below 500KB"

**Execution:**
```
/autoresearch
# Agent gathers metrics, profiles, suggests fixes
# Loop: modify → measure → keep if improved → repeat
```

### Route 6 — Ralph (Persistent Retry)

**Conditions:**
- Task is flaky or retry-heavy
- First approach might fail
- Need to escalate to higher model on retry
- Can't afford to give up

**Examples:**
- "Fix flaky E2E test"
- "Debug 'works on my machine' issue"
- "Fix production bug that's hard to reproduce"

**Execution:**
```
ralph: "Task description"
# Tries up to 5 times with different strategies
# Escalates Haiku → Sonnet → Opus on repeated failure
```

### Route 7 — Deep-Interview (Socratic)

**Conditions:**
- Requirements are exploratory
- Need to discover what's possible
- High value in structured questions
- Building something new

**Examples:**
- "Build a real-time collaboration tool"
- "Create a new product feature" (unclear what's possible)
- "Redesign the auth system" (many options)

**Execution:**
```
/oh-my-claudecode:deep-interview "Your idea"
# Agent asks Socratic questions
# Discovers requirements & creates spec
# Then routes to PAUL or OMC
```

### Route 8 — Subagents (No Framework)

**Conditions:**
- 2-5 independent sub-tasks
- Each is focused and reports a summary
- No need for inter-agent talk
- Want to protect main context window from bulk data

**Examples:**
- "Research A, B, and C separately"
- "Summarize 3 different PRs"
- "Read 4 unrelated files and report summaries"

**Execution:** Launch 2-5 subagents in parallel (single message, multiple Agent tool calls).

## Decision Pseudocode

```python
def route_task(task):
    # Trivial
    if tool_calls_estimate(task) <= 3 and single_file(task):
        return DIRECT
    
    # Vague scope
    if conflicting_requirements(task) or unclear_scope(task):
        return SEED if brand_new_idea(task) else DEEP_INTERVIEW
    
    # Measurable optimization
    if has_target_metric(task):
        return AUTORESEARCH
    
    # Parallel work
    if independent_tasks_count(task) >= 3:
        return OMC_TEAM if tracks_share_findings(task) else SUBAGENTS
    
    # Multi-phase
    if phases_count(task) >= 3 and planning_helps(task):
        return PAUL
    
    # Flaky / retry-heavy
    if first_attempt_might_fail(task) or needs_persistence(task):
        return RALPH
    
    # Default
    return DIRECT
```

## Integration with CARL (Layer 1 routing)

CARL's domain loading informs orchestration:

```
Task: "Optimize React component performance"
      ↓
CARL loads: GLOBAL + WEB-DEVELOPMENT (react, component keywords)
      ↓
Orchestration sees:
  - WEB-DEV domain loaded → likely coding task
  - Keyword "optimize" → measurable target
  - Keyword "performance" → benchmarking needed
      ↓
Routes to: autoresearch (gather metrics)
           + PAUL (plan optimization)
           + OMC team (parallel benchmarking on variants)
```

## Customizing Orchestration

### Override routing manually

```bash
# Default routing picks
"Your task"

# Force direct
direct: "Your task"

# Force PAUL
/paul:init "Your task"

# Force team mode
team 3:executor "Task 1" "Task 2" "Task 3"

# Force autopilot
autopilot: "Your task"

# Force ralph
ralph: "Your task"
```

### Edit routing defaults

Edit `~/.claude/ORCHESTRATION-ENGINE.md` directly. It's just a markdown file — Claude reads it and follows it.

## Four Real Examples

### Example 1 — Simple Fix (DIRECT)

```
Task: "Add JWT token validation to API"

Classification:
  Duration: < 1 hour
  Files: 1-2
  Planning needed: No
  Risk: Low

Route: DIRECT
Execution: Write code, test, commit.
Time: 45 minutes.
```

### Example 2 — Complex Refactor (PAUL)

```
Task: "Refactor codebase from CommonJS to ES modules"

Classification:
  Duration: 8+ hours
  Files: 20+
  Phases: 3 (assess → migrate → verify)
  Risk: Medium-High (breaking changes)

Route: PAUL
Execution:
  /paul:init "Migrate to ES modules"
  /paul:plan
  /paul:apply  (runs 3 phases with quality gates)
  /paul:unify
Time: 2 days.
```

### Example 3 — Sprint Work (TEAM)

```
Task: "Implement 3 user stories in parallel"

Classification:
  Independent tasks: 3
  Parallel opportunity: Yes
  Risk: Low (isolated)
  Time savings: 2x

Route: OMC TEAM
Execution: team 3:executor "Story 1" "Story 2" "Story 3"
Result: 3 PRs opened in parallel. Review and merge in any order.
Time: 1 day instead of 2.
```

### Example 4 — Unknown Bottleneck (AUTORESEARCH → PAUL)

```
Task: "API responses are too slow"

Classification:
  Root cause: Unknown
  Data needed: Yes (metrics, profiles)
  Research first: Yes
  Planning helps: After research

Route: autoresearch → PAUL

Execution:
  /autoresearch
  # Gathers: response times, database queries, network latency
  # Identifies: N+1 query issue in user list endpoint

  /paul:plan "Optimize N+1 queries with proper JOINs"
  /paul:apply

Time: 4 hours (1h research, 3h fix).
```

## Conflict Resolution (Two Routes Match)

Prefer in this order:

1. **Scope match** — PAUL for multi-phase; direct for single-step
2. **Locality** — project-level triggers in CLAUDE.md override generic routing
3. **Cost** — graph/memory query before raw file read; Haiku before Opus; skill before MCP when equivalent
4. **Completion guarantee** — PAUL requires `/paul:unify`; Autoresearch requires metric convergence
5. **Parallelism** — independent reviews (code-reviewer + security-reviewer) run in parallel; sequential reviews waste tokens

## Self-Check Before Spawning a Framework

- [ ] Is there an MCP / skill / subagent that solves this in one shot? (If yes, skip framework.)
- [ ] Does the user care about process visibility, or just the outcome? (If outcome, go direct.)
- [ ] Have I read `CAPABILITY-REGISTRY.md` for the task-pattern routing? (If no, do that first.)
- [ ] Are there dependencies between sub-tasks? (If no, parallelize instead of sequencing.)
- [ ] Can I use Graphify instead of raw file reads? (Usually yes; saves 10-30× tokens.)

## Pro Tips

- **Trust the engine.** Don't force PAUL for a 2-minute fix. The overhead costs more than the benefit.
- **Direct first.** If you can describe the fix in one sentence with high confidence, run it direct.
- **PAUL for anything multi-session.** If the work spans days, the unify step is where learning survives.
- **`team N:` only for truly independent work.** Dependencies kill parallelism.
- **Autoresearch needs a metric.** No metric = no loop to converge on. Use PAUL instead.
- **Ralph is for flakiness, not complexity.** Complex tasks want PAUL's structure; flaky tasks want ralph's persistence.

## Next Step

- [PAUL-INTEGRATION.md](./PAUL-INTEGRATION.md) — Deep dive on /paul:plan → /paul:apply → /paul:unify
- [OMC-INTEGRATION.md](./OMC-INTEGRATION.md) — autopilot, ralph, team, deep-interview
- [CUSTOMIZATION.md](./CUSTOMIZATION.md) — Add your own routing rules

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
