# Orchestration Engine — Decision Framework

## Request Classification Matrix

| Request Type | Route To | Example |
|-------------|----------|---------|
| Quick single task | Direct execution | "Fix this typo", "Add a button" |
| Multi-step task (3+) | PAUL: plan → apply → unify | "Build auth system", "Refactor module" |
| Vague idea / exploration | SEED or /deep-interview | "I want to build something for...", "What if we..." |
| Optimization with metric | Autoresearch | "Improve load time", "Reduce bundle size" |
| Parallel independent work | OMC team N:executor | "Update 5 components", "Test across browsers" |
| Persistent must-complete | Ralph | "Don't stop until...", "Must finish..." |
| Full autonomous pipeline | Autopilot | "autopilot: build a dashboard" |
| Multi-terminal coordination | Claude Peers | Complex projects needing multiple sessions |

## Parallelism Levels

### Level 1 — Subagents (lightweight)
- 2-3 quick focused tasks
- No inter-agent communication needed
- Use: `Agent(subagent_type="...", ...)` calls in parallel

### Level 2 — Agent Teams (collaborative)
- 3+ tasks that share findings
- Each agent gets own context
- Use: `team N:executor <task>`

### Level 3 — Batch (mass parallel)
- 5-30 independent units
- Auto-worktree isolation
- Each creates its own PR if needed

### Level 4 — RuFlo Swarm
- 4+ tasks needing hierarchical coordination
- Via claude-flow MCP tools
- Orchestrator → workers → aggregator pattern

## Decision Flow

```
1. Classify the request (table above)
2. Check CARL for relevant domain rules
3. Load required skills/agents
4. Determine parallelism level
5. Execute with chosen framework
6. Verify output (build, test, screenshot)
7. Update memory if significant
```

## When NOT to Use a Framework

- Simple file edits → just edit
- Quick questions → just answer
- Single-file bugs → just fix
- Don't add framework overhead to 30-second tasks
