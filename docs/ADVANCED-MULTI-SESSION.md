# Advanced Multi-Session Workflows

> How to coordinate work across multiple Claude Code terminals: Peers, Agent Teams, session handoff, and Dream memory consolidation.

## The Three Multi-Session Primitives

1. **Claude Peers** — multiple terminals, same machine, message each other over `localhost:7899`
2. **Agent Teams** — one terminal spawns N parallel workers in git worktrees
3. **Session handoff** — a single terminal resumes from the last session's state

And a fourth mechanism that supports all three:
4. **Dream consolidation** — 4-phase memory cleanup that preserves durable lessons across sessions

## Claude Peers — Inter-Terminal Communication

### Architecture

```
Terminal 1 (Planner)    Terminal 2 (Backend)    Terminal 3 (Frontend)
      │                       │                       │
      ▼                       ▼                       ▼
┌─────────────────────────────────────────────────────────────┐
│ Peers Broker (localhost:7899)                               │
│  - Peer discovery                                           │
│  - Message routing                                          │
│  - Shared memory: ~/.claude/memory/peers/shared/            │
└─────────────────────────────────────────────────────────────┘
```

### Start the broker (once per machine)

```bash
cd ~/.claude
bash hooks/peers-auto-register.sh.disabled
```

Note the `.disabled` suffix — rename to `peers-auto-register.sh` to enable by default on future sessions.

### Discover peers

In any terminal:
```bash
list_peers
```

**Expected:**
```
Connected Peers (localhost:7899):
1. peer-terminal-1 (Summary: Planner for my-webapp)
2. peer-terminal-2 (Summary: Backend - API endpoints)
3. peer-terminal-3 (Summary: Frontend - UI work)
```

### Announce your role

```bash
set_summary "Backend Engineer — API layer"
```

Visible to all peers. Helps avoid duplicate work.

### Send messages

```bash
# To a specific peer
send_message peer-terminal-2 "Spec for /api/users is in shared/sprint/users-api.md"

# To all peers
send_message all "Database migration applied — please rebase"
```

### Receive messages

```bash
receive_message
# Lists all pending messages, then clears them
```

### Shared memory

```
~/.claude/memory/peers/shared/
├── sprint/
│   ├── users-api.md
│   └── checkout-flow.md
├── decisions.log
├── blockers.md
└── open-questions.md
```

All peers read/write this directory. Use append (`>>`) not overwrite (`>`) for logs to avoid clobbering each other.

### Example workflow — 1 planner + 2 executors

**Terminal 1 (Planner):**
```bash
set_summary "Planner: Sprint 12 structure"

/deep-interview "Sprint 12 goals"
/paul:plan

# Write plan to shared location
cp ~/sprint-12-plan.md ~/.claude/memory/peers/shared/sprint/plan.md

send_message all "Sprint plan ready! shared/sprint/plan.md"
```

**Terminal 2 (Backend Executor):**
```bash
set_summary "Executor: Story 1 - Backend"

receive_message
# Sprint plan ready! shared/sprint/plan.md

cat ~/.claude/memory/peers/shared/sprint/plan.md
# Reads the plan

autopilot: "Implement backend for Story 1"

send_message peer-terminal-1 "Story 1 complete, PR #234"
```

**Terminal 3 (Frontend Executor):**
```bash
set_summary "Executor: Story 2 - Frontend"

receive_message
cat ~/.claude/memory/peers/shared/sprint/plan.md

autopilot: "Implement frontend for Story 2"

send_message peer-terminal-1 "Story 2 complete, PR #235"
```

Parallel speedup: roughly 2× for independent tracks.

## Agent Teams — One Terminal, N Workers

Unlike Peers (N terminals you manage), Agent Teams have one terminal spawn N parallel workers automatically.

### Syntax

```bash
team N:executor "Task 1" "Task 2" ... "Task N"
```

### What happens

1. Apex creates N git worktrees, one per task
2. Spawns N executor agents, each in its own worktree
3. Agents work in parallel — no inter-agent communication by default
4. Each opens a PR when complete
5. Main terminal monitors progress and reports

