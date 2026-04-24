# What Is Claude Code?

> You finished [00-START-HERE.md](00-START-HERE.md). Now let's dig into what Claude Code actually is.

## The one-sentence version

**Claude Code is a command-line program that puts Claude (the AI) inside your terminal, where it can read your files, write new code, and run programs for you.**

## The useful mental model

**Claude Code is like having a senior developer sitting inside your terminal.**

Not a senior developer on Slack who you message and wait for a reply. A senior developer *in the terminal with you*. They can see your files. They can run your commands. They can try things, watch what happens, and fix what's wrong — all while you watch.

## Broken down, very slowly

### "Command-line program"

A command-line program is software you run by typing commands. Like `git`, `npm`, or `curl` if you've seen those. You type a word, press Enter, something happens.

### "Puts Claude inside your terminal"

Instead of opening a web browser and typing at claude.ai, you open a terminal on your computer, type `claude`, and Claude is now right there in a text window ready to chat.

### "Read your files"

When you tell Claude "fix the bug in login.tsx", it opens the file login.tsx on your computer, reads it, finds the bug, and fixes it. It does NOT guess what the file contains — it reads the real file.

### "Write new code"

When you say "create a landing page", it creates new files on your disk. Real files you can open in any editor afterwards.

### "Run programs for you"

It can run `npm install`, `git commit`, `python script.py`, anything you would type yourself. It sees the output and reacts to it — if a build fails, it reads the error and tries again.

## Key vocabulary — learn these 5

Before we go further, know these five words:

### Claude
The AI model made by Anthropic. Versions include **Opus** (smartest, slowest), **Sonnet** (balanced, default for most work), and **Haiku** (fastest, cheapest, great for simple tasks).

### Anthropic
The AI safety company that makes Claude. San Francisco-based. Founded 2021. https://anthropic.com

### Claude Code
The CLI program (that's what we're talking about). Install it with `npm install -g @anthropic-ai/claude-code`.

### Context window
The total amount of text Claude can consider at once. Think of it as Claude's short-term memory. When the context fills up, Claude starts forgetting. You type `/compact` to compress it and keep going.

### Tokens
The unit of text Claude measures. One token is about 4 characters of English. 1,000 tokens is about 750 words. Claude's context window holds 200,000 tokens (about 150,000 words, or a short novel). Every API call costs money per token.

Memorize these five. The rest of this doc series refers to them constantly.

## The big picture

```
┌─────────────────────────────────────────┐
│ Your Computer                           │
│                                         │
│  ┌────────────────────┐                 │
│  │ Terminal (bash,    │                 │
│  │ PowerShell, etc.)  │                 │
│  │                    │                 │
│  │  $ claude          │                 │
│  │                    │                 │
│  │  > "fix this bug"  │                 │
│  │                    │                 │
│  │  (Claude reads     │                 │
│  │   files, edits     │                 │
│  │   code, runs tests)│                 │
│  └─────────┬──────────┘                 │
│            │                            │
│            ▼                            │
│  Your project files get edited          │
└────────────┬────────────────────────────┘
             │ encrypted internet connection
             ▼
┌─────────────────────────────────────────┐
│ Anthropic's Servers                     │
│ (where Claude the AI "lives")           │
└─────────────────────────────────────────┘
```

Claude Code = the program on your computer.
Claude = the AI brain on Anthropic's servers that your local program talks to.

## What's the difference from chatting with Claude in a browser?

| claude.ai (browser) | Claude Code (terminal) |
|---|---|
| You paste code, Claude answers | Claude reads your files directly |
| Claude can't run anything | Claude runs commands, tests, builds |
| You copy Claude's code into your editor | Claude writes directly to disk |
| Good for: asking questions, brainstorming | Good for: actually building software |
| Free tier exists | Uses API credits (pay-as-you-go) |

## Why is this a big deal?

Before Claude Code, AI coding went like this:

1. You ask AI for help
2. AI gives you a code snippet
3. You copy-paste it into your editor
4. You run it, see an error
5. You copy-paste the error back to AI
6. Repeat forever

With Claude Code, the AI is **the one doing steps 3-5 for you**. You describe what you want; it handles the whole loop. That 30-second manual paste-run-paste cycle becomes a single continuous action on your behalf.

## Example — what it looks like

You type this in Claude Code:

```
node --version
```

You see this back (abbreviated):

```
Running: node --version
v20.11.0

You have Node.js v20.11.0 installed, which meets the Apex requirement (20+).
```

Claude ran `node --version` on your computer, saw `v20.11.0`, and told you. It did not guess. It did not imagine. It ran a real command.

## What you need to install

1. **Node.js** (version 20+) — Claude Code runs on Node
2. **Python 3.10+** — some hooks and skills use it
3. **Git** — for version control and for cloning this repo
4. **A terminal** — already on every computer

The next tutorial ([02-INSTALL-FROM-ZERO.md](02-INSTALL-FROM-ZERO.md)) walks through all of this step-by-step on Windows, Mac, and Linux.

## What about privacy?

When Claude Code sends your code to Anthropic's servers to think about, Anthropic does not train their models on it. Your code stays yours. Read their policy at https://www.anthropic.com/legal/commercial-terms for the full details.

If you work with sensitive data (medical, legal, classified), check with your employer before using any cloud AI tool.

## What does it cost?

- **Claude Code the program**: free
- **The AI responses** (Anthropic API): pay-as-you-go, typically $5-$20 per month for moderate use. There is a free tier.
- **Claude Apex** (this upgrade pack): free, MIT-licensed

Heavy autonomous tasks (like `autopilot:` building a full feature) cost more. Apex includes a budget-aware setup that defaults to `effortLevel: high` (not `max`, which burns tokens) to protect you.

## What You Learned

- Claude is the AI model. Claude Code is the CLI program. Anthropic is the company.
- Context window = Claude's short-term memory (200,000 tokens, about a short novel).
- Tokens are the unit Anthropic bills you by. One token ≈ 4 characters of English.
- Claude Code reads real files, runs real commands, and writes real code on your disk.
- Think of it like a senior developer sitting inside your terminal — they can see what you see and act on it.

## Next Step

Ready to install? Go to **[02-INSTALL-FROM-ZERO.md](02-INSTALL-FROM-ZERO.md)**.

If you hit an unfamiliar word, check **[09-GLOSSARY.md](09-GLOSSARY.md)**.

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
