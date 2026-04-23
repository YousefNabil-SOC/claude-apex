---
name: switch-project
description: Quick-switch between active projects with pre-loaded context. Lists available projects or switches to the named one.
argument-hint: "[project-slug]"
---

# /switch-project

**EDIT THIS FILE** — replace the example projects below with your own projects. The list here is intentionally generic so everyone starts from a clean slate.

## Purpose
Quick-switch between active projects with pre-loaded context. When you say `/switch-project my-webapp`, Claude reads the project's CLAUDE.md and MEMORY.md, changes to its directory, and restores active-project context.

## Configuration — Your Projects

Define your projects below. For each one:
- **Slug**: what you'll type after `/switch-project`
- **Path**: absolute path to the project folder
- **Trigger**: optional natural-language trigger phrase (e.g. "resume my-webapp")
- **Description**: one line describing the project

### Example Projects (REPLACE WITH YOUR OWN)

| Slug | Path | Description |
|---|---|---|
| `my-webapp` | `~/projects/my-webapp` | Main web application (React + Vite + Vercel) |
| `my-api` | `~/projects/my-api` | Backend API (Node.js + Postgres) |
| `my-docs` | `~/projects/my-docs` | Documentation site (VitePress) |

---

## Behavior

When the user types `/switch-project <slug>`:
1. Find the matching project in the table above
2. `cd` to its absolute path
3. Read `CLAUDE.md` in that directory (if present)
4. Read `MEMORY.md` in that directory (if present)
5. Read the project's `graphify-out/GRAPH_REPORT.md` (if present) — restores architecture awareness
6. Announce: "Switched to `<slug>` — ready for work on <one-line-description>"

When the user types `/switch-project` with no argument:
1. List all projects in the table above
2. Show the current working directory
3. Wait for the user to pick one

## Adding a New Project

1. Edit this file (`~/.claude/commands/switch-project.md`)
2. Add a row to the table above
3. Save — no restart needed

## Tips

- Pick short, memorable slugs (`my-webapp`, not `my-webapp-production-v2-final`)
- Include the tech stack in the description so Claude activates the right skills
- If a project has its own CLAUDE.md, list critical rules there, not here
- Use `trigger:` natural-language phrases for when you say "resume my webapp"
