# PRIMER — Read this FIRST at the start of every session

> **This is a TEMPLATE.** Copy it to `~/.claude/PRIMER.md` and replace every `<placeholder>` with your real info. Delete sections you don't need. The more specific this file is, the better Claude Code serves you.

---

## Who am I working with?
- Name: `<your-name>`
- Role / Title: `<your-role>`
- Company / Team: `<your-company>`
- Location / Timezone: `<your-timezone>`
- Primary language(s): `<your-language>`
- Communication preferences: `<slack|email|whatsapp|terse|verbose>`

## Stakeholders (people Claude might be writing for)
- `<Stakeholder 1>` — `<title>` — how to address them: `<tone>`
- `<Stakeholder 2>` — `<title>` — how to address them: `<tone>`

Rule: use stakeholder titles EXACTLY as specified. Never improvise role names.

## Active Projects (in priority order)

### 1. `<Project Name>` — `<STATUS>`
- URL: `<production-url>`
- Codebase path: `<local-path>`
- GitHub: `<owner/repo>`
- Tech stack: `<e.g. React 19 + TS + Vite 7 + Tailwind v4>`
- Status: `<one-line status>`
- Next steps: `<one-line next action>`
- Resume trigger: `"<TRIGGER>"` — then read `<project>/CLAUDE.md` and `<project>/MEMORY.md`
- Critical rule: `<e.g. always run vercel alias after deploy>`

### 2. `<Project Name>` — `<STATUS>`
(Repeat the same structure.)

### 3. `<Project Name>` — `<STATUS>`
(Add or remove projects as needed.)

## Tech Stack (always use for this profile's web projects)
`<React + TypeScript + Tailwind CSS + Vite + Vercel + Supabase>` (customize)

## Critical Rules (never break these)
1. `<Rule 1 — e.g. never commit with git add -A>`
2. `<Rule 2 — e.g. vercel alias set after every vercel --prod>`
3. `<Rule 3 — e.g. run npm run build before committing>`
4. `<Rule 4 — e.g. mobile-first responsive design>`
5. `<Rule 5 — e.g. English-only in terminal, generate non-Latin scripts in Python>`

## Image Generation Budget
- fal.ai balance: `<$X.XX>`
- Default to code-based graphics (SVG, CSS, Canvas) — they are FREE
- Use fal.ai ONLY for photorealistic images
- Max 3 images per request without asking
- Start with FLUX Schnell ($0.003) for drafts, only use Pro ($0.05) for finals
- Track and report costs after every generation session

## Environment version: V7 (Claude Apex)
- Skills: `<count>` | Agents: `<count>` | MCP servers: `<count>` | Plugins: `<count>`
- CARL: 9 domains, 40 rules
- Hooks: PostCompact, Stop, Notification, UserPromptSubmit, SessionStart-chain
- Model routing: Opus for planning, Sonnet for execution, Haiku for trivia
- See `CAPABILITY-REGISTRY.md` for the live tool inventory

## Session memory
- `memory/session-handoff.md` — last session's open items
- `memory/tool-health.md` — which tools are broken / fallbacks
- `memory/decisions.md` — durable decisions made across sessions
- `memory/learning-log.md` — patterns Claude should repeat or avoid
