# CARL Guide — Just-In-Time Rule Loading

## The Problem CARL Solves

Without CARL, every session loads ALL rules at once:
```
[Without CARL]  React rules + deployment rules + legal rules + ... = 2,000 tokens per turn
[With CARL]     Detect "react" in prompt → load only WEB-DEVELOPMENT rules = 300 tokens
```

Result: focused context, cleaner reasoning, fewer tokens per turn.

## How CARL Works

CARL is a Python hook (`~/.claude/hooks/carl-hook.py`) registered on the `UserPromptSubmit` event.

```
User types: "Fix React hydration error in my-webapp"
              ↓
        UserPromptSubmit fires
              ↓
        carl-hook.py runs
              ↓
     Keywords matched: [react, error]
              ↓
    Domains loaded: GLOBAL (always) + WEB-DEVELOPMENT
              ↓
    Rules injected: 3 + 9 = 12 rules
              ↓
    Claude now has focused context
```

Cost per prompt: ~100-300 tokens for the injected rules block.

## The 9 CARL Domains (Apex V7)

### 1. GLOBAL (3 rules, always-on)

Fires on every prompt. Universal behavioral rules.

**Rules:**
- Never use relative paths in code; never use absolute paths when referencing files to the user
- Never run independent tool calls sequentially — batch them in parallel
- Never mark tasks complete without validation — test everything, require proof

### 2. DEVELOPMENT (0 rules, routing signal)

Fires on general coding keywords. No specific rules — signals "this is a code task" to Layer 2 routing.

**Recall keywords:**
`write code for`, `fix this bug`, `implement this feature`, `build this component`, `refactor this`, `add this endpoint`, `programming task`, `code review`

### 3. WEB-DEVELOPMENT (9 rules)

Fires on web / frontend keywords.

**Recall keywords (32+):**
`react`, `typescript`, `tailwind`, `vite`, `component`, `frontend`, `css`, `vercel`, `deploy`, `website`, `nextjs`, `supabase`, `page`, `navbar`, `footer`, `layout`, `responsive`, `mobile`, `21st`, `magic component`, `generate component`, `ui component`, `design system`, `premium design`, `animation`, `scroll effect`, `parallax`, `hero section`, `hover effect`, `interactive`, `GSAP`, `framer motion`, `lenis`, `smooth scroll`

**Rules:**
1. Always use TypeScript strict mode, never plain JavaScript
2. Use Tailwind CSS v4 utility classes, no custom CSS unless necessary
3. Keep components under 300 lines, split into modules
4. Run npm run build after code changes to verify
5. Use context7 MCP for library documentation lookup before writing framework code
6. Test on mobile viewport first — mobile-first responsive design is the default
7. Use semantic HTML for accessibility; include ARIA labels where needed
8. Before coding UI from scratch, check if 21st.dev Magic MCP has a ready-made component. Generate base with 21st.dev, customize with hand-coded GSAP/Framer Motion
9. For design reference, check premium-web-design references (analyzed sites at `~/.claude/skills/premium-web-design/references/`)

### 4. DOCUMENT-CREATION (7 rules)

Fires on document keywords.

**Recall keywords:**
`pdf`, `pptx`, `docx`, `presentation`, `report`, `document`, `word`, `powerpoint`, `excel`, `slides`, `deliverable`, `export`

**Rules:**
1. Generate non-Latin scripts (Arabic, Hebrew, CJK) inside Python scripts only — never in terminal commands (terminals corrupt encoding)
2. Use arabic-reshaper + python-bidi for PDF; use raw Unicode + rtl=1 XML for PPTX; never use arabic-reshaper for PPTX
3. All presentations must be phone-readable: 18pt+ body, 28pt+ headers
4. On Linux/WSL, pip install always uses `--break-system-packages`
5. Never mix RTL and LTR scripts in the same text run — separate paragraphs/text boxes
6. Use consistent brand colors on every slide; define them once in a config object
7. Export Word via python-docx, PDF via reportlab, PPTX via python-pptx, XLSX via openpyxl

### 5. RESEARCH-OSINT (5 rules)

Fires on research keywords.

**Recall keywords:**
`research`, `osint`, `investigate`, `company`, `competitor`, `analysis`, `intelligence`, `background check`, `vendor`, `market research`, `due diligence`

**Rules:**
1. Use exa-web-search MCP for semantic search
2. Use firecrawl MCP for website scraping
3. Cross-reference minimum 3 sources before stating facts
4. Save research output with a date prefix (YYYY-MM-DD) in a dedicated folder
5. When delivering research in multiple languages, generate each language version separately

### 6. DEPLOYMENT (6 rules)

Fires on deployment keywords.

**Recall keywords:**
`deploy`, `vercel`, `git push`, `production`, `live`, `publish`, `ship it`, `go live`, `release`

