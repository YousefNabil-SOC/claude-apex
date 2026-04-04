# Customization: Make Apex Yours

## Adding Custom Agents

### Step 1: Create Agent File

```bash
touch ~/.claude/agents/my-specialist.md
```

### Step 2: Write Agent Definition

```yaml
---
name: my-specialist
role: Your Specialist Role
model: sonnet
specialties:
  - Specialty 1
  - Specialty 2
  - Specialty 3
trigger_keywords:
  - keyword1
  - keyword2
enabled: true
---

# My Specialist Agent

**Purpose**: One sentence describing what this agent does.

**When to use**:
- Scenario 1
- Scenario 2

**Constraints**:
- Constraint 1 (time, scope, etc.)
- Constraint 2

**How it works**:
1. Step 1 of process
2. Step 2 of process
3. Step 3 of process

**Output format**: 
Structured report with sections: Issues, Recommendations, Score

**Example**:
\`\`\`
agent:my-specialist "Your task description"
\`\`\`

**Related agents**:
- agent:other-agent (complementary)
```

### Step 3: Register Agent

Add to `~/.claude/AGENTS.md`:

```markdown
| my-specialist | Your specialist role | `agent:my-specialist "task"` | Specialty 1, Specialty 2 |
```

### Step 4: Test

```bash
agent:my-specialist "Test prompt"
# Should execute and return structured output
```

## Adding CARL Domains

### Step 1: Create Domain File

```bash
touch ~/.claude/rules/my-domain.md
```

### Step 2: Define Rules

```yaml
---
domain: my-domain
description: "Rules for my custom domain"
trigger_keywords:
  - keyword1
  - keyword2
  - keyword3
enabled: true
---

# My Custom Domain

## Rule 1: Basic Pattern

When doing X:
- Always do A
- Never do B
- Consider C

Example:
\`\`\`
Code snippet here
\`\`\`

## Rule 2: Advanced Pattern

For complex scenarios:
- Follow pattern X
- Then verify Y
- Document Z

Checklist:
- [ ] Item 1
- [ ] Item 2
- [ ] Item 3
```

### Step 3: Register Domain

Add to `~/.claude/rules/INDEX.md`:

```markdown
| my-domain | Description | keyword1, keyword2, keyword3 |
```

### Step 4: Test

```bash
# Your task should trigger the domain
"Task description containing keyword1"

# Verify in health check
/healthcheck
# Should show: my-domain LOADED
```

## Customizing Orchestration Rules

### View Current Rules

```bash
cat ~/.claude/config/orchestration.yaml
```

### Modify via Command

```bash
# Increase min_phases for PAUL (be stricter)
/update-config orchestration.routes.PAUL.min_phases 4

# Decrease max_duration for DIRECT (keep it simple)
/update-config orchestration.routes.DIRECT.max_duration 180

# Add custom routing rule
/update-config orchestration.custom_rules \
  "if contains('database') then PAUL" true
```

### Edit Configuration File

```bash
nano ~/.claude/config/orchestration.yaml

# Example changes:
# Increase team mode max workers
max_workers: 20

# Add keywords that trigger autoresearch
autoresearch_keywords: [optimize, slow, debug, bottleneck, analyze]

# Add keywords that trigger ralph
ralph_keywords: [flaky, race, intermittent, timeout]
```

## Creating Task Templates

### Step 1: Create Template

```bash
mkdir -p ~/.claude/templates
touch ~/.claude/templates/my-feature-template.md
```

### Step 2: Define Template

```markdown
# Feature Template: My Feature

## Required Information
- Feature name: ___________
- Target users: ___________
- Success metric: ___________

## Recommended Workflow
1. Start with: `/deep-interview "Feature description"`
2. Then: `/paul:plan`
3. Then: `/paul:apply`
4. Finish with: `/paul:unify`

## Agents Involved
- planner — Creates detailed plan
- tdd-guide — Writes tests first
- code-reviewer — Quality check
- security-reviewer — Security audit

## Checklist
- [ ] Requirements clarified
- [ ] Plan created
- [ ] Tests written
- [ ] Code implemented
- [ ] Reviewed
- [ ] Tests passing
- [ ] Documentation updated
- [ ] Deployed

## Time Estimate: ___ hours
## Actual Time: ___ hours
```

