# What Is Claude Code?

> You finished [00-START-HERE.md](00-START-HERE.md). Now let's go deeper on what Claude Code actually is.

## The one-sentence version

**Claude Code is a command-line program that puts Claude (the AI) inside your terminal, where it can read your files, write new code, and run programs for you.**

## Broken down, very slowly

### "Command-line program"

A command-line program is software you run by typing commands. Like `git`, `npm`, or `curl` if you've seen those. You type a word, press Enter, and something happens.

### "Puts Claude inside your terminal"

Instead of opening a web browser and typing at claude.ai, you open a terminal on your computer, type `claude`, and now Claude is right there in a text window, ready to chat.

### "Read your files"

When you tell Claude "fix the bug in login.tsx", it actually opens the file login.tsx on your computer, reads it, finds the bug, and fixes it. It does NOT guess — it reads the real file.

### "Write new code"

When you say "create a landing page", it creates new files on your disk. Real files you can open in any editor afterwards.

### "Run programs for you"

It can run `npm install`, `git commit`, `python script.py`, anything you would type yourself. It sees the output and reacts to it.

## The big picture

```
┌───────────────────────────────────────┐
│ Your Computer                         │
│                                       │
│  ┌────────────────────┐               │
│  │ Terminal (bash,    │               │
│  │ PowerShell, etc.)  │               │
│  │                    │               │
│  │  $ claude          │               │
│  │                    │               │
│  │  > "fix this bug"  │               │
│  │                    │               │
│  │  (Claude reads     │               │
│  │   files, edits     │               │
│  │   code, runs tests)│               │
│  └─────────┬──────────┘               │
│            │                          │
│            ▼                          │
│  Your project files get edited        │
└───────────────────────────────────────┘
            │
            ▼  (encrypted internet connection)
┌───────────────────────────────────────┐
│ Anthropic's Servers                   │
│ (where Claude the AI "lives")         │
└───────────────────────────────────────┘
```

Claude Code = the program on your computer.
Claude = the AI brain on Anthropic's servers that your local program talks to.

## What's the difference from chatting with Claude in a browser?

| claude.ai (browser) | Claude Code (terminal) |
|---|---|
| You paste code, Claude answers | Claude reads your files directly |
| Claude can't run anything | Claude runs commands, tests, builds |
| You copy Claude's code into your editor | Claude writes directly to your disk |
| Good for: asking questions, brainstorming | Good for: actually building software |
| Free tier exists | Uses API credits (pay as you go) |

## Why is this a big deal?

Before Claude Code, AI coding went like this:
1. You ask AI for help
2. AI gives you a code snippet
3. You copy-paste it
4. You run it, see an error
5. You copy-paste the error back to AI
6. Repeat

With Claude Code, the AI is **the one doing steps 3-5 for you**. You describe what you want, it handles the whole loop.

## What you need to install

1. **Node.js** (version 18+) — Claude Code is built on this
2. **Python 3.10+** — some hooks and skills use it
3. **Git** — for version control
4. **A terminal** — already on every computer

The next tutorial ([02-INSTALL-FROM-ZERO.md](02-INSTALL-FROM-ZERO.md)) walks through all of this step-by-step.

## What about privacy?

When Claude Code sends your code to Anthropic's servers to think about, Anthropic promises not to train their models on it. Your code stays yours. Read Anthropic's policy if you want the full details.

If you work with sensitive data (medical, legal, classified), talk to your company before using any cloud AI.

## What does it cost?

- **Claude Code the program**: free (MIT license-equivalent)
- **The AI responses** (Anthropic API): pay-as-you-go, typically $5-$20/month for moderate use. There's a free tier to try.
- **Claude Apex** (this upgrade pack): free (MIT)

You can burn more if you run big autonomous tasks. Apex includes budget-aware settings to prevent that.

## Key concepts to remember

- Claude Code is the program; Claude is the AI
- It lives in a terminal, not a browser
- It edits files on your real disk
- It costs API credits per message (usually cheap)
- Apex upgrades it; without Apex, you have a basic version

## Ready?

When you're ready to install, go to **[02-INSTALL-FROM-ZERO.md](02-INSTALL-FROM-ZERO.md)**.

If you have questions about any word you saw here, check **[09-GLOSSARY.md](09-GLOSSARY.md)**.
