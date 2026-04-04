# Memory System: Auto-Save and Dream Consolidation

## Overview

Claude Pantheon has a sophisticated 3-tier memory system that auto-saves context, consolidates learnings, and persists across sessions:

```
┌─────────────────────────────────────────┐
│ Semantic Memory (Permanent)              │
│ - Patterns, lessons, skills (keep forever)
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│ Episodic Memory (Project-Level)          │
│ - SESSION-MEMORY.md (project context)   │
│ - SESSION-HANDOFF.md (task transitions)  │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│ Working Memory (Session-Level)           │
│ - MEMORY.md (150-line limit, auto-prune) │
│ - Auto-updated after each major task    │
└─────────────────────────────────────────┘
```

## Auto-Save (Always On)

### What Gets Auto-Saved
After every major task, Pantheon auto-saves to `MEMORY.md`:
- Task description
- Key decisions made
- Artifacts created (file paths)
- Learnings discovered
- Blockers encountered
- Time estimate vs actual

### Example Auto-Save Entry

```markdown
## Session 42 Summary (2026-04-04) — Refactor Authentication Module

### What was done:
1. Created new JWT implementation in src/auth/jwt.ts
2. Wrote 24 tests (TDD: RED → GREEN → IMPROVE)
3. Migrated existing auth calls (3 files affected)

### Key decisions:
- JWT over sessions (simpler, stateless)
- RS256 algorithm (asymmetric, secure)
- 1 hour expiry (balance of security/UX)

### Artifacts:
- src/auth/jwt.ts (142 lines)
- __tests__/jwt.test.ts (203 lines)
- docs/AUTH-ARCHITECTURE.md (created)

### Time:
- Estimate: 4 hours
- Actual: 3.5 hours
- Difference: -30 min (TDD saved time)

### Learnings:
- TDD prevents rework on auth (complex logic)
- JWT library choice matters (node-jsonwebtoken most stable)
- Test data factory pattern essential (3+ different user scenarios)

### Next priority:
- Integration tests with API endpoints
- Frontend token refresh logic
```

## MEMORY.md Structure & Limits

### 150-Line Limit
MEMORY.md is capped at **150 lines** to stay digestible:

```bash
# Check current size
wc -l ~/.claude/memory/MEMORY.md

# If over 150 lines, consolidate
consolidate memory
```

### What to Keep
```markdown
✅ Last 3-5 session summaries (most recent first)
✅ Current project active status
✅ Pending priorities (1-3 items max)
✅ Key deployment info (URLs, credentials pattern)
✅ Link to detailed memory files (SESSION-MEMORY.md)

❌ Full session transcripts (too verbose)
❌ Completed tasks from 2+ weeks ago
❌ Resolved blockers (archive to lessons.md)
```

### Pruning Strategy
```markdown
## Session 40 Summary (2026-03-29) — ARCHIVED
[Link to: memory/archive/session-40.md]

## Session 41 Summary (2026-03-31)
[Full details, still relevant]

## Session 42 Summary (2026-04-04) — CURRENT
[Full details, most relevant]
```

## Dream Consolidation (4-Phase Cycle)

Dream is triggered to compress memory when sessions get too large.

### Phase 1: Orient
**Goal**: Resume from last checkpoint

```bash
consolidate memory
# Loads previous checkpoint
# Reads MEMORY.md, SESSION-MEMORY.md, lessons.md
```

### Phase 2: Gather
**Goal**: Collect episodic events from current session

```
Gathering events:
  ✓ Task: "Refactor auth" (2 hours)
  ✓ Learnings: "TDD saves rework" 
  ✓ Decision: "Use JWT not sessions"
  ✓ Artifact: "src/auth/jwt.ts"
  ✓ Blocker: "Integration tests pending"
  ✓ Time delta: estimate 4h, actual 3.5h
```

### Phase 3: Consolidate
**Goal**: Abstract patterns, compress details