### Step 3: Use Template

```bash
/paul:init --template my-feature-template
# Loads template, prompts for values
```

## Customizing Memory Settings

### View Memory Config

```bash
grep -A 10 "memory:" ~/.claude/settings.json
```

### Adjust Limits

```bash
# Increase MEMORY.md line limit (default: 150)
/update-config memory.memoryLimit 250

# Change Dream auto-trigger (manual/interval/session-end)
/update-config memory.dreamTrigger "interval"

# Set consolidation interval (hours)
/update-config memory.consolidationInterval 24
```

## Creating Skill Shortcuts

### Add Skill Alias

```bash
# Add to ~/.claude/shortcuts.json
{
  "shortcuts": {
    "myskill": "agent:my-specialist",
    "qc": "agent:code-reviewer",
    "go": "team 3:executor"
  }
}
```

### Use Shortcut

```bash
myskill "Task description"
# Equivalent to: agent:my-specialist "Task description"
```

## Customizing Model Selection

### Force Specific Model for Task Type

```bash
# Edit ~/.claude/config/model-routing.yaml

overrides:
  security:
    model: opus  # Always use Opus for security
  
  frontend:
    model: sonnet  # Use Sonnet for frontend work
  
  simple-fixes:
    model: haiku  # Use Haiku for quick fixes
```

### Test Model Routing

```bash
# Check what model would be selected
/paul:plan "Your task" --explain-model

# Output:
# Model routing decision:
#   Task complexity: Medium
#   Suggested model: Sonnet
#   Reason: Balanced capability, good for design work
```

## Adding Project-Specific Rules

### Project-Level CLAUDE.md

Create `.claude/projects/[YOUR_PROJECT]/CLAUDE.md`:

```markdown
# [YOUR_PROJECT] — Custom Configuration

## Project Context
- Tech stack: React 19 + TypeScript + Node.js
- Team size: 3 people
- Deployment target: Vercel

## Custom Rules

### CARL Domains (Project-Specific)
Enable additional domains:
- project-specific-domain (loaded for [YOUR_PROJECT] only)

### Agents (Project-Specific)
Use these agents by default:
- agent:project-architect
- agent:project-tdd-guide
- agent:project-security-reviewer

### Orchestration (Project-Specific)
- Default route: PAUL (we like structure)
- Team mode: Use team 3:executor (always 3 workers)
- Never use: autoresearch (we plan before acting)

### Memory (Project-Specific)
- SESSION-MEMORY.md location: docs/DEV-SESSION.md
- Consolidation frequency: Daily
- Archive old sessions: After 2 weeks

## Project Checklist

Before every commit:
- [ ] Tests pass locally
- [ ] Code passes linting
- [ ] Security review done
- [ ] Performance check done

Before every PR:
- [ ] Deployment tested
- [ ] Docs updated
- [ ] Related issues linked
```

### Load Project Configuration

```bash
/switch-project [YOUR_PROJECT]
# Loads project CLAUDE.md
# Applies custom rules, agents, memory settings
```

## Keyboard Shortcuts

### Customize Keybindings

```bash
# View current bindings
keybindings-help

# Edit keybindings.json
nano ~/.claude/keybindings.json

# Example customizations:
{
  "bindings": {
    "ctrl+shift+a": "autopilot:",
    "ctrl+shift+p": "/paul:plan",
    "ctrl+shift+r": "ralph:",
    "ctrl+shift+t": "team 3:executor",
    "alt+m": "consolidate memory"
  }
}
```

## Git Integration

### Custom Git Hooks

Create `~/.claude/hooks/custom-pre-commit.sh`:

```bash
#!/bin/bash
# Run before every commit

# Run tests
npm test
if [ $? -ne 0 ]; then
  echo "Tests failed. Commit aborted."
  exit 1
fi

# Run linter
npm run lint
if [ $? -ne 0 ]; then
  echo "Linting failed. Commit aborted."
  exit 1
fi

# Update MEMORY.md
consolidate memory --auto

echo "Pre-commit checks passed"
```

