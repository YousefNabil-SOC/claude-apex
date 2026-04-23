# What Are MCP Servers?

## The kid-friendly analogy

**MCP servers are like superpowers you plug into Claude.**

Imagine Claude is a kid with basic skills. MCP servers are toys you hand the kid:
- Here's a **web browser toy** — now Claude can click websites
- Here's a **GitHub toy** — now Claude can make pull requests
- Here's a **web search toy** — now Claude can look things up
- Here's a **component maker toy** — now Claude can design UI from words

Each MCP server = one new capability Claude can use whenever needed.

## What MCP actually stands for

**Model Context Protocol**. It's an open standard made by Anthropic. It defines how programs on your computer can expose tools to AI models in a safe, structured way.

Think of it like USB: before USB, every device had its own cable. After USB, every device uses the same cable and they all just work. MCP is USB for AI tools.

## MCP servers you get with Apex

Out of the box, Apex configures 4 MCP servers:

| Server | What it does | Needs API key? |
|---|---|---|
| **playwright** | Control a web browser, take screenshots, fill forms | No |
| **github** | Create PRs, comment on issues, manage repos | Yes (GitHub PAT) |
| **exa-web-search** | Semantic web search, deeper than Google | Yes (Exa key) |
| **@21st-dev/magic** | Generate React+TS+Tailwind components from words | Yes (21st.dev key) |

You can add more (optional, documented in config):
- **firecrawl** — website scraping
- **supabase** — database ops
- **context7** — live library documentation
- **sequential-thinking** — multi-step reasoning
- **claude-flow (RuFlo)** — 51 swarm agents
- **claude-peers** — inter-terminal communication

## A real example

You say: *"take a screenshot of google.com and save it"*

1. Claude recognizes this needs a browser
2. Claude calls the **playwright** MCP server
3. Playwright MCP opens a headless Chrome, navigates to google.com
4. Takes a screenshot
5. Returns the image path to Claude
6. Claude saves/displays it

You didn't install Chrome. You didn't write automation code. The MCP server handled all of that.

## How MCP servers run

An MCP server is a program that runs in the background when Claude Code needs it. Usually it's an `npx` command that downloads and runs the server the first time, then caches it.

You see this in `settings.json`:
```json
"playwright": {
  "command": "npx",
  "args": ["-y", "@playwright/mcp"]
}
```

Translation: "when I need playwright, run `npx -y @playwright/mcp`".

## API keys for MCP servers

Some MCP servers need credentials to talk to third-party services (GitHub, Exa, 21st.dev, fal.ai). You store these in `~/.claude/.env`:

```
GITHUB_PERSONAL_ACCESS_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx
EXA_API_KEY=your_key_here
TWENTY_FIRST_DEV_API_KEY=your_key_here
FAL_KEY=your_key_here
```

The `settings.json` references them as `${GITHUB_PERSONAL_ACCESS_TOKEN}`, so your real keys never sit in a file you might commit to git.

## Is it safe?

MCP servers have:
- **Scoped permissions**: they only access what you allow
- **Local execution**: they run on your computer, not Anthropic's
- **Open source**: you can read the code of any MCP server before using it
- **No access to the rest of your system**: each server has its own sandbox

Still, only install MCP servers you trust. Stick to official ones (from Anthropic, 21st.dev, major vendors).

## How MCP differs from skills and agents

| | Skills | Agents | MCP Servers |
|---|---|---|---|
| **What** | Knowledge | AI workers | External tools |
| **Who runs them** | Claude | Claude | Your computer |
| **Cost** | 0 extra | 1 agent = 1 context | 0 tokens (free to call) |
| **Analogy** | Recipe books | Specialist coworkers | Superpowers plugged in |
| **Example** | "how to make a PDF" | "go make the PDF" | "a PDF-making machine" |

## Can I make my own MCP server?

Yes. They're just programs that speak the MCP protocol. There are official SDKs in Python, TypeScript, and Rust.

Examples of custom MCP servers people have built:
- Read/write your Notion database
- Talk to your home automation
- Query your company's internal APIs
- Generate images via a local Stable Diffusion

See https://modelcontextprotocol.io for docs.

## Checking which MCP servers are running

In Claude Code, type:
```
/mcp
```

This shows a list of configured MCP servers and their status.

Or check your `~/.claude/settings.json` — the `mcpServers` section lists them all.

## What's next

- [07-WHAT-ARE-HOOKS.md](07-WHAT-ARE-HOOKS.md) — Hooks are automatic scripts that fire at specific moments (like session start, or when Claude finishes a task)
