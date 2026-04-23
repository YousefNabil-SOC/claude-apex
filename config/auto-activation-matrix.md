# Auto-Activation Matrix (Claude Apex V7)

# When a user gives a task, this is what activates automatically via the three-layer routing system.

## Task Type → Tools Activated

| Task Type | Skills | MCP Servers | Agents | CLI Tools | Plugins |
|-----------|--------|-------------|--------|-----------|---------|
| Build a website | frontend-design, premium-web-design, tailwind-patterns, react-patterns | playwright, github, context7, @21st-dev/magic | architect, code-reviewer + RuFlo coder, tester, reviewer | Playwright CLI, gh | frontend-design |
| Generate a UI component | 21st-dev-magic, premium-web-design | @21st-dev/magic, context7 | architect | npx, npm | frontend-design |
| Fix a bug in React | systematic-debugging, clean-code | playwright, github | build-error-resolver + RuFlo coder, tester | Playwright CLI, gh | code-simplifier |
| Review a contract | (LEGAL domain auto-activates) | exa-web-search, filesystem | legal-advisor agent | - | security-guidance |
| Write marketing content | copywriting, content-creator | exa-web-search | content-marketer | - | prompt-improver |
| Research a topic | deep-research | exa-web-search, firecrawl | RuFlo researcher | Playwright CLI | - |
| Create Word document | docx-official | filesystem | doc-updater | - | - |
| Create PDF | pdf-official | filesystem | doc-updater | Python (reportlab) | - |
| Create PowerPoint | pptx-official | filesystem | presentation-builder | Python (python-pptx) | - |
| Create spreadsheet | xlsx-official | filesystem | - | Python (openpyxl) | - |
| Deploy to Vercel | deployment-procedures | github | DevOps agent | gh, vercel | commit-commands |
| Search for products/companies | deep-research | exa-web-search, playwright | Research agent | Playwright CLI | - |
| Generate images | (budget-aware via fal.ai skills) | - | Creative agent | Python | - |
| Process video/audio | - | filesystem | - | FFmpeg | - |
| Security analysis | security-audit, 007 | exa-web-search | security-reviewer | - | security-guidance |
| Run parallel tasks | dispatching-parallel-agents | claude-flow (RuFlo) | RuFlo swarm | - | - |
| Code review | code-reviewer, clean-code | github | code-reviewer agent | gh | code-review, pr-review-toolkit |
| Create a git commit | commit | github | - | gh | commit-commands |
| Plan architecture | writing-plans, architecture | - | architect, planner | - | - |
| Overnight batch work | - | claude-flow | RuFlo daemon workers | - | ralph-loop |
| Resume past work | (reads MEMORY.md, session-handoff.md) | - | - | claude-mem, graphify | claude-mem |
| Navigate codebase | (graphify query first) | - | - | graphify | - |
| TDD / write tests | tdd-workflow | - | tdd-guide | npm | - |
| Instagram research | instagram-access | - | - | instaloader | - |

## Auto-Activation Sequence

1. **CARL** (Layer 1): Prompt arrives → `carl-hook.py` matches keywords → injects relevant rules (3-6 rules typical)
2. **Category classification**: Claude reads CARL output + CAPABILITY-REGISTRY and classifies the task
3. **Skill loading**: Load skills named in the registry's task-pattern row BEFORE writing code
4. **MCP selection**: Pick MCP servers from the same row based on what data is needed
5. **Agent dispatch**: If 2+ independent sub-tasks, spawn RuFlo agents or regular subagents
6. **CLI invocation**: Use CLI tools for efficiency (e.g. Playwright CLI > Playwright MCP for visual tests)
7. **Post-task**: Update `memory/learning-log.md`, `memory/decisions.md`, `MEMORY.md` as needed

## Category Detection Keywords

Each category triggers keyword-based auto-activation. These map directly to CARL recall keywords:

- **CODING**: build, create, make, fix, bug, error, component, page, feature, refactor, implement, endpoint
- **LEGAL**: counsel, contract, law, clause, arbitration, compliance, lease, agreement, dispute
- **MARKETING**: campaign, email, social, content, SEO, audience, analytics
- **RESEARCH**: search, find, compare, analyze, investigate, market, competitor, vendor
- **DOCUMENT**: report, document, PDF, Word, PowerPoint, spreadsheet, presentation, slides
- **CREATIVE**: design, image, logo, visual, mockup, prototype, UI/UX
- **DEVOPS**: deploy, push, CI/CD, vercel, server, infrastructure, production
- **MULTIMEDIA**: video, audio, convert, transcode, compress, extract
- **NAVIGATION**: where is, how does, show me, architecture, structure, find the

## How to Add New Categories

1. Add a new domain to `~/.carl/carl.json` with its recall keywords
2. Add a routing row to `CAPABILITY-REGISTRY.md` for the task pattern
3. Add the category to this matrix
4. Test: type a matching keyword and verify the right tools activate

## Anti-Patterns (don't do this)

- **Loading every skill "just in case"** — wastes context window. Only load what the routing table says.
- **Spawning agents for trivial tasks** — if the task is < 3 tool calls, do it directly.
- **Running sequential tool calls when they're independent** — parallelize per the GLOBAL rule.
- **Reading raw files before checking graphify** — use the graph first, 10-30× cheaper.
