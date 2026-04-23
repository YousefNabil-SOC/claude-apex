Run a full security review of the current project.

Use the security-reviewer agent to perform a comprehensive analysis covering:

1. **OWASP Top 10** — XSS, SQL injection, CSRF, broken auth, sensitive data exposure
2. **Dependency audit** — Run `npm audit` and flag high/critical vulnerabilities
3. **Secrets scan** — Check for hardcoded API keys, tokens, passwords in source files
4. **Auth & authorization** — Review authentication flows, JWT handling, session management
5. **Input validation** — All user inputs, form fields, API endpoints
6. **Environment variables** — Ensure .env is gitignored, no secrets in code
7. **HTTPS/TLS** — Check for mixed content, proper redirect from HTTP
8. **Content Security Policy** — Check CSP headers
9. **Rate limiting** — API endpoints protected against abuse

Output format:
- CRITICAL: must fix before deploy
- HIGH: fix this sprint
- MEDIUM: fix next sprint
- LOW: informational / best practice

End with a prioritized remediation checklist.
