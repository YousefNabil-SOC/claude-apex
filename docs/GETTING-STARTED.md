# Getting Started with Claude Apex

## Your First 5 Minutes

### Step 1: Verify Installation (1 minute)

```bash
cd ~/.claude
ls -la
# Should show: agents/ | skills/ | config/ | hooks/ | memory/ | settings.json
```

### Step 2: Health Check (1 minute)

```bash
/healthcheck
```

Expected output:
```
✓ CARL system: OK (7 domains loaded)
✓ Orchestration engine: OK (5 routes available)
✓ OMC agents: OK (108 agents active)
✓ PAUL framework: OK (28 commands ready)
✓ Memory system: OK (MEMORY.md writable)
✓ MCP servers: OK (12/12 connected)
```

If anything shows RED, see [TROUBLESHOOTING.md](./TROUBLESHOOTING.md).

### Step 3: Try Autopilot (2 minutes)

Start with a simple task:

```
autopilot: Write a TypeScript function to validate email addresses
```

Watch Apex:
1. Classify task (coding)
2. Load relevant skills (typescript, testing)
3. Activate OMC autopilot mode
4. Execute in 5 stages: research → plan → implement → review → verify

### Step 4: Try PAUL (If multi-step) (1 minute)

For complex tasks with 3+ steps:

```
/paul:init "Refactor authentication module"
/paul:plan
# Creates phases: assess → redesign → test → deploy
# Shows risks, estimates effort, identifies blockers
```

Then:
```
/paul:apply
# Executes each phase with quality gates
```

Finally:
```
/paul:unify
# Reconciles plan vs reality, documents lessons learned
```

## What's Next?

Choose your path:

### Path 1: Multi-Agent Work
- Run **parallel teams**: `team 3:executor "Task 1" "Task 2" "Task 3"`
- Or persistent retry: `ralph: "Flaky test that needs debugging"`
- Read [OMC-INTEGRATION.md](./OMC-INTEGRATION.md)

### Path 2: Structured Planning
- Create detailed plans: `/paul:plan --phases 5 --risk-assessment`
- Track milestones: `/paul:milestone "Phase 2 complete"`
- Read [PAUL-INTEGRATION.md](./PAUL-INTEGRATION.md)

### Path 3: Understand the System
- Architecture overview: [ARCHITECTURE.md](./ARCHITECTURE.md)
- Agent guide: [AGENTS-GUIDE.md](./AGENTS-GUIDE.md)
- CARL domains: [CARL-GUIDE.md](./CARL-GUIDE.md)

### Path 4: Customize
- Add your own agents: [CUSTOMIZATION.md](./CUSTOMIZATION.md)
- Create CARL domains: [CARL-GUIDE.md](./CARL-GUIDE.md)
- Configure settings: `/switch-project` or edit `.claude/settings.json`

## Quick Commands Reference

| Command | Purpose | When to Use |
|---------|---------|------------|
| `/healthcheck` | Verify all systems | Session start |
| `autopilot: <task>` | Full 5-stage pipeline | Clear, well-defined tasks |
| `/paul:plan` | Structure multi-step work | 3+ steps with dependencies |
| `team N: <task>` | Run N parallel workers | Independent parallel work |
| `ralph: <task>` | Persistent, never-quit | Retry-heavy, flaky tasks |
| `/deep-interview <idea>` | Socratic Q&A planning | Unclear requirements |
| `/switch-project <name>` | Load project context | Multiple active projects |
| `consolidate memory` | Run Dream consolidation | Session cleanup |

## Common Scenarios

### Scenario 1: Write a feature
```
autopilot: Add user authentication to [YOUR_PROJECT]
```
Apex handles: analysis → design → TDD (test-first) → code review → verification.

### Scenario 2: Debug failing test
```
ralph: Fix failing E2E test in [YOUR_PROJECT]/tests/auth.e2e.ts
```
ralph will retry, try alternatives, and never give up.

### Scenario 3: Refactor large codebase
```
/paul:plan
# Breaks into phases: analyze → design → execute → test → document
/paul:apply
```

### Scenario 4: Run 3 independent tasks in parallel
```
team 3:executor \
  "Task 1: Write docs" \
  "Task 2: Fix bugs" \
  "Task 3: Optimize DB queries"
```

## Keyboard Shortcuts

| Binding | Action |
|---------|--------|
| `Cmd+Enter` (Mac) / `Ctrl+Shift+Enter` (Windows) | Submit & execute |
| `Alt+T` | Toggle extended thinking (31K tokens) |
| `Ctrl+O` | Show thinking output |
| `Cmd+/` (Mac) / `Ctrl+/` (Windows) | Command palette |

See [keybindings-help skill](../skills/keybindings-help.md) to customize.

## Safety Guardrails

Apex includes:
- PII detection (auto-redaction for sensitive data)
- Prompt injection detection (via AIDefence MCP)
- Rate limiting (5 req/sec per agent)
- Token budget enforcement (stop at 85% of context window)

All mitigations happen silently — you won't notice unless something is blocked.

## Troubleshooting This Step

### "OMC not activating"
```bash
grep -i "omc" ~/.claude/settings.json
# Should have: "omcEnabled": true
```

### "PAUL commands not found"
```bash
/paul:help
# If 404, reinstall: cd ~/.claude/commands && git pull
```

### "Health check failed"
See [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) → "OMC Agent Initialization Failed"

## Next: Deep Dive

- [ARCHITECTURE.md](./ARCHITECTURE.md) — Understand the 5-layer system
- [AGENTS-GUIDE.md](./AGENTS-GUIDE.md) — Meet your 25 specialist agents
- [PAUL-INTEGRATION.md](./PAUL-INTEGRATION.md) — Master structured execution
- [OMC-INTEGRATION.md](./OMC-INTEGRATION.md) — Unlock parallel execution