```
Consolidation:
  Raw events: 47 lines (session transcript)
             → Abstracted: 8 lines (summary)
  
  Pattern: "TDD in auth code"
           → Stored in semantic memory as lesson
  
  Decision: "JWT vs sessions"
           → Documented in decisions.log
           
  New skill: "Token refresh pattern"
           → Added to skill library
```

### Phase 4: Prune
**Goal**: Remove obsolete entries, archive old data

```
Pruning:
  ✓ Remove entries older than 30 days (unless important)
  ✓ Move completed tasks to archive/
  ✓ Compress resolved blockers
  ✓ Archive session logs (keep summaries)
  ✓ Clean up temp working memory entries
```

## Triggering Dream Consolidation

### Manual Trigger
```bash
consolidate memory

# Or verbose mode
consolidate memory --verbose
```

### Auto-Trigger (Happens at Session End)
```bash
# At end of session, Pantheon runs:
consolidate memory --auto

# Creates: memory/consolidation-<date>.log
```

### Scheduled Consolidation
```bash
# Every Sunday at 2 AM
/schedule "Weekly memory consolidation" "0 2 * * 0" \
  "consolidate memory"
```

## Memory File Structure

### Directory Layout
```
~/.claude/memory/
├── MEMORY.md                    # Main (150-line limit)
├── SESSION-MEMORY.md            # Current project context
├── SESSION-HANDOFF.md           # Last session → this session
├── lessons.md                   # Permanent learnings
├── tool-health.md               # Failed tools + fallbacks
├── decisions.md                 # Key architectural decisions
├── projects/
│   └── [YOUR_PROJECT]/
│       ├── SESSION-MEMORY.md    # Project-specific context
│       └── lessons.md           # Project learnings
├── archive/
│   ├── session-40.md
│   ├── session-41.md
│   └── consolidation-2026-03-31.log
└── peers/shared/                # Shared memory (multi-terminal)
    ├── sprint/
    └── decisions/
```

### SESSION-MEMORY.md (Project-Level)
Persists across all sessions for a project:

```markdown
# Session Memory — [YOUR_PROJECT]

## Last Updated: 2026-04-04

## Active Work
- Current feature: "User dashboard"
- Current blocker: "Performance optimization needed"
- Current branch: feature/dashboard-metrics

## Project Context
- Tech stack: React 19 + TypeScript + Supabase
- Test coverage: 78%
- Build status: ✓ PASS

## Recent Decisions
- Use Supabase for real-time (vs Firebase)
- Client-side caching with TanStack Query
- E2E tests with Playwright (vs Cypress)

## Pending PRs
- #234: Dashboard UI (awaiting review)
- #235: Performance optimization (in progress)

## Known Issues
- Slow initial load (being addressed in #235)
- Mobile responsiveness (minor, backlog)
```

### lessons.md (Permanent Learnings)
Preserved forever, grows over time:

```markdown
# Project Learnings — [YOUR_PROJECT]

## Testing
- TDD prevents rework in auth code (Session 42)
- E2E tests need data factories (Session 40)
- Flaky tests need transaction isolation (Session 39)

## Performance
- Memoization essential for React component trees >100 nodes (Session 41)
- Database indexes on user_id + created_at (Session 38)

## Architecture
- Supabase row-level security works well for multi-tenant (Session 37)
- Avoid N+1 queries with proper JOIN logic (Session 36)

## Deployment
- Always run migrations before deploy (Session 42)
- Monitor error logs for 10 min post-deploy (Session 41)
```

### tool-health.md (Self-Healing)
Logs tool failures and fallbacks:

```markdown
# Tool Health Log

## Failed Tools & Recovery
- **Tool**: lspServerTypescript
  Status: FAILED (2026-04-04 09:30)
  Error: "Language server timeout"
  Fallback: Switched to ast-grep parser
  Resolved: (2026-04-04 10:15) — restarted service
  
- **Tool**: vercelCLI
  Status: FAILED (2026-04-02)
  Error: "No Vercel token found"
  Fallback: Using HTTP API directly
  Status: ONGOING — waiting for token refresh
```

