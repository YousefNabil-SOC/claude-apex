# Getting Started with Claude Apex

> You have Apex installed. Here's what to do in your first 5 minutes.

## Your First 5 Minutes

### Step 1 — Verify installation (1 minute)

```bash
cd ~/.claude
ls -la
```

**Expected:** `agents/`, `commands/`, `hooks/`, `skills/`, `settings.json`, `MEMORY.md`, `CLAUDE.md`, `PRIMER.md`.

### Step 2 — Health check (1 minute)

```bash
claude
```

Then type:
```
/healthcheck
```

**Expected output (abbreviated):**
```
System Health Check V7

 #  | System              | Status
----|---------------------|--------
 1  | OMC Plugin          | OK
 2  | PAUL Framework      | OK
 3  | CARL                | OK (9 domains, 40 rules)
 4  | Autoresearch        | OK
 5  | SEED                | OK
 6  | UserPromptSubmit    | OK (carl-hook.py)
 7  | SessionStart        | OK
 8  | PostCompact Hook    | OK
 9  | Sound Notification  | OK (60s cooldown)
 10 | Settings JSON       | OK
 11 | MCP Servers         | OK (4 default)
 12 | 21st.dev Magic      | OK
 13 | Graphify            | OK
 14 | Premium Web Design  | OK
 15 | Skills Count        | OK (1,276+)
 16 | Agents Count        | OK (108)
 17 | effortLevel         | OK (high)
 18 | Memory Health       | OK

Result: 18/18 OK — all systems green
```

If anything shows `FAIL`, jump to [10-TROUBLESHOOT-FOR-BEGINNERS.md](./10-TROUBLESHOOT-FOR-BEGINNERS.md).

### Step 3 — Try autopilot (2 minutes)

```
autopilot: Write a TypeScript function to validate email addresses
```

**What happens:**
- CARL fires → WEB-DEVELOPMENT rules inject (9 rules)
- CAPABILITY-REGISTRY → typescript-pro + test skills activated
- OMC autopilot runs 5-stage pipeline

**Expected result:**
- `src/utils/validateEmail.ts` created
- `__tests__/validateEmail.test.ts` created with 6+ tests
- Build passes (0 errors, 0 warnings)
- Tests pass (6/6)

### Step 4 — Try PAUL (for multi-step work)

For tasks with 3+ phases:

```
/paul:plan "Refactor authentication module"
```

PAUL creates a plan. Review it. Then:

```
/paul:apply
```

PAUL runs each phase with quality gates.

Finally — and this is mandatory:

```
/paul:unify
```

PAUL reconciles plan vs reality and documents lessons learned.

## What's Next? Choose Your Path

### Path 1 — Multi-Agent Work
- Run parallel teams: `team 3:executor "Task 1" "Task 2" "Task 3"`
- Or persistent retry: `ralph: "Flaky test that needs debugging"`
- Read [OMC-INTEGRATION.md](./OMC-INTEGRATION.md)

### Path 2 — Structured Planning
- Create detailed plans: `/paul:plan`
- Track milestones: `/paul:milestone`
- Read [PAUL-INTEGRATION.md](./PAUL-INTEGRATION.md)

### Path 3 — Understand the System
- Architecture overview: [ARCHITECTURE.md](./ARCHITECTURE.md)
- Agent guide: [AGENTS-GUIDE.md](./AGENTS-GUIDE.md)
- CARL domains: [CARL-GUIDE.md](./CARL-GUIDE.md)

### Path 4 — Customize
- Add your own agents: [CUSTOMIZATION.md](./CUSTOMIZATION.md)
- Create CARL domains: [CARL-GUIDE.md](./CARL-GUIDE.md#adding-your-own-domain)
- Configure settings: edit `~/.claude/settings.json`

## Quick Commands Reference

| Command | Purpose | When to Use |
|---|---|---|
| `/healthcheck` | Verify all systems | Session start, after install |
| `autopilot: <task>` | Full 5-stage pipeline | Clear, well-defined tasks |
| `/paul:plan` | Structure multi-step work | 3+ steps with dependencies |
| `team N: <task>` | Run N parallel workers | Independent parallel work |
| `ralph: <task>` | Persistent, never-quit | Retry-heavy, flaky tasks |
| `/deep-interview <idea>` | Socratic Q&A planning | Unclear requirements |
| `/switch-project <name>` | Load project context | Multiple active projects |
| `consolidate memory` | Run Dream consolidation | Session cleanup |
| `/graphify` | Build project knowledge graph | Before heavy navigation |
| `/compact` | Compress conversation | Free up context |

## Common Scenarios

### Scenario 1 — Write a feature

```
autopilot: Add user authentication to my-webapp
```

Apex handles: analysis → design → TDD (test-first) → code review → verification.

### Scenario 2 — Debug a failing test

```
ralph: Fix failing E2E test in tests/auth.e2e.ts
```

Ralph retries, tries alternatives, escalates models, and never gives up.

### Scenario 3 — Refactor large codebase

```
/paul:plan
# Creates phases: analyze → design → execute → test → document
/paul:apply
/paul:unify
```

### Scenario 4 — Run 3 independent tasks in parallel

```
team 3:executor \
  "Task 1: Write docs for the API" \
  "Task 2: Fix bugs in the checkout" \
  "Task 3: Optimize DB queries"
```

## Keyboard Shortcuts

| Binding | Action |
|---|---|
| `Ctrl+Enter` / `Cmd+Enter` | Submit & execute |
| `Alt+T` / `Option+T` | Toggle extended thinking |
| `Ctrl+O` / `Cmd+O` | Show thinking output |
| `Ctrl+L` | Clear terminal |

## Safety Guardrails (V7 defaults)

- **effortLevel capped at `high`** — self-healing lowers `xhigh`/`max` at session start
- **MAX_THINKING_TOKENS=10000** — prevents runaway thinking
- **Subagents use Haiku** — `CLAUDE_CODE_SUBAGENT_MODEL=haiku`
- **Non-destructive install** — every change is backed up to `~/.claude/backups/`
- **`.env` chmod 600** — your API keys are user-read-only

## Troubleshooting Quick Fixes

### "OMC not activating"
```bash
grep -i "oh-my-claudecode" ~/.claude/settings.json
# Should show: "oh-my-claudecode@omc": true
```

### "PAUL commands not found"
```
/paul:help
```
If 404, the PAUL plugin is not installed. Install via `/plugin install paul-framework`.

### "Health check shows FAIL"
See [10-TROUBLESHOOT-FOR-BEGINNERS.md](./10-TROUBLESHOOT-FOR-BEGINNERS.md) or run the repo's `verify.sh`.

## Pro Tips

- **Type natural language.** The three-layer routing activates the right tools — you rarely need to type slash commands.
- **Run `/healthcheck` at the start of each session.** 10 seconds to know everything's green.
- **Use `/compact` between phases.** Especially after big PAUL sessions.
- **Edit PRIMER.md with your actual projects.** Claude reads it every session — the more specific, the better the output.
- **Don't `/effort max` casually.** `high` is enough for almost everything. Max burns tokens.

## Next — Deep Dive

- [ARCHITECTURE.md](./ARCHITECTURE.md) — The three-layer routing system
- [AGENTS-GUIDE.md](./AGENTS-GUIDE.md) — Meet 108 specialist agents
- [CARL-GUIDE.md](./CARL-GUIDE.md) — JIT rule loading (9 domains, 40 rules)
- [PAUL-INTEGRATION.md](./PAUL-INTEGRATION.md) — Structured execution
- [OMC-INTEGRATION.md](./OMC-INTEGRATION.md) — Multi-agent modes

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