### Example

```bash
team 5:executor \
  "Write unit tests for user service" \
  "Generate OpenAPI docs for payment API" \
  "Optimize image loading in product grid" \
  "Add dark mode toggle to settings page" \
  "Fix accessibility issues in checkout"
```

Roughly 45 minutes instead of 2+ hours sequential. 5 PRs open for review.

### Prereq

In `settings.json`:
```json
"env": {
  "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
}
```

Apex enables this by default in V7.

### When to use Peers vs Teams

| Use Peers when... | Use Teams when... |
|---|---|
| You want different roles (planner + executors) | All workers are executors |
| Tasks share state or coordinate mid-flight | Tasks are truly independent |
| You want manual control per terminal | You want hands-off parallelism |
| Long-running multi-day work | Single-session burst of parallel work |

### Combining them

You can use both:
```
Terminal 1 (Planner) runs /paul:plan
Terminal 1 sends plan to shared memory
Terminal 2 (Executor) reads plan, dispatches team 3:executor for sub-tasks
Terminal 3 (Reviewer) polls PRs, runs /review-pr on each
```

## Session Handoff — Single Terminal Continuity

### The handoff flow

```
Session N ends                   Session N+1 starts
      │                                 │
      ▼                                 ▼
Stop hook fires                  SessionStart hook fires
      │                                 │
      ▼                                 ▼
session-end-save.sh              session-start-check.sh
appends timestamp to             reads session-handoff.md
session-handoff.md               + MEMORY.md + PRIMER.md
      │                                 │
      ▼                                 ▼
Keep last 50 lines               Claude sees last session's
(no bloat)                       end state in context
```

### What gets preserved

- `memory/session-handoff.md` — last 50 lines of timestamps + notes
- `memory/MEMORY.md` — main memory file (up to 200 lines)
- `memory/decisions.md` — durable architectural decisions
- `memory/learning-log.md` — patterns to repeat or avoid
- `memory/tool-health.md` — tool failures with fallback choices

### Write a good handoff note

At session end, before typing `/exit`, add context:

```
memory: "Left off in phase 2 of auth refactor. 
TODO next session: integrate JWT refresh with session cookies."
```

This appends to MEMORY.md. Next session, Claude reads it.

### Read the handoff at next start

Claude auto-reads it via `session-start-check.sh`. Look for the session-handoff block in the first response.

### Manual resume

```
/resume
```

Re-reads the last session transcript from Claude Code's own archives (if enabled). Different from the handoff — more detailed but larger token cost.

## Dream Consolidation — Memory Preservation Across Sessions

Dream is Apex's memory consolidation skill. It runs a 4-phase cleanup:

### Phase 1 — Orient

Reads MEMORY.md, session-handoff.md, last 3 archived sessions. Figures out what's current vs stale.

### Phase 2 — Gather

Collects events from the current session:
- Tasks completed
- Decisions made
- Files changed
- Tools that failed
- Lessons learned

### Phase 3 — Consolidate

- Raw events (500 lines) → abstract patterns (50 lines)
- Patterns that repeat 3+ times → promote to `lessons.md`
- One-off observations → keep in MEMORY.md
- Resolved blockers → archive with resolution note

### Phase 4 — Prune

- Remove entries older than 30 days (unless tagged important)
- Move completed tasks to `archive/`
- Compress duplicated session summaries

### Trigger manually

```
consolidate memory
```

### Auto-trigger

Runs at session end via `session-end-save.sh` if MEMORY.md exceeds the soft limit (200 lines).

### Scheduled

If you want weekly consolidation regardless:
```
/schedule "Weekly memory consolidation" "0 2 * * 0" "consolidate memory"
```

(Requires the `schedule` skill, which is optional.)

## Multi-Project Memory Strategy

### Global vs Project memory

- **Global**: `~/.claude/memory/` — shared across all projects
- **Project-specific**: inside each project's folder, a `CLAUDE.md` and optionally a `MEMORY.md`

