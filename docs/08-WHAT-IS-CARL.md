# What Is CARL?

## The kid-friendly analogy

**CARL is like a librarian who hands you only the books you need right now.**

You walk into a library. Instead of wandering the shelves, a librarian watches what you ask about and says:

- You said "I'm cooking" → here are the cooking rules.
- You said "I'm deploying to Vercel" → here are the deployment rules.
- You said "I'm doing legal work" → here are the legal rules.

The librarian loads ONLY the relevant rules, not everything. That's CARL.

## What CARL actually is

CARL stands for **Context Augmentation & Reinforcement Layer**. It's a Python hook (`carl-hook.py`) that fires every time you press Enter in Claude Code.

The hook:
1. Reads your prompt
2. Matches keywords against 9 domains
3. For each domain that matches, injects its rules into Claude's context
4. Claude sees those rules as part of the conversation

Result: Claude follows relevant rules without having to memorize ALL rules at once.

## A real example — traced step by step

**Your prompt:**
```
deploy the site to vercel and check with playwright after
```

**Step 1 — UserPromptSubmit hook fires.**

When you press Enter, Claude Code runs the hook registered in settings.json:
```
python3 $HOME/.claude/hooks/carl-hook.py
```

**Step 2 — `carl-hook.py` reads your prompt and matches keywords.**

Keyword matcher finds:
- `deploy` → matches **DEPLOYMENT** domain
- `vercel` → matches **DEPLOYMENT** domain
- `playwright` → matches **DEPLOYMENT** + **BROWSER** domains

**Step 3 — CARL injects rules into context.**

The hook prepends a `<carl-rules>` block to the prompt:

```
[GLOBAL] RULES (always on):
  0. NEVER use relative paths in code...
  1. NEVER run independent tool calls sequentially...
  2. NEVER mark tasks complete without validation...

[DEPLOYMENT] RULES:
  0. git add specific files only. NEVER git add -A or git add .
  1. git commit with descriptive message following conventional commits format.
  2. git push origin main before deploying.
  3. vercel --prod and wait for completion. Note the deployment URL.
  4. If you use a canonical alias, ALWAYS run 'vercel alias set' after deploy.
  5. Verify deployment with Playwright screenshot after alias is set.

[BROWSER] RULES:
  0. For unauthenticated web content, prefer WebSearch, WebFetch, exa-web-search MCP...
  1. Tasks requiring a logged-in browser session should be delegated to session-cookie-based scrapers...
```

**Step 4 — Claude sees the injected rules and follows them.**

When Claude reads "deploy the site to vercel", it now knows:
- Stage specific files (not `git add -A`)
- Commit with conventional format
- Run `vercel --prod`
- ALWAYS follow with `vercel alias set`
- Verify with Playwright screenshot

If you had asked only "write a hello world" without the deployment keywords, NONE of these rules would have loaded. Token savings, zero irrelevant noise.

## The three-layer routing diagram

CARL is Layer 1 of Apex's three-layer auto-routing system:

```
User prompt: "deploy the site to vercel"
      │
      ▼
┌──────────────────────────────────────────────────┐
│ LAYER 1 — CARL                                   │  ← carl-hook.py
│ Matches keywords → injects JIT rules              │
│ Result: DEPLOYMENT + BROWSER domains loaded       │
│ 8 rules injected into context                    │
└────────────────────┬─────────────────────────────┘
                     ▼
┌──────────────────────────────────────────────────┐
│ LAYER 2 — CAPABILITY-REGISTRY                    │  ← Claude reads at session start
│ Task pattern "deploy to vercel" matches row       │
│ Loads: skill:deployment-procedures, skill:        │
│   vercel-deployment; MCP:github, playwright;      │
│   CLI:gh, vercel, Playwright CLI; plugin:commit   │
└────────────────────┬─────────────────────────────┘
                     ▼
┌──────────────────────────────────────────────────┐
│ LAYER 3 — COMMAND-REGISTRY                       │  ← Claude reads on demand
│ Intent matches /deploy + /commit-push-pr          │
│ Auto-invokes in correct sequence                  │
└──────────────────────────────────────────────────┘
```

## The 9 CARL domains in V7

| Domain | When it activates | Example keywords | Rules |
|---|---|---|---:|
| **GLOBAL** | Always (always_on: true) | (universal) | 3 |
| **DEVELOPMENT** | Code tasks | "write code for", "fix this bug", "implement feature", "refactor", "add endpoint" | 0* |
| **WEB-DEVELOPMENT** | Web / frontend | "react", "typescript", "tailwind", "component", "animation", "21st", "gsap", "lenis", "scroll effect", "parallax", "hero section" | 9 |
| **DOCUMENT-CREATION** | Documents | "pdf", "pptx", "docx", "report", "presentation", "word", "powerpoint", "excel", "slides" | 7 |
| **RESEARCH-OSINT** | Research | "research", "osint", "investigate", "company", "competitor", "market research", "due diligence" | 5 |
| **DEPLOYMENT** | Shipping | "deploy", "vercel", "git push", "production", "publish", "ship it", "release" | 6 |
| **LEGAL** | Legal work | "contract", "law", "legal", "counsel", "agreement", "dispute", "arbitration", "liability" | 5 |
| **BROWSER** | Web access | "browse", "chrome", "instagram", "linkedin", "reddit", "facebook", "scrape", "social media", "take screenshot", "login session" | 2 |
| **PROJECT-NAVIGATION** | Codebase | "where is", "how does", "show me", "architecture", "structure", "continue working on", "resume", "last session", "navigate", "graph", "recall memory" | 3 |

