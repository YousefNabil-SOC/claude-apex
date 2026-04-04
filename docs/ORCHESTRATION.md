# Orchestration: The Decision Engine

## Overview

The Orchestration Engine is the brain that routes tasks to the optimal execution strategy. It classifies tasks and decides: direct → PAUL → OMC → SEED → autoresearch → ralph?

```
User Task
  ↓
Classification Engine
  ↓ (analyzes task characteristics)
  ├─→ Quick fix? (1-2 min) → DIRECT execution
  ├─→ Multi-step? (3+ phases) → PAUL framework
  ├─→ Parallel work? (3+ tasks) → OMC team mode
  ├─→ Vague scope? → SEED (interactive discovery)
  ├─→ Needs research? → autoresearch
  ├─→ Persistent retry? → ralph mode
  └─→ Unclear → deep-interview (Socratic Q&A)
```

## Decision Matrix

This matrix shows when to use each strategy:

| Task | Characteristics | Route | Why |
|------|---|---|---|
| "Fix typo in README" | Single file, obvious fix, <2 min | **Direct** | No ceremony needed |
| "Refactor auth module" | 3+ files, planning needed, 1+ day | **PAUL** | Structure prevents missed steps |
| "Write 5 new endpoints" | 5 parallel tasks, independent | **team 5:** | Parallel saves time |
| "Unclear requirements" | Vague scope, conflicting info | **SEED** | Interview clarifies intent |
| "Improve API performance" | Unknown root cause, data needed | **autoresearch** | Gather metrics first |
| "Fix flaky test" | Needs retries, retry-heavy | **ralph** | Never-quit persistence |
| "Build real-time feature" | New domain, exploration needed | **/deep-interview** | Discover via questions |

## Detailed Decision Rules

### Route 1: DIRECT Execution
**Conditions**:
- Task is simple (one file, obvious solution)
- Can be completed in <5 minutes
- No dependencies on other tasks
- Doesn't require planning

**Examples**:
```
"Fix typo in docs/README.md"
"Update imports in src/utils.ts"
"Add console.log for debugging"
```

**Execution**:
```bash
# Just do it
# No PAUL, no agents, direct execution
```

### Route 2: PAUL (Plan-Apply-Unify)
**Conditions**:
- Task has 3+ phases
- Planning helps prevent missed steps
- Work spans multiple files/components
- Risk of forgetting important steps

**Examples**:
```
"Refactor authentication module"
"Migrate from MySQL to PostgreSQL"
"Add real-time notifications"
```

**Execution**:
```bash
/paul:init "Your task"
/paul:plan
/paul:apply
/paul:unify
```

### Route 3: OMC TEAM (Parallel Execution)
**Conditions**:
- 3+ independent tasks
- Tasks don't depend on each other
- Want to save time (parallelism)
- Can benefit from 2-3x speedup

**Examples**:
```
"Build 3 API endpoints in parallel"
"Implement auth + payments + UI simultaneously"
"Sprint with 5 independent stories"
```

**Execution**:
```bash
team 5:executor \
  "Task 1" \
  "Task 2" \
  ...
```

### Route 4: SEED (Interactive Discovery)
**Conditions**:
- Requirements are vague/conflicting
- Need to clarify scope with user
- Risk of building wrong thing
- Benefit from structured questions

**Examples**:
```
"Build a dashboard" (vague)
"Improve system performance" (unclear which metric)
"Add user features" (what features?)
```

**Execution**:
```bash
/seed "Your vague idea"
# Agent asks clarifying questions
# Refines into concrete spec
```

### Route 5: autoresearch
**Conditions**:
- Root cause is unknown
- Need data/metrics to decide
- Benefit from research before action
- Complex optimization task

**Examples**:
```
"API is slow" (need to find why)
"Database queries taking too long" (need to profile)
"Choose between two libraries" (need comparison)
```

