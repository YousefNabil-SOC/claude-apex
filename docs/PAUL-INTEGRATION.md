# PAUL Framework: Plan-Apply-Unify Structured Execution

## The PAUL Loop

PAUL is a 3-phase structured execution framework for complex, multi-step tasks:

```
START
  ↓
/paul:plan      ← Decompose task into phases
  ↓
/paul:apply     ← Execute with quality gates
  ↓
/paul:unify     ← Reconcile plan vs reality
  ↓
END
```

## When to Use PAUL

**Use PAUL when**:
- Task has 3+ distinct phases
- Work spans multiple days/sessions
- Risk of missing steps is high
- You need documentation/audit trail
- Multiple people involved

**Don't use PAUL when**:
- Task is simple (one file, <5 min)
- Fully exploratory (unclear scope)
- Emergency incident (use direct command instead)

## 28 PAUL Commands

### Core Commands (Essential)

| Command | Purpose | Example |
|---------|---------|---------|
| `/paul:init` | Start new PAUL task | `/paul:init "Refactor auth module"` |
| `/paul:plan` | Create structured plan | `/paul:plan` |
| `/paul:apply` | Execute current phase | `/paul:apply` |
| `/paul:unify` | Finish & document | `/paul:unify` |

### Phase Management

| Command | Purpose | Example |
|---------|---------|---------|
| `/paul:add-phase` | Insert new phase | `/paul:add-phase "Testing" 3` |
| `/paul:remove-phase` | Delete phase | `/paul:remove-phase 4` |
| `/paul:list-phase-assumptions` | Show phase risks | `/paul:list-phase-assumptions` |
| `/paul:plan-phase-gaps` | Identify blockers | `/paul:plan-phase-gaps` |

### Progress Tracking

| Command | Purpose | Example |
|---------|---------|---------|
| `/paul:progress` | Show current status | `/paul:progress` |
| `/paul:status` | Detailed milestone view | `/paul:status` |
| `/paul:milestone` | Mark phase complete | `/paul:milestone "Phase 2: Testing done"` |
| `/paul:consider-issues` | Link GitHub issues | `/paul:consider-issues #123 #456` |

### Execution Control

| Command | Purpose | Example |
|---------|---------|---------|
| `/paul:apply` | Execute phase | `/paul:apply` |
| `/paul:pause` | Pause execution | `/paul:pause` |
| `/paul:resume` | Resume from pause | `/paul:resume` |
| `/paul:discuss` | Q&A on current phase | `/paul:discuss "How should we...?"` |
| `/paul:discuss-milestone` | Q&A on milestone | `/paul:discuss-milestone 2` |

### Planning & Adjustment

| Command | Purpose | Example |
|---------|---------|---------|
| `/paul:research` | Investigate task | `/paul:research "API rate limits"` |
| `/paul:research-phase` | Investigate phase | `/paul:research-phase 1` |
| `/paul:map-codebase` | Analyze codebase | `/paul:map-codebase /src` |
| `/paul:discover` | Find edge cases | `/paul:discover "Authentication flows"` |

### Verification & Quality

| Command | Purpose | Example |
|---------|---------|---------|
| `/paul:verify` | Check plan quality | `/paul:verify` |
| `/paul:audit` | Audit milestone | `/paul:audit 2` |
| `/paul:assumptions` | List plan assumptions | `/paul:assumptions` |

### Workflow Control

| Command | Purpose | Example |
|---------|---------|---------|
| `/paul:flows` | Show all PAUL workflows | `/paul:flows` |
| `/paul:register` | Register custom workflow | `/paul:register my-workflow` |
| `/paul:config` | Customize PAUL behavior | `/paul:config --phases 6 --depth deep` |
| `/paul:help` | Show all commands | `/paul:help` |

### Cleanup & Handoff

| Command | Purpose | Example |
|---------|---------|---------|
| `/paul:handoff` | Transfer to another person | `/paul:handoff @[YOUR_MANAGER]` |
| `/paul:plan-fix` | Recover from failure | `/paul:plan-fix` |

## Example Workflow: Refactor Authentication Module

### Step 1: Initialize Plan

```bash
/paul:init "Refactor authentication module in [YOUR_PROJECT]"
```

Output:
```
PAUL Task Started: Refactor authentication module
ID: paul-2026-04-04-001
Estimated effort: 3-5 days

What's next? Run: /paul:plan
```

### Step 2: Create Plan

```bash
/paul:plan
```

Pantheon asks:
```
1. Current state: Describe the auth module?
2. Goal state: What should it do?
3. Constraints: Time, resources, dependencies?
4. Risks: What could go wrong?
```

You answer each question, then:

