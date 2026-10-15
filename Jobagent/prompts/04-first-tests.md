# 4. First supervised tests

Run these in review mode, watch the results, and do not schedule anything until they behave.

## Discovery (nothing is applied)

> Read CLAUDE.md, profile.md, and sources.md. Run the discover stage for only three companies: <A>, <B>, and <C>. Add them to companies.csv and show me each row with the evidence you found.

Check: official domains, real evidence, E-Verify recorded honestly (unknown is fine), and no row set to a status you did not expect.

## Resume tailoring (no account, no application)

> Run the apply stage for <Company> only, but stop before starting any application or creating any account. Use the browser to open the careers_url, find one entry-level role that matches my resume, and build the tailored resume following the Resume tailoring rules. Show me logs/resumes/<company>-<title>.md with the supporting line from resume_master.md next to every item, and the path to the tailored PDF.

Check every line against your real resume. Nothing may be stronger than the original.

## One application in review mode

> Run the apply stage for <Company> only, in review mode. Create the account if the portal needs one, using scripts/get_verification.py. Fill the whole application with the tailored resume, stop on the final review page, take a screenshot, and do not submit. Show me every field you answered and where the answer came from, plus anything marked needs_review.

Check the screenshot and answers. If everything is right, approve it with `a-approve <words>` and confirm the employer's on-screen confirmation text.

## Scheduling

Test Claude under cron's bare environment before relying on it:

```bash
a-login
```

It should print `OK`. Then run `scripts/run.sh find` by hand, read the digest, and only then add the cron lines from docs/setup-guide.md.
