# 2. Resume verifier and builder

> Create scripts/verify_resume.py, an independent check that does not rely on your own judgment. Usage: python3 scripts/verify_resume.py <tailored_resume.html>, plus --text <file> to check plain text.
> 1. Read resume_master.md and the tailored HTML. Extract every text segment from the HTML: each list item, paragraph, heading, skill entry, and entry-header span (job title, employer, school, degree, dates).
> 2. Normalize case, unicode quotes and dashes, punctuation, and whitespace on both sides.
> 3. Use whole-word token matching with space-padded strings, so a short skill like "C", "R", or "Go" cannot match inside another word. Keep compound tokens such as C++, C#, and Node.js intact.
> 4. Check that each list item, paragraph, and entry field is contained in the normalized master. Split comma-separated skill lines and check each skill individually.
> 5. Exempt only an exact allowlist of generic section titles (Education, Skills, Experience, Projects, Leadership, Certifications and Honors). Check every other heading like normal text. Require the contact line to match the master's contact line exactly.
> 6. Numbers check: every standalone number or percentage in a segment (not digits glued to letters) must appear verbatim in the master.
> 7. Print every unsupported segment with its type, exit 1 on any failure, otherwise print PASS and exit 0.
>
> Then create scripts/build_resume.sh <html> <pdf>: run verify_resume.py on the HTML and refuse to render if it fails; otherwise render with npx playwright pdf, run pdftotext on the PDF, re-verify that text with verify_resume.py --text, check the text against scripts/banned_terms.txt (grep -i -f) and delete the PDF and exit 1 on any match, and delete the PDF if any check fails.
>
> Update the Resume tailoring section of CLAUDE.md so PDFs may only be produced with scripts/build_resume.sh, never a direct render command.
>
> Prove it with negative tests on copies in /tmp: change an employer name, a job title, a date, and a degree; add a fake certification; add a heading with a fake project name; add a skill that is not a whole word in the master; append an invented metric to a real bullet; add a banned term. Show that every one fails and that build_resume.sh produces no PDF, then show that the real tailored resume passes and builds a one-page PDF.

If you added a banned-terms check later, make sure `build_resume.sh` reads `scripts/banned_terms.txt` (one pattern per line, no comment lines, because `grep -f` treats every line as a pattern).
