# gstack Integration (the 19 `gs-*` skills)

Claude Apex V8 adds 19 skills cherry-picked from [gstack](https://github.com/garrytan/gstack)
(MIT, Garry Tan) using a **cherry-pick + rename** pattern that lets external skill packs
coexist with this environment's routing without name collisions.

## Why rename to `gs-*`

gstack ships skills under generic names (`review`, `spec`, `investigate`, ...). Several
of those collide with commands/skills already in a rich Claude Code setup. Renaming each
to a `gs-` prefix (e.g. `review` -> `gs-review`) gives a collision-free namespace while
keeping the gstack methodology intact. The CARL domain `GSTACK-INTEGRATED` then routes
natural language to the right `gs-*` skill (19 rules, 117 trigger keywords).

## The integration pattern (reusable for any external skill pack)

1. Clone the upstream pack (read-only). Do not run its global `setup`.
2. Copy each chosen skill folder to `~/.claude/skills/<prefix>-<name>/`.
3. Rewrite only the frontmatter `name:` (to the prefixed slug) and `description:`
   (append `CARL TRIGGERS: <keywords>. SOURCE: <upstream>/<folder>`). Leave the body intact.
4. Fix cross-references between sibling skills to the prefixed slugs.
5. Add one routing domain to `carl.json` mapping trigger keywords -> the prefixed skills.
6. Smoke-test: confirm each skill routes from natural language and loads without parse errors.

## The 19 skills, by tier

**Tier A - high value, works standalone (pure-prompt):**
gs-review (PR review), gs-cso (OWASP+STRIDE security), gs-investigate (root-cause debug),
gs-spec (five-phase spec), gs-plan-design (rate a design plan 0-10), gs-office-hours
(product ideation), gs-plan-ceo (strategic review), gs-plan-eng (architecture lock).

**Tier B - useful, may overlap host tools:**
gs-retro (weekly retro), gs-careful (advisory destructive-command warnings),
gs-doc-release (post-ship doc sync), gs-doc-generate (Diataxis doc generation).

**Tier C - needs gstack upstream infra for full power:**
- gs-autoplan - runs CEO/design/eng review sequentially; full automation needs the
  gstack `bin/` toolchain. Without it, invoke gs-plan-ceo / gs-plan-design / gs-plan-eng directly.
- gs-canary, gs-benchmark - post-deploy monitoring and Core Web Vitals; need the gstack
  browse daemon (headless browser). Without it, use the playwright MCP or Lighthouse.
- gs-freeze / gs-guard / gs-unfreeze - advisory edit-lock modes (need bash for the hook scripts).
- gs-skillify - codifies a gstack browser/scrape flow specifically. For turning a generic
  workflow into a skill, prefer the `skill-creator` plugin.

## Getting full power

To unlock the Tier-C skills, also install gstack from its own repo
(https://github.com/garrytan/gstack) so the browse daemon and `bin/` toolchain exist.
Claude Apex ships the integration + routing; gstack ships the engine those skills drive.

## Natural-language triggers

You do not type slash commands. Just say what you want:
- "review the code in X and find bugs" -> gs-review
- "do a security audit on the booking API" -> gs-cso
- "investigate why the hydration warning shows up" -> gs-investigate
- "draft a spec for feature X" -> gs-spec
- "rate this design plan dimension by dimension" -> gs-plan-design
- "give me a weekly retro" -> gs-retro
- "do an engineering review on this plan" -> gs-plan-eng

See `config/carl-domains.json` (domain `GSTACK-INTEGRATED`) for the full keyword map.
