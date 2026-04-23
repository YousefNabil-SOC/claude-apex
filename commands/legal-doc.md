Create a professional legal document for enterprise use.

The user will specify the document type. Supported types:
- NDA (Non-Disclosure Agreement) — mutual or one-way
- Service Agreement / MSA (Master Services Agreement)
- SLA (Service Level Agreement)
- Privacy Policy
- Terms of Service
- Statement of Work (SOW)
- Consulting Agreement
- Website Accessibility Statement

Steps:
1. Ask for: document type, Party A name, Party B name, jurisdiction/governing law, effective date, any specific clauses
2. Generate the full legal document using python-docx with proper clause numbering
3. Include standard sections appropriate to the document type
4. Add signature block with date lines
5. Save as .docx AND .pdf (two outputs)
6. Add a disclaimer: "This is a template — review with a licensed attorney before use"

Important:
- Use clear, precise legal language
- Number all clauses (1.1, 1.2, 2.1, etc.)
- Include definitions section for all defined terms
- Governing law defaults to user's jurisdiction if known
