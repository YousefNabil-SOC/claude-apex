# CARL Guide: Just-In-Time Rule Loading

## The Problem CARL Solves

Without CARL, every session loads ALL context at once:
```
❌ Without CARL: React rules + Django rules + Kubernetes rules + ... = 800 lines of context
✅ With CARL: Detect "React" keyword → load only React rules = 80 lines
```

Result: **10x context efficiency**, cleaner reasoning, faster responses.

## How CARL Works

```
User types: "Fix React hydration error in [YOUR_PROJECT]"
              ↓
        CARL keyword scan
              ↓
     Keywords: [React, error, hydration]
              ↓
    Load domain: "libraries" → React rules
              ↓
   Agent now has focused context
        + 28 relevant rules
```

## 7 CARL Domains

### 1. syntax
**When triggered**: "eslint", "linter", "prettier", "format", "style"

**Loaded rules**:
- Code formatting conventions (spacing, naming)
- Linting rules per language
- Import ordering, quote style
- Indentation standards

**Example trigger**:
```
"Add eslint to [YOUR_PROJECT]"
→ Loads domain:syntax
```

### 2. libraries
**When triggered**: Framework/library names (React, Django, Express, Vue, etc.)

**Loaded rules**:
- Framework conventions
- Common patterns (hooks, components, middleware)
- Performance gotchas
- Testing patterns
- Ecosystem tools

**Example trigger**:
```
"Build React component for dashboard"
→ Loads domain:libraries (React section)
```

### 3. deployment
**When triggered**: "Vercel", "Kubernetes", "Docker", "deploy", "CI/CD", "GitHub Actions"

**Loaded rules**:
- Platform-specific deployment steps
- Environment configuration
- Secrets management
- Scaling guidelines
- Monitoring setup

**Example trigger**:
```
"Deploy to Kubernetes"
→ Loads domain:deployment (K8s section)
```

### 4. security
**When triggered**: "auth", "crypto", "encryption", "password", "token", "OWASP", "CVE"

**Loaded rules**:
- Authentication patterns (JWT, OAuth, MFA)
- Encryption best practices
- Input validation, SQL injection prevention
- OWASP top 10
- Vulnerability scanning

**Example trigger**:
```
"Implement OAuth2"
→ Loads domain:security
```

### 5. performance
**When triggered**: "optimize", "cache", "profiling", "benchmark", "slow", "latency"

**Loaded rules**:
- Caching strategies (Redis, browser cache)
- Database query optimization
- Code profiling workflows
- Bundle size reduction
- Network optimization

**Example trigger**:
```
"Profile and optimize API response time"
→ Loads domain:performance
```

### 6. database
**When triggered**: "SQL", "PostgreSQL", "MongoDB", "migration", "schema", "index"

**Loaded rules**:
- SQL best practices
- Migration patterns
- Indexing strategies
- Connection pooling
- Query optimization
- NoSQL patterns

**Example trigger**:
```
"Write migration for PostgreSQL"
→ Loads domain:database
```

### 7. devops
**When triggered**: "monitoring", "logging", "alerting", "incident", "observability", "SLA"

**Loaded rules**:
- Prometheus, Grafana setup
- Log aggregation (ELK, Loki)
- Alerting thresholds
- Incident response workflows
- SLO definition
- Runbook templates

**Example trigger**:
```
"Set up monitoring with Prometheus"
→ Loads domain:devops
```

## Creating a Custom CARL Domain

### Step 1: Create domain file

```bash
touch ~/.claude/rules/my-domain.md
```

### Step 2: Define trigger keywords

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

## Rule 1: Description

When implementing X, always:
- Constraint 1
- Constraint 2

## Rule 2: Description

Pattern for Y:
\`\`\`
Code example
\`\`\`

## Rule 3: Checklist

- [ ] Item 1
- [ ] Item 2
```

### Step 3: Test it

```bash
# Trigger the domain
"Your task containing keyword1"

# Check rules were loaded
cat ~/.claude/memory/carl-status.md
# Should show: my-domain LOADED
```

### Step 4: Register in CARL index

