# Contributing to Claude Apex

Claude Apex was created and is maintained by **Engineer Yousef Nabil** ([@YousefNabil-SOC](https://github.com/YousefNabil-SOC)).

Thank you for your interest in contributing! Whether it's a new agent, a CARL domain, a bug fix, or documentation improvement — PRs are appreciated.

## How to Contribute

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/my-new-agent`
3. **Make** your changes
4. **Test** your changes (run `/healthcheck` after installing)
5. **Commit** with a descriptive message: `git commit -m "feat: add kubernetes-deployer agent"`
6. **Push** to your fork: `git push origin feature/my-new-agent`
7. **Open** a Pull Request with a clear description

## What to Contribute

### New Agents
Place in `agents/`. Follow the frontmatter format:
```yaml
---
description: One-line description of what this agent does
model: sonnet  # haiku | sonnet | opus
---
```

### New CARL Domains
Add to `config/carl-domains.json`. Each domain needs:
- A unique name (UPPERCASE)
- Recall keywords (what triggers this domain)
- Rules (specific instructions for this context)

### New Slash Commands
Place in `commands/`. Follow the frontmatter format:
```yaml
---
name: command-name
description: What this command does
---
```

### Documentation
Place in `docs/`. Use clear headings, practical examples, and cross-references.

## Guidelines

- **No personal data** — use placeholders like `[YOUR_COMPANY]`
- **No API keys** — use `YOUR_API_KEY_HERE` for any credential
- **No hardcoded paths** — use `$HOME` or `~/.claude/`
- **Test before submitting** — verify your changes work
- **One concern per PR** — don't bundle unrelated changes
- **Follow existing patterns** — match the format of existing files

## Commit Message Format

```
<type>: <description>

Types: feat, fix, docs, refactor, test, chore
```

## Code of Conduct

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## Questions?

Open an issue on GitHub. We're happy to help!

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
