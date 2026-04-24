# OMC Integration: Multi-Agent Autopilot

## What is OMC?

**OMC** = oh-my-claudecode, a sophisticated multi-agent orchestration layer that:
- Automates 5-stage pipelines (research → plan → implement → review → verify)
- Activates optimal agents for your task
- Routes between Haiku (fast), Sonnet (balanced), Opus (deep reasoning)
- Runs agents in parallel with auto-worktree isolation
- Never gives up (ralph mode) or explores deeply (deep-interview mode)

## 4 Execution Modes

### Mode 1: autopilot (Full 5-Stage Pipeline)

**When**: Task is clear, well-scoped, and you want end-to-end execution

**Syntax**:
```bash
autopilot: "Write a TypeScript utility to parse CSV files"
```

**5-Stage Pipeline**:
1. **Research** — Agent:analyst gathers requirements, searches for prior art
2. **Plan** — Agent:planner creates implementation plan, estimates effort
3. **Implement** — Agent:code-reviewer + tdd-guide write tests first, then code
4. **Review** — Agent:code-reviewer audits for quality, security, performance
5. **Verify** — Agent:e2e-runner creates tests, runs build, confirms success

**Output**:
```
AUTOPILOT: Write a TypeScript utility to parse CSV files

Stage 1/5: RESEARCH
  ✓ Found papaparse library (most popular CSV parser)
  ✓ Analyzed 3 alternatives (csv-parser, fast-csv)
  ✓ Decision: papaparse for native TypeScript support

Stage 2/5: PLAN
  ✓ Created implementation plan (3 phases, 2 hours)
  ✓ Phase 1: Setup + dependencies (30 min)
  ✓ Phase 2: Core parsing logic (60 min)
  ✓ Phase 3: Testing + validation (30 min)

Stage 3/5: IMPLEMENT
  ✓ Wrote 8 tests (TDD: RED → GREEN → IMPROVE)
  ✓ Implemented parseCSV() function (54 lines)
  ✓ Implemented validation (18 lines)
  ✓ Coverage: 92%

Stage 4/5: REVIEW
  ✓ Code quality: 94/100
  ✓ Security: No issues
  ✓ Performance: Within spec
  ✓ Suggestion: Add JSDoc comments (3 min)

Stage 5/5: VERIFY
  ✓ Build: PASS
  ✓ Tests: 8/8 pass
  ✓ Type check: PASS
  ✓ Status: COMPLETE ✅

Artifacts:
  - src/utils/parseCSV.ts (72 lines)
  - __tests__/parseCSV.test.ts (94 lines)
  - docs/PARSE-CSV-API.md (created)

Ready to commit: git commit -m "feat: CSV parsing utility"
```

**Best for**:
- Clear feature requests
- Well-defined requirements
- New utility functions
- Simple bug fixes

### Mode 2: ralph (Persistent, Never-Quit)

**When**: Task is difficult, flaky, or needs retries. ralph keeps trying.

**Syntax**:
```bash
ralph: "Fix flaky E2E test in authentication flow"
```

**Behavior**:
- Tries up to 5 times with different strategies
- If first approach fails, tries alternative
- Escalates to higher model (Haiku → Sonnet → Opus) on repeated failure
- Logs all attempts, explains why each failed
- Never gives up until success or max attempts reached

**Example**:
```
RALPH: Fix flaky E2E test in authentication flow

Attempt 1/5: Try fixing test isolation
  ✗ Failed: Tests still flaky
  Reason: Timing issue in login redirect

Attempt 2/5: Add wait() wrapper
  ✗ Failed: Tests slower but still flaky
  Reason: Race condition in session creation

Attempt 3/5: Use database transactions (higher-scope fix)
  ✓ Success! Tests now stable
  
Summary:
  - Attempts: 3/5
  - Approach: Database transaction isolation
  - Fix: tests/auth.e2e.ts (committed)
  - Learning: Session tests need atomic transactions

Status: COMPLETE ✅
```

**Best for**:
- Flaky tests
- Integration issues
- Debugging production errors
- "It works on my machine" problems

### Mode 3: team (Parallel Workers)

**When**: Multiple independent tasks that can run simultaneously