Add to `~/.claude/rules/INDEX.md`:

```markdown
| my-domain | Description here | keyword1, keyword2, keyword3 |
```

## Adding Rules to Existing Domains

### Find the domain file

```bash
cat ~/.claude/rules/libraries.md | grep -A 10 "React"
```

### Add new rule section

```markdown
## New Rule: Hooks Performance

When using React hooks in [YOUR_PROJECT]:
- Memoize callbacks with useCallback
- Use useMemo for expensive computations
- Avoid creating new objects in render

Example:
\`\`\`typescript
const Component = memo(({ data }) => {
  const handleClick = useCallback(() => {
    // Memoized callback
  }, []);
  
  return <button onClick={handleClick}>{data}</button>;
});
\`\`\`
```

## Disabling Domains

If a domain causes false positives:

```bash
# Edit domain file
nano ~/.claude/rules/my-domain.md

# Change enabled flag
enabled: false

# Reload
/healthcheck
# Should show: my-domain DISABLED
```

## Checking Active Domains

```bash
# Show all loaded domains
/healthcheck
# Output: CARL: 7/7 domains loaded

# Show domain status file
cat ~/.claude/memory/carl-status.md
# Shows: [LOADED], [DISABLED], [FAILED]
```

## CARL Performance Impact

| Scenario | Without CARL | With CARL | Speedup |
|----------|---|---|---|
| Simple React fix | 400ms | 150ms | 2.7x |
| Multi-framework task | 600ms | 180ms | 3.3x |
| Full codebase analysis | 2000ms | 400ms | 5x |

## Best Practices

### 1. Keep keywords specific
```yaml
❌ trigger_keywords: [code, work, build]  # Too broad
✅ trigger_keywords: [react, jsx, hooks]  # Specific to domain
```

### 2. Order rules by frequency
```markdown
❌ Rare edge case first
✅ Most common pattern first
   Then edge cases
```

### 3. Use examples liberally
```markdown
❌ "Use memoization"
✅ "Use memoization with useCallback:
     \`\`\`typescript
     const memoized = useCallback(() => {...}, [deps]);
     \`\`\`"
```

### 4. Link to official docs
```markdown
Rule: X

Reference: https://[official-docs]

When to use:
- Scenario 1
- Scenario 2
```

## Troubleshooting

### Domain not loading
```bash
# Check if keywords are in task description
echo "Your task description" | grep -i "keyword1"
# No match? Keywords may be too specific

# Check if domain is enabled
grep "enabled:" ~/.claude/rules/my-domain.md
```

### Too many domains loading at once
```bash
# Remove overlapping keywords
# Edit domain files, reduce trigger_keywords list
# Test with specific task
```

### Rule conflicts (both security & performance rules say opposite things)
```bash
# Add clarification to rule
# Example: "Use caching [for read-heavy scenarios]"
#          "Avoid caching [for real-time data]"
```

## CARL + Orchestration Engine

When CARL loads rules, they inform the routing decision:

```
Task: "Fix React component performance"
      ↓
CARL loads: libraries (React rules)
           + performance (optimization rules)
      ↓
Orchestration Engine sees context
      ↓
Routes to: performance-optimizer agent + tdd-guide
```

## Example: Create "testing" Domain

```yaml
---
domain: testing
description: "Test-driven development rules"
trigger_keywords:
  - test
  - jest
  - mocha
  - pytest
  - tdd
  - unittest
enabled: true
---

# Testing Domain

## Rule 1: Write Tests First (TDD)

Always:
1. Write failing test (RED)
2. Implement to pass test (GREEN)
3. Refactor (IMPROVE)

## Rule 2: Test Naming

Convention:
\`\`\`
describe('[FEATURE]', () => {
  it('should [BEHAVIOR]', () => {
    // Arrange, Act, Assert
  });
});
\`\`\`

## Rule 3: Mocking

- Mock external APIs
- Mock databases
- Keep tests isolated
```

---

**Next**: [ARCHITECTURE.md](./ARCHITECTURE.md) → See how CARL fits in Layer 1