**Totals: 9 domains, 40 rules, 117+ recall keywords.**

*DEVELOPMENT is a recall-only domain — it signals "this is a code task" to the routing layer, but all specific rules live in WEB-DEVELOPMENT, DEPLOYMENT, or other domains.

## Why not just load all rules always?

Because Claude has a **context window** (a limit on how much it reads at once). If you loaded all 40 rules every prompt:
- You'd waste ~2,000 tokens per turn on rules that don't apply
- Claude might skim them instead of focusing on the 3-8 that matter
- You'd pay more per message

CARL's Just-In-Time loading solves this: 40 total rules exist, but each prompt sees only the 3-15 that apply.

## Three routing examples

### Example 1 — "write me a react component for login"

```
Keywords matched: react, component
Domains loaded: GLOBAL (always), WEB-DEVELOPMENT
Rules injected: 3 (GLOBAL) + 9 (WEB-DEVELOPMENT) = 12 rules
Skills auto-loaded (Layer 2): frontend-design, react-patterns, typescript-pro, tailwind-patterns, ui-ux-pro-max
MCPs activated: @21st-dev/magic, context7, playwright
```

### Example 2 — "research acme-corp's main competitors"

```
Keywords matched: research, company
Domains loaded: GLOBAL, RESEARCH-OSINT
Rules injected: 3 + 5 = 8 rules
Skills auto-loaded: deep-research
MCPs activated: exa-web-search, firecrawl, playwright
```

### Example 3 — "create a pdf report on our q4 performance"

```
Keywords matched: pdf, report
Domains loaded: GLOBAL, DOCUMENT-CREATION
Rules injected: 3 + 7 = 10 rules
Skills auto-loaded: pdf-official
Agent auto-selected: doc-updater
CLI tools: Python (reportlab)
```

## Where CARL's rules live

All rules are in one JSON file: `~/.carl/carl.json`.

Edit it directly:
```bash
notepad ~/.carl/carl.json   # Windows
open -e ~/.carl/carl.json   # Mac
nano ~/.carl/carl.json      # Linux
```

The structure is obvious when you open it: each domain has `recall_keywords` (what triggers it) and `rules` (what gets injected).

## Adding your own rule

Say you always forget to run tests before committing. Add to the DEPLOYMENT domain's `rules` array:

```json
{
  "id": 406,
  "text": "ALWAYS run npm test before git commit. If tests fail, fix them first, then commit.",
  "source": "my-preference"
}
```

Save `carl.json`. Next time you mention "commit" or "deploy", Claude sees this rule and follows it.

## Adding your own domain

Want CARL to activate when you mention "PHP"? Add a new top-level entry in `domains`:

```json
"PHP": {
  "state": "active",
  "always_on": false,
  "recall": ["php", "laravel", "symfony", "wordpress", "composer"],
  "exclude": [],
  "rules": [
    { "id": 700, "text": "Use PHP 8.3+. Enable strict_types. Use typed properties.", "source": "my-preference" }
  ],
  "decisions": []
}
```

Save. You now have a 10th domain. Test by typing something with "php" or "laravel".

## CARL vs just putting rules in CLAUDE.md

Both work. CARL is smarter:

| In CLAUDE.md | In CARL |
|---|---|
| Every rule loads every session | Only matching rules load per prompt |
| All rules count against context | Only active rules count |
| Can't be disabled per-session | Can be turned off with `devmode` flag |
| No keyword matching | Automatic keyword matching |

**Use CLAUDE.md for**: always-on critical rules (brand principles, stakeholder titles).
**Use CARL for**: domain-specific rules that only apply to certain tasks.

## Checking CARL is working

Run any prompt and look at the first response. You should see something like:

```
LOADED DOMAINS:
  [GLOBAL] always_on (3 rules)
  [WEB-DEVELOPMENT] matched: react, component (9 rules)
```

This is CARL telling you which domains activated. If you never see this, CARL isn't firing — check `settings.json` for the UserPromptSubmit hook.

## CARL's debug mode

Open `~/.carl/carl.json`, find the top-level `config.devmode` field, change to `true`. Now every Claude response ends with a debug block showing which rules fired and which were applied. Useful for tuning rules. Turn it back off when done.

## What You Learned

- CARL = Context Augmentation & Reinforcement Layer — a Python hook that injects rules JIT.
- 9 domains, 40 rules, 117+ recall keywords total.
- GLOBAL is always on; the other 8 domains activate only when matching keywords appear.
- CARL is Layer 1 of three-layer routing (CARL → CAPABILITY-REGISTRY → COMMAND-REGISTRY).
- Rules live in `~/.carl/carl.json`; edit it to add custom rules or domains.

## Next Step

- **[09-GLOSSARY.md](09-GLOSSARY.md)** — Every term you've seen, defined in one line.
- **[10-TROUBLESHOOT-FOR-BEGINNERS.md](10-TROUBLESHOOT-FOR-BEGINNERS.md)** — When things go wrong.

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
