# What Is CARL?

## The kid-friendly analogy

**CARL is like a librarian who hands you only the books you need right now.**

Imagine you walk into a library. Instead of you wandering the shelves looking for the right book, a librarian watches what you ask about and says:

- You said "I'm cooking": here are the cooking rules books.
- You said "I'm deploying to Vercel": here are the deployment rules books.
- You said "I'm doing legal work": here are the legal rules books.

The librarian loads ONLY the relevant rules, not everything. That's CARL.

## What CARL actually is

CARL stands for **Context Augmentation & Reinforcement Layer**. It's a Python hook (`carl-hook.py`) that fires every time you press Enter in Claude Code.

The hook:
1. Reads your prompt
2. Matches keywords against 9 domains
3. For each domain that matches, injects its rules into Claude's context
4. Claude sees those rules as part of the conversation

Result: Claude follows relevant rules without having to memorize ALL rules at once.

## A real example

Your prompt: *"deploy the site to Vercel"*

CARL's keyword matcher finds:
- `deploy` → matches **DEPLOYMENT** domain
- `vercel` → matches **DEPLOYMENT** domain

CARL injects the 6 DEPLOYMENT rules into Claude's context:
```
[DEPLOYMENT] RULES:
  0. git add specific files only. NEVER git add -A or git add .
  1. git commit with descriptive message...
  2. git push origin main...
  3. vercel --prod and wait for completion...
  4. ALWAYS run vercel alias set...
  5. Verify deployment with Playwright screenshot
```

Claude sees these rules and follows them. If you hadn't mentioned deploy or vercel, these rules never load — saving tokens.

## The 9 CARL domains in V7

| Domain | When it activates | Example keywords |
|---|---|---|
| **GLOBAL** | Always (3 rules) | (always on) |
| **DEVELOPMENT** | Code tasks | "write code for", "fix this bug", "implement this feature" |
| **WEB-DEVELOPMENT** | Web/frontend | "react", "tailwind", "component", "animation", "21st" |
| **DOCUMENT-CREATION** | Documents | "pdf", "pptx", "docx", "report", "presentation" |
| **RESEARCH-OSINT** | Research | "research", "investigate", "company", "competitor" |
| **DEPLOYMENT** | Shipping | "deploy", "vercel", "production", "release" |
| **LEGAL** | Legal work | "contract", "law", "legal", "counsel", "agreement" |
| **BROWSER** | Web access | "chrome", "screenshot website", "instagram", "scrape" |
| **PROJECT-NAVIGATION** | Codebase | "where is", "how does", "architecture", "structure" |

Total: 40 rules across 9 domains.

## Why not just load all rules always?

Because Claude has a **context window** (a limit on how much it reads at once). If you loaded 40 rules every single prompt:
- You'd waste ~2,000 tokens per turn on rules that don't apply
- Claude might skim them instead of focusing on the 3-6 that matter
- You'd pay more per message

CARL's Just-In-Time loading solves this: 40 total rules exist, but each prompt only sees the 3-15 that are relevant.

## Where CARL's rules live

All rules are in one JSON file: `~/.carl/carl.json`.

You can edit it directly:
```bash
notepad ~/.carl/carl.json   # Windows
open -e ~/.carl/carl.json   # Mac
nano ~/.carl/carl.json      # Linux
```

The structure is obvious when you open it: each domain has `recall_keywords` (what triggers it) and `rules` (what to inject).

## Adding your own rule

Say you always forget to run tests before committing. Add a custom rule to the DEPLOYMENT domain:

```json
{
  "id": 406,
  "text": "ALWAYS run npm test before git commit. If tests fail, fix them first, then commit.",
  "source": "my-preference"
}
```

Save `carl.json`. Next time you mention "commit" or "deploy", Claude sees this rule and follows it.

## Adding your own domain

Want CARL to activate when you mention "PHP"? Add a new domain:

```json
"PHP": {
  "state": "active",
  "always_on": false,
  "recall": ["php", "laravel", "symfony", "wordpress", "composer"],
  "exclude": [],
  "rules": [
    { "id": 700, "text": "Use PHP 8.3+. Enable strict_types. Use typed properties." }
  ],
  "decisions": []
}
```

Save and you have a new domain.

## CARL vs just putting rules in CLAUDE.md

Both work. CARL is smarter about it:

| In CLAUDE.md | In CARL |
|---|---|
| Every rule loads every session | Only matching rules load per prompt |
| All rules count against context | Only active rules count |
| Can't be disabled per-session | Can be turned off with `*DEVMODE off` etc. |
| No keyword matching | Automatic keyword matching |

**Use CLAUDE.md for**: always-on critical rules (brand colors, core principles, stakeholder names).
**Use CARL for**: domain-specific rules that only apply to certain tasks.

## Checking CARL is working

Run any prompt and look at the first response. You should see something like:

```
LOADED DOMAINS:
  [GLOBAL] always_on (3 rules)
  [WEB-DEVELOPMENT] matched: react, component (9 rules)
```

This is CARL telling you which domains activated and why. If you never see this, CARL isn't firing — check `settings.json` for the UserPromptSubmit hook.

## CARL's debug mode

Open `~/.carl/carl.json`, find `"devmode": false`, change to `"devmode": true`. Now every Claude response ends with a debug block showing which rules fired and which were applied. Useful for debugging rules. Turn it back off when done.

## What's next

- [09-GLOSSARY.md](09-GLOSSARY.md) — Every term you've seen, defined in one line
- [10-TROUBLESHOOT-FOR-BEGINNERS.md](10-TROUBLESHOOT-FOR-BEGINNERS.md) — When things go wrong
