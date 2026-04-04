# Custom Specialist Agents

Specialist agents in Claude Code are autonomous AI agents that focus on specific tasks and domains. Each agent has specialized expertise, tools, and workflows to solve targeted problems efficiently.

## What Are Agents?

Agents are Claude instances configured with:
- **Specialized expertise** through custom system instructions
- **Focused toolsets** for their domain
- **Optimized models** (Haiku, Sonnet, or Opus based on complexity)
- **Structured workflows** for consistent execution

Use agents to:
- Get expert reviews of your code
- Automate repetitive tasks
- Parallelize independent work
- Maintain consistent quality standards
- Handle domain-specific complexity

## Available Agents (25 Total)

| Agent | Domain | Description | Model |
|-------|--------|-------------|-------|
| architect | Architecture | System design, scalability, and technical decision-making | opus |
| build-error-resolver | Build Tools | Resolves TypeScript, build, and compilation errors | sonnet |
| chief-of-staff | Communication | Manages multi-channel communication workflows | opus |
| code-reviewer | Code Quality | Expert code review for quality and security | sonnet |
| cs-ceo-advisor | C-Level | Strategic leadership and executive guidance | opus |
| cs-cto-advisor | C-Level | Technology strategy and CTO responsibilities | opus |
| database-reviewer | Databases | Database design, performance, and best practices | sonnet |
| doc-updater | Documentation | Documentation generation and maintenance | sonnet |
| e2e-runner | Testing | End-to-end testing and test automation | sonnet |
| go-build-resolver | Go Lang | Go build and compilation error resolution | sonnet |
| go-reviewer | Go Lang | Go code review and best practices | sonnet |
| harness-optimizer | Optimization | Test harness and pipeline optimization | sonnet |
| loop-operator | Operations | Iterative execution and loop optimization | sonnet |
| planner | Planning | Feature planning and implementation roadmaps | opus |
| python-reviewer | Python | Python code review and best practices | sonnet |
| refactor-cleaner | Refactoring | Dead code removal and technical debt cleanup | sonnet |
| security-reviewer | Security | Security analysis and vulnerability assessment | sonnet |
| seo-content | SEO | Content optimization and SEO strategy | sonnet |
| seo-geo | SEO | Geographic and local SEO optimization | sonnet |
| seo-performance | SEO | Performance optimization for SEO metrics | sonnet |
| seo-schema | SEO | Schema markup and structured data | sonnet |
| seo-sitemap | SEO | Sitemap generation and XML optimization | sonnet |
| seo-technical | SEO | Technical SEO audit and optimization | sonnet |
| seo-visual | SEO | Visual content and image SEO optimization | sonnet |
| tdd-guide | Testing | Test-driven development guidance and execution | sonnet |

## How to Use Agents

### Invoke an Agent

```bash
# Use the agent directly with a task description
agent architect "Design the database schema for a new feature"

# Or use within Claude Code with a specific prompt
# The system will automatically route to the appropriate agent
```

### Recommended Usage Patterns

**Code Review:** After writing code
```bash
agent code-reviewer
# Automatically reviews staged changes
```

**Architecture Decisions:** Before implementing large features
```bash
agent architect "We need to redesign our authentication system"
```

**Test Strategy:** When setting up new test suites
```bash
agent tdd-guide "Write tests for the payment processing module"
```

**Security Check:** Before deploying to production
```bash
agent security-reviewer
# Reviews all staged changes for security issues
```

## Creating Your Own Agent

Agents are defined as markdown files with YAML frontmatter. Here's the format:

```yaml
---
name: your-agent-name
description: One-line description of what this agent does
tools: ["Read", "Grep", "Glob", "Bash", "Edit", "Write"]
model: sonnet
---

# Your Agent Name

## Your Role

Describe what this agent does and when to use it.

## Key Workflows

Document the main workflows and responsibilities.

## Example Usage

Show how to invoke and use the agent.
```

### Frontmatter Fields

- **name**: Unique identifier for the agent (kebab-case)
- **description**: One-line summary of the agent's purpose
- **tools**: Array of tools the agent can access (Read, Bash, Edit, Write, Grep, Glob, etc.)
- **model**: Claude model tier (haiku, sonnet, opus)
  - `haiku`: Fast, lightweight tasks
  - `sonnet`: General-purpose, balanced cost/capability
  - `opus`: Complex reasoning, architectural decisions

### Best Practices for Agent Design

1. **Clear Responsibility**: Each agent should have one primary focus
2. **Detailed Instructions**: Provide explicit workflows in the agent markdown
3. **Tool Selection**: Include only tools the agent actually needs
4. **Model Sizing**: Choose the right model for task complexity
5. **Documentation**: Document the agent's workflows and success criteria
6. **Examples**: Provide concrete usage examples

## Agent Discovery

All agents in this directory are automatically discovered by Claude Code. To see all available agents:

```bash
# List all agents (via Claude Code UI)
# Or read the agent files directly in this directory
```

## Architecture Patterns

### Domain-Specific Agents
- Group related agents (e.g., all SEO agents, all C-Level agents)
- Share common knowledge bases and workflows
- Maintain consistent naming conventions

### Skill Integration
Agents can leverage skills for specific tooling:
- SEO agents use domain-specific SEO skills
- C-Level agents use executive leadership skills
- Language agents (Go, Python) use language-specific skills

### Multi-Agent Workflows
Combine agents for complex tasks:
1. **Architect** designs the system
2. **Planner** creates implementation roadmap
3. **TDD Guide** writes tests
4. **Code Reviewer** reviews implementation
5. **Security Reviewer** checks for vulnerabilities

## Integration with Claude Code

Agents integrate with Claude Code through:
- **Automatic routing**: Tasks are routed to appropriate agents
- **Tool access**: Agents can use all standard Claude Code tools
- **Context preservation**: Full codebase context available
- **Parallel execution**: Multiple agents can work in parallel
- **Skill loading**: Agents can load and use specialized skills

## Performance Optimization

### Model Selection
- **Lightweight tasks** (refactoring, code cleanup) → Haiku
- **Standard tasks** (code review, implementation) → Sonnet
- **Complex reasoning** (architecture, strategy) → Opus

### Tool Efficiency
- Only include tools the agent actually needs
- Use Grep for large-scale searches (faster than repeated Reads)
- Batch-read multiple small files when possible

## Related Documentation

- **Agent Development**: See project-specific CLAUDE.md files
- **Skill Development**: Reference skill documentation in the skills directory
- **Claude Code Docs**: https://docs.anthropic.com/en/docs/claude-code

---

**Last Updated**: 2026-04-04  
**Total Agents**: 25  
**Model Distribution**: 8 Opus, 17 Sonnet, 0 Haiku
