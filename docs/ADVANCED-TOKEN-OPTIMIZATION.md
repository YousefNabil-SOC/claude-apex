# Advanced Token Optimization

> How to run Apex for 50% of typical token cost without losing capability.

## The Token Budget

Claude's context window is 200,000 tokens. Each token is about 4 characters of English. You pay per token at Anthropic's rates:

| Model | Input | Output | Cached input |
|---|---|---|---|
| Haiku 4.5 | $0.80 / M tokens | $4.00 / M tokens | $0.08 / M (cached) |
| Sonnet 4.6 | $3.00 / M tokens | $15.00 / M tokens | $0.30 / M (cached) |
| Opus 4.7 | $15.00 / M tokens | $75.00 / M tokens | $1.50 / M (cached) |

A moderate Apex user spends $5-$20/month. Heavy autopilot users hit $50-$200/month. You can cut that in half with awareness.

## What Loads at Session Start

Apex's `session-start-check.sh` reads **exactly 4 files plus memory markers** at session start:

| File | Typical size | Token cost |
|---|---|---|
| `CLAUDE.md` | 100-200 lines | ~1,500 tokens |
| `PRIMER.md` | 80-150 lines | ~1,200 tokens |
| `CAPABILITY-REGISTRY.md` | 200-250 lines | ~2,500 tokens |
| `AGENTS.md` | 170 lines | ~1,700 tokens |
| `memory/session-handoff.md` | up to 50 lines | ~400 tokens |
| `memory/learning-log.md` | variable | ~500 tokens |
| `memory/decisions.md` | variable | ~500 tokens |
| `memory/tool-health.md` | variable | ~300 tokens |
| **Total session start** | | **~8,600 tokens** |

Before V7 optimization, this was ~25,000 tokens (read everything in `~/.claude/`). V7's `session-start-check.sh` reads only these essentials — a 66% reduction.

## Graphify — the Biggest Token Saver

Raw file reads are expensive. For navigation and codebase questions, Graphify is 10-30× cheaper.

### Cost comparison

```
Question: "Where does the auth middleware live?"

Without Graphify:
  - Read src/index.ts         (2,000 tokens)
  - Read src/app.ts           (3,000 tokens)
  - Read src/middleware/*.ts  (8,000 tokens across 4 files)
  - Read src/auth/*.ts        (10,000 tokens across 5 files)
  Total: ~23,000 tokens

With Graphify:
  - graphify query "auth middleware"
  - Returns specific node with file path, imports, exports
  - Total: ~1,000 tokens
```

23× cheaper.

### Build a graph

```bash
cd /path/to/your/project
/graphify
```

This invokes the `graphify` skill, which builds `graphify-out/graph.json`. Cost depends on project size: a 10K LOC TypeScript project is AST-only (free); doc-heavy projects cost more but it's a one-time spend.

### Use the graph

Once built, `graphify query` calls are cheap. Claude auto-prefers the graph over raw reads — the PROJECT-NAVIGATION CARL domain enforces this:

```
Rules:
  0. ALWAYS query claude-mem (mem-search skill) for prior context BEFORE reading memory files
  1. ALWAYS check if a graphify knowledge graph exists BEFORE reading raw files
  2. Graph query costs ~1,000 tokens; raw file read can be 10,000+.
```

### Keep the graph fresh

```bash
graphify update .
```

Incremental refresh, always free. Run after major commits.

Or install the post-commit hook:
```bash
graphify hook install
```

## /clear vs /compact — the 4 Rules

### Rule 1 — /compact for most session breaks

`/compact` compresses your conversation history in-place. Typical 93% reduction. Use it:
- Between major phases of PAUL work
- After a long diagnostic session before moving to implementation
- When you notice Claude starting to forget earlier context

After /compact, the PostCompact hook runs `post-compact-recovery.sh`, which reminds Claude to re-read CAPABILITY-REGISTRY and PRIMER. This keeps three-layer routing intact.

### Rule 2 — /clear only for unrelated project switches

`/clear` wipes the conversation entirely. Use it only when switching to an unrelated project. Mid-project `/clear` loses valuable context and costs another ~8,600 tokens to rebuild at session start.

### Rule 3 — Never /clear mid-PAUL

PAUL state persists in `memory/paul-state.json`, so `/clear` doesn't lose the plan. But it does lose in-flight reasoning and decisions. Use `/paul:pause` + `/paul:resume` instead — designed for breaks.

### Rule 4 — /compact beats /clear for continued work

Default to `/compact`. It's non-destructive and idempotent.

## Effort Levels and Token Consumption

Effort level controls how much extended thinking Claude uses.

| Level | Extended thinking | Typical cost multiplier |
|---|---|---|
| `low` | Minimal | 0.7× |
| `medium` | Moderate | 0.9× |
| `high` (Apex default) | High | 1.0× |
| `xhigh` | Higher | 1.5-2× |
| `max` | Maximum | 3-5× |

Apex auto-lowers `xhigh`/`max` to `high` at session start via self-healing. This alone saves many users 30-50% of their spend.

### When to override

- **`max`** — genuinely hard architectural decisions where deep reasoning matters more than cost
- **`low`** — simple one-shot edits where you don't need reasoning

Reset with:
```
/effort high
```

## Model Routing Saves Tokens

Apex routes agents to different models based on task:

| Agent type | Model | Ratio |
|---|---|---|
| Explore, writer | Haiku | 1× |
| Most specialists (code-reviewer, security-reviewer, tdd-guide, SEO) | Sonnet | 3.75× Haiku |
| Architect, planner, critic, analyst, C-level advisors | Opus | 18.75× Haiku |

Running everything on Opus is 18× the cost of running everything on Haiku. Apex's V7 routing uses each tier where it earns its cost.

### Default subagent model

`CLAUDE_CODE_SUBAGENT_MODEL=haiku` in `settings.json` means subagents spawned by specialist agents default to Haiku. This cascades: when a Sonnet agent spawns 5 subagents for parallel exploration, those 5 are on Haiku.

## Prompt Caching (1-Hour TTL)

Apex enables `ENABLE_PROMPT_CACHING_1H=1` by default. Cached tokens cost 10% of non-cached.

### What gets cached

Anthropic's cache TTL is 5 minutes by default, 1 hour with this flag. Typical cache hits:
- Your session-start files (CLAUDE.md, PRIMER.md, CAPABILITY-REGISTRY.md, AGENTS.md)
- Repeated reads of the same project files within an hour

### Cost impact

A typical session with 5 tool calls per Claude turn:

- Turn 1: ~8,600 tokens at full price
- Turns 2-20: ~8,000 of those same tokens at cached price (10% cost)

Net savings: roughly 50% on repeated session-start context.

### When cache misses

- If you sleep > 1 hour between turns (TTL expired)
- If you `/compact` (context changes significantly)
- If you switch projects (`cd` to a new directory changes CWD markers)

## Measuring Your Token Usage

### Claude Code's built-in counter

Your statusline shows current session token usage. Check it after major operations to see what's expensive.

### Codeburn (optional)

Install `codeburn` (third-party tool) to track spend per session. Not shipped with Apex — install separately if you want per-session cost reports.

### Manual audit

Anthropic Console (https://console.anthropic.com) shows per-day spend broken down by model. Check at week's end to spot outliers.

## Practical Optimization Patterns

### Pattern 1 — Graphify before navigation

Before running "explain this codebase" or "where is X":
```
/graphify
```

Then the navigation query costs 10-30× less.

### Pattern 2 — /compact between PAUL phases

```
/paul:plan "Refactor auth"    # costs ~5,000 output tokens
/paul:apply                   # executes phase 1, ~20,000 tokens
/compact                       # compress to ~2,000 tokens
/paul:apply                   # phase 2 starts fresh
```

Without /compact, phase 2 carries ~20,000 tokens of phase 1 context.

### Pattern 3 — Use Haiku subagents explicitly

```
Use subagent: explore  "Find all references to handleAuth across the codebase"
```

`explore` is a Haiku agent. Using it for exploration saves ~4× vs defaulting to Sonnet.

### Pattern 4 — Consolidate memory weekly

```
consolidate memory
```

Runs Dream's 4-phase cleanup. Moves durable lessons to `lessons.md`, prunes old entries. Keeps session-start reads fast.

### Pattern 5 — Don't read whole files

Bad:
```
Read src/auth/index.ts              # 3,000 tokens
```

Good:
```
Read src/auth/index.ts:1-50         # 500 tokens
# Or:
Grep -n "handleAuth" src/auth/       # 100 tokens per match
```

Claude tools accept line ranges — use them.

### Pattern 6 — Batch related operations

Bad:
```
Turn 1: Read file A
Turn 2: Based on A, read file B
Turn 3: Based on B, read file C
```

Each turn incurs session-start cache overhead. If dependencies allow:
```
Turn 1: Read A, B, C in parallel
```

One turn, one cache hit, same information.

## Settings to Audit

```json
{
  "env": {
    "MAX_THINKING_TOKENS": "10000",           // cap thinking at 10K — don't raise
    "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "50",  // auto-compact at 50% full
    "CLAUDE_CODE_SUBAGENT_MODEL": "haiku",    // default subagents to Haiku
    "ENABLE_PROMPT_CACHING_1H": "1"           // 1-hour cache
  },
  "effortLevel": "high"                       // not xhigh, not max
}
```

These are Apex V7 defaults. If yours differ, you're probably overspending.

## Red Flags — you're overspending if:

- Your Anthropic bill is >$50/month for individual use
- You see `effortLevel: xhigh` or `max` in settings.json
- Your `MEMORY.md` is >500 lines (should be <200)
- You `/clear` instead of `/compact`
- You don't graphify large projects before navigating them
- Your autopilot runs everything on Opus (check agent model frontmatter)

## Pro Tips

- **Graphify every project you touch twice.** One-time cost, lifetime savings.
- **Honor CARL's PROJECT-NAVIGATION rules.** They're not suggestions — graph-first saves real money.
- **Never run autopilot on Opus-by-default.** Check each agent's model frontmatter.
- **`/compact` between phases, `/clear` between projects.** Almost never the reverse.
- **Audit your bill weekly for the first month.** Spot patterns early before habits form.
- **Subagents are cheap — use more of them.** Five Haiku subagents cost less than one Sonnet agent with the same context.

## Next Step

- [ADVANCED-MULTI-SESSION.md](./ADVANCED-MULTI-SESSION.md) — Multi-terminal coordination and handoffs
- [ADVANCED-CUSTOMIZATION.md](./ADVANCED-CUSTOMIZATION.md) — Build your own agents, skills, hooks

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