**Execution**:
```bash
autoresearch: "Research API performance bottlenecks"
# Agent gathers metrics, profiles, suggests fixes
```

### Route 6: ralph (Persistent Retry)
**Conditions**:
- Task is flaky/retry-heavy
- First approach might fail
- Need escalation to higher models
- Can't afford to give up

**Examples**:
```
"Fix flaky E2E test"
"Debug 'works on my machine' issue"
"Fix production bug that's hard to reproduce"
```

**Execution**:
```bash
ralph: "Task description"
# Tries up to 5 times, escalates models
```

### Route 7: deep-interview (Socratic)
**Conditions**:
- Requirements are exploratory
- Need to discover possibilities
- High value in structured questions
- Building something new

**Examples**:
```
"Build a real-time collaboration tool" (needs exploration)
"Create a new product feature" (unclear what's possible)
"Redesign the auth system" (many options)
```

**Execution**:
```bash
/deep-interview "Your idea"
# Agent asks Socratic questions
# Discovers requirements & creates spec
```

## Decision Rules (If-Then)

```python
def route_task(task_description):
    # Rule 1: Typos, simple fixes
    if task_duration < 5_minutes and single_file:
        return DIRECT
    
    # Rule 2: Vague scope
    if has_conflicting_requirements or unclear_scope:
        return SEED
    
    # Rule 3: Parallel work
    if independent_tasks >= 3:
        return OMC_TEAM
    
    # Rule 4: Multi-phase work
    if phases >= 3 and planning_helps:
        return PAUL
    
    # Rule 5: Unknown cause
    if root_cause_unknown and needs_research:
        return AUTORESEARCH
    
    # Rule 6: Flaky/retry-heavy
    if first_attempt_might_fail or needs_persistence:
        return RALPH
    
    # Rule 7: Exploration
    if exploratory_work and high_discovery_value:
        return DEEP_INTERVIEW
    
    # Default
    return DIRECT
```

## Customizing Routing

### Edit Routing Rules

```bash
# View current routing config
cat ~/.claude/config/orchestration.yaml

# Example:
---
routes:
  DIRECT:
    max_duration: 300  # seconds
    max_files: 1
  
  PAUL:
    min_phases: 3
    max_risk: 7        # out of 10
  
  TEAM:
    min_parallel_tasks: 3
    max_workers: 10
  
  AUTORESEARCH:
    keywords: [slow, optimize, debug, bottleneck]
    min_investigation_time: 900  # 15 min
  
  RALPH:
    keywords: [flaky, race, timing, intermittent]
    max_retries: 5
```

### Adjust Rules for Your Project

```bash
# Make PAUL more aggressive (use for 2+ phases instead of 3+)
/update-config orchestration.routes.PAUL.min_phases 2

# Make team mode more conservative (require 4+ tasks instead of 3+)
/update-config orchestration.routes.TEAM.min_parallel_tasks 4

# Increase ralph retry limit
/update-config orchestration.routes.RALPH.max_retries 10
```

## Routing Metrics

Track how often each route is used:

```bash
# Show routing statistics
/orchestration:stats

# Output:
Route Usage (last 30 days):
  DIRECT: 45%     (mostly small fixes)
  PAUL: 25%       (planned features)
  TEAM: 15%       (sprint work)
  SEED: 8%        (exploratory)
  ralph: 5%       (debugging)
  autoresearch: 2% (optimization)

Average success rate by route:
  DIRECT: 98%     (simple, predictable)
  PAUL: 94%       (structured, well-planned)
  TEAM: 92%       (parallel work, some overhead)
  SEED: 87%       (discovery, higher variance)
  ralph: 81%      (retry-heavy, tougher problems)
  autoresearch: 76% (unknowns, harder problems)
```

## Integration with CARL

CARL domain loading informs routing decision:

```
Task: "Optimize React component performance"
  ↓
CARL loads: libraries (React) + performance
  ↓
Orchestration Engine sees:
  - Complexity: Medium
  - Research needed: Yes
  - Planning helps: Yes
  ↓
Routes to: autoresearch (gather metrics)
           + PAUL (plan optimization)
           + OMC (parallel benchmarking)
```

## Examples: Routing in Action

### Example 1: Simple Fix
```
Task: "Add JWT token validation to API"

Classification:
  - Duration: < 1 hour
  - Files affected: 1-2
  - Planning needed: No
  - Risk: Low

Route: DIRECT

Execution: Write code, test, commit
Time: 45 minutes
```

### Example 2: Complex Refactor
```
Task: "Refactor codebase from CommonJS to ES modules"

Classification:
  - Duration: 8+ hours
  - Files affected: 20+
  - Phases: 3 (assess → migrate → verify)
  - Planning helps: Yes
  - Risk: Medium-High (breaking changes)

Route: PAUL

Execution:
  /paul:init "Migrate to ES modules"
  /paul:plan
  /paul:apply
  /paul:unify
Time: 2 days
```

### Example 3: Sprint Work
```
Task: "Implement 3 user stories in parallel"

Classification:
  - Independent tasks: 3
  - Parallel opportunity: Yes
  - Risk: Low (isolated)
  - Time savings: 2x (2 days → 1 day)

Route: OMC TEAM

Execution: team 3:executor "Story 1" "Story 2" "Story 3"
Time: 1 day
```

### Example 4: Vague Request
```
Task: "Improve the user experience"

Classification:
  - Scope: Vague (what aspect of UX?)
  - Conflicting info: Possible
  - Need clarification: Yes
  - Discovery value: High

Route: SEED → /deep-interview

Execution:
  /deep-interview "Improve user experience"
  # Agent asks: What's broken? 
  #             For which users?
  #             Metrics to improve?
  # Creates concrete spec
  # Then routes to PAUL or OMC

Time: 30 min (discovery) + 2 days (execution)
```

### Example 5: Unknown Bottleneck
```
Task: "API responses are too slow"

Classification:
  - Root cause: Unknown
  - Data needed: Yes (metrics, profiles)
  - Research first: Yes
  - Planning helps: After research

Route: autoresearch → PAUL

Execution:
  autoresearch: "Find API bottleneck"
  # Gathers: response times, database queries, network latency
  # Identifies: Database N+1 query issue
  
  /paul:plan "Optimize database queries"
  /paul:apply
  
Time: 4 hours (research + fix)
```

## Orchestration + Peer Collaboration

When using Peers (multi-terminal), orchestration helps coordinate:

```
Terminal 1 (Planner): /deep-interview → /paul:plan
  ↓ (sends plan to shared memory)

Terminal 2-3 (Executors): Read plan
  ↓
Orchestration routes each executor to: team 2:executor
  ↓
Both execute in parallel

Terminal 1: Monitors via /paul:status
  ↓
Terminal 1: /paul:unify (consolidates results)
```

## Best Practices

### 1. Trust the Engine
```bash
❌ Always use PAUL even for simple fixes
✅ Let orchestration decide (usually routes simple to DIRECT)
```

### 2. Provide Good Context
```bash
❌ "Build a dashboard"
✅ "Build a dashboard showing [YOUR_PROJECT] metrics, 
     real-time updates, 100 max users, mobile-first"
# Better context → better routing decision
```

### 3. Override When Needed
```bash
# Default routing
"Your task"  → Routes to PAUL

# Force DIRECT if you prefer
direct: "Your task"

# Force PAUL if orchestration chose wrong
/paul:init "Your task"
```

### 4. Check Stats Regularly
```bash
/orchestration:stats
# If mostly DIRECT, tasks might be too simple
# If mostly PAUL, might batch into TEAM mode
# If lots of SEED, requirements might be unclear
```

---

**Next**: [CUSTOMIZATION.md](./CUSTOMIZATION.md) → Extend Apex with custom agents, domains, and rules
