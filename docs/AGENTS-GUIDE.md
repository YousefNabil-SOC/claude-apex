# Agents Guide: Working with 108 Specialist Agents

## Quick Start

Find the right agent for your task:

```bash
# List all agents
ls ~/.claude/agents/

# Auto-select agent for task
/paul:plan "Your task here"
# Pantheon suggests optimal agent(s)

# Manually trigger agent
agent:code-reviewer "Review my PR"
```

## 25 Core Agents (Public)

### Planning & Analysis
| Agent | Purpose | Trigger |
|-------|---------|---------|
| **planner** | Implementation planning | `agent:planner "Build feature X"` |
| **architect** | System design decisions | `agent:architect "Design database"` |
| **product-manager** | Feature scoping, roadmaps | `agent:product-manager "Roadmap Q2"` |
| **analyst** | Market/data analysis | `agent:analyst "Analyze competitor"` |

### Development
| Agent | Purpose | Trigger |
|-------|---------|---------|
| **code-reviewer** | Code quality assessment | `agent:code-reviewer "Review PR #123"` |
| **tdd-guide** | Test-driven development | `agent:tdd-guide "Write tests first"` |
| **refactor-cleaner** | Dead code, tech debt | `agent:refactor-cleaner "Clean up utils/"` |
| **backend-dev** | Server-side architecture | `agent:backend-dev "API design"` |
| **frontend-dev** | Client-side architecture | `agent:frontend-dev "Component system"` |

### Quality & Security
| Agent | Purpose | Trigger |
|-------|---------|---------|
| **security-reviewer** | Vulnerability assessment | `agent:security-reviewer "Audit auth"` |
| **performance-optimizer** | Speed & efficiency | `agent:performance-optimizer "Profile API"` |
| **accessibility-reviewer** | WCAG/a11y compliance | `agent:accessibility-reviewer "Check a11y"` |
| **build-error-resolver** | Compilation & CI/CD | `agent:build-error-resolver "Fix build"` |

### Documentation & Communication
| Agent | Purpose | Trigger |
|-------|---------|---------|
| **doc-updater** | Technical documentation | `agent:doc-updater "Update README"` |
| **technical-writer** | User-facing docs | `agent:technical-writer "Write guide"` |
| **content-creator** | Blog posts, marketing | `agent:content-creator "Blog post"` |

### Specialized
| Agent | Purpose | Trigger |
|-------|---------|---------|
| **devops-engineer** | Infrastructure, deployment | `agent:devops-engineer "Setup CI/CD"` |
| **database-admin** | SQL, migrations, indexing | `agent:database-admin "Optimize queries"` |
| **e2e-runner** | End-to-end testing | `agent:e2e-runner "Test user flow"` |
| **ml-engineer** | ML/AI pipelines | `agent:ml-engineer "Train model"` |
| **security-researcher** | OSINT, threat modeling | `agent:security-researcher "Threat model"` |

## Agent Anatomy (Frontmatter)

Every agent has this structure:

```yaml
---
name: code-reviewer
role: Code Quality Specialist
model: sonnet          # haiku/sonnet/opus
specialties:
  - Code review
  - Security scanning
  - Performance analysis
constraints:
  - Review 1 file per session
  - Flag blockers only
trigger_keywords:
  - review
  - audit
  - quality
---

# Code Reviewer

**Purpose**: Identify bugs, security issues, and code smells.

**When to use**:
- After writing code
- Before committing
- During PR reviews

**What it does**:
1. Scans for CRITICAL/HIGH issues
2. Flags security vulnerabilities
3. Suggests optimizations
4. Rates overall code health (0-100)

**Output**: Markdown report with issues, severity, fixes.
```

## Creating New Agents

### Step 1: Create agent file

```bash
touch ~/.claude/agents/my-agent.md
```

### Step 2: Add frontmatter + instructions

```yaml
---
name: my-agent
role: Your Agent Role
model: sonnet
specialties:
  - Thing 1
  - Thing 2
trigger_keywords:
  - keyword1
  - keyword2
---

# My Agent

**Purpose**: One sentence describing what this agent does.

**When to use**: Specific scenarios.

**Constraints**: 
- Limit 1
- Limit 2

**How it works**:
1. Step 1
2. Step 2
3. Step 3

**Output format**: What the user receives.

**Example invocation**:
\`\`\`
agent:my-agent "Your prompt"
\`\`\`
```

### Step 3: Register in AGENTS.md

