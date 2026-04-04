# Changelog

All notable changes to Claude Apex will be documented in this file.

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

**Skills (2 custom):**
- dream-consolidation (memory consolidation 4-phase cycle)
- autoresearch (autonomous optimization loops)

**Commands (3):**
- /healthcheck (15 automated system verifications)
- /switch-project (instant context switching)
- /templates (recurring task workflows)

**Hooks (5):**
- post-compact-recovery.sh (context restoration after /compact)
- session-end-save.sh (state persistence on exit)
- task-complete-sound.sh (audio notification)
- peers-auto-register.sh (Claude Peers auto-discovery)
- carl-hook.py (JIT rule injection)

**Config Templates:**
- orchestration-engine.md (decision framework)
- capability-registry.md (tool routing table)
- carl-domains.json (7 domains, 33 rules)
- claude-md-template.md (CLAUDE.md structure)
- primer-template.md (identity template)
- settings-template.json (full config with placeholders)

**Documentation (14 guides):**
- Architecture, Getting Started, Agents Guide, CARL Guide
- PAUL Integration, OMC Integration, Peers Setup, Memory System
- Orchestration, Customization, Troubleshooting, Windows Guide
- Uninstall, FAQ

**Installers:**
- install.sh (Mac/Linux one-command)
- install.ps1 (Windows PowerShell one-command)
- install-interactive.sh (guided, all platforms)
- uninstall.sh (clean restore from backup)

**Third-party integrations:**
- oh-my-claudecode (Yeachan-Heo) — multi-agent orchestration
- PAUL framework (ChristopherKahler) — structured execution
- SEED incubator (ChristopherKahler) — project brainstorming
- Claude Peers MCP (louislva) — inter-instance communication
