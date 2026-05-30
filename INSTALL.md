# Installing Claude Apex

Claude Apex is a framework + smart installer. It installs the Apex layer (CARL routing engine,
config templates, 26 agents, slash commands, hooks, the 19 gstack-integrated gs-* skills, docs)
and then points you at the upstream powerhouses (gstack, GSD, OMC, plugins, MCP servers) so you
end up with the same environment the maintainer runs - with current upstream versions and correct
attribution. No third-party content beyond the 19 gs-* skills is vendored.

New to Claude Code with zero terminal experience? Start at `docs/00-START-HERE.md` instead.

## Prerequisites
- Claude Code (the CLI) installed and working
- Node.js 18+ (24.x recommended) and npm
- Python 3.10+ (3.14 recommended) - powers the CARL hook
- git and the GitHub CLI (`gh`) if you will push to repos
- Optional: Bun (for some upstream tooling), Windows users: enable Developer Mode for symlinks

The installer CHECKS prerequisites and reports what is missing; it does NOT auto-install them.

## Base install

Windows PowerShell:
```powershell
irm https://raw.githubusercontent.com/YousefNabil-SOC/claude-apex/master/install.ps1 | iex
```

macOS / Linux:
```bash
curl -fsSL https://raw.githubusercontent.com/YousefNabil-SOC/claude-apex/master/install.sh | bash
```

Interactive (all platforms):
```bash
git clone https://github.com/YousefNabil-SOC/claude-apex.git
cd claude-apex
bash install-interactive.sh
```

Prefer to read before running? Clone first, open `install.sh` / `install.ps1`, then run it.

## What the base install does
1. Backs up your existing `~/.claude/` (timestamped) - non-destructive, never overwrites existing files.
2. Installs agents, commands, hooks, and ALL vendored skills (globs `skills/`, so the 19 gs-* are included).
3. Writes `~/.carl/carl.json` from `config/carl-domains.json` (10 domains, 59 rules incl. GSTACK-INTEGRATED) if absent.
4. Writes `CLAUDE.md`, `PRIMER.md`, `settings.json`, `.env` from templates ONLY if they do not already exist.
5. Prints the next steps to unlock full power, then runs `verify.sh`.

After it finishes: edit `~/.claude/.env` with your own API keys (FAL_KEY, GITHUB_PERSONAL_ACCESS_TOKEN,
EXA_API_KEY, TWENTY_FIRST_DEV_API_KEY, etc.), then restart Claude Code.

## Unlock full power (run inside Claude Code after the base install)
```
/plugin marketplace add https://github.com/anthropic-community/everything-claude-code
/plugin install everything-claude-code
/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
/plugin install oh-my-claudecode
/oh-my-claudecode:omc-setup
```
Optional upstreams the gs-* skills build on:
- gstack (browse daemon + bin toolchain that gs-autoplan / gs-canary / gs-benchmark use at full power):
  `git clone https://github.com/garrytan/gstack` and follow its README.
- get-shit-done (phase-based planning agents): `npm i -g get-shit-done-cc`

## Verify
```bash
cd claude-apex && bash verify.sh
```
Or inside Claude Code: `/healthcheck`. Expect the CARL line to read 10 domains / 59 rules and the
GSTACK-INTEGRATED domain present.

## Update later
Re-clone or `git pull` this repo and re-run the installer; it skips files you already have. For
upstreams, use their own update path (`/plugin` re-install, `git pull` in the gstack clone, etc.).

## Uninstall
```bash
cd claude-apex && bash uninstall.sh
```
Restores the pre-install backup. See `docs/UNINSTALL.md`.

## Troubleshooting
Common issues (Windows symlinks needing Developer Mode, Node/Python version mismatches, gh missing
`workflow` scope, carl-hook needing `python3` on PATH) are covered in `docs/TROUBLESHOOTING.md` and
`docs/10-TROUBLESHOOT-FOR-BEGINNERS.md`.
