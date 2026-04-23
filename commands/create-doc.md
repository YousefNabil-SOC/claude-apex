Generate a professional Word document (.docx) using Python and python-docx.

The user will provide: document type (proposal/report/contract/NDA/brief/memo), content, and output filename.

Steps:
1. Ask for: document type, title, sections/content, output filename
2. Generate a Python script using python-docx that creates a complete document with:
   - Cover page with title, date, client/company name
   - Proper heading hierarchy (Heading 1, 2, 3)
   - Body text with professional formatting
   - Tables where appropriate
   - Page numbers and footer
   - For legal docs: numbered clauses, definitions section, signature block
3. Run the script with Bash to produce the .docx file
4. Confirm the output file path

Supported document types:
- proposal: executive summary, scope, timeline, pricing, terms
- contract/NDA: parties, definitions, obligations, terms, signatures
- report: executive summary, findings, recommendations, appendix
- brief: background, objective, approach, deliverables
- memo: to/from/date/re header, body, action items
