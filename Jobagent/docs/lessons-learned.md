# Lessons learned

- **A mechanical check beats a promise.** A model's claim that a resume is truthful means little without a script that verifies it. Negative tests prove the script works.
- **Confirmations matter more than summaries.** Count an application as submitted only when you see the employer's confirmation text.
- **Large companies have few entry-level openings at any moment.** Curated new-grad lists and mid-size companies give a better hit rate than keyword searches on big career sites.
- **Workday and Oracle portals are the fragile part.** Required type-ahead fields can return nothing in an automated browser, and some sign-ups fail on background network calls. Greenhouse and Lever usually work.
- **Review mode first.** The first scheduled apply runs are where surprises appear. Keep review mode until many applications have gone through cleanly.
- **A global MCP scope matters.** Tools added with the default scope vanish when you start Claude Code in a different folder.
- **Cron needs its own login test.** Test Claude under a bare environment (`env -i`) because scheduled jobs do not inherit your shell.
- **Placeholders get pasted literally.** Make scripts reject obvious placeholders, and prefer prompts that ask you to type a value over text you must edit.
- **Alerts must avoid false alarms.** Triggering on short output plus a login or usage phrase works better than scanning whole logs for keywords.
- **Anchor your `sed` patterns.** A rules sentence beginning with the same words as a setting line can be damaged by an unanchored replace.
- **Keep one run at a time.** A shared lock prevents scrambled CSV files.
- **Do not hand secrets to tools you cannot inspect.** Privacy and truthfulness claims on a marketing page are not verification.
- **Fit scores are estimates.** They are useful for ordering, not for deciding.
