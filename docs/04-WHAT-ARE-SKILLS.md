# What Are Skills?

## The kid-friendly analogy

**Skills are like recipe books that Claude keeps on a shelf.**

When you ask Claude "make me a pizza", Claude doesn't need to memorize every pizza recipe. It grabs the pizza recipe book off the shelf, reads it, and follows the steps.

Skills work the same way. Claude has **1,276+ recipe books** on a shelf. When you ask it to do something, it grabs the right one and uses it.

## A real example

You ask Claude: *"create a presentation about our company"*.

Without skills, Claude would make a mediocre PowerPoint because it has to guess at best practices.

With skills, Claude reads the `pptx-official` skill first. That skill is a 300-line recipe book covering:
- Brand color application
- Font sizing for readability
- Slide structure for pitch decks
- RTL/LTR text handling
- Export to PDF workflow

Now Claude produces a professional deck because it's following a tested recipe.

## What's in a skill?

Every skill is a markdown file called `SKILL.md` in a folder like:
```
~/.claude/skills/premium-web-design/SKILL.md
```

Inside, you find:
- A title and description
- Keywords that trigger the skill automatically
- Guidance written for Claude to follow

Example (first few lines of a real skill):
```markdown
---
name: Premium Web Design
description: Luxury web design skill with animation patterns
recall_keywords: [premium design, luxury website, animation, scroll]
---

# Premium Web Design Skill

Build stunning websites with production-ready animation patterns...
```

The `recall_keywords` are what matter. When you type "I need a luxury landing page", Claude notices "luxury" matches this skill's keywords and reads the skill.

## Categories of skills in Apex

After full install, you have skills for:

- **Web development**: React, Vue, Next.js, TypeScript, Tailwind
- **Backend**: Node.js, FastAPI, Django, NestJS
- **Database**: PostgreSQL, Supabase, Prisma
- **DevOps**: Docker, Kubernetes, Vercel, CI/CD
- **Security**: OWASP, pentest, vulnerability scanning
- **SEO**: 25+ specialized SEO skills
- **Documents**: Word, PDF, PowerPoint, Excel
- **AI/ML**: LangChain, RAG, embeddings
- **Business**: CEO/CTO/CFO advisors, pricing, marketing
- **Programming languages**: Python, Go, Rust, Java, C++, Ruby, PHP
- **Testing**: Playwright, TDD workflows
- **Design**: Graphic design, premium web design, 3D experiences

## Apex-exclusive skills (9 custom, not in the plugin library)

1. **premium-web-design** — 36 animation patterns, 10 reference site analyses
2. **21st-dev-magic** — React component generation from natural language
3. **instagram-access** — authenticated Instagram scraping
4. **graphify** — knowledge-graph navigation (saves ~90% of tokens)
5. **graphic-design-studio** — code-based graphic rendering
6. **impeccable** — design polish and micro-interactions
7. **fireworks-tech-graph** — technical documentation graphing
8. **dream-consolidation** — memory cleanup between sessions
9. **autoresearch** — autonomous optimization loops

## How Claude picks which skill to use

This is where Apex is clever. It uses **three layers**:

**Layer 1: CARL** (via `carl-hook.py`) matches keywords in your prompt to **rule domains**, not skills. But those rules often mention skills you should load.

**Layer 2: CAPABILITY-REGISTRY.md** is the routing table. Claude reads it at session start. When you say "build a website", Claude looks up "build website" in the table and sees: "Load skills: frontend-design, premium-web-design, tailwind-patterns, react-patterns".

**Layer 3: COMMAND-REGISTRY.md** maps user intent to slash commands, which often invoke skills.

So from your one sentence, the right skills activate automatically.

## Can I make my own skill?

Yes. Easily. Create a folder:

```bash
mkdir -p ~/.claude/skills/my-custom-skill
```

Create `~/.claude/skills/my-custom-skill/SKILL.md` with this content:

```markdown
---
name: My Custom Skill
description: What this skill does in one sentence
recall_keywords: [keyword1, keyword2, keyword3]
---

# My Custom Skill

Guidance Claude should follow when this skill activates.

## When to use
When the user says <keyword1> or <keyword2>.

## Steps
1. ...
2. ...
```

That's it. The next time you mention one of your keywords, Claude reads your skill.

## Where does the 1,276 number come from?

- **9** custom Apex skills (this repo)
- **1,267** from the `everything-claude-code` plugin (a giant community library)

When you run `/plugin install everything-claude-code`, that plugin pulls in its entire skill library. That's how you get to 1,276+.

## Can I delete a skill?

Sure. `rm -rf ~/.claude/skills/<name>`. Or disable the plugin that installed it. Claude won't miss it.

## What's next

- [05-WHAT-ARE-AGENTS.md](05-WHAT-ARE-AGENTS.md) — Agents are different from skills. Agents DO work; skills GUIDE work.
