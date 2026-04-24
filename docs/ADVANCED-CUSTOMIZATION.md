# Advanced Customization

> For users building on top of Apex or shipping it to a team. Every customization point: CARL domains, agents, skills, MCP servers, hooks, and COMMAND-REGISTRY.

## Create a Custom CARL Domain

### Concept

A CARL domain is a JSON object in `~/.carl/carl.json` containing:
- `state` — `"active"` or `"disabled"`
- `always_on` — if `true`, fires on every prompt regardless of keywords
- `recall` — array of keywords that trigger this domain
- `exclude` — array of keywords that suppress this domain (even if recall matches)
- `rules` — array of rule objects injected into context when the domain fires
- `decisions` — array of decision log entries (managed automatically)

### File format

```json
"YOUR_DOMAIN_NAME": {
  "state": "active",
  "always_on": false,
  "recall": ["keyword1", "keyword phrase", "another keyword"],
  "exclude": [],
  "rules": [
    {
      "id": 900,
      "text": "Rule text Claude sees when this domain fires.",
      "source": "my-custom"
    },
    {
      "id": 901,
      "text": "Another rule. Keep each rule focused on one behavior.",
      "source": "my-custom"
    }
  ],
  "decisions": []
}
```

### Example — Kubernetes domain

```json
"KUBERNETES": {
  "state": "active",
  "always_on": false,
  "recall": ["kubernetes", "k8s", "kubectl", "helm chart", "pod", "deployment.yaml", "ingress", "helm", "manifest"],
  "exclude": [],
  "rules": [
    {
      "id": 900,
      "text": "Always specify resource limits (cpu, memory) on every container. Missing limits are a CRITICAL review issue.",
      "source": "kubernetes-domain"
    },
    {
      "id": 901,
      "text": "Use Helm charts for anything beyond 3 resources. Raw YAML beyond that becomes unmaintainable.",
      "source": "kubernetes-domain"
    },
    {
      "id": 902,
      "text": "Never commit secrets to ConfigMaps. Use Sealed Secrets or External Secrets Operator.",
      "source": "kubernetes-domain"
    }
  ],
  "decisions": []
}
```

### Verification

1. Save `carl.json`
2. Open a new Claude Code session
3. Type a prompt with a recall keyword: "deploy this to kubernetes"
4. Look at the first line of the response for `LOADED DOMAINS: [KUBERNETES] matched: kubernetes (3 rules)`

If the domain doesn't fire, check:
- JSON is valid (`python3 -c "import json; json.load(open('$HOME/.carl/carl.json'))"`)
- `state` is `"active"` not `"disabled"`
- Recall keyword actually appears in your prompt
- `carl-hook.py` is registered in settings.json's UserPromptSubmit hook

## Create a Custom Agent

### Concept

An agent is a markdown file at `~/.claude/agents/<name>.md` with:
- YAML frontmatter (name, description, model, optional tools)
- A system prompt body in second person ("You are...")

### File format

```markdown
---
description: One-line summary shown in /agents list
model: sonnet
tools: Read, Edit, Bash, Grep, Glob
---

# Agent Name

You are a specialist in <domain>. When invoked:

1. First, read the relevant files.
2. Analyze for <specific criteria>.
3. Report findings in this structured format:
   - Issues (severity: CRITICAL, HIGH, MEDIUM, LOW)
   - Recommended fixes with code examples
   - Overall score out of 100

## Constraints
- Stay focused on <scope>
- Never recommend changes outside <scope>
- If you're uncertain, say so explicitly
- Quote file:line references for every finding

## Tone
<Brief description of how the agent should write: terse/verbose, formal/casual, etc.>
```

### Example — Accessibility Auditor

