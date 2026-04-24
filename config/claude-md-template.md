# Claude Code — Global Configuration V7 (Apex)

## CARL Integration
Follow all rules in `<carl-rules>` blocks injected by the UserPromptSubmit hook from system-reminders.

## SESSION START (every session, in order)
1. Read `PRIMER.md` — who you are, what projects are active, stakeholder info
2. Read `CAPABILITY-REGISTRY.md` — routing table, tool inventory, MCP status
3. Read `MEMORY.md` — last session context (or `memory/session-handoff.md`)
4. If in a project folder — read that project's `CLAUDE.md`

`session-start-check.sh` runs automatically via the SessionStart hook. Do NOT run it manually.

NEVER read `SKILL-INDEX.md`, `COMMAND-REGISTRY.md`, `AGENTS.md` at startup — these are ON DEMAND only.

If effort level is above `high`, lower it to `high`. Never use `xhigh` or `max` unless explicitly commanded for a one-shot task.

## ON DEMAND (read when the task requires it)
- `SKILL-INDEX.md` — finding skill names
- `COMMAND-REGISTRY.md` — routing slash commands (182 commands indexed)
- `AGENTS.md` / `AGENT-REGISTRY.md` — selecting specialist agents
- `AUTO-ACTIVATION-MATRIX.md` — task → tool activation mapping
- `ORCHESTRATION-ENGINE.md` — when to use direct / PAUL / SEED / Autoresearch / OMC
- `tasks/lessons.md` — avoiding past mistakes
- `graphify query` — if CWD has `graphify-out/graph.json`

## TECH STACK DEFAULTS (override per project)
Frontend: React 19 + TypeScript + Tailwind CSS v4
Build: Vite 7 | Animation: GSAP 3.14 + Framer Motion 12 + Lenis
Backend: Node.js + Supabase (PostgreSQL) or FastAPI + PostgreSQL
Deploy: Vercel | Testing: Playwright | VCS: Git + GitHub

## STANDARDS (non-negotiable)
- TypeScript only (never plain JS) for web
- Mobile-first CSS, semantic HTML, error handling in every function
- Files under 300 lines — split into modules
- `npm run build` after every code change
- `git add` specific files only — NEVER `git add -A` or `git add .`

## TASK PROTOCOL
1. Classify task → look up `CAPABILITY-REGISTRY.md` routing table
2. Load listed skills, activate MCP servers
3. Execute (parallel where possible) → verify → update memory

## THREE-LAYER AUTO-ROUTING (V7 innovation)

Apex activates the right tools automatically from natural language. You should never need to type a slash command unless you want a specific one.

```
User prompt
    │
    ▼
┌───────────────────────────────────┐
│ Layer 1: CARL                     │   ← carl-hook.py on UserPromptSubmit
│ Injects domain-specific JIT rules │      Matches keywords → loads 1-9 domains
│ into context before Claude reads  │
└───────────────┬───────────────────┘
                ▼
┌───────────────────────────────────┐
│ Layer 2: CAPABILITY-REGISTRY      │   ← Claude reads at session start
│ Routes task type → Skills + MCP + │      e.g. "build website" →
│ Agents + CLI + Plugins            │      frontend-design + react-patterns +
│                                   │      playwright + context7 + architect
└───────────────┬───────────────────┘
                ▼
┌───────────────────────────────────┐
│ Layer 3: COMMAND-REGISTRY         │   ← Claude reads on demand
│ Auto-invokes slash commands when  │      e.g. "review this PR" →
│ user intent matches               │      /review-pr + /code-review (parallel)
└───────────────────────────────────┘
```

## SELF-HEALING (V7 addition)
Tool fails → log to `memory/tool-health.md` → check fallback table in CAPABILITY-REGISTRY.md → switch → continue.
At session end: write handoff to `memory/session-handoff.md`.
If session start takes > 30s, report which file is slow.
If task > 60min, pause and ask user for guidance.
If `effortLevel` is `xhigh` in settings.json at session start, change it to `high`. Respect manual `/effort` overrides mid-session.

