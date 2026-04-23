# COMMAND REGISTRY — V7
# Regenerate with: python3 $HOME/.claude/scripts/refresh-command-registry.py

This registry catalogs every slash command discoverable by Claude Code on an Apex-enabled machine.
Use it to auto-dispatch: match user intent to 1-3 commands from the routing table, invoke transparently.

**Total commands when fully installed: 182**
(Counts vary with which plugins/marketplaces are enabled.)

## Apex Custom Commands (ships with this repo)

| Command | Purpose |
|---------|---------|
| `/healthcheck` | Verify all Apex systems are operational. Run at session start or when things feel broken. |
| `/switch-project` | Quick-switch between active projects with pre-loaded context. |
| `/templates` | Pre-built task templates for recurring work (edit `templates.md` to add your own). |

## Core Built-in Commands (Claude Code itself)

| Command | Purpose |
|---------|---------|
| `/agents` | List configured agents |
| `/bug` | Report a bug |
| `/clear` | Clear conversation history |
| `/compact` | Compact conversation history |
| `/config` | Open config UI |
| `/doctor` | Run Claude Code health diagnostics |
| `/effort` | Set effort level (low / medium / high / xhigh / max) |
| `/export` | Export conversation |
| `/help` | Show help for Claude Code |
| `/hooks` | Manage hooks |
| `/init` | Init a CLAUDE.md in current repo |
| `/mcp` | Manage MCP servers |
| `/memory` | Edit CLAUDE.md / memory files |
| `/model` | Select or display the active model |
| `/plugin` | Manage plugins |
| `/resume` | Resume a previous session |
| `/review` | Built-in code review command |
| `/security-review` | Built-in security review command |
| `/statusline` | Show or configure the statusline |

## Plugin Commands (via enabled plugins)

### commit-commands
| Command | Purpose |
|---|---|
| `/commit` | Create a git commit |
| `/commit-push-pr` | Commit, push, and open a PR |
| `/clean_gone` | Clean up local branches deleted on remote |

### feature-dev
| Command | Purpose |
|---|---|
| `/feature-dev` | Guided feature development with codebase understanding |

### pr-review-toolkit
| Command | Purpose |
|---|---|
| `/review-pr` | Comprehensive PR review using specialized agents |

### claude-md-management
| Command | Purpose |
|---|---|
| `/revise-claude-md` | Update CLAUDE.md with learnings from this session |

### ralph-loop
| Command | Purpose |
|---|---|
| `/ralph-loop` | Start Ralph persistent-loop in current session |
| `/cancel-ralph` | Cancel active Ralph Loop |

### oh-my-claudecode (OMC) — 19 agents, multi-mode orchestration
| Command | Purpose |
|---|---|
| `/oh-my-claudecode:autopilot` | Full autonomous pipeline (expansion → plan → execute → QA → validate) |
| `/oh-my-claudecode:ralph` | Persistent loop until completion |
| `/oh-my-claudecode:team` | Spawn N parallel agents |
| `/oh-my-claudecode:ultrawork` | Max-capability deep work |
| `/oh-my-claudecode:plan` | Opus-tier planning |
| `/oh-my-claudecode:verify` | Evidence-based completion check |
| `/oh-my-claudecode:debug` | Root-cause debugging |
| `/oh-my-claudecode:ask` | Multi-perspective Q&A |
| `/oh-my-claudecode:remember` | Persistent memory write |
| `/oh-my-claudecode:omc-doctor` | OMC system diagnostics |
| `/oh-my-claudecode:omc-setup` | OMC first-time setup |
| `/oh-my-claudecode:skillify` | Turn patterns into a reusable skill |
| `/oh-my-claudecode:ralplan` | Plan + Ralph loop combo |
| `/oh-my-claudecode:external-context` | Pull context from external systems |
| `/oh-my-claudecode:writer-memory` | Curate writer voice/style memory |
| `/oh-my-claudecode:trace` | Causal tracing with competing hypotheses |
| `/oh-my-claudecode:ultraqa` | Max-capability test authoring |

## PAUL Framework Commands (28 — optional, install via npx paul-framework)

| Command | Purpose |
|---|---|
| `/paul:init` | Initialize PAUL for project |
| `/paul:plan` | Create structured plan |
| `/paul:apply` | Execute plan |
| `/paul:unify` | Close plan (MANDATORY) |
| `/paul:pause` / `/paul:resume` | Session break handoff |
| `/paul:milestone` | Create milestone |
| `/paul:complete-milestone` | Mark milestone done |
| `/paul:audit` | Enterprise audit |
| `/paul:discuss` | Articulate phase vision |
| `/paul:discover` | Research technical options |
| `/paul:research` | Research topic via subagents |
| `/paul:research-phase` | Research phase unknowns |
| `/paul:plan-fix` | Plan fixes from UAT |
| `/paul:verify` | Manual UAT |
| `/paul:assumptions` | Surface assumptions |
| `/paul:consider-issues` | Triage deferred issues |
| `/paul:flows` | Configure workflow integrations |
| `/paul:handoff` | Generate handoff document |
| `/paul:progress` | Smart status + routing |
| `/paul:add-phase` / `/paul:remove-phase` | Manage phases |
| `/paul:discuss-milestone` | Articulate next milestone |
| `/paul:map-codebase` | Map codebase for PAUL |
| `/paul:register` | Register existing project |
| `/paul:help` | Show PAUL commands |
| `/paul:config` | PAUL config |

## SEED Incubator Commands (optional)