### Switching projects

```
/switch-project my-webapp
```

Apex:
1. Reads `<project>/CLAUDE.md`
2. Merges project-specific rules over global
3. Project's MEMORY.md becomes active

### Shared learnings

Things you learn in project A that apply globally go in `~/.claude/memory/lessons.md`. Claude loads this in every project.

## Coordinating Work Across Sessions

### Pattern 1 — Plan in one session, execute in next

```
Session 1 (Opus-tier planning):
  /paul:plan "Migration plan"
  /paul:pause
  (exit — plan saved to paul-state.json)

Session 2 (next day):
  /paul:resume
  /paul:apply
  /paul:unify
```

### Pattern 2 — One PR per session

Keeps context clean. Each session ships one feature, unifies state, ends.

### Pattern 3 — Long-running autopilot with handoffs

```
Session 1:
  autopilot: "Build e-commerce checkout"
  (3 hours, hits token budget)
  /compact
  /exit

Session 2:
  (session-start reads handoff, sees autopilot was 60% done)
  autopilot: "Continue e-commerce checkout"
```

Autopilot state is in `memory/OMC-executions/`. Session start reloads it.

### Pattern 4 — Peers with Git branches

```
Terminal 1: cd ~/project && git checkout feature/auth
Terminal 2: cd ~/project && git checkout feature/ui
Terminal 3: cd ~/project && git checkout feature/api

All 3 work in parallel, rebase on main periodically.
Peers messages coordinate merge order.
```

## Memory Anti-Patterns

### Don't — let MEMORY.md grow past 500 lines

Session-start cost balloons. Run `consolidate memory`.

### Don't — write session transcripts to MEMORY.md

Summaries, not transcripts. If you need the full transcript, Claude Code archives them natively.

### Don't — ignore tool-health.md

Tool failures log there with fallback choices. If the same tool keeps failing across sessions, the log tells you.

### Don't — mix private and shared memory in peers/

Shared = visible to all peers. Keep sensitive data in `~/.claude/private/` (not a peers dir).

## Shipping Multi-Session Work

### Handoff checklist

Before ending a session with handoff to yourself or a teammate:

- [ ] Run `consolidate memory` if MEMORY.md is over 200 lines
- [ ] Update PRIMER.md if project status changed
- [ ] Commit and push any unstaged changes
- [ ] Add a handoff note to MEMORY.md: "TODO next session: X"
- [ ] If PAUL is active, run `/paul:pause` (not `/exit` mid-phase)
- [ ] If Peers is active, `send_message all "Signing off — check shared/ for my notes"`

### Next-session checklist

When you open a new session:

- [ ] Let session-start-check.sh read handoff automatically
- [ ] Type `/healthcheck` if anything feels off
- [ ] If resuming PAUL, run `/paul:resume`
- [ ] If resuming autopilot, check `memory/OMC-executions/` for state
- [ ] If you're the next person (not yourself), read the handoff note out loud — catches assumptions you wouldn't spot silently

## Pro Tips

- **Peers is for collaboration; Teams is for parallelism.** Don't confuse them.
- **One broker per machine.** Don't start multiple brokers on different ports — it defeats discovery.
- **Always append to shared logs.** `>>`, not `>`. Race conditions are real.
- **Dream weekly if memory grows.** Easier than fighting a 500-line MEMORY.md.
- **Test handoff with yourself.** End a session intentionally; next session, see if the handoff captured enough.
- **Peers works best on < 5 terminals.** Beyond that, PR review becomes the bottleneck — use Teams instead.

## Next Step

- [PEERS-SETUP.md](./PEERS-SETUP.md) — Detailed Peers workflow
- [MEMORY-SYSTEM.md](./MEMORY-SYSTEM.md) — Memory tiers and Dream in depth
- [ADVANCED-CUSTOMIZATION.md](./ADVANCED-CUSTOMIZATION.md) — Custom hooks for your team

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