Add to `~/.claude/AGENTS.md`:

```markdown
| my-agent | Your role | `agent:my-agent "task"` | Specialties |
```

### Step 4: Test

```bash
agent:my-agent "Test prompt"
```

## Auto-Selection vs Manual Triggering

### Auto-Selection (Recommended)
Pantheon picks the best agent:

```
/paul:plan "Refactor authentication"
# Pantheon suggests: architect + tdd-guide + security-reviewer
```

**Advantages**:
- Optimal agent(s) for task
- Saves thinking time
- Multi-agent collaboration

### Manual Triggering
You pick the agent:

```
agent:security-reviewer "Audit password hashing"
```

**Advantages**:
- Precise control
- Single-agent focus
- Faster feedback

## Agent Teams

Run multiple agents in parallel:

```bash
# Sequential (one after another)
agent:architect "Design schema"
agent:tdd-guide "Write tests for schema"

# Parallel (all at once)
team 3:agent-review \
  agent:code-reviewer \
  agent:security-reviewer \
  agent:performance-optimizer
```

## Model Assignment

Choose agent model based on task complexity:

```yaml
# Haiku (fast, cheap) — 90% of Sonnet capability
model: haiku
# Use for: code review, simple refactoring, documentation

# Sonnet (balanced) — best for most tasks
model: sonnet
# Use for: architecture, TDD, planning

# Opus (deep reasoning) — maximum capability
model: opus
# Use for: security analysis, ML engineering, complex design
```

## Agent Capabilities

### What ALL agents can do
- Read files & codebases
- Execute commands (bash)
- Access MCP servers
- Call 1,308+ skills
- Use extended thinking (31K tokens)

### Special capabilities
Some agents have extras:

| Agent | Special Powers |
|-------|---|
| security-reviewer | PII detection, vulnerability scanner |
| performance-optimizer | Profiler, benchmarking tools |
| ml-engineer | TensorFlow, scikit-learn, PyTorch |
| devops-engineer | Terraform, Kubernetes, Docker |
| database-admin | SQL query optimizer, index analyzer |

## Agent Output Formats

### Standard Report
```
## Issues Found: 3

### 🔴 CRITICAL (1)
- SQL injection vulnerability in user input validation
  File: api/auth.js:45
  Fix: Use parameterized queries

### 🟡 MEDIUM (2)
- Missing error handler in async function
  File: services/payment.js:82
  Fix: Add try-catch block

## Code Health: 72/100
- Security: 65/100
- Performance: 78/100
- Readability: 85/100
```

### Structured Data
```json
{
  "issues": [
    {
      "severity": "CRITICAL",
      "type": "security",
      "file": "api/auth.js",
      "line": 45,
      "description": "SQL injection vulnerability",
      "fix": "Use parameterized queries"
    }
  ],
  "health_score": 72
}
```

## Best Practices

### 1. Give Context
```
❌ agent:architect "Design database"
✅ agent:architect "Design database for [YOUR_PROJECT] — 
   100 users, read-heavy, needs real-time notifications"
```

### 2. Single Focus
```
❌ agent:code-reviewer "Review everything"
✅ agent:code-reviewer "Review /src/auth/ folder for security issues"
```

### 3. Sequence Dependent Tasks
```
❌ Run 5 agents in parallel on untested code
✅ tdd-guide → code-reviewer → security-reviewer (sequence)
```

### 4. Use Right Agent
```
❌ code-reviewer → backend-dev → security-reviewer
✅ architect → tdd-guide → security-reviewer (aligned with task)
```

## Troubleshooting

### Agent not responding
```bash
# Check agent status
agent:my-agent "Test"

# If timeout (>60s), check logs
cat ~/.claude/memory/agent-health.md
```

### Agent giving wrong advice
```
# Switch to different agent
agent:code-reviewer "Review this" → try agent:architect instead

# Or escalate to higher model
# Edit agent file, change model: sonnet → opus
```

### Too many agents activated
```bash
# Limit to top 3
/paul:plan "Task" --max-agents 3
```

## Agent Scheduling

Run agents on a schedule:

```bash
/schedule "Daily code review" "0 9 * * MON" \
  "agent:code-reviewer 'Review daily'"

/schedule "Weekly security audit" "0 10 * * FRI" \
  "agent:security-reviewer 'Weekly audit'"
```

---

**Next**: [ARCHITECTURE.md](./ARCHITECTURE.md) → See how agents fit in the 5-layer system
