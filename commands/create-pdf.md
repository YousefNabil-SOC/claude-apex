Generate a professional PDF document using Python and reportlab.

The user will provide: document type (report/proposal/invoice/contract), content or outline, and output filename.

Steps:
1. Ask for: document type, title, content outline, output filename
2. Generate a Python script using reportlab that creates a polished PDF with:
   - Professional header with title and date
   - Table of contents (for reports > 3 sections)
   - Styled body content with headings (H1/H2/H3)
   - Footer with page numbers
   - Professional typography (Helvetica family)
3. Run the script with Bash to produce the .pdf file
4. Confirm the output file path

Default style: clean white background, dark navy text #1B2A4A, section headers in blue #2563EB.
For legal documents: use formal styling, clear section numbering, signature blocks at the end.
