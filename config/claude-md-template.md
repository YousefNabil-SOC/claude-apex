# Claude Code — Project Configuration (Pantheon V6)

## Identity
- Owner: [YOUR_NAME]
- Company: [YOUR_COMPANY]
- Role: [YOUR_ROLE]

## Tech Stack
- Frontend: [e.g., React + TypeScript + Tailwind CSS]
- Backend: [e.g., Node.js + Express]
- Database: [e.g., PostgreSQL / Supabase]
- Deployment: [e.g., Vercel / AWS / Netlify]

## Standards
- Always TypeScript — never plain JavaScript
- Always mobile-first CSS
- Always include error handling
- Always semantic HTML for accessibility
- Keep files under 300 lines — split into modules

## Brand
- Primary Color: [YOUR_BRAND_PRIMARY]
- Accent Color: [YOUR_BRAND_ACCENT]
- Text Color: [YOUR_BRAND_TEXT]

## Key People
- [TITLE]: [NAME] (use correct title always)

## Deployment Rules
After every production deploy:
1. git add (specific files) -> git commit -> git push
2. Deploy command — wait for completion, note URL
3. Set production alias if applicable
4. Verify with Playwright screenshot

## Pantheon V6 Environment
- Agents: 25 custom specialists in ~/.claude/agents/
- CARL: 7 domains, 33 JIT rules in ~/.carl/carl.json
- Orchestration: ~/.claude/ORCHESTRATION-ENGINE.md
- Health: /healthcheck for 15-system verification
- Projects: /switch-project for instant context loading

## Memory Rules
- Read MEMORY.md at session start
- Update MEMORY.md after completing major tasks
- Keep MEMORY.md under 200 lines — summarize, never bloat

## Token Efficiency
- Use /compact between major phases
- Use /clear only when switching to unrelated tasks