```
PAUL Plan Created: 5 phases

Phase 1: Assess Current Implementation (2 hours)
  - Review existing auth code
  - Document current flows
  - Identify tech debt
  Assumptions: Code is in /src/auth/

Phase 2: Design New Architecture (4 hours)
  - Design new auth flows
  - Choose libraries (e.g., next-auth vs custom)
  - Create architecture diagram
  Risks: Team alignment on choice

Phase 3: Test Coverage (3 hours)
  - Write tests for new design
  - Reach 80%+ coverage
  - Test edge cases (token expiry, 2FA, etc.)
  Assumptions: Jest available

Phase 4: Implement (8 hours)
  - Rewrite auth module
  - Integrate with existing code
  - Handle migrations
  Risks: Breaking changes to API

Phase 5: Verify & Deploy (3 hours)
  - E2E testing
  - Canary deploy
  - Monitor for issues
  Risks: Production incidents

Total: 20 hours, 5 days at 4h/day

Run: /paul:apply to start Phase 1
```

### Step 3: Execute Phases

```bash
/paul:apply
# Executes Phase 1: Assess Current Implementation
```

During execution:
```
[Phase 1/5] Assess Current Implementation
Status: IN PROGRESS

✓ Reviewed auth code (/src/auth/index.ts, 342 lines)
✓ Documented current flows (JWT + sessions)
✓ Found tech debt:
  - No token refresh logic
  - Sessions not invalidated on logout
  - No 2FA support

Next: /paul:milestone "Phase 1 complete"
```

After Phase 1:

```bash
/paul:milestone "Phase 1 complete - documented 3 tech debt items"
/paul:apply
# Executes Phase 2: Design New Architecture
```

### Step 4: Handle Blockers

If stuck:

```bash
/paul:discuss "Should we migrate from JWT to sessions?"
# Opens Q&A with architect agent
```

Or skip a phase:

```bash
/paul:pause
# Pauses current execution

# Later...
/paul:research "How do we handle token expiry?"
/paul:resume
# Resumes from where you paused
```

### Step 5: Finish

```bash
/paul:apply
# Completes all 5 phases

/paul:unify
```

Output:
```
PAUL Plan Unification: Refactor authentication module

Plan vs Reality:
Phase 1 ✓ Assess - On time (2 hours)
Phase 2 ✓ Design - 1 hour over (complex flows)
Phase 3 ✓ Testing - On time (3 hours)
Phase 4 ✓ Implement - 2 hours under (cleaner code)
Phase 5 ✓ Verify - On time (3 hours)

Actual total: 21 hours (1 hour over, within margin)

Key Learnings:
1. Design phase is complex - estimate extra time for discussions
2. Choosing next-auth saved implementation time
3. E2E tests caught edge case in token refresh

Artifacts:
- Architecture document: docs/AUTH-ARCHITECTURE.md
- Implementation: src/auth/new-implementation/
- Tests: __tests__/auth.test.ts (94 tests, 87% coverage)
- Runbook: docs/AUTH-RUNBOOK.md

Recommendations for future auth work:
- Use next-auth for new features
- Require architecture review before Phase 2
- Add 20% buffer for design discussions

Status: COMPLETE ✓
```

## Customizing PAUL

### Set default phase count

```bash
/paul:config --phases 6 --default-duration "2 weeks"
```

### Use pre-built workflow templates

```bash
/paul:flows
# Shows: refactor, feature, migration, incident-response, security-audit

/paul:register incident-response
# Uses incident response template for planning
```

## PAUL Best Practices

### 1. Make assumptions explicit
```
❌ Phase 1: Code review
✅ Phase 1: Code review (assumes: access to main branch, no code freeze)
```

### 2. Include verification at each phase
```
Phase 3: Implement
  Tasks:
    - Write code
    - ✓ Self-review
    - ✓ Unit tests pass
    - ✓ Linting passes
  Quality gate: 80% coverage minimum
```

### 3. Estimate conservatively
```
❌ Phase 2: Design (1 hour)
✅ Phase 2: Design (1-2 hours, complex decisions needed)
```

### 4. Document decisions in /paul:discuss
```bash
/paul:discuss "Why JWT vs sessions?"
# Creates decision log in PAUL artifact
```

## Troubleshooting

### "My plan is too vague"
```bash
/paul:research "Topic"
/paul:discover "Edge cases"
# Then /paul:plan again
```

### "Phase took longer than estimated"
```bash
/paul:pause
/paul:plan-fix
# Adjust remaining phases based on learnings
```

### "Need to add urgent phase"
```bash
/paul:add-phase "Hot fix: Security patch" 2
# Inserts new phase at position 2
```

### "Switching contexts to other task"
```bash
/paul:pause
# Status saved, can resume later
/paul:resume
# Picks up where you left off
```

## PAUL + OMC Multi-Agent

PAUL works with OMC for automation:

```bash
/paul:plan
# Creates phases

/paul:apply
# In background: team 3:executor runs
#   - Agent 1: code review
#   - Agent 2: tests
#   - Agent 3: security scan
# All parallel, PAUL tracks progress
```

## Integrating with Git

PAUL auto-creates commits:

```
After /paul:unify:

Commits created:
  - "phase: assess current implementation"
  - "phase: design new architecture"
  - "phase: implement refactoring"
  - "phase: verify and document"

Branch: feature/paul-refactor-auth-YYYY-MM-DD

Ready to: git push origin feature/paul-refactor-auth-2026-04-04
```

---

**Next**: [OMC-INTEGRATION.md](./OMC-INTEGRATION.md) → Combine PAUL with multi-agent orchestration
