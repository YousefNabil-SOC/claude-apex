# First Time Using Claude Apex

> You installed everything. Now here are your first 10 commands, each with what to type, what it does, and exactly what to expect back.

## Start Claude Code

Open your terminal. Type:

```bash
claude
```

**Expected output:**
```
Claude Code v2.1.80
Working directory: /home/you/claude-apex
Type /help for commands, or just ask a question.

>
```

The `>` is your prompt. Everything you type after it is sent to Claude.

---

## Command 1 — Say hi

**Type:**
```
hi
```

**What it does:** Sends a simple message. Tests that Claude Code is connected.

**Expected output:**
```
Hi! What would you like to work on today? I can read your files, 
run commands, and help you build, debug, or learn. What's on 
your mind?
```

If you see this, you're connected.

---

## Command 2 — Ask a question that runs a real command

**Type:**
```
what version of node do i have installed?
```

**What it does:** Claude runs `node --version` on your machine and reports the result. Notice it runs a real command, not guesses.

**Expected output:**
```
I'll check your Node.js version.

Running: node --version
v20.11.0

You have Node.js v20.11.0 installed. This meets the Apex V7 
requirement of Node.js 20 or higher.
```

---

## Command 3 — Run the Apex health check

**Type:**
```
/healthcheck
```

**What it does:** The `/` prefix means "run a slash command". `/healthcheck` verifies all 18 Apex systems.

**Expected output:**
```
System Health Check V7

 #  | System              | Status | Details
----|---------------------|--------|--------------------------------
 1  | OMC Plugin          | OK     | oh-my-claudecode@omc enabled
 2  | PAUL Framework      | OK     | 28 commands
 3  | CARL                | OK     | 9 domains, 40 rules configured
 4  | Autoresearch        | OK     | SKILL.md present
 5  | SEED                | OK     | seed.md present
 6  | UserPromptSubmit    | OK     | carl-hook.py (UTF-8 fixed)
 7  | SessionStart        | OK     | session-start-check + auto-graph
 8  | PostCompact Hook    | OK     | V7 recovery verified
 9  | Sound Notification  | OK     | 60s cooldown configured
 10 | Settings JSON       | OK     | Valid JSON
 11 | MCP Servers         | OK     | 4 default + 11 optional
 12 | 21st.dev Magic      | OK     | Component generation active
 13 | Graphify            | OK     | Knowledge graph skill loaded
 14 | Premium Web Design  | OK     | 36 patterns, 10 references
 15 | Skills Count        | OK     | 1,276+ skills
 16 | Agents Count        | OK     | 108 agents
 17 | effortLevel         | OK     | high (self-healing enforced)
 18 | Memory Health       | OK     | 112 lines (limit: 200)

Result: 18/18 OK — all systems green
```

---

## Command 4 — See what agents are available

**Type:**
```
/agents
```

**What it does:** Lists all specialist agents Claude can delegate work to.

**Expected output (abbreviated — full list has 108 entries):**
```
Available agents (108 total)

Apex custom (25):
  architect              - System design specialist (Opus)
  code-reviewer          - Code quality reviewer (Sonnet)
  security-reviewer      - Security vulnerability specialist (Sonnet)
  tdd-guide              - TDD workflow enforcer (Sonnet)
  planner                - Implementation planner (Opus)
  ... (20 more)

RuFlo (51 via claude-flow MCP):
  coder, tester, reviewer, planner, researcher...

OMC (19 via oh-my-claudecode):
  analyst, architect, code-reviewer, debugger, designer...

Plugin-provided (13):
  agent-sdk-verifier, code-architect, code-explorer...

Type "agent:<name> <task>" to invoke one directly.
```

---

## Command 5 — Check your current model and effort level

**Type:**
```
/model
```

**What it does:** Shows which Claude model you're using.

**Expected output:**
```
Current model: claude-sonnet-4-6

Available models:
  claude-opus-4-7        - Deepest reasoning (slowest, most expensive)
  claude-sonnet-4-6      - Best all-around (default)
  claude-haiku-4-5       - Fast, cheap, capable

Type /model <name> to switch.
```

Then:
```
/effort
```

