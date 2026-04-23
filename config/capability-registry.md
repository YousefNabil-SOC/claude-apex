# CAPABILITY REGISTRY — V7 (Apex)
# Last verified: 2026-04-23
# For complete skill list: see SKILL-INDEX.md (generated at install)
# For complete command list: see COMMAND-REGISTRY.md (182 commands)

## QUICK COUNTS
- **Skills**: 1,276+ on disk (Apex custom + plugin-provided via everything-claude-code)
- **Agents**: 108 unique (25 Apex custom + 51 RuFlo + 19 OMC + 13 plugin-unique)
- **MCP Servers**: 4 in settings.json (Apex default) → up to 15 with optional servers
- **Plugins**: 20 available, 9 enabled by default in Apex
- **CLI Tools**: Node, npm, Bun, Python 3, Git, GitHub CLI, FFmpeg, Playwright CLI, Vercel (optional)
- **Slash Commands**: 182 indexed in COMMAND-REGISTRY.md
- **CARL Domains**: 9 (GLOBAL, DEVELOPMENT, WEB-DEVELOPMENT, DOCUMENT-CREATION, RESEARCH-OSINT, DEPLOYMENT, LEGAL, BROWSER, PROJECT-NAVIGATION)
- **CARL Rules**: 40 (3 GLOBAL + 9 WEB-DEV + 7 DOC + 5 RESEARCH + 6 DEPLOY + 5 LEGAL + 2 BROWSER + 3 PROJ-NAV)
- **Hooks**: 5 events (PostCompact, Stop, Notification, UserPromptSubmit, SessionStart-chain)
- **Beginner docs**: 10 tutorials (00-START-HERE.md through 10-TROUBLESHOOT-FOR-BEGINNERS.md)

## THE THREE-LAYER AUTO-ROUTING SYSTEM

Apex routes natural-language prompts to the right tools automatically. Users rarely need to type slash commands.

### Layer 1 — CARL (keyword → rules)
`carl-hook.py` fires on every UserPromptSubmit. It matches keywords in the prompt to the 9 CARL domains and injects their rules into Claude's context *before* the response starts. 40 rules total, but only 3-6 typically load per prompt.

### Layer 2 — CAPABILITY-REGISTRY (task → stack)
This file. Claude reads it at session start and consults the routing table below to pick skills, MCP servers, agents, and CLI tools for each task pattern.

### Layer 3 — COMMAND-REGISTRY (intent → commands)
`COMMAND-REGISTRY.md` maps user intent keywords to the best 1-3 slash commands. Claude auto-invokes them when intent matches.

## TOOL ROUTING TABLE
# For ANY task, find the matching row. Use ALL tools in that row simultaneously.

| Task Pattern | Skills to Load | MCP Servers | Agents | CLI Tools | Plugins |
|---|---|---|---|---|---|
| Build / create website or component | frontend-design, premium-web-design, tailwind-patterns, react-patterns, typescript-pro, ui-ux-pro-max | playwright, github, context7, @21st-dev/magic | architect, code-reviewer + RuFlo coder/tester/reviewer | Playwright CLI, gh, npm | frontend-design, code-review |
| UI component generation / design system | premium-web-design, 21st-dev-magic, frontend-design | @21st-dev/magic, context7 | architect | npx, npm | frontend-design |
| Fix bug / debug | systematic-debugging, clean-code, error-detective | playwright, github | build-error-resolver + RuFlo coder/tester | Playwright CLI, gh | code-simplifier |
| Review legal work | (LEGAL domain active) | exa-web-search, filesystem | legal-advisor agent | - | security-guidance |
| Write marketing content | copywriting, content-creator | exa-web-search | content-marketer | - | prompt-improver |
| Research / OSINT | deep-research | exa-web-search, firecrawl, memory, playwright | RuFlo researcher | Playwright CLI | - |
| Create Word document | docx-official | filesystem | doc-updater | - | - |
| Create PDF | pdf-official | filesystem | doc-updater | Python (reportlab) | - |
| Create PowerPoint | pptx-official | filesystem | - | Python (python-pptx) | - |
| Create spreadsheet | xlsx-official | filesystem | - | Python (openpyxl) | - |
| Deploy to Vercel | deployment-procedures, vercel-deployment | github, playwright | - | gh, vercel, Playwright CLI | commit-commands |
| Generate images (photorealistic) | fal-generate, fal-image-edit | - | - | Python (fal.ai API) | - |
| Generate images (vector/code) | graphic-design-studio | - | - | Python (Pillow, svgwrite) | - |
| Process video / audio | - | filesystem | - | FFmpeg | - |
| Security analysis / pentest | security-audit, 007, pentest-checklist | exa-web-search | security-reviewer + RuFlo security-architect | - | security-guidance |
| Code review | code-reviewer, clean-code | github | code-reviewer + RuFlo reviewer | gh | code-review, pr-review-toolkit |
| Plan architecture | writing-plans, architecture, software-architecture | sequential-thinking | architect, planner | - | - |
| Parallel complex work | dispatching-parallel-agents | claude-flow (RuFlo) | RuFlo swarm | - | ralph-loop |
| Git commit / push / PR | commit | github | - | gh, git | commit-commands |
| SEO optimization | seo + seo-technical, seo-schema, seo-content, seo-geo, seo-performance | exa-web-search, playwright | seo-* agents (7 specialists) | Playwright CLI | - |
| Database work | postgresql, database-design | supabase | database-reviewer | - | - |
| Browser testing / E2E | playwright-skill, e2e-testing-patterns | playwright | e2e-runner | Playwright CLI | - |
| TDD / writing tests | tdd-workflow, test-driven-development | github | tdd-guide | npm (test runner) | - |
| Python development | python-pro, python-patterns | - | python-reviewer | Python, pip | - |
| Instagram research / download | instagram-access | - | - | instaloader (Python) | - |
| Go development | golang-pro | - | go-reviewer, go-build-resolver | go | - |
| API design | api-design-principles, api-patterns | context7 | architect | - | - |
| Docker / K8s | docker-expert, kubernetes-architect | - | - | docker, kubectl | - |
| AI / ML development | ai-engineer, llm-app-patterns, rag-implementation | context7, exa-web-search | RuFlo ml-developer | Python | huggingface-skills |
| Presentation / pitch | pptx-official, copywriting | exa-web-search | - | Python | - |
| Measurable optimization | autoresearch (loop) | varies | - | varies | - |
| New project idea | /seed → brainstorm → PLANNING.md → /paul:init | - | planner | - | - |
| Health check / diagnostics | /healthcheck (system check) | - | - | curl, python3 | - |
| JIT rule loading | CARL auto-activates via carl-hook.py on UserPromptSubmit | - | - | - | - |
| Resume / continue work | claude-mem (mem-search) + graphify query | - | - | claude-mem, graphify | claude-mem |
| Navigate codebase / "where is X" | graphify query (NOT raw file reads) | - | - | graphify | - |
| Architecture / structure question | graphify query + graphify explain | - | - | graphify | - |

