# Claude Apex Architecture

## Overview

Claude Apex is a 5-layer autonomous agent system built on Anthropic's Claude Agent SDK. It powers 1,308 skills, 108 agents, and automated decision-making across 12 MCP servers and 19 plugins.

## 5-Layer Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│ Layer 5: Skills & Agents (Workers)                              │
│ 1,308 skills | 108 specialist agents | Task executors           │
├─────────────────────────────────────────────────────────────────┤
│ Layer 4: OMC Multi-Agent Orchestration                          │
│ autopilot | ralph | team | ultrawork | deep-interview          │
│ Model routing: Haiku/Sonnet/Opus                                │
├─────────────────────────────────────────────────────────────────┤
│ Layer 3: PAUL Structured Execution                              │
│ /paul:plan → /paul:apply → /paul:unify                         │
│ Quality gates, phase tracking, milestone management             │
├─────────────────────────────────────────────────────────────────┤
│ Layer 2: Orchestration Engine (Decision Classifier)             │
│ Task classification (coding/legal/marketing/research/devops)    │
│ Route to: PAUL/SEED/direct/autoresearch/team/ralph             │
├─────────────────────────────────────────────────────────────────┤
│ Layer 1: CARL (Just-In-Time Rules)                              │
│ 7 keyword-triggered domains: syntax, libraries, deployment...   │
│ Context injection, rule loading, memory restoration             │
└─────────────────────────────────────────────────────────────────┘
```

## How a Request Flows

1. **CARL Domain Detection** — Keywords trigger rule domains (e.g., "React" → library rules)
2. **Classification** — Orchestration Engine classifies task type
3. **Routing Decision** — Match task type to execution strategy
4. **Execution** — PAUL (multi-step), OMC agents (parallel), or direct execution
5. **Memory Update** — Auto-save to session memory, trigger Dream consolidation if needed

## Memory Persistence

### Session Memory (Auto-Save)
- **MEMORY.md** — Auto-updated after each task (150-line limit)
- **SESSION-MEMORY.md** — Per-project episodic memory
- **MEMORY.COMPACT** — Last compact checkpoint

### Memory Tiers
1. **Working Memory** — Current session (7 days auto-prune)
2. **Episodic Memory** — Project-level context (preserved)
3. **Semantic Memory** — Patterns, skills, lessons (permanent)

### Dream Consolidation
- **Trigger**: Manual `consolidate memory`, auto on session end
- **4-Phase Cycle**:
  1. Orient — Resume from last checkpoint
  2. Gather — Collect episodic events
  3. Consolidate — Compress & abstract patterns
  4. Prune — Remove obsolete entries, archive lessons

## Layer Details

### Layer 1: CARL (Rules System)
**Purpose**: Prevent context bloat by loading rules JIT

**7 Domains**:
- `syntax` — Language conventions, linting
- `libraries` — Framework-specific patterns (React, Django, etc.)
- `deployment` — Vercel, Kubernetes, Docker
- `security` — Authentication, encryption, OWASP
- `performance` — Optimization, caching, profiling
- `database` — SQL, migrations, indexing
- `devops` — CI/CD, monitoring, incident response

**How It Works**:
```bash
User types: "Set up GitHub Actions for Node.js"
↓
CARL detects keywords: [github, actions, nodejs]
↓
Loads domain: deployment
↓
Injects rules: CI/CD conventions, GitHub Actions syntax, Node.js best practices
↓
Agent now has focused context (80 lines instead of 800)
```

### Layer 2: Orchestration Engine
**Decision Matrix**:
| Task | Characteristics | Route | Rationale |
|------|-----------------|-------|-----------|
| Quick fix | <5 min, single file | Direct | No ceremony needed |
| Multi-step | 3+ steps, dependencies | PAUL | Structure prevents missed steps |
| Vague | Unclear scope | SEED | Interview clarifies intent |
| Optimize | Performance tuning | autoresearch | Needs data gathering |
| Parallel | 3+ independent tasks | team N: | Saves time, auto-worktree |
| Persistent | Long-running, retry-heavy | ralph | Never gives up |

### Layer 3: PAUL (Plan-Apply-Unify)
**3-Phase Loop**:
1. `/paul:plan` — Structure phases, estimate effort, identify risks
2. `/paul:apply` — Execute with quality gates at each phase
3. `/paul:unify` — Reconcile plan vs. reality, document lessons

**28 Commands**: See [PAUL-INTEGRATION.md](./PAUL-INTEGRATION.md)

### Layer 4: OMC (oh-my-claudecode)
**4 Execution Modes**:
- `autopilot` — Full 5-stage pipeline, no user intervention
- `ralph` — Persistent, retry on failure, never gives up
- `team N:` — N parallel workers, auto-worktree isolation
- `ultrawork` — Max parallelism (50+ concurrent workers)
- `deep-interview` — Socratic Q&A for planning

**Model Routing**: Haiku (fast) → Sonnet (balanced) → Opus (deep reasoning)

### Layer 5: Skills & Agents
- **Skills**: 1,308 reusable functions (code generation, deployment, testing, etc.)
- **Agents**: 108 specialist agents (planner, architect, security-reviewer, etc.)
- **Auto-Selection**: OMC picks best agent based on task classification

## Cross-Cutting Concerns

### Error Recovery
1. Catch error immediately
2. Check fallback table (CAPABILITY-REGISTRY.md)
3. Switch to alternative tool
4. If no alternative, surface to user

### Context Management
- Session context: ~32K tokens (20% reserved for safety)
- Extended thinking: Up to 31,999 tokens (configurable)
- File reading: Load only needed sections (use offset/limit)

### Token Efficiency Rules
- Compact between major phases
- Clear only for unrelated projects
- Sub-agents use Haiku (90% of Sonnet at 1/3 cost)
- MAX_THINKING_TOKENS: 10,000 (prevent runaway thinking)

## Configuration

See `.claude/settings.json`:
```json
{
  "orchestration": {
    "autoClassify": true,
    "carlEnabled": true,
    "paulDefaultMode": "apply",
    "omcAutoRoute": true
  },
  "memory": {
    "autoSave": true,
    "dreamTrigger": "manual|interval|session-end",
    "memoryLimit": 150
  },
  "agents": {
    "defaultModel": "sonnet",
    "haikuTreshold": "simple",
    "opusThreshold": "complex-reasoning"
  }
}
```

## When to Use Each Layer

| Scenario | Use |
|----------|-----|
| "Write a React component" | Direct (simple) or OMC autopilot (complex) |
| "Refactor legacy PHP" | PAUL (3-step: assess → plan → execute) |
| "Fix CI/CD pipeline" | ralph: (persistent, retry-heavy) |
| "Design database schema" | SEED (clarify requirements) + architect agent |
| "Run 10 performance tests" | team 10: (parallel execution) |
| "Unclear request" | deep-interview (Socratic Q&A) |

---

**Next Steps**:
- [GETTING-STARTED.md](./GETTING-STARTED.md) — First 5 minutes
- [PAUL-INTEGRATION.md](./PAUL-INTEGRATION.md) — Structured execution
- [OMC-INTEGRATION.md](./OMC-INTEGRATION.md) — Multi-agent modes
