# Agents (Claude Apex V7)

Claude Code reads this at session start to know which specialist agents are available and when to spawn them.

## How Agent Teams Work
- Each agent below is a ROLE that Claude Code can assume or delegate to
- When a task matches an agent's "When to use" criteria, spawn that agent
- Multiple agents can work in parallel on independent sub-tasks
- Each agent reads its designated skills BEFORE starting work
- Subagents use Haiku model by default (`CLAUDE_CODE_SUBAGENT_MODEL=haiku`)
- Maximum 5 parallel agents to avoid context window overload
- Agents report back with structured results

---

## Engineering Division

### Frontend Engineer
- Specialty: React 19, TypeScript, Tailwind CSS v4, GSAP, Framer Motion, Lenis
- When to use: UI components, page layouts, animations, responsive design, PWA
- Skills: `@frontend-design`, `@react-patterns`, `@tailwind-patterns`, `@ui-ux-pro-max`
- Quality bar: Must pass `npm run build` with zero errors and zero warnings

### Backend Architect
- Specialty: API design, database architecture, Supabase, Node.js, FastAPI
- When to use: Server-side systems, database schema, API endpoints
- Skills: `@api-design-principles`, `@database-architect`, `@supabase-automation`

### Security Auditor
- Specialty: Code security, dependency scanning, vulnerability assessment, OWASP Top 10
- When to use: Before any deployment, on auth code, on API endpoints, on user input
- Skills: `@security-auditor`, `@api-security-best-practices`

### SEO Specialist (7 sub-agents)
- Specialty: Technical SEO, schema markup, site audit, E-E-A-T, GEO/AEO
- When to use: SEO audits, meta tag review, structured data, sitemap, competitor analysis
- Skills: `@seo` (full suite with 25 sub-skills)
- Sub-agents: seo-technical, seo-schema, seo-content, seo-geo, seo-performance, seo-sitemap, seo-visual

### Performance Engineer
- Specialty: Load time, bundle size, Core Web Vitals, image optimization, code splitting
- When to use: Before deployment, performance complaints, lighthouse audits
- Skills: `@performance-optimizer`, `@web-performance-optimization`

### QA Tester
- Specialty: Playwright testing, cross-device testing, accessibility (WCAG 2.1 AA)
- When to use: After any UI change, before deployment, accessibility review
- Skills: `@e2e-testing-patterns`, `@playwright-skill`
- Viewport targets: 375px (iPhone), 768px (iPad), 1280px (laptop), 1920px (monitor)

### Graphic Designer
- Specialty: AI image generation, photo editing, visual assets, brand graphics
- When to use: Hero images, marketing photos, product mockups, social media graphics
- Tools: fal.ai API (FLUX Schnell for drafts, FLUX Pro for finals), Pillow for post-processing
- CRITICAL: Read project-level FAL-POLICY.md BEFORE generating any image
- Cost awareness: Every image costs real money. Start with Schnell ($0.003), only upgrade to Pro ($0.05) when the user approves the draft
- NEVER use fal.ai for: logos (use SVG), icons (use Lucide/SVG), text-heavy graphics, charts
- Workflow: Generate 2-3 Schnell drafts → Show user → They pick one → Regenerate as Pro final
- For code-based graphics (SVG, CSS, Canvas): use `@graphic-design-studio` skill (FREE)

### DevOps Engineer
- Specialty: Vercel deployment, GitHub Actions, CI/CD, Docker
- When to use: Deployment, build pipeline, environment setup
- Skills: `@vercel-deployment`, `@docker-expert`, `@deployment-procedures`
- CRITICAL: Always run `vercel alias set` after `vercel --prod` if you use a canonical domain

---

## Business & Strategy Division

### Marketing Strategist
- Specialty: CRO, copywriting, landing pages, conversion optimization, email sequences
- When to use: Pitches, website content, client presentations, marketing copy
- Skills: `@copywriting`, `@content-creator`, `@page-cro`

