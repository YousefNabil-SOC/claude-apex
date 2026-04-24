# What Are Skills?

## The kid-friendly analogy

**Skills are like recipe books that Claude keeps on a shelf.**

When you ask Claude "make me a pizza", Claude doesn't memorize every pizza recipe. It grabs the pizza recipe book off the shelf, reads it, and follows the steps.

Skills work the same way. Claude has **1,276+ recipe books** on a shelf. When you ask it to do something, it grabs the right one and uses it.

## A real example

You ask Claude: *"create a presentation about our company"*.

Without skills, Claude would produce a mediocre PowerPoint because it has to guess at best practices.

With skills, Claude reads the `pptx-official` skill first. That skill is a several-hundred-line recipe book covering:
- Brand color application (defined in your project's CLAUDE.md)
- Font sizing for phone-readability (18pt+ body, 28pt+ headers)
- Slide structure for pitch decks
- RTL/LTR text handling for bilingual decks
- Export to PDF workflow

Now Claude produces a professional deck because it follows a tested recipe.

## What's in a skill?

Every skill is a markdown file called `SKILL.md` inside a folder like:
```
~/.claude/skills/premium-web-design/SKILL.md
```

Inside, you find:
- A title and description
- Keywords that trigger the skill automatically
- Guidance Claude follows

**Example (first lines of the real `premium-web-design` skill):**
```markdown
---
name: Premium Web Design
description: Luxury web design skill with animation patterns
recall_keywords: [premium design, luxury website, animation, scroll, parallax, hero section, gsap, framer motion]
---

# Premium Web Design Skill

Build stunning websites with production-ready animation patterns.
36 patterns in patterns/. 10 reference site analyses in references/.
...
```

The `recall_keywords` are what matter. When your prompt contains one of these keywords, Claude reads this skill before responding.

## The top 10 most useful Apex skills — by name, with examples

### 1. `premium-web-design` (Apex custom)
**What it does:** 36 curated animation patterns, 10 reference site analyses (Airbnb, Apple, Linear, Stripe, etc.), GSAP/Framer Motion tool guides.
**Example prompt that activates it:**
> build me a luxury landing page with scroll-triggered animations

### 2. `21st-dev-magic` (Apex custom)
**What it does:** Generates React+TS+Tailwind UI components via the 21st.dev Magic MCP from natural language.
**Example prompt:**
> generate a pricing table component with 3 tiers

### 3. `graphify` (Apex custom)
**What it does:** Knowledge-graph skill that navigates your codebase at ~1,000 tokens per query instead of 10,000+ for raw file reads.
**Example prompt:**
> where is the authentication middleware in this codebase?

### 4. `impeccable` (Apex custom)
**What it does:** Design polish layer — hover states, micro-interactions, focus rings, keyboard nav, empty states. Run after building a UI to raise it to production quality.
**Example prompt:**
> polish this landing page — make it feel premium

### 5. `fireworks-tech-graph` (Apex custom)
**What it does:** Technical documentation graphing. Converts API docs, architecture diagrams, and data flow descriptions into queryable graphs.
**Example prompt:**
> graph the data flow of our checkout pipeline

### 6. `instagram-access` (Apex custom)
**What it does:** Authenticated Instagram scraping via instaloader. Pulls posts, captions, media, follower data with your logged-in session.
**Example prompt:**
> download @acme-corp Instagram posts from the last 30 days

### 7. `dream-consolidation` (Apex custom)
**What it does:** 4-phase memory cleanup (Orient → Gather → Consolidate → Prune). Compresses session history and preserves durable lessons.
**Example prompt:**
> consolidate memory

### 8. `autoresearch` (Apex custom)
**What it does:** Autonomous optimization loops. Modify → measure → keep if improved, discard if not → repeat until metric converges.
**Example prompt:**
> autoresearch: optimize our build size below 500KB

### 9. `graphic-design-studio` (Apex custom)
**What it does:** Code-based graphic rendering via HTML/CSS/SVG/Pillow/Playwright. Generates logos, banners, social media graphics for free (no fal.ai cost).
**Example prompt:**
> create a social media banner announcing our product launch

### 10. `commit` (from everything-claude-code plugin)
**What it does:** Smart git commit flow — stages specific files (never `git add -A`), drafts conventional-commit messages, creates PRs via `gh`.
**Example prompt:**
> commit and push these changes

## Categories of skills in Apex

After the full install, you have skills for:

- **Web development**: React, Vue, Next.js, TypeScript, Tailwind, Remix
- **Backend**: Node.js, FastAPI, Django, NestJS, Go, Rust
- **Database**: PostgreSQL, Supabase, Prisma, Drizzle, MongoDB
- **DevOps**: Docker, Kubernetes, Vercel, GitHub Actions, Terraform
- **Security**: OWASP, pentest, vulnerability scanning, threat modeling
- **SEO**: 25+ specialized SEO skills (technical, schema, content, GEO, performance)
- **Documents**: Word (docx-official), PDF (pdf-official), PowerPoint (pptx-official), Excel (xlsx-official)
- **AI/ML**: LangChain, RAG implementation, embeddings, LLM app patterns
- **Business**: CEO/CTO/CFO/CMO/COO advisors, pricing strategy, market sizing
- **Programming languages**: Python, Go, Rust, Java, C++, Ruby, PHP, Elixir, Scala
- **Testing**: Playwright, TDD workflows, test-driven patterns
- **Design**: Graphic design, premium web design, 3D web experiences

## Apex-exclusive skills (9 custom — not in any plugin)

1. `premium-web-design` — luxury patterns, animation, reference site analyses
2. `21st-dev-magic` — React component generation via 21st.dev Magic MCP
3. `instagram-access` — authenticated Instagram scraping (instaloader)
4. `graphify` — knowledge-graph navigation (~90% token savings)
5. `graphic-design-studio` — code-based graphic rendering
6. `impeccable` — design polish and micro-interaction refinement
7. `fireworks-tech-graph` — technical documentation graphing
8. `dream-consolidation` — memory cleanup between sessions
9. `autoresearch` — autonomous optimization loops

## How Claude picks which skill to use

Apex uses **three layers** to pick skills:

**Layer 1 — CARL** (via `carl-hook.py`) matches keywords in your prompt to one of 9 rule domains. Rules often mention skills to load.

**Layer 2 — CAPABILITY-REGISTRY.md** is the task-routing table. Claude reads it at session start. When you say "build a website", the table says: "Load skills: frontend-design, premium-web-design, tailwind-patterns, react-patterns".

**Layer 3 — COMMAND-REGISTRY.md** maps user intent to slash commands, which themselves invoke skills.

So from one sentence, the right skills activate automatically.

## Can I make my own skill?

Yes. Easily. Create a folder:

```bash
mkdir -p ~/.claude/skills/my-custom-skill
```

Create `~/.claude/skills/my-custom-skill/SKILL.md`:

```markdown
---
name: My Custom Skill
description: What this skill does in one sentence
recall_keywords: [keyword1, keyword2, keyword3]
---

# My Custom Skill

Guidance Claude follows when this skill activates.

## When to use
When the user mentions keyword1 or keyword2.

## Steps
1. ...
2. ...
```

That's it. Next time you mention one of your keywords, Claude reads your skill.

## Where does the 1,276 number come from?

- **9** custom Apex skills (this repo)
- **1,267** from the `everything-claude-code` plugin (a giant community library)

When you run `/plugin install everything-claude-code`, that plugin pulls in its entire skill library. That's how you get to 1,276+.

Before installing that plugin, you have 9 skills — just the Apex custom set.

## Can I delete a skill?

Sure. `rm -rf ~/.claude/skills/<name>`. Or disable the plugin that installed it. Claude won't miss it.

## What You Learned

- Skills are recipe books Claude reads on demand, not knowledge it memorizes.
- Apex ships 9 custom skills; the `everything-claude-code` plugin adds 1,267 more.
- Each skill's `recall_keywords` auto-trigger when they appear in your prompt.
- You can make your own skill in 60 seconds — folder + SKILL.md + frontmatter.
- Skills cost zero tokens until loaded; only the relevant one reads per prompt.

## Next Step

- **[05-WHAT-ARE-AGENTS.md](05-WHAT-ARE-AGENTS.md)** — Agents are different from skills. Skills GUIDE work; agents DO work.

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