## Best Practices

### 1. Summarize, Don't Transcribe
```markdown
❌ User asked X. I said Y. User replied Z. Agent said A.
✅ Implemented feature X via approach Y. 2 key learnings discovered.
```

### 2. Link to Detailed Memory
```markdown
❌ [500-line session transcript pasted here]
✅ Session 42: Refactor authentication (see archive/session-42.md)
```

### 3. Keep Learnings Actionable
```markdown
❌ "Found that TDD is good"
✅ "TDD on auth code saves 30% rework time — always use for security-critical code"
```

### 4. Update MEMORY.md at Session End
```bash
# At end of session, Pantheon prompts:
# "Update MEMORY.md? (y/n)"
# → Review and save key learnings
```

## Memory Across Projects

### Switching Projects
```bash
/switch-project [YOUR_PROJECT]

# Pantheon loads:
# 1. ~/.claude/memory/MEMORY.md (global)
# 2. ~/.claude/projects/[YOUR_PROJECT]/SESSION-MEMORY.md (project-specific)
# 3. ~/.claude/projects/[YOUR_PROJECT]/lessons.md (project learnings)
```

### Shared Knowledge
Global lessons in `~/.claude/memory/lessons.md` are available to all projects:

```bash
# Add global lesson
echo "Always use connection pooling for databases" \
  >> ~/.claude/memory/lessons.md

# Available to all projects via MEMORY
```

## MEMORY.md Lifecycle

```
Session 1: MEMORY.md created
  ├─ 15 lines (small project)
  └─ End of session: auto-save

Session 2: MEMORY.md updated
  ├─ 35 lines (more context)
  └─ End of session: auto-save

Sessions 3-5: MEMORY.md grows
  ├─ 50 → 75 → 100 lines
  └─ End of each: auto-save

Session 6: MEMORY.md exceeds 150 lines
  ├─ Consolidate memory triggered
  ├─ Old entries archived
  ├─ Patterns abstracted
  ├─ Size: 150 lines → 95 lines
  └─ End of session: auto-save

Sessions 7+: Maintain 150-line limit
  ├─ New entries added at top
  ├─ Old entries periodically archived
  ├─ Lessons extracted to lessons.md
  └─ Cycle repeats as needed
```

## Troubleshooting

### "MEMORY.md is too large"
```bash
consolidate memory --aggressive
# Compresses more aggressively, archives older entries
```

### "Lost context from previous session"
```bash
# Check SESSION-HANDOFF.md
cat ~/.claude/memory/SESSION-HANDOFF.md

# Should contain: "Last session ended at: ..."
# If empty, context was lost

# Restore from archive
ls ~/.claude/memory/archive/session-*.md | tail -1
# Read most recent archived session
```

### "Learnings not being saved"
```bash
# Check if lessons.md is writable
ls -la ~/.claude/memory/lessons.md

# If missing, create it
touch ~/.claude/memory/lessons.md

# Next consolidation will populate it
```

### "Memory seems stale"
```bash
# Force full consolidation with trace
consolidate memory --trace

# Will show:
# Phase 1: Orient ✓
# Phase 2: Gather ✓
# Phase 3: Consolidate ✓
# Phase 4: Prune ✓
```

## Integration with PAUL & OMC

### PAUL Auto-Updates Memory
```bash
/paul:plan "Task"
# Creates: memory/paul-plans/plan-2026-04-04.md

/paul:unify
# Auto-saves to: memory/paul-unifications/
# Adds learnings to: lessons.md
```

### OMC Auto-Updates Memory
```bash
autopilot: "Task"
# Creates: memory/OMC-executions/autopilot-2026-04-04.log

# On completion, auto-saves:
# - Artifacts created
# - Time vs estimate
# - Model selection rationale
```

---

**Next**: [ORCHESTRATION.md](./ORCHESTRATION.md) → Understand the decision engine that routes tasks
