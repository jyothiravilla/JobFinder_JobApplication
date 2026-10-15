# Resume truthfulness

The most important rule in this project: **a tailored resume may only select, reorder, and trim content that already exists in your resume.** It may never add a skill, tool, language, framework, project, employer, title, degree, certification, date, metric, number, or outcome.

Asking a model to follow that rule is not enough, so it is enforced by scripts.

## Pieces

| Piece | Role |
|---|---|
| `resume_master.md` | Text of your real resume. The only source of truth. Locked with `chmod 444` |
| `resume_template.html` | Plain single-column, ATS-friendly layout |
| `verify_resume.py` | Checks a tailored HTML (or plain text) against the master |
| `build_resume.sh` | Verifies the HTML, renders the PDF, extracts the PDF's text with `pdftotext`, re-verifies it, and deletes the PDF on any failure |
| `banned_terms.txt` | Terms that must never appear (employer product, device, or part names) |

To edit the master, unlock it (`chmod 644`), edit, and lock it again (`chmod 444`). Keep your real resume file in sync, because forms and fallbacks use it.

## What the verifier checks

- Every list item, paragraph, skill entry, entry header (title, employer, school, degree, dates), and heading in the tailored resume appears in the master after normalizing case, punctuation, and whitespace.
- **Whole-word matching.** Skills are tokenized so a short skill such as `C`, `R`, or `Go` can never match inside another word. Compound tokens like `C++`, `C#`, and `Node.js` stay intact.
- Only a fixed allowlist of generic section titles is exempt. Headings that contain an employer, title, school, degree, date, or project name are checked.
- The contact line must match the master exactly.
- Every number or percentage must also appear in the master.
- The same rules run on text extracted from the finished PDF.
- The builder refuses to create the PDF if verification fails, and also if any banned term appears.

## Tests worth running

Tamper with a copy of a tailored HTML in `/tmp` and confirm each change fails:

| Tamper | Should fail as |
|---|---|
| Change an employer name | entry field |
| Change a job title | entry field |
| Change a date | entry field and number |
| Change a degree | entry field |
| Add a fake certification | list item |
| Add a heading with a fake project | heading |
| Add a skill that is not in the master | skill |
| Append an invented metric to a real bullet | list item and number |
| Add a banned term | build refused |

Then confirm the real tailored resume passes and builds a one-page PDF.

## Known gaps

- The check asks whether a line exists somewhere in the master, not whether it sits under the right employer. Moving a real bullet under the wrong job would pass.
- Cover letters and free-text form answers are not checked mechanically. Read them in review mode.
- Your own resume file, website, and profiles are outside this system. Keep them consistent with the master.

## Confidential names

Employer product, device, platform, or part names can be confidential. Describe the work in generic technical terms ("closed-loop stepper motor control firmware", "medical device platform"), keep those names out of `resume_master.md`, `profile.md`, logs, and notes, and add them to `scripts/banned_terms.txt` so a build fails if they ever return.