### Enable Hook

```bash
chmod +x ~/.claude/hooks/custom-pre-commit.sh

# Add to git config
git config core.hooksPath ~/.claude/hooks
```

## Notification Customization

### Configure Notifications

```bash
/omc-setup
# Select: Configure notifications
# Choose: When to notify
#   - On completion (default)
#   - On errors only
#   - On phase completion (if PAUL)
#   - Disable

# Select: How to notify
#   - Terminal bell (default)
#   - Desktop notification
#   - Slack integration
#   - Email
```

## Integration with External Tools

### Slack Notifications

```bash
# Add Slack webhook
/update-config integrations.slack.webhook_url "https://hooks.slack.com/..."

# Now Apex posts to Slack on:
# - Task completion
# - Errors
# - Phase completion (PAUL)
# - PR created (OMC)
```

### GitHub Integration

```bash
# Already integrated via gh CLI
# Customize PR titles/bodies

/update-config github.pr_template "feat: [DESCRIPTION]"
/update-config github.pr_auto_assign "true"
/update-config github.pr_auto_link_issues "true"
```

## Performance Tuning

### Token Efficiency

```bash
# Reduce context (aggressive)
/update-config context.window_safety_margin 25  # default 20
/update-config context.max_thinking_tokens 5000  # default 10000

# Increase thinking budget (more reasoning)
/update-config context.max_thinking_tokens 20000

# Enable aggressive caching
/update-config performance.cache_aggressively true
```

### Model Selection Optimization

```bash
# Prefer cheaper models
/update-config orchestration.prefer_cost true
# Routes more tasks to Haiku

# Prefer faster execution
/update-config orchestration.prefer_speed true
# Routes more tasks to Haiku/Sonnet
```

## Debugging Custom Configuration

### Validate Configuration

```bash
# Check all config files
/healthcheck

# Shows:
# ✓ settings.json: Valid
# ✓ orchestration.yaml: Valid
# ✓ model-routing.yaml: Valid
# ✗ keybindings.json: FAILED (duplicate key "ctrl+s")
```

### Trace Configuration Loading

```bash
# Show which configs loaded
/config:list --trace

# Output:
# Loading: ~/.claude/settings.json
# Loading: ~/.claude/projects/[YOUR_PROJECT]/CLAUDE.md
# Loading: ~/.claude/rules/INDEX.md
# Loading: ~/.claude/agents/AGENTS.md
# ...
```

## Examples: Complete Customization

### Example 1: Setup for Data Science Work

```bash
# Create data-science agent
cat > ~/.claude/agents/data-scientist.md << 'EOF'
---
name: data-scientist
role: Data Science Specialist
model: opus
specialties:
  - ML model development
  - Data analysis
  - Performance optimization
trigger_keywords:
  - ml
  - model
  - data
  - numpy
  - pandas
---

# Data Science Agent
[Full definition here]
EOF

# Create data-science CARL domain
cat > ~/.claude/rules/data-science.md << 'EOF'
---
domain: data-science
trigger_keywords: [ml, model, training, inference, data]
---

# Data Science Rules
[Rules for ML work here]
EOF

# Register both
echo "| data-scientist | ML specialist | agent:data-scientist | ML, data analysis |" >> ~/.claude/AGENTS.md
echo "| data-science | ML development rules | ml, model, training |" >> ~/.claude/rules/INDEX.md
```

### Example 2: Setup for Frontend Team

```bash
# Edit project CLAUDE.md for frontend focus
cat > ~/.claude/projects/[YOUR_PROJECT]/CLAUDE.md << 'EOF'
# Frontend Project Configuration

## Default Agents
- agent:frontend-dev (not backend-dev)
- agent:accessibility-reviewer (important)
- agent:performance-optimizer (UI performance)

## Orchestration
- Always use team mode (multiple developers)
- PAUL for component library work
- Direct for quick CSS fixes

## Memory
- Track component patterns in lessons.md
- Archive old PRs weekly
EOF
```

---

**Next**: [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) → Common issues and solutions
