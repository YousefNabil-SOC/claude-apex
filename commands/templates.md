---
name: templates
description: Pre-built task templates for recurring workflows. Say "template: [name]" or run /templates [name].
argument-hint: "[presentation|research|deploy|documentation|review]"
---

# Task Templates

When run with no argument, list all available templates.
When run with a template name, execute that template's workflow.

## Available Templates

### template: presentation
Create a professional presentation (PPTX).

**Steps:**
1. Ask user for: topic, number of slides, key points
2. Generate PPTX using python-pptx
3. Apply project brand colors from CLAUDE.md
4. Font sizes: 28pt+ headers, 18pt+ body (phone-readable)
5. Save to appropriate project folder
6. Export as PDF for sharing
7. Verify both files exist and are non-empty

### template: research
Research a company or topic.

**Steps:**
1. Ask user for: subject, what to find out, urgency
2. Use exa-web-search MCP for initial semantic research
3. Use firecrawl MCP to scrape relevant websites
4. Cross-reference minimum 3 sources before stating any fact
5. Create a structured report with findings
6. Include credibility rating (1-10) with justification
7. Save to project research directory with date prefix

### template: deploy
Deploy the current project to production.

**Steps:**
1. Run build — must succeed with 0 errors
2. Run tests — must pass
3. git add (specific changed files only — NEVER git add -A)
4. git commit with descriptive message
5. git push
6. Run deployment command — wait for completion
7. Set production alias if applicable
8. Verify with Playwright screenshot
9. Report: build time, test count, deployment URL

### template: documentation
Generate project documentation.

**Steps:**
1. Ask user for: scope (API docs, README, architecture, user guide)
2. Scan the codebase to understand structure
3. Generate documentation using appropriate skill
4. Include code examples and diagrams where relevant
5. Save to docs/ directory
6. Verify markdown renders correctly

### template: review
Run a comprehensive code review.

**Steps:**
1. Run git diff to identify changed files
2. Use code-reviewer agent on each file
3. Use security-reviewer agent for security analysis
4. Check for: bugs, security issues, performance, style
5. Generate review report with severity ratings
6. Suggest specific fixes for CRITICAL and HIGH issues