**Syntax**:
```bash
team 3:executor \
  "Task 1: Write user authentication" \
  "Task 2: Create payment integration" \
  "Task 3: Build dashboard UI"
```

**How it works**:
```
Task 1           Task 2           Task 3
  ↓                ↓                ↓
Agent1 (git      Agent2 (git      Agent3 (git
worktree1)       worktree2)       worktree3)
  ↓                ↓                ↓
Parallel execution (all at once)
  ↓                ↓                ↓
PR1              PR2              PR3
(auto-created, awaiting review)
```

**Features**:
- Auto-creates 3 git worktrees (isolated environments)
- Each worker has its own branch
- Workers don't interfere with each other
- All 3 PRs created simultaneously
- You review & merge in any order

**Example**:
```
TEAM: 3 parallel workers

Worker 1: Write user authentication
  ✓ Branch: feature/auth-worker1
  ✓ Tests: 24/24 pass
  ✓ PR created: #234 (ready for review)

Worker 2: Create payment integration
  ✓ Branch: feature/payment-worker2
  ✓ Tests: 18/18 pass
  ✓ PR created: #235 (ready for review)

Worker 3: Build dashboard UI
  ✓ Branch: feature/dashboard-worker3
  ✓ Tests: 32/32 pass
  ✓ PR created: #236 (ready for review)

Total time: 45 minutes (would be 2+ hours sequentially)
Speedup: 2.7x ⚡
```

**Best for**:
- Parallel development (backend + frontend + devops)
- Sprint work (3+ independent user stories)
- Unblocking teams (while one works on X, another on Y)
- Sprint planning (draft 3 features in parallel)

### Mode 4: deep-interview (Socratic Planning)

**When**: Requirements are vague or you need to explore possibilities

**Syntax**:
```bash
/deep-interview "Build a real-time collaboration tool"
```

**Behavior**:
- Agent asks Socratic questions to clarify scope
- Each answer narrows down the solution space
- Builds detailed specification as you answer
- Creates implementation plan based on your answers
- Takes 10-15 minutes, saves hours of rework

**Example Conversation**:
```
DEEP-INTERVIEW: Build a real-time collaboration tool

Question 1: How many concurrent users?
  You: "5-10 people per session"
  
Question 2: What data do they collaborate on?
  You: "Documents and diagrams"
  
Question 3: Conflict resolution strategy?
  You: "Last-write-wins, with undo capability"

Question 4: Offline support needed?
  You: "Yes, sync when reconnected"

Question 5: Existing infrastructure?
  You: "Node.js backend, React frontend"

Generated Specification:
  - Real-time sync: WebSockets + CRDT (Yjs library)
  - Document storage: PostgreSQL with versioning
  - Diagram storage: S3 + metadata in DB
  - Offline: IndexedDB + sync queue
  - Architecture: [detailed spec created]

Generated Plan (3 phases, 2 weeks):
  Phase 1: Setup + dependencies (2 days)
  Phase 2: Core sync engine (5 days)
  Phase 3: Testing + optimization (3 days)

Ready to: autopilot: "Implement real-time collaboration tool"
```

**Best for**:
- Exploratory features
- New projects
- Clarifying ambiguous requirements
- Cross-team alignment
- Pre-project discovery

## Model Routing Strategy

OMC automatically chooses the right Claude model:

```
Task complexity assessment:
  ↓
Simple (write function, fix bug)        → Haiku (fast, 90% of Sonnet)
Balanced (architecture, design)         → Sonnet (best all-around)
Complex (security, ML, reasoning)       → Opus (maximum capability)
```

### Model Economics

| Model | Speed | Cost | Best For | Threshold |
|-------|-------|------|----------|-----------|
| **Haiku** | 2x | $0.08/M tokens | Code generation, fixing, simple tasks | < 500 chars |
| **Sonnet** | 1x | $3/M tokens | Design, planning, most tasks | 500-5000 chars |
| **Opus** | 0.5x | $15/M tokens | Deep reasoning, security, ML | > 5000 chars, reasoning |

### Forcing a Model

```bash
# Use Opus for this task (extra reasoning)
opus: "Design secure authentication system"

# Use Haiku for speed
haiku: "Quick code generation"

# Default (auto-select)
autopilot: "Write utility"
```

