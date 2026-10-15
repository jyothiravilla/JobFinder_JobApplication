# 1. Master resume and template

## Master resume

> Read resumes/<YourResume>.pdf. Create resume_master.md that copies every line of the resume exactly as written, organized under its original section headings. Do not add, rephrase, merge, or improve anything. Then show me the file.

Compare it with your real resume line by line and fix errors. Remove any employer product, device, or part names now (see docs/resume-truthfulness.md). Then:

```bash
chmod 444 resume_master.md
```

## Template

> Create resume_template.html: a plain single-column, ATS-friendly layout (standard headings, Arial 10.5pt, no tables, images, or columns) that reproduces resume_master.md and fits one page. Render it to resumes/test.pdf with npx playwright pdf, then tell me the page count.

Download `test.pdf`, open it, and check that it is one page, has the same content as your resume, has a plain layout, and has selectable text.
