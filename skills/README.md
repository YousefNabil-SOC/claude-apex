# Custom Skills

Skills are specialized instruction sets that Claude Code loads on demand.

| Skill | Purpose |
|-------|---------|
| `dream-consolidation` | Memory consolidation 4-phase cycle (Orient → Gather → Consolidate → Prune) |
| `autoresearch` | Autonomous goal-directed iteration with measurable metrics |

## Skill Format

Each skill lives in its own directory with a `SKILL.md` file:

```
~/.claude/skills/
  my-skill/
    SKILL.md    # Frontmatter + instructions
```

### SKILL.md Frontmatter

```yaml
---
name: my-skill
description: What this skill does (shown in skill listings)
---

# Instructions for Claude Code when this skill is activated
```