```markdown
---
description: WCAG 2.1 AA compliance auditor for React/HTML. Use before shipping any UI change.
model: sonnet
tools: Read, Grep, Glob, Bash
---

# Accessibility Auditor

You are a WCAG 2.1 AA compliance specialist. When invoked on a codebase or PR:

1. Read the affected UI files (tsx, jsx, html, css).
2. Check for:
   - Semantic HTML (nav, main, article, section, header, footer)
   - ARIA labels on interactive elements without visible labels
   - Color contrast (4.5:1 for text, 3:1 for large text and UI components)
   - Keyboard navigation (tab order, focus rings, skip links)
   - Screen reader compatibility (alt text, aria-live regions)
   - Motion sensitivity (prefers-reduced-motion honored)

3. Report findings as:

   ## Accessibility Audit
   ### CRITICAL (1)
   - Missing alt text on <img> (src/components/Hero.tsx:42)
     Fix: Add descriptive alt="" attribute or role="presentation"
   ### HIGH (2)
   ...
   ## Score: 72/100

## Constraints
- Only report issues that would fail an automated Axe or Lighthouse audit
- Quote specific file:line for every finding
- Do NOT suggest aesthetic changes unrelated to accessibility

## Tone
Professional, direct. No filler. No apologies.
```

### Verification

```bash
# Save as ~/.claude/agents/accessibility-auditor.md
# Then in Claude Code:
agent:accessibility-auditor "Audit the current page"
```

Look for structured output matching your agent's spec.

## Create a Custom Skill

### Concept

A skill is a `SKILL.md` file in `~/.claude/skills/<name>/` with YAML frontmatter containing `recall_keywords`. When any of those keywords appear in a prompt, Claude reads the skill before responding.

### File format

```markdown
---
name: Skill Display Name
description: One-sentence description
recall_keywords: [keyword1, keyword2, phrase with spaces]
---

# Skill Title

## When to use
When the user mentions <keyword> or the context involves <scenario>.

## Core principles
1. Principle 1
2. Principle 2
3. Principle 3

## Steps
1. Step 1 description
   - Sub-detail
2. Step 2 description
3. Step 3 description

## Code examples
```language
example code
```

## Anti-patterns (never do these)
- Don't do X
- Don't do Y
```

### Example — Feature-Flag-Discipline

```markdown
---
name: Feature Flag Discipline
description: Best practices for adding, using, and removing feature flags
recall_keywords: [feature flag, launchdarkly, statsig, flagsmith, growthbook, rollout, kill switch, gradual rollout]
---

# Feature Flag Discipline

## When to use
When the user asks to add a feature flag, gate a feature, roll out incrementally, or remove a flag after launch.

## Core principles
1. Every flag has a **removal date** in its description — no orphan flags
2. Flags default to **off** in production, **on** in test
3. Kill switches are always boolean; experiments are always percentage-based
4. Never branch on flags inside hot paths — check once at the boundary

## Steps to add a flag
1. Define in `flags.config.ts` with name, description, default, removal date
2. Wrap the feature's entry point with `useFlag("flag-name")`
3. Write a test with flag off AND flag on
4. Document in the PR description

## Steps to remove a flag
1. Verify it has been 100% rolled out for ≥2 weeks
2. Remove the `useFlag` call, keep only the flag-on branch
3. Delete the flag entry from `flags.config.ts`
4. Delete the flag-off test
5. Commit with message: `chore: remove feature flag <name>`

## Anti-patterns
- Don't use a flag as a permanent config toggle (that's a settings, not a flag)
- Don't branch on flags in loops or hot paths
- Don't leave flags past their removal date
```

### Verification

1. Create `~/.claude/skills/feature-flag-discipline/SKILL.md` with the content above.
2. Type a prompt mentioning "feature flag": "add a feature flag for the new checkout".
3. Claude should respond following your skill's structure.

## Add a Custom MCP Server

### Concept

MCP servers are external programs that speak the Model Context Protocol. Register them in `~/.claude/settings.json` under `mcpServers`.

### File format

```json
"server-name": {
  "command": "npx",
  "args": ["-y", "package-name"],
  "env": {
    "API_KEY_REFERENCE": "${ENV_VAR_NAME}"
  },
  "description": "What the server does"
}
```

