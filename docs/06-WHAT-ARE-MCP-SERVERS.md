# What Are MCP Servers?

## The kid-friendly analogy

**MCP servers are like superpowers you plug into Claude.**

Imagine Claude is a kid with basic skills. MCP servers are toys you hand the kid:
- Here's a **web browser toy** → now Claude can click websites
- Here's a **GitHub toy** → now Claude can make pull requests
- Here's a **web search toy** → now Claude can look things up
- Here's a **component maker toy** → now Claude can design UI from words

Each MCP server = one new capability Claude can use on demand.

## What MCP actually stands for

**Model Context Protocol**. An open standard made by Anthropic. It defines how programs on your computer expose tools to AI models in a safe, structured way.

Think of it like USB. Before USB, every device had its own cable. After USB, every device uses one cable and they all just work. MCP is USB for AI tools.

## The 4 default MCP servers Apex configures

Out of the box after running `install.sh`, your `settings.json` has 4 MCP servers configured:

### 1. `playwright`
**What it enables:** Browser automation — open pages, click, fill forms, take screenshots, scrape.
**Needs API key:** No.
**Example use case:**
> take a screenshot of google.com and save it

What happens: Claude calls the playwright MCP, which spawns a headless Chrome, navigates to google.com, takes a screenshot, and returns the file path.

### 2. `github`
**What it enables:** GitHub operations — create PRs, comment on issues, search code, manage releases.
**Needs API key:** Yes — `GITHUB_PERSONAL_ACCESS_TOKEN` in `~/.claude/.env`.
**Example use case:**
> create a pull request for the changes on this branch

What happens: Claude calls the github MCP, drafts a PR title/body, runs `gh pr create` with structured metadata.

### 3. `exa-web-search`
**What it enables:** Semantic web search. Deeper than Google — uses embeddings to find conceptually related pages.
**Needs API key:** Yes — `EXA_API_KEY` in `~/.claude/.env`.
**Example use case:**
> research competitors of acme-corp in the CRM space

What happens: Claude calls the exa-web-search MCP with semantic queries, gets ranked results with excerpts, and synthesizes a research report.

### 4. `@21st-dev/magic`
**What it enables:** Generate premium React+TS+Tailwind components from natural language.
**Needs API key:** Yes — `TWENTY_FIRST_DEV_API_KEY` in `~/.claude/.env`.
**Example use case:**
> generate a pricing table component with 3 tiers and a "most popular" highlight

What happens: Claude calls the @21st-dev/magic MCP with the description. The MCP returns production-ready TSX code that you can drop into your project.

## How to add more MCP servers

Apex's `settings.json` has a `mcpServers` section. Add entries like:

```json
"firecrawl": {
  "command": "npx",
  "args": ["-y", "firecrawl-mcp"],
  "env": { "FIRECRAWL_API_KEY": "${FIRECRAWL_API_KEY}" },
  "description": "Website scraping"
}
```

After editing, restart Claude Code.

### Common additions

| MCP Server | What it does | When to add |
|---|---|---|
| `firecrawl` | Website scraping | Scraping dynamic sites beyond playwright's reach |
| `supabase` | Supabase database ops | Supabase-backed projects |
| `context7` | Live library docs | Looking up React/Next/etc. docs at current version |
| `sequential-thinking` | Multi-step reasoning | Complex chains where you want visible thought |
| `claude-flow (RuFlo)` | 51 swarm agents | Parallel work at 10+ task scale |
| `claude-peers` | Inter-terminal comms | Multiple Claude Code windows coordinating |
| `memory` | Persistent key-value store | Long-term note storage beyond files |

Template for adding an MCP is in `config/settings-template.json`.

## A real example — playwright

You say: *"take a screenshot of github.com/YousefNabil-SOC/claude-apex and save it to /tmp/apex.png"*

1. Claude recognizes this needs a browser.
2. Claude calls the **playwright** MCP server.
3. playwright MCP opens a headless Chrome.
4. Navigates to github.com/YousefNabil-SOC/claude-apex.
5. Takes a screenshot.
6. Saves to /tmp/apex.png.
7. Returns the file path to Claude.
8. Claude confirms to you.

**Expected output:**
```
Running playwright MCP: screenshot

Navigating to https://github.com/YousefNabil-SOC/claude-apex...
Waiting for page load...
Taking screenshot at 1920x1080...
Saved to /tmp/apex.png (248 KB)

Done.
```

You didn't install Chrome. You didn't write Selenium code. MCP handled everything.

## How MCP servers run

An MCP server is a program that runs in the background when Claude Code needs it. Usually an `npx` command that downloads and runs the server the first time, then caches it.

You see this in `settings.json`:
```json
"playwright": {
  "command": "npx",
  "args": ["-y", "@playwright/mcp"]
}
```

Translation: "when I need playwright, run `npx -y @playwright/mcp`".

## API keys for MCP servers

Some MCP servers need credentials. Store them in `~/.claude/.env`:

```
GITHUB_PERSONAL_ACCESS_TOKEN=ghp_your_token_here
EXA_API_KEY=your_exa_key_here
TWENTY_FIRST_DEV_API_KEY=your_21st_dev_key_here
FAL_KEY=your_fal_key_here
```

The `settings.json` references them as `${GITHUB_PERSONAL_ACCESS_TOKEN}` — so your real keys never sit in a file you might accidentally commit to git.

## Is it safe?

MCP servers have:
- **Scoped permissions**: they only access what you allow
- **Local execution**: they run on your computer, not Anthropic's
- **Open source**: you can read the source of any MCP server
- **No cross-access**: each server is sandboxed

Still, only install MCP servers you trust. Stick to official ones (Anthropic, 21st.dev, major vendors).

## How MCP differs from skills and agents

|  | Skills | Agents | MCP Servers |
|---|---|---|---|
| **What** | Knowledge | AI workers | External tools |
| **Who runs them** | Claude | Claude | Your computer |
| **Cost** | 0 extra tokens | 1 agent = 1 context | 0 tokens (free to call) |
| **Analogy** | Recipe books | Specialist coworkers | Superpowers plugged in |
| **Example** | "how to make a PDF" | "go make the PDF" | "a PDF-making machine" |

## Can I make my own MCP server?

Yes. They're just programs that speak the MCP protocol. Official SDKs exist in Python, TypeScript, and Rust.

Examples of custom MCP servers people have built:
- Read/write a Notion database
- Talk to home automation
- Query a company's internal API
- Generate images via a local Stable Diffusion

See https://modelcontextprotocol.io for the full spec and SDK docs.

## Checking which MCP servers are running

In Claude Code:

```
/mcp
```

**Expected output:**
```
Configured MCP servers:
  ✓ playwright          @playwright/mcp (cached)
  ✓ github              @modelcontextprotocol/server-github (connected)
  ✓ exa-web-search      exa-mcp-server (connected)
  ✓ @21st-dev/magic     @21st-dev/magic (connected)

4 servers active.
```

If you see a red X next to one, its API key is missing or the service is down.

## What You Learned

- MCP = Model Context Protocol, an open standard for AI tool integration.
- Apex configures 4 MCP servers by default: playwright, github, exa-web-search, @21st-dev/magic.
- MCP servers calls are free (0 tokens) — the model only pays for the data it sees back.
- API keys go in `~/.claude/.env`, referenced as `${VAR_NAME}` in `settings.json`.
- You can add more MCP servers by editing `settings.json` and restarting Claude Code.

## Next Step

- **[07-WHAT-ARE-HOOKS.md](07-WHAT-ARE-HOOKS.md)** — Hooks fire automatically at specific moments (session start, post-compact, etc.)

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
