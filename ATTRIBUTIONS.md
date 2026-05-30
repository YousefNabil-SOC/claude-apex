# Attributions and Third-Party Licenses

Claude Apex is an integration framework. It ships a small amount of original work
(the CARL routing engine + config, the three-layer routing system, the installers,
the docs) and orchestrates a number of excellent third-party projects. This file
credits them and records the licenses of any third-party content that is vendored
(copied) into this repository.

Claude Apex itself is MIT licensed, Copyright (c) 2026 Yousef Nabil (see LICENSE).

---

## Vendored third-party content

### gstack (the 19 `gs-*` skills under `skills/gs-*`)

The 19 skills named `gs-*` are renamed, lightly-adapted derivatives of skills from
**gstack** by Garry Tan. Only the frontmatter `name`/`description` was rewritten (to
coexist with this environment's routing) and a one-line integration note was added;
the gstack methodology body is preserved. Each `gs-*/SKILL.md` keeps a
`SOURCE: garrytan/gstack/<folder>` line in its description for traceability.

- Upstream: https://github.com/garrytan/gstack
- License: MIT

```
MIT License

Copyright (c) 2026 Garry Tan

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

Some `gs-*` skills (gs-autoplan, gs-canary, gs-benchmark, gs-skillify) reach full
power only when gstack's upstream binaries/toolchain are also installed. Install
gstack from the link above to unlock those. See docs/GSTACK-INTEGRATION.md.

---

## Integrated-by-reference (NOT vendored - installed from their own sources)

These power a full Claude Apex environment. The installer and docs point you to them;
their content is not copied into this repository, so you always get the upstream
version with its own license.

- get-shit-done (GSD) - phase-based planning/execution framework. Installed via npm.
- oh-my-claudecode (OMC) - Copyright Yeachan-Heo. https://github.com/Yeachan-Heo/oh-my-claudecode . Installed as a Claude Code plugin.
- PAUL and SEED - Copyright ChristopherKahler. Planning/scaffolding frameworks.
- Claude Peers - Copyright louislva. Inter-instance messaging MCP.
- Bun - runtime used by some upstream tooling. MIT.
- Claude Code plugins (context7, pr-review-toolkit, commit-commands, feature-dev,
  ralph-loop, claude-md-management, frontend-design, prompt-improver, etc.) - installed
  from their official marketplaces, each under its own license.
- MCP servers (playwright, github, exa-web-search, @21st-dev/magic) - installed from
  their own npm packages, each under its own license.

If you are an author of any project listed here and want a change to this attribution,
please open an issue.