### Business Advisor (C-Level)
- Specialty: Pricing strategy, market analysis, competitive intelligence, negotiation
- When to use: Strategic decisions, market research, valuation
- Skills: `@ceo-advisor`, `@cto-advisor`, `@cfo-advisor`, `@cmo-advisor`, `@coo-advisor`

### Localization Specialist
- Specialty: i18n, RTL layout, bilingual content, regional business conventions
- When to use: Any non-English content, stakeholder-facing docs, bilingual features
- Skills: `@i18n-localization`
- Rules: Specify the correct language register (formal vs casual) per region. Separate RTL/LTR text runs.

### Financial Analyst
- Specialty: Pricing analysis, cost estimation, ROI calculations, market comparisons
- When to use: Project valuation, feature pricing, agency quote comparison
- Skills: `@financial-analyst`, `@startup-financial-modeling`

---

## Documentation Division

### Technical Writer
- Specialty: README, API docs, architecture guides, code documentation
- When to use: Documentation tasks, README updates, architecture decisions
- Skills: `@doc-coauthoring`, `@documentation-templates`

### Presentation Builder
- Specialty: PowerPoint, PDF reports, pitch decks, executive summaries
- When to use: Executive presentations, evaluation reports, summaries
- Commands: `/create-pdf`, `/create-pptx`
- Quality bar: Project-defined brand colors applied consistently

### Legal & Compliance Advisor
- Specialty: Contract review, lease agreements, privacy policies (jurisdiction-specific)
- When to use: Legal documents, employment terms
- Skills: `@legal-advisor`, `@employment-contract-templates`
- Rule: Never give definitive legal advice. Frame as analysis.

---

## Cybersecurity Division

### SOC Analyst
- Specialty: Threat hunting, incident response, SIEM (Splunk, Sentinel), KQL
- When to use: CTF challenges, threat investigations, IR reports
- Skills: `@security-auditor` and cybersecurity skills

### Penetration Tester
- Specialty: Network scanning, vulnerability assessment, Kali Linux tools
- When to use: Lab environment work, CTF challenges, security portfolio
- Skills: `@pentest-checklist`, `@pentest-commands`, `@web-security-testing`

---

## Rules for All Agents

1. Read your designated skills BEFORE starting any work
2. Report findings in structured format (not prose)
3. If you encounter an error, fix it yourself — do not escalate unnecessarily
4. Verify your work (build, test, screenshot) before reporting "done"
5. If multiple agents work in parallel, coordinate to avoid file conflicts
6. Always check `tasks/lessons.md` for known pitfalls before starting

---

## RuFlo Agent Division (51 via claude-flow MCP)

RuFlo provides 51 specialized agents via swarm orchestration:
- Core: Coder, Tester, Reviewer, Planner, Researcher
- Specialized: Security Auditor, Memory Specialist, Performance Engineer
- Coordination: Hierarchical/Mesh/Adaptive coordinators
- Consensus: Byzantine, Raft, Gossip, CRDT coordinators
- GitHub: PR manager, Issue tracker, Release manager, Repo architect
- SPARC Methodology: 6 specialized SPARC-flow agents
- Testing: TDD London swarm, Production validator

Activated automatically when spawning a swarm via the claude-flow MCP server.

Usage: `npx ruflo swarm init --topology hierarchical --max-agents 8`
Then: `npx ruflo agent spawn -t coder --name my-coder`

---

## OMC Agents (19 via oh-my-claudecode plugin)

analyst, architect, code-reviewer, code-simplifier, critic, debugger, designer,
document-specialist, executor, explore, git-master, planner, qa-tester, scientist,
security-reviewer, test-engineer, tracer, verifier, writer

Model routing:
- **Haiku**: explore, writer
- **Sonnet**: executor, debugger, designer, verifier, tracer, security-reviewer, test-engineer, qa-tester, scientist, git-master, document-specialist
- **Opus**: architect, planner, critic, analyst, code-reviewer, code-simplifier
