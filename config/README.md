# Configuration Templates

These files are templates for configuring Claude Apex. The installer places them in the correct locations.

| File | Installs To | Purpose |
|------|-------------|---------|
| `carl-domains.json` | `~/.carl/carl.json` | CARL JIT rule domains (7 domains, 33 rules) |
| `orchestration-engine.md` | `~/.claude/ORCHESTRATION-ENGINE.md` | Decision framework for request routing |
| `capability-registry.md` | `~/.claude/CAPABILITY-REGISTRY.md` | Tool routing table |
| `claude-md-template.md` | `~/.claude/CLAUDE.md` (if none exists) | Main instruction file template |
| `primer-template.md` | User fills in manually | Identity and preferences template |
| `settings-template.json` | Reference only (not auto-installed) | Full settings.json structure with placeholder keys |

## Customization

After installation, edit these files to match your environment:

1. **CARL domains**: Add new domains or modify recall keywords in `~/.carl/carl.json`
2. **Orchestration**: Adjust routing rules in `~/.claude/ORCHESTRATION-ENGINE.md`
3. **CLAUDE.md**: Fill in your project details, brand colors, team info
4. **Primer**: Create `~/.claude/PRIMER.md` from the template with your identity