**Rules:**
1. git add specific files only — NEVER `git add -A` or `git add .`
2. git commit with descriptive message in conventional commits format
3. git push origin main (or your default branch) before deploying
4. vercel --prod and wait for completion; note the deployment URL
5. If you use a canonical alias, ALWAYS run `vercel alias set` after deploy
6. Verify deployment with Playwright screenshot after alias is set

### 7. LEGAL (5 rules)

Fires on legal keywords.

**Recall keywords:**
`contract`, `law`, `legal`, `counsel`, `agreement`, `dispute`, `labor`, `commercial`, `arbitration`, `liability`, `court`

**Rules:**
1. Reference the jurisdiction's primary commercial/labor law first; specialize recall keywords for your region
2. All legal output in the jurisdiction's formal legal register (MSA for GCC, plain English for US/UK)
3. Never provide definitive legal advice; frame every output as analysis and recommend licensed counsel
4. Cross-reference with regional regulations when applicable (GCC, EU, state-level, federal)
5. Cite sources for every legal claim — statute number, case citation, or regulation reference

### 8. BROWSER (2 rules)

Fires on browser / scraping keywords.

**Recall keywords:**
`browse`, `chrome`, `screenshot website`, `instagram`, `linkedin`, `reddit`, `github`, `open site`, `visit url`, `facebook`, `scrape`, `social media`, `scroll feed`, `view website`, `extract from website`, `check website`, `read posts`, `view profile`, `take screenshot`, `login session`, `web page`

**Rules:**
1. For unauthenticated web content, prefer WebSearch, WebFetch, exa-web-search MCP, or context7 MCP. Use browser MCPs (Playwright) only when you need rendering, JS execution, or visual capture.
2. Tasks requiring logged-in sessions (authenticated Instagram, LinkedIn, private dashboards) should use session-cookie-based scrapers (instaloader), not Claude Code's Bash tool.

### 9. PROJECT-NAVIGATION (3 rules)

Fires on codebase-navigation keywords.

**Recall keywords:**
`where is`, `how does`, `show me`, `understand the codebase`, `architecture`, `structure`, `find the`, `continue working on`, `pick up`, `resume`, `last session`, `what did we`, `navigate`, `graph`, `recall memory`

**Rules:**
1. ALWAYS query claude-mem (mem-search skill) for prior context BEFORE reading memory files
2. ALWAYS check if a graphify knowledge graph exists BEFORE reading raw files (path: `graphify-out/graph.json`)
3. Graph query costs ~1,000 tokens; raw file read costs 10,000+. Prefer the graph unless the task specifically needs file content.

## Totals

- **9 domains** (GLOBAL + 8 context-specific)
- **40 rules** across all domains
- **117+ recall keywords** that trigger domains

## Three Real Routing Examples

### Example 1 — Web development task

**Prompt:**
```
build me a react component with a smooth scroll animation on the hero section
```

**CARL trace:**
```
Keywords matched: react, component, animation, scroll effect, hero section
Domains loaded: GLOBAL (always) + WEB-DEVELOPMENT
Rules injected: 3 + 9 = 12 rules

Claude now knows:
- TypeScript strict mode required
- Tailwind CSS v4 preferred
- Components under 300 lines
- npm run build after changes
- Check @21st-dev/magic for ready-made first
- Use GSAP or Framer Motion for animations
- Mobile-first
```

### Example 2 — Deployment task

**Prompt:**
```
deploy this to production on vercel
```

**CARL trace:**
```
Keywords matched: deploy, production, vercel
Domains loaded: GLOBAL + DEPLOYMENT
Rules injected: 3 + 6 = 9 rules

Claude now knows:
- NEVER git add -A
- git add specific files; conventional commit
- git push before vercel --prod
- ALWAYS vercel alias set after --prod
- Verify with Playwright screenshot
```

### Example 3 — Legal document task

**Prompt:**
```
review this employment contract and flag compliance issues
```

**CARL trace:**
```
Keywords matched: contract, legal, compliance (legal recall keyword variant), labor
Domains loaded: GLOBAL + LEGAL
Rules injected: 3 + 5 = 8 rules

Claude now knows:
- Reference jurisdiction's commercial/labor law
- Never give definitive legal advice
- Cross-reference regional regulations
- Cite statutes/cases/regs for every claim
- Output in formal register for the jurisdiction
```

## Why Not Load All Rules Always?

- 40 rules × average 50 tokens = 2,000 tokens every prompt
- Most rules don't apply; Claude would skim them
- You'd pay more per message
- Irrelevant rules sometimes contradict relevant ones

CARL's JIT approach: only 3-8 rules active per prompt, tightly scoped.

## Where CARL's Rules Live

Single JSON file: `~/.carl/carl.json`.