## CONTEXT RETRIEVAL PRIORITY — TOKEN DISCIPLINE

Before reading raw files, ALWAYS check the cheaper source first:

1. **Prior-session context** → `/mem-search <query>` (claude-mem). Cost ≈ 500 tokens.
2. **Project structure / "where is X"** → `graphify-out/GRAPH_REPORT.md` (no tokens) THEN `graphify query "..."` (needs `graphify-out/graph.json`).
3. **Raw file read** → only when graph is missing OR the task needs file content (edit, debug, review).

### How graphs get built
- `/graphify .` inside a project directory — AST-only for code (free), subagent-based for doc/image-heavy projects (costs tokens).
- `graphify update .` — incremental refresh, always free.
- `graphify hook install` — post-commit auto-refresh.

## PARALLEL EXECUTION RULES

### PARALLELIZE when
- 2+ INDEPENDENT sub-tasks (no data dependency)
- Building + testing + reviewing (3 agents: coder, tester, reviewer)
- Researching multiple topics simultaneously
- Processing multiple files independently

### STAY SEQUENTIAL when
- Step N depends on output of step N-1
- Single file needing coherent changes
- Debugging (need each step's result)
- Deployment (strict: build → test → commit → push → deploy → alias → verify)

### TOPOLOGY SELECTION
- 2-3 independent tasks: regular Agent subagents
- 4-9 independent tasks: RuFlo hierarchical via claude-flow MCP
- 10+ independent tasks: RuFlo hierarchical-mesh
- Sequential pipeline with handoffs: RuFlo ring
- Simple hub coordination: RuFlo star

## MCP SERVER STATUS (Apex defaults)

| Server | Config | Status | Notes |
|---|---|---|---|
| context7 | plugin | ACTIVE | Library docs |
| playwright | settings.json | ACTIVE | Browser automation |
| github | settings.json | ACTIVE | Needs `GITHUB_PERSONAL_ACCESS_TOKEN` |
| exa-web-search | settings.json | ACTIVE | Needs `EXA_API_KEY` |
| @21st-dev/magic | settings.json | ACTIVE | Needs `TWENTY_FIRST_DEV_API_KEY` |

### Optional MCP servers (documented but disabled by default)
firecrawl, supabase, memory, sequential-thinking, filesystem, claude-flow (RuFlo), claude-peers, n8n-mcp, testsprite, magic-ui.

## TOOL ALTERNATIVES (self-healing fallbacks)

| Primary Tool | Fallback | Switch When |
|---|---|---|
| Playwright MCP | Playwright CLI (`npx playwright`) | MCP timeout, token-heavy ops |
| exa-web-search MCP | WebSearch built-in | MCP down, simple queries |
| github MCP | `gh` CLI | MCP down, simple git ops |
| firecrawl MCP | WebFetch built-in | No API key, simple fetch |
| context7 MCP | WebFetch official docs | MCP down |
| claude-flow (RuFlo) | Regular Agent spawning | Daemon issues |
| fal.ai image gen | SVG / CSS / Canvas (FREE) | Budget constraint, non-photorealistic |
| OMC autopilot | RuFlo swarm / manual agents | OMC hooks not loading |
| PAUL `/paul:plan` | Manual `/plan` mode | PAUL not loaded |

## CUSTOM AGENTS (25 in ~/.claude/agents/)

| Agent | Domain | Auto-Trigger |
|---|---|---|
| architect | System design | New features, refactoring |
| planner | Implementation planning | Complex tasks |
| code-reviewer | Code quality | After any code change |
| build-error-resolver | Build fixes | When build fails |
| tdd-guide | Test-driven dev | New features, bug fixes |
| security-reviewer | Security | Before commits, auth/API code |
| e2e-runner | E2E testing | Critical flows |
| refactor-cleaner | Dead code cleanup | Maintenance |
| python-reviewer | Python quality | Python changes |
| go-reviewer | Go quality | Go changes |
| go-build-resolver | Go builds | Go build fails |
| database-reviewer | PostgreSQL | SQL, migrations |
| doc-updater | Documentation | Docs tasks |
| loop-operator | Agent loops | Long-running agents |
| harness-optimizer | Agent config | Reliability tuning |
| chief-of-staff | Comms triage | Multi-channel comms |
| cs-ceo-advisor | CEO strategy | Strategy decisions |
| cs-cto-advisor | CTO strategy | Tech decisions |
| seo-schema | Schema.org | Structured data |
| seo-performance | Core Web Vitals | Page speed |
| seo-geo | AI search / GEO | AI visibility |
| seo-content | E-E-A-T | Content quality |
| seo-technical | Crawlability | Technical SEO |
| seo-sitemap | XML sitemaps | Sitemap work |
| seo-visual | Visual analysis | Above-fold check |

## RUFLO AGENTS (51 via claude-flow MCP)

Core (5): coder, reviewer, tester, planner, researcher
V3 Specialized (4): security-architect, security-auditor, memory-specialist, performance-engineer
Swarm Coord (5): hierarchical-coordinator, mesh-coordinator, adaptive-coordinator, collective-intelligence-coordinator, swarm-memory-manager
Consensus (7): byzantine-coordinator, raft-manager, gossip-coordinator, consensus-builder, crdt-synchronizer, quorum-manager, security-manager
Performance (5): perf-analyzer, performance-benchmarker, task-orchestrator, memory-coordinator, smart-agent
GitHub (9): github-modes, pr-manager, code-review-swarm, issue-tracker, release-manager, workflow-automation, project-board-sync, repo-architect, multi-repo-swarm
SPARC (6): sparc-coord, sparc-coder, specification, pseudocode, architecture, refinement
Specialized Dev (8): backend-dev, mobile-dev, ml-developer, cicd-engineer, api-docs, system-architect, code-analyzer, base-template-generator
Testing (2): tdd-london-swarm, production-validator

## OMC AGENTS (19 via oh-my-claudecode plugin)

analyst, architect, code-reviewer, code-simplifier, critic, debugger, designer,
document-specialist, executor, explore, git-master, planner, qa-tester, scientist,
security-reviewer, test-engineer, tracer, verifier, writer

Model routing: **Haiku** (explore, writer) | **Sonnet** (executor, debugger, designer, verifier, tracer, security-reviewer, test-engineer, qa-tester, scientist, git-master, document-specialist) | **Opus** (architect, planner, critic, analyst, code-reviewer, code-simplifier)

## V7 ROUTING TABLE EXTENSIONS

| Task Pattern | Primary Tool | Fallback |
|---|---|---|
| Multi-agent orchestration | OMC autopilot | RuFlo/claude-flow swarm |
| Parallel task execution | OMC team/ultrawork | Spawn subagents |
| Structured project execution | PAUL framework (/paul:plan) | Manual /plan mode |
| Memory consolidation | Dream skill ("consolidate memory") | Manual MEMORY.md edit |
| Vague idea exploration | OMC deep-interview + SEED | Manual brainstorming |
| Persistent autonomous task | OMC ralph mode | /ralph-loop or /loop |
| UI component generation | @21st-dev/magic MCP | shadcn/ui + manual |
| Knowledge navigation | graphify query | Raw file reads (expensive) |

## POST-COMPACT RECOVERY

When /compact or autocompact fires:
1. PostCompact hook runs `post-compact-recovery.sh`
2. Script tells Claude to re-read `CAPABILITY-REGISTRY.md` and `PRIMER.md`
3. Critical rules are restated so they survive compaction
4. Claude resumes with capability awareness intact

## SESSION HANDOFF

At session end:
1. `session-end-save.sh` appends a timestamp to `memory/session-handoff.md`
2. Keeps last 50 lines only (prevents bloat)

At session start:
- `session-start-check.sh` tails `session-handoff.md` to restore context
- Claude reads it as part of MEMORY.md flow
