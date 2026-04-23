---
name: templates
description: Pre-built task templates for recurring workflows. Say "template [name]" or run /templates [name].
argument-hint: "[template-name]"
---

# /templates

**EDIT THIS FILE** — the examples below are generic starting points. Add your own templates for recurring workflows.

## Purpose
Pre-built task templates for recurring work. Instead of re-explaining a workflow every time, define it once here and invoke with `/templates <name>` or `template: <name>`.

## Example Templates (replace with your own)

### deploy-app
**Workflow**: standard React/TS/Vite app deployment to Vercel.

Steps:
1. `npm run build` — verify zero errors and zero warnings
2. Run tests: `npm test`
3. Stage specific changed files: `git add <files>`
4. Commit with conventional-commit message: `feat/fix/refactor: <what>`
5. `git push origin main`
6. `vercel --prod` — wait for completion, note deployment URL
7. `vercel alias set <new-deployment-url> <canonical-domain>` — NEVER skip
8. Screenshot canonical URL with Playwright to verify
9. Update `MEMORY.md` with deployment timestamp

### research-company
**Workflow**: OSINT on a company for competitive intelligence or due diligence.

Steps:
1. Use exa-web-search MCP for semantic queries on the company name
2. Fetch the company website homepage with WebFetch — extract about, products, team
3. Search LinkedIn, Crunchbase, Pitchbook for funding/team signals (if accessible)
4. Check news in the last 12 months via exa-web-search
5. Compile a structured report:
   - Company name, founded, HQ, employee count
   - Products/services, target market
   - Funding/revenue (if public)
   - Recent news, executive changes, risks
   - Competitive positioning
6. Save to `research/YYYY-MM-DD-<company-slug>.md`
7. Cross-reference minimum 3 sources before stating any "fact"

### code-review-workflow
**Workflow**: multi-perspective code review of a PR or branch.

Steps:
1. Run parallel agents:
   - `code-reviewer` agent — quality, style, convention adherence
   - `security-reviewer` agent — auth, input validation, secrets
   - `performance-engineer` agent — bundle size, render performance
   - `tdd-guide` agent — test coverage, edge cases
2. Merge findings into a single structured report
3. Group by severity: CRITICAL / HIGH / MEDIUM / LOW
4. For each CRITICAL/HIGH: include file path, line number, suggested fix
5. Present report to user for review
6. Fix agreed-upon issues with focused edits (no scope creep)
7. Re-run affected tests and build to verify

## How to Add Your Own Template

1. Edit this file (`~/.claude/commands/templates.md`)
2. Add a new section with a clear slug (lowercase, hyphenated)
3. Write the **Workflow** one-liner
4. List **Steps** numerically — be precise, Claude will follow them exactly
5. Save — no restart needed

## Invocation

- `/templates` (no arg) — list all templates
- `/templates <slug>` — execute the workflow for `<slug>`
- "template: <slug>" (natural language) — same as above

## Best Practices

- Keep workflows under 10 steps — longer workflows should become PAUL plans
- Specify which skills/agents/MCP servers to activate at each step
- Include verification/quality gates (build, test, screenshot)
- Reference external files/paths explicitly — no guessing
- Update the template whenever you discover a better way to do the workflow