**Structure:**
```json
{
  "version": 1,
  "config": {
    "devmode": false,
    "post_compact_gate": true,
    "global_exclude": []
  },
  "domains": {
    "GLOBAL": {
      "state": "active",
      "always_on": true,
      "recall": ["universal"],
      "rules": [
        { "id": 0, "text": "...", "source": "apex-template" }
      ]
    },
    "WEB-DEVELOPMENT": {
      "state": "active",
      "always_on": false,
      "recall": ["react", "typescript", ...],
      "rules": [
        { "id": 100, "text": "Always use TypeScript strict mode...", "source": "apex-template" }
      ]
    }
  }
}
```

Edit directly:
```bash
notepad ~/.carl/carl.json   # Windows
open -e ~/.carl/carl.json   # macOS
nano ~/.carl/carl.json      # Linux
```

## Adding Your Own Rule

Add to any existing domain's `rules` array:

```json
{
  "id": 109,
  "text": "Use connection pooling for databases. Minimum pool size 10, max 100.",
  "source": "my-preference"
}
```

Save. Next time a matching keyword fires, Claude sees this rule.

## Adding Your Own Domain

Add a new top-level entry under `domains`:

```json
"PHP": {
  "state": "active",
  "always_on": false,
  "recall": ["php", "laravel", "symfony", "wordpress", "composer"],
  "exclude": [],
  "rules": [
    { "id": 700, "text": "Use PHP 8.3+. Enable strict_types. Typed properties.", "source": "my-preference" },
    { "id": 701, "text": "Laravel projects use Pest for tests, not PHPUnit.", "source": "my-preference" }
  ],
  "decisions": []
}
```

Save. Type something with "php" or "laravel" to confirm it fires.

## Disabling a Domain

Set `state: "disabled"` for the domain. The hook will skip it.

```json
"LEGAL": {
  "state": "disabled",
  ...
}
```

## CARL vs CLAUDE.md

| In CLAUDE.md | In CARL |
|---|---|
| Every rule loads every session | Only matching rules load per prompt |
| All rules count against context | Only active rules count |
| No keyword matching | Automatic keyword matching |
| Good for stakeholder names | Good for task-specific rules |

**Use CLAUDE.md for** always-on rules (brand values, stakeholder titles, workspace conventions).
**Use CARL for** domain-specific rules that only apply in certain tasks.

## Checking CARL Is Working

On any prompt, look at the first line of the response. You should see:

```
LOADED DOMAINS:
  [GLOBAL] always_on (3 rules)
  [WEB-DEVELOPMENT] matched: react, component (9 rules)
```

If you never see this, CARL isn't firing. Run `/healthcheck` — line 6 should show `UserPromptSubmit | OK`.

## Debug Mode

Set `config.devmode: true` in `carl.json`. Every response now ends with a debug block showing which rules fired and which were applied. Useful for rule tuning. Turn off when done.

## CARL + Orchestration Engine

When CARL loads rules, they inform routing decisions:

```
Task: "Optimize React component performance"
      ↓
CARL loads: GLOBAL + WEB-DEVELOPMENT (but NOT a "performance" domain — none exists)
Recall matches on: react, component
      ↓
Orchestration Engine sees loaded domains + context
      ↓
Routes to: autoresearch (measurable metric: render time)
           + OMC team mode (parallel benchmarking)
```

## Common Pitfalls

### Rule not firing?

- Check trigger keywords: `grep "recall" ~/.carl/carl.json` — make sure your keyword is in the list
- Check `state: "active"` — inactive domains are skipped
- Check the hook is installed: `grep carl-hook.py ~/.claude/settings.json`
- Restart Claude Code after editing carl.json

### Too many domains firing?

- Keywords too broad. `code` fires WEB-DEVELOPMENT constantly. Use more specific keywords.
- Reduce overlap: split shared keywords into their own domain

### Rules contradicting each other?

Add clarification text:
```
Rule text: "Use caching [for read-heavy data]. Avoid caching [for real-time data]."
```

## Pro Tips

- **Keep recall keywords specific.** `react` is good; `code` is too broad — it fires every coding prompt.
- **Order rules by frequency.** Most common pattern first. Claude reads top-to-bottom.
- **Use examples in rule text.** `"Use memoization with useCallback: const x = useCallback(...)"` beats `"Use memoization"`.
- **Always-on rules stay minimal.** Every GLOBAL rule costs ~50 tokens on every prompt. Keep it to 3-5.
- **Watch your devmode output.** Turning on devmode for a few prompts teaches you which rules actually fire for your workflow.
- **Edit `carl.json`, not CLAUDE.md.** CLAUDE.md is always-on; CARL is JIT. Most rules belong in CARL.

## Next Step

- [AGENTS-GUIDE.md](./AGENTS-GUIDE.md) — Meet the 108 specialist agents
- [ARCHITECTURE.md](./ARCHITECTURE.md) — See how CARL fits in the full stack

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