## Activation Syntax

### Direct Activation
```bash
autopilot: "Your task here"
ralph: "Your task here"
team 5:executor "Task 1" "Task 2" ... "Task 5"
/deep-interview "Your idea"
```

### Via OMC Command
```bash
/omc-setup
# Walks you through setup, shows available modes

/omc-reference
# Shows all modes + syntax

/omc-teams --count 3
# Shortcut for team 3:executor
```

### With PAUL
```bash
/paul:plan "Refactor codebase"
# OMC auto-suggests best mode based on plan

/paul:apply
# Uses OMC for implementation
```

## OMC Configuration

Edit `.claude/settings.json`:
```json
{
  "omc": {
    "enabled": true,
    "defaultMode": "autopilot",
    "defaultTeamSize": 3,
    "modelRouting": {
      "haikuThreshold": 500,
      "sonnetThreshold": 5000,
      "opusAlways": ["security", "ml", "architecture"]
    },
    "parallelization": {
      "maxWorkers": 10,
      "autoWorktree": true,
      "autoPullRequests": true
    },
    "retry": {
      "maxRalphAttempts": 5,
      "escalateModelOnFailure": true
    }
  }
}
```

## OMC + PAUL Integration

Powerful combination: structured planning + parallel execution

```bash
# Phase 1: Plan
/paul:plan "Build [YOUR_PROJECT] feature"

# Phase 2: Parallel implementation
/paul:apply
# Uses team 3:executor automatically
#   - Agent1: Backend (Node.js)
#   - Agent2: Frontend (React)
#   - Agent3: Tests + deployment

# Phase 3: Consolidate
/paul:unify
# Merges all 3 PRs in proper sequence
# Verifies integration works
```

## Common Patterns

### Pattern 1: autopilot → code review
```bash
autopilot: "Implement feature X"
agent:code-reviewer "Review the output"
```

### Pattern 2: deep-interview → PAUL → team
```bash
/deep-interview "New feature idea"
/paul:plan
/paul:apply  # Uses team internally
/paul:unify
```

### Pattern 3: ralph for emergencies
```bash
ralph: "Fix production bug"
# Tries up to 5 times, escalates models, logs everything
```

### Pattern 4: Weekly sprint
```bash
team 5:executor \
  "Story 1: Auth" \
  "Story 2: Payments" \
  "Story 3: Admin" \
  "Story 4: API docs" \
  "Story 5: Tests"
# All 5 stories in parallel
```

## Troubleshooting

### OMC not activating
```bash
/healthcheck
# Check: "OMC agents: OK"

# If failed:
grep "omcEnabled" ~/.claude/settings.json
# Should be: "omcEnabled": true
```

### autopilot stuck on research phase
```bash
# Skip research, jump to planning
autopilot: "Task" --skip-research

# Or use PAUL instead
/paul:plan → /paul:apply
```

### team workers not creating PRs
```bash
# Check git worktree setup
git worktree list
# Should show 3 worktrees

# Check settings
grep "autoPullRequests" ~/.claude/settings.json
# Should be: "autoPullRequests": true
```

### ralph giving up too early
```bash
# Increase retry attempts
/update-config omc.retry.maxRalphAttempts 10

# Or switch to PAUL for structured retries
/paul:plan → /paul:resume on failure
```

---

## Pro Tips

- **Autopilot for clear tasks, deep-interview for fuzzy ones.** Autopilot assumes you know what you want; deep-interview asks first.
- **Ralph is for flaky, not hard.** Hard tasks want PAUL's structure. Ralph retries the same approach with small variations.
- **Team mode only when tracks are truly independent.** A shared data dependency kills the parallelism benefit.
- **Respect the model routing.** If you force `opus:` on every autopilot, your bill will triple without proportional quality gain.
- **Autopilot Stage 1 (Research) can skip with --skip-research** when you already know the approach.
- **Save autopilot logs.** They're in `memory/OMC-executions/` — useful for post-mortems on why autopilot picked one approach over another.

**Next**: [MEMORY-SYSTEM.md](./MEMORY-SYSTEM.md) → Understand auto-save and Dream consolidation

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