**Expected output:**
```
Current effort level: high

Available levels:
  low     - Minimum reasoning, cheapest
  medium  - Moderate
  high    - Recommended default (Apex auto-sets this)
  xhigh   - Extra reasoning (burns tokens)
  max     - Maximum (very expensive, rarely needed)

Apex auto-lowers xhigh/max to high at session start.
```

---

## Command 6 — Try natural language (the fun one)

**Type:**
```
can you help me create a simple hello-world website?
```

**What it does:** Apex's three-layer routing kicks in. You did NOT type a slash command.

**Expected output:**
```
[CARL Layer 1] WEB-DEVELOPMENT + DEVELOPMENT rules loaded (9 rules)
[CAPABILITY-REGISTRY Layer 2] Skills: frontend-design, react-patterns, tailwind-patterns
[COMMAND-REGISTRY Layer 3] Intent matches /feature-dev

I'll build a simple hello-world website for you.

Creating index.html...
Creating styles.css...
Creating script.js...

Files created:
  index.html (34 lines)
  styles.css (41 lines)
  script.js (12 lines)

Open index.html in your browser to see it. Want me to add 
anything — a dark mode toggle, an animation, a form?
```

Notice: no slash command was typed. The system read "create a website" and activated the web stack automatically.

---

## Command 7 — Ask about your own code

Exit Claude Code (`/exit`), `cd` into any code project you have, then run `claude` again.

**Type:**
```
what does this project do?
```

**What it does:** Claude reads your `package.json`, `README.md`, and top-level source files and summarizes.

**Expected output:**
```
Let me explore your project.

Reading package.json...
Reading README.md...
Reading src/index.ts...

This is a Next.js 14 application called "my-webapp" that appears 
to be an e-commerce storefront. It uses:
- React 18 + TypeScript
- Next.js App Router
- Tailwind CSS for styling
- Stripe for payments (via @stripe/stripe-js)
- PostgreSQL via Prisma

Main entry point is app/page.tsx. Your checkout flow lives in 
app/checkout/. Payment webhooks are handled in app/api/webhook/route.ts.

Want me to dig into any specific part?
```

---

## Command 8 — Fix a bug

In any project with an obvious typo or broken function, **type:**
```
there's a bug in src/auth.ts where login always returns false. find and fix it.
```

**What it does:** Claude reads the file, finds the bug, fixes it, and runs your tests if they exist.

**Expected output:**
```
Reading src/auth.ts...

Found it. Line 42:
  return false; // should return result of validation
  
The function validates credentials correctly but always returns 
false at the end. Fixing now...

Editing src/auth.ts...
  Changed: return false;
  To:      return result;

Running tests...
  npm test
  PASS src/auth.test.ts
    ✓ login succeeds with valid credentials (12ms)
    ✓ login fails with invalid credentials (8ms)

Done. 2 tests pass.
```

---

## Command 9 — Try autopilot mode (OMC)

**Type:**
```
autopilot: add a dark mode toggle to this website
```

**What it does:** Triggers OMC's full 5-stage autonomous pipeline: research → plan → implement → review → verify. Multiple agents work in parallel.

**Expected output (abbreviated):**
```
AUTOPILOT: add a dark mode toggle to this website

Stage 1/5: RESEARCH
  Agent:analyst investigating best practices for dark mode in 
  React + Tailwind...
  ✓ Found: Tailwind v4 darkMode class strategy is current standard
  ✓ Decision: Use prefers-color-scheme media query + localStorage

Stage 2/5: PLAN
  Agent:planner creating implementation plan...
  ✓ Plan: 3 files to modify (tailwind.config, ThemeProvider, Toggle component)
  ✓ Estimate: 45 minutes

Stage 3/5: IMPLEMENT
  Agent:code-reviewer + tdd-guide working in parallel...
  ✓ Wrote 6 tests first (TDD)
  ✓ Created src/components/ThemeToggle.tsx (52 lines)
  ✓ Created src/context/ThemeContext.tsx (38 lines)
  ✓ Updated tailwind.config.js

Stage 4/5: REVIEW
  Agent:code-reviewer auditing output...
  ✓ Code quality: 94/100
  ✓ Accessibility: PASS (button has aria-label)
  ✓ No security issues

Stage 5/5: VERIFY
  ✓ Build: PASS (0 errors, 0 warnings)
  ✓ Tests: 6/6 pass
  ✓ Toggle visible and functional

Status: COMPLETE
Files changed: tailwind.config.js, src/components/ThemeToggle.tsx, 
  src/context/ThemeContext.tsx, src/app/layout.tsx
Ready to commit.
```