| Command | Purpose |
|---|---|
| `/seed` | Typed project incubator — idea → buildable plan |
| `/seed:tasks:ideate` | Start ideation |
| `/seed:tasks:graduate` | Graduate idea to project |
| `/seed:tasks:launch` | Launch incubated project |
| `/seed:templates:planning-application` | Application project template |
| `/seed:templates:planning-campaign` | Campaign project template |
| `/seed:templates:planning-client` | Client project template |
| `/seed:templates:planning-utility` | Utility project template |
| `/seed:templates:planning-workflow` | Workflow project template |

## Autoresearch Commands

| Command | Purpose |
|---|---|
| `/autoresearch` | Autonomous goal-directed iteration |
| `/autoresearch:plan` | Build scope, metric, direction |
| `/autoresearch:debug` | Scientific-method bug hunting loop |
| `/autoresearch:fix` | Iteratively repair errors |
| `/autoresearch:learn` | Codebase documentation engine |
| `/autoresearch:predict` | Multi-persona prediction swarm |
| `/autoresearch:reason` | Adversarial multi-agent refinement |
| `/autoresearch:scenario` | Scenario generator |
| `/autoresearch:security` | STRIDE threat model + OWASP Top 10 |
| `/autoresearch:ship` | Universal shipping workflow |

## GSD (Goal-Structured Delivery) — optional

| Command | Purpose |
|---|---|
| `/gsd:new-project` / `/gsd:new-milestone` | Bootstrap |
| `/gsd:plan-phase` / `/gsd:execute-phase` / `/gsd:validate-phase` | Phase lifecycle |
| `/gsd:add-tests` / `/gsd:verify-work` | Testing |
| `/gsd:debug` / `/gsd:map-codebase` | Diagnostics |
| `/gsd:progress` / `/gsd:resume-work` / `/gsd:pause-work` | State |
| `/gsd:health` / `/gsd:help` | Support |

## Language-Specific Reviewers (via everything-claude-code)

| Command | Purpose |
|---|---|
| `/go-build` | Fix Go build errors |
| `/go-review` | Comprehensive Go review |
| `/go-test` | Go TDD |
| `/python-review` | Python review (PEP 8, type hints, security) |
| `/tdd` | Generic TDD workflow |

## Auto-Invocation Routing Table

When the user's natural-language prompt contains these intent keywords, auto-invoke the matching commands (in parallel when independent):

| Intent Keywords | Top Commands | Guidance |
|---|---|---|
| plan, feature, architecture, design | `/paul:plan`, `/oh-my-claudecode:plan`, `/plan` | Opus-tier planning |
| review, critique, audit | `/review`, `/oh-my-claudecode:ask`, `/review-pr` | Run in parallel for multi-perspective |
| deploy, ship, release, push to prod | `/deploy`, `/commit-push-pr` | Always verify post-deploy |
| continue, resume, last session, pick up | `/mem-search`, `/paul:resume`, `/gsd:resume-work` | Memory + plan resume |
| where is, find, navigate, architecture of | `/graphify`, `/graphify query` | 10-30× cheaper than raw file reads |
| commit, git, pr, pull request | `/commit`, `/commit-push-pr`, `/clean_gone` | Standard git workflow |
| debug, fix, trace, diagnose | `/debug`, `/oh-my-claudecode:debug`, `/oh-my-claudecode:trace` | Debug first, then fix |
| research, investigate, osint, web | `/autoresearch`, `/autoresearch:plan`, `/oh-my-claudecode:deep-dive` | Research stack |
| create doc, pptx, pdf, spreadsheet | `/create-doc`, `/create-pdf`, `/create-pptx` | Document generation |
| security, pentest, vulnerability | `/security-review`, `/autoresearch:security`, `/oh-my-claudecode:omc-doctor` | Security posture |
| test, tdd, e2e | `/add-tests`, `/oh-my-claudecode:ultraqa`, `/feature-dev` | Test authoring + runs |
| autonomous, full auto, build me, make me | `/oh-my-claudecode:autopilot`, `/oh-my-claudecode:ralph`, `/oh-my-claudecode:ultrawork` | Large autonomous workflows |
| remember, save memory, persist | `/mem-search`, `/oh-my-claudecode:remember`, `/oh-my-claudecode:writer-memory` | Persistent memory writes |
| new project, scaffold, bootstrap | `/paul:init`, `/seed`, `/gsd:new-project` | Project bootstrap |
| skill, skillify, create skill | `/oh-my-claudecode:skillify`, `/oh-my-claudecode:skill`, `/skill-create` | Skill authoring |
| health, status, verify env | `/healthcheck`, `/oh-my-claudecode:omc-doctor`, `/doctor` | Diagnostics |

## Conflict Resolution

When two commands match the same intent, prefer in order:

1. **Scope match** — `/paul:*` for structured multi-step; native commands for single actions
2. **Locality** — project-level triggers in CLAUDE.md override generic routing
3. **Cost** — graph/memory query before raw file read; Haiku-eligible before Opus
4. **Completion guarantee** — `/paul:unify` must close every `/paul:plan` session
5. **Parallelism** — independent reviews (code-reviewer + security-reviewer) run in parallel; sequential waste tokens

## Don't-Use List

- `/oh-my-claudecode:cancel` — invoke only when stopping an autopilot/ralph loop
- `/oh-my-claudecode:hud` — skip unless `/hud setup` has been run
- `/paul:status` — deprecated, use `/paul:progress` instead
