# Capability Registry — Tool Routing Table

## Overview
This file maps task types to the tools that handle them. Read this after /compact to restore awareness.

## Task Routing

| Task Type | Primary Tools | MCP Servers | Agents | Skills |
|-----------|--------------|-------------|--------|--------|
| Web development | Edit, Write, Bash | context7, magic-ui | code-reviewer, tdd-guide | frontend-design |
| Code review | Read, Grep | - | code-reviewer, security-reviewer | code-review |
| Testing | Bash, Agent | playwright | tdd-guide, e2e-runner | - |
| Research | WebSearch, WebFetch | exa-web-search, firecrawl | - | deep-research |
| Documentation | Write, Edit | - | doc-updater | docx-official, pdf-official |
| Deployment | Bash | - | - | deploy |
| Database | Bash, Read | supabase | database-reviewer | postgresql |
| Security audit | Read, Grep | - | security-reviewer | security-audit |
| Architecture | Read, Agent | - | architect, planner | - |
| Bug fixing | Read, Grep, Edit | - | build-error-resolver | debugger |
| SEO | WebFetch, Bash | playwright | seo-* agents (7) | seo-* skills |
| Legal analysis | Read, Write | - | - | legal-doc |

## MCP Server Status

| Server | Status | Fallback |
|--------|--------|----------|
| context7 | Active | WebFetch official docs |
| exa-web-search | Active | WebSearch built-in |
| github | Active | gh CLI |
| firecrawl | Active | WebFetch built-in |
| playwright | Active | Playwright CLI (npx playwright) |
| magic-ui | Active | shadcn/ui manual |
| memory | Active | File-based memory |
| sequential-thinking | Active | Extended thinking |
| supabase | Placeholder | Direct REST API |
| claude-peers | Active | Manual coordination |

## Agent Tiers

| Tier | Model | Use For |
|------|-------|---------|
| LOW | Haiku | Doc updates, simple lookups, formatting |
| MEDIUM | Sonnet | Standard coding, review, testing |
| HIGH | Opus | Architecture, complex debugging, planning |