---

## Command 10 — End the session cleanly

**Type:**
```
/compact
```

**What it does:** Compresses your conversation history to save context for when you resume later.

**Expected output:**
```
Compacting conversation...
Original: 47,382 tokens
Compacted: 3,214 tokens (saved 44,168 tokens, 93% reduction)

PostCompact hook ran: recovery script reminded Claude to re-read 
CAPABILITY-REGISTRY.md.

Context is now cleaner. Continue with your work.
```

Then to exit cleanly:

```
/exit
```

**Expected output:**
```
[Stop hook fired]
  session-end-save.sh appended session-end timestamp to 
  memory/session-handoff.md
  task-complete-sound.sh played chime (60s cooldown respected)

Goodbye.
```

Your next session picks up from the handoff note.

---

## What NOT to do

- **Don't paste passwords, API keys, or credit cards into chat.** Put keys in `~/.claude/.env`. Passwords: never.
- **Don't skip `/healthcheck`.** If something feels broken, run it first — 90% of issues show up there.
- **Don't run `autopilot:` on unfamiliar code without a git backup.** Autopilot will make changes.
- **Don't set effort to `max` casually.** Max burns tokens. `high` is usually enough; `xhigh` only when you really need deep reasoning.

## Slash commands that save you time

| Command | What it does |
|---|---|
| `/healthcheck` | Verify all systems green |
| `/plan` | Start a structured plan before coding |
| `/feature-dev` | Full feature dev workflow |
| `/commit` | Smart git commit |
| `/review` | Code review with specialist agents |
| `/security-review` | Security audit |
| `/paul:plan` → `/paul:apply` → `/paul:unify` | Multi-phase execution |
| `/seed` | Brainstorm a new project from scratch |
| `/graphify` | Build a knowledge graph of your project |
| `/compact` | Compress conversation to save context |
| `/resume` | Pick up a past session |
| `/memory` | See what Claude remembers about you |

## Natural-language triggers (no slash needed)

These activate automatically — no slash command needed:

- "build me a ..."
- "fix the bug in ..."
- "review this code"
- "research this company"
- "create a pdf / pptx / docx"
- "where is the auth code?"
- "what did we do last session?"
- "deploy this to production"
- "optimize this for speed"
- "consolidate memory"

## Tips from power users

1. **`cd` into the right directory first.** If your project is in `~/my-webapp`, `cd` there before running `claude`. Claude sees the folder you started in.
2. **Edit your CLAUDE.md.** After install, open `~/.claude/CLAUDE.md` and add your preferences. Claude reads it every session.
3. **Edit your PRIMER.md.** Describe who you are, what projects you work on. Helps Claude tailor answers.
4. **Use `/memory` after big tasks.** Claude saves context for next session.
5. **When stuck, run `/healthcheck`.** 90% of problems surface there.

## What You Learned

- Slash commands start with `/` and do a specific action (`/healthcheck`, `/compact`).
- Natural language triggers the three-layer auto-routing — no slash command needed for most tasks.
- `autopilot:` runs the full 5-stage OMC pipeline with multiple agents in parallel.
- `/compact` saves 90%+ of your tokens by compressing conversation history.
- `/exit` runs the Stop hooks (session-handoff save, sound chime) before closing.

## Next Step

- **[04-WHAT-ARE-SKILLS.md](04-WHAT-ARE-SKILLS.md)** — Understand skills (the 1,276 recipes Claude reads on demand)
- **[05-WHAT-ARE-AGENTS.md](05-WHAT-ARE-AGENTS.md)** — Understand agents (the 108 specialists)

You're now officially using Apex. Welcome.

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
