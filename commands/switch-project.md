---
name: switch-project
description: Quick-switch between active projects with pre-loaded context. Lists available projects or switches to the named one.
argument-hint: "[project-name]"
---

# Project Switcher

When run with no argument, list all available projects below.
When run with a name, execute the switch actions for that project.

## Example Projects (customize these)

### 1. webapp (aliases: web, frontend)
- **Directory**: ~/projects/webapp
- **Context files**: Read CLAUDE.md, README.md
- **Stack**: React + TypeScript + Tailwind
- **CARL domain**: WEB-DEVELOPMENT

### 2. api (aliases: backend, server)
- **Directory**: ~/projects/api
- **Context files**: Read CLAUDE.md, README.md
- **Stack**: Node.js + Express + PostgreSQL
- **CARL domain**: DEVELOPMENT

### 3. mobile (aliases: app)
- **Directory**: ~/projects/mobile
- **Context files**: Read CLAUDE.md
- **Stack**: React Native + TypeScript
- **CARL domain**: WEB-DEVELOPMENT

## Switch Actions (execute in order)

1. `cd` to the project directory
2. Read the project's CLAUDE.md or README.md if it exists
3. Read SESSION-MEMORY.md if it exists
4. Announce which CARL domains are relevant
5. Set Claude Peers summary if available
6. If it's a git repo, show the 3 most recent commits
7. Report: "Switched to [project]. Ready."

## Adding Your Own Projects

Add a new section above following the same format. Include:
- Directory path
- Context files to load
- Tech stack
- Relevant CARL domain