### Example — add Firecrawl

```json
"firecrawl": {
  "command": "npx",
  "args": ["-y", "firecrawl-mcp"],
  "env": {
    "FIRECRAWL_API_KEY": "${FIRECRAWL_API_KEY}"
  },
  "description": "Dynamic website scraping (SPA-capable)"
}
```

Then in `~/.claude/.env`:
```
FIRECRAWL_API_KEY=your_key_here
```

Restart Claude Code.

### Verification

```
/mcp
```

Should show:
```
  ✓ firecrawl   firecrawl-mcp (connected)
```

If red X, check:
- API key is set in `.env`
- `settings.json` JSON is valid
- The npm package name is correct (firecrawl-mcp vs @mendable/firecrawl-mcp)

## Add a Custom Hook

### Concept

A hook is a shell script or Python script at `~/.claude/hooks/<name>.(sh|py)` registered in `settings.json` under a specific event.

### Events

- `UserPromptSubmit` — fires on every Enter
- `SessionStart` — fires when Claude Code opens
- `Stop` — fires when Claude finishes responding
- `PostCompact` — fires after `/compact`
- `Notification` — fires on notification events
- `PreToolUse` / `PostToolUse` — fires before/after any tool call

### File format (shell)

```bash
#!/usr/bin/env bash
# ~/.claude/hooks/my-hook.sh

# Your logic here
# Hooks have 30s timeout by default
# stdout is visible in Claude Code's session
# stderr is logged

echo "Hook ran at $(date)" >> "$HOME/my-hook-log.txt"
```

Make executable:
```bash
chmod +x ~/.claude/hooks/my-hook.sh
```

### Register in settings.json

```json
"hooks": {
  "UserPromptSubmit": [
    {
      "hooks": [
        { "type": "command", "command": "python3 $HOME/.claude/hooks/carl-hook.py" },
        { "type": "command", "command": "bash $HOME/.claude/hooks/my-hook.sh" }
      ]
    }
  ]
}
```

Order matters — hooks in the same event fire sequentially, top to bottom.

### Example — auto-commit after Stop event

```bash
#!/usr/bin/env bash
# ~/.claude/hooks/auto-commit.sh

# Only run inside a git repo with changes
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  if [[ -n "$(git status --porcelain)" ]]; then
    git add -u  # stage modifications (but not new files)
    git commit -m "wip: auto-commit [$(date +%H:%M)]" --no-verify > /dev/null 2>&1 || true
  fi
fi
```

Register under `Stop`, after `session-end-save.sh`.

**CAUTION**: this fires on every Stop event — make sure `--no-verify` isn't bypassing pre-commit hooks you need.

### Verification

Trigger the event manually:
- For UserPromptSubmit: press Enter in Claude Code
- For Stop: complete a task
- For SessionStart: restart Claude Code

Check your hook's side effects (log file, git log, etc.).

## Modify COMMAND-REGISTRY

### Concept

`~/.claude/COMMAND-REGISTRY.md` is a markdown file Claude reads when auto-invoking slash commands. Edit it to change intent-to-command routing.

### Structure

The critical section is the "Auto-Invocation Routing Table":

```markdown
| Intent Keywords | Top Commands | Guidance |
|---|---|---|
| plan, feature, architecture | `/paul:plan`, `/oh-my-claudecode:plan` | Opus-tier planning |
| review, critique, audit | `/review`, `/review-pr` | Run in parallel |
```

### Example — add a "deploy production" trigger

Add a new row:
```markdown
| ship prod, deploy to prod, production deploy | `/deploy`, `/commit-push-pr`, `/security-review` | Security review MUST run first |
```

Save. Next session, "ship this to production" auto-invokes `/security-review` before `/deploy`.

### Verification

Test with a matching prompt. Claude should mention which commands it's auto-invoking. If it doesn't, the registry isn't being consulted — check that Claude reads CAPABILITY-REGISTRY.md at session start (see `session-start-check.sh`).