## PARALLEL EXECUTION
- **Level 1 — Subagents**: 2-3 quick tasks, no inter-agent talk
- **Level 2 — Agent Teams**: 3+ tasks, own git worktrees (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`)
- **Level 3 — /batch**: 5-30 independent units. RuFlo swarm: 4+ hierarchical tasks

## VERCEL DEPLOYMENT (never skip the alias step)
`git add` (specific files) → commit → push → `vercel --prod` → `vercel alias set` → verify.
Skipping the alias step means clients see stale content on the canonical URL.

## ERROR RECOVERY
Read error → fix → rebuild. After 2 failed attempts: revert, try a different approach. Do NOT ask the user to debug something Claude Code should handle.

## IMAGE GENERATION (fal.ai budget awareness)
Prefer SVG/CSS/Canvas (free). fal.ai only for photorealistic images.
Max 3 images per request without asking.
Track costs per session. Stop at $0.50 remaining.

## DOCUMENT CREATION
Colors: define in project CLAUDE.md
Word: `docx-official` skill | PDF: `pdf-official` | PPTX: `pptx-official` | XLSX: `xlsx-official`

## TOKEN EFFICIENCY
- `/compact` between phases. After /compact: re-read ONLY `CAPABILITY-REGISTRY.md` and `PRIMER.md`.
- `/clear` only for unrelated projects.
- Subagents use Haiku (`CLAUDE_CODE_SUBAGENT_MODEL=haiku`).
- `MAX_THINKING_TOKENS=10000` — do not raise unless explicitly commanded.
- Graphify: query graph before raw file reads (~1K tokens vs ~10K for full file).

## COMMAND AUTO-INVOCATION
Before writing code: parse intent → consult `COMMAND-REGISTRY.md` → invoke matching commands.
CARL injects rules; COMMAND-REGISTRY dispatches commands.

## MODEL ROUTING (V7 dynamic)
- Planning / architecture / deep reasoning → **Opus**
- Review / analysis / execution / debugging → **Sonnet**
- Docs / fixes / quick lookups / explorer subagents → **Haiku**

Respect each agent's `model:` frontmatter. Default subagent: **Haiku**.

## TRIGGERS (project-specific — edit this list)
- `<TRIGGER_1>` → cd `<project-path-1>`, read that CLAUDE.md, activate
- `<TRIGGER_2>` → cd `<project-path-2>`, read that CLAUDE.md, activate
  (Define your own triggers for recurring project contexts.)

## CRITICAL RULES (customize for your workflow)
1. Define stakeholder titles in PRIMER.md — never improvise role names
2. Generate non-Latin scripts (Arabic, Hebrew, CJK) in Python, never terminal
3. `vercel --prod` → ALWAYS `vercel alias set`
4. Never `git add -A` — specific files only
5. Update MEMORY.md after major tasks
6. Literal paths (e.g. `C:\Users\you`) never `%USERPROFILE%` in hooks — Claude Code doesn't expand them

## OMC (oh-my-claudecode)
- Autopilot: `"autopilot: <task>"` — full autonomous execution
- Ralph: `"ralph: <task>"` — persistent loop until completion
- Team: `"team N:executor <task>"` — N parallel agents
- Dream: `"consolidate memory"` — 4-phase memory cleanup

## PAUL (structured execution)
`/paul:plan` → `/paul:apply` → `/paul:unify` (always close with unify — critical).

## HEALTH CHECK
When you say "health check" or "system status":
1. Report effortLevel, enabled plugin count, MCP server count, CLAUDE.md line count
2. Report if any hook fires excessively or background process > 200MB
3. Give 1-line verdict: HEALTHY or NEEDS ATTENTION (with reason)

## graphify
Trigger: `/graphify` → invokes the Skill tool with `skill: "graphify"`
Build a knowledge graph per project to save ~90% of file-reading tokens.

<!-- Claude Apex V7 by Engineer Yousef Nabil — https://github.com/YousefNabil-SOC/claude-apex -->
