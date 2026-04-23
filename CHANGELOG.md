# Changelog

All notable changes to Claude Apex will be documented in this file.

## v7.0.0 (2026-04-23) — Three-Layer Auto-Routing

### Headline
The three-layer auto-routing system is the core V7 innovation: CARL (JIT rules) + CAPABILITY-REGISTRY (task → stack) + COMMAND-REGISTRY (intent → commands). Users never need to type slash commands — the system reads natural language and activates the right tools automatically.

### New Capabilities

**Three-Layer Auto-Routing**
- CARL now injects rules at UserPromptSubmit via `carl-hook.py` (UTF-8 fixed on all 4 file opens)
- CAPABILITY-REGISTRY.md rewritten to route 30+ task patterns to skill+MCP+agent+CLI combos
- COMMAND-REGISTRY.md added — 182 slash commands indexed with auto-invocation routing

**7 New Custom Skills**
- `premium-web-design` — luxury web design skill with animation patterns, reference analyses, and GSAP/Framer Motion tool guides (205-line SKILL.md + patterns/ + references/ + tools/)
- `21st-dev-magic` — React+TS+Tailwind component generation via 21st.dev Magic MCP
- `instagram-access` — authenticated Instagram scraping via instaloader (generic session file)
- `graphify` — knowledge-graph skill; saves ~90% of file-reading tokens
- `graphic-design-studio` — code-based graphic design (HTML/CSS/SVG/Pillow pipelines)
- `fireworks-tech-graph` — technical documentation graphing
- `impeccable` — design polish + micro-interaction refinement

**3 New MCP Servers in default settings**
- `@21st-dev/magic` — premium React component generation
- (`context7`, `playwright`, `github`, `exa-web-search` already present)

**2 New Hooks**
- `session-start-check.sh` — reads ONLY essential files (CLAUDE.md, PRIMER.md, CAPABILITY-REGISTRY.md, AGENTS.md) + memory markers. Optimized against the prior "read everything" approach.
- `project-auto-graph.sh` — on SessionStart, detects new project folders, queues them for user-opt-in graphify build (never auto-runs to protect token budget).

**CARL Expanded**
- 7 → **9 domains**: added BROWSER and PROJECT-NAVIGATION
- 33 → **40 rules**
- All rules sanitized to generic, reusable templates (zero personal profile data, zero client data)

**New Config Files**
- `config/env.template` — API key env var names with placeholders
- `config/command-registry.md` — 182-command index with auto-invocation routing table
- `config/agents.md` — agent divisions (Engineering, Business, Documentation, Cybersecurity, RuFlo, OMC)
- `config/auto-activation-matrix.md` — task→tool activation mapping

**Beginner Documentation (10 new guides)**
Zero-prerequisite tutorials for users who have never used Claude Code or a terminal:
- `docs/00-START-HERE.md` — "What is this?" for absolute beginners
- `docs/01-WHAT-IS-CLAUDE-CODE.md` — defines Claude, Anthropic, CLI, terminal
- `docs/02-INSTALL-FROM-ZERO.md` — every step from brand-new computer to running Apex
- `docs/03-FIRST-TIME-USING.md` — first 10 commands with expected output
- `docs/04-WHAT-ARE-SKILLS.md` — analogy: skills = recipe books Claude reads on demand
- `docs/05-WHAT-ARE-AGENTS.md` — analogy: agents = specialist coworkers
- `docs/06-WHAT-ARE-MCP-SERVERS.md` — analogy: MCP = superpowers plugged in
- `docs/07-WHAT-ARE-HOOKS.md` — analogy: hooks = automatic reflexes
- `docs/08-WHAT-IS-CARL.md` — analogy: CARL = librarian
- `docs/09-GLOSSARY.md` — every term defined in one sentence
- `docs/10-TROUBLESHOOT-FOR-BEGINNERS.md` — "It didn't work — now what?"

### Fixed

- `carl-hook.py` — UTF-8 encoding fix on all 4 open() calls (was corrupting non-Latin file content)
- `task-complete-sound.sh` — 60-second cooldown added (prevents sound spam)
- `session-start-check.sh` — reads only 4 essential files + memory markers (was reading everything, slow at session start)
- `effortLevel` default lowered to `high` (never `xhigh` or `max` — self-healing enforces this)
- Self-healing rules added to CLAUDE.md template
- Post-compact recovery script simplified and sanitized (was referencing personal projects)

### Changed

- **Version badges**: 6.0 → 7.0 everywhere
- **Skill count**: 1,308 (V6 claim) → 1,276+ verified on disk
- **MCP count**: 12 → 15 (includes all optional)
- **Plugin count**: 19 → 20 (added claude-md-management)
- **Slash commands**: 107 → 182 (added 75 via user-created + plugin expansions)
- **Agent count**: 108 remains stable (25 custom + 51 RuFlo + 19 OMC + 13 plugin)
- Commands `switch-project.md` and `templates.md` rewritten as generic templates users edit for their own projects
- README rewritten with V7 numbers, three-layer routing diagram, and "Start Here" beginner pointer
- Install scripts (install.sh, install.ps1, install-interactive.sh) updated to install all 7 new skills + 2 new hooks + env.template
- `verify.sh` updated with V7 expected counts (9 CARL domains, 40 rules, new skill checks)

### Security

- Full grep sweep before push: zero API keys, zero personal names, zero client/project data leaked
- All API key references use `${VAR_NAME}` placeholders
- `.env.template` documents every required env var
- `.gitignore` enforces `.env` exclusion

### Attribution

- Third-party credit preserved for OMC (Yeachan-Heo), PAUL (ChristopherKahler), SEED (ChristopherKahler), Claude Peers (louislva), Bun runtime
- Skills from `everything-claude-code` plugin remain installed via `/plugin install` (not vendored in this repo)

### Breaking Changes

- `~/.claude/settings.json` hooks section now requires `UserPromptSubmit` and `SessionStart-chain` entries for full auto-routing. The installer adds these non-destructively, but if you have custom hooks in those events, review the merge.
- CARL domain count changed from 7 to 9 — any custom rules referencing old domain IDs must migrate.

## v6.0.0 (2026-04-04)

### Initial Release

**Agents (25):**
- architect, build-error-resolver, chief-of-staff, code-reviewer
- cs-ceo-advisor, cs-cto-advisor, database-reviewer, doc-updater
- e2e-runner, go-build-resolver, go-reviewer, harness-optimizer
- loop-operator, planner, python-reviewer, refactor-cleaner
- security-reviewer, seo-content, seo-geo, seo-performance
- seo-schema, seo-sitemap, seo-technical, seo-visual, tdd-guide

**CARL Domains (7, 33 rules):**
- GLOBAL, DEVELOPMENT, WEB-DEVELOPMENT, DOCUMENT-CREATION
- RESEARCH-OSINT, DEPLOYMENT, LEGAL

**Skills (2 custom):** dream-consolidation, autoresearch

**Commands (3):** healthcheck, switch-project, templates

**Hooks (5):** post-compact-recovery.sh, session-end-save.sh, task-complete-sound.sh, peers-auto-register.sh, carl-hook.py

**Installers:** install.sh, install.ps1, install-interactive.sh, uninstall.sh, verify.sh

**Third-party integrations:** OMC, PAUL, SEED, Claude Peers MCP