## Advanced Patterns

### Project-specific CARL overrides

Create `<project>/CLAUDE.md` with project-specific rules. It loads only when you `cd` into that project. Project rules can extend or override global CARL rules.

### Multi-project routing with /switch-project

Edit `~/.claude/commands/switch-project.md` to add your projects:

```markdown
---
description: Switch between project contexts
---

Switch Claude's context to a specific project.

## Your projects

| Trigger | Path | CLAUDE.md |
|---|---|---|
| my-webapp | ~/code/my-webapp | ~/code/my-webapp/CLAUDE.md |
| acme-backend | ~/code/acme-backend | ~/code/acme-backend/CLAUDE.md |
| project-alpha | ~/code/project-alpha | ~/code/project-alpha/CLAUDE.md |

When invoked with a trigger, cd to the path and read its CLAUDE.md.
```

### Custom model routing per agent

In an agent's frontmatter, set the model explicitly:
```yaml
---
model: opus   # always use Opus for this agent
---
```

Or conditionally in the agent's system prompt:
```
If the task is "audit production code", use Opus reasoning.
Otherwise, Sonnet is sufficient.
```

### Chaining hooks

Multiple hooks in one event run in order. Use this to pipeline:

```json
"SessionStart": [
  {
    "matcher": "",
    "hooks": [
      { "type": "command", "command": "bash $HOME/.claude/hooks/session-start-check.sh" },
      { "type": "command", "command": "bash $HOME/.claude/hooks/project-auto-graph.sh" },
      { "type": "command", "command": "bash $HOME/.claude/hooks/my-custom-greeting.sh" }
    ]
  }
]
```

Order: left-to-right. Earlier hooks' output flows into the Claude session before later hooks.

## Testing Your Customizations

### Unit test a CARL domain

Set `config.devmode: true` in carl.json. Fire a prompt with your keyword. The devmode debug block shows exactly which rules fired.

### Unit test an agent

```
agent:my-agent "Test case 1"
agent:my-agent "Test case 2"
agent:my-agent "Edge case"
```

Verify output format matches your system prompt's spec.

### Unit test an MCP server

```
/mcp
```

Green checkmark = server connected. Then use a skill or agent that relies on the MCP.

### Unit test a hook

Trigger the event. Check side effects (log file, commit, notification).

## Shipping Customizations to a Team

### Option 1 — dotfiles repo

Commit your customizations to a private git repo:

```
my-claude-dotfiles/
  ├── agents/              # your custom agents
  ├── skills/              # your custom skills
  ├── hooks/               # your custom hooks
  ├── carl-additions.json  # your CARL additions
  └── README.md
```

Onboarding script:
```bash
# bootstrap.sh
cp -r agents/* ~/.claude/agents/
cp -r skills/* ~/.claude/skills/
cp -r hooks/* ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh
python3 merge-carl.py carl-additions.json
```

### Option 2 — custom Apex fork

Fork `claude-apex`, add your customizations under `agents/`, `skills/`, `hooks/`, `config/`, and run your fork's `install.sh`.

This is the cleanest approach for teams — everyone runs one script.

## Pro Tips

- **Test in devmode before shipping.** CARL devmode shows exactly which rules fire — cheap debugging.
- **Version your customizations.** Put dotfiles in git. When Claude Code updates, your customs survive.
- **Prefix custom ids.** CARL rule IDs 900+ are "yours"; Apex uses 0-799.
- **Keep custom agents narrow.** A 100-line system prompt beats a 1000-line one every time.
- **Don't override Apex hooks.** Write your own hook with a different name and add it in sequence — that way an Apex update doesn't clobber you.

## Next Step

- [ADVANCED-TOKEN-OPTIMIZATION.md](./ADVANCED-TOKEN-OPTIMIZATION.md) — How to run Apex for 50% of typical token cost
- [CUSTOMIZATION.md](./CUSTOMIZATION.md) — Lighter customization intro

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
