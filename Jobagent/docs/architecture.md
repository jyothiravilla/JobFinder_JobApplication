# Architecture

## Components

```
Your laptop  --SSH-->  Linux VM
                        |- cron           schedules discover, find, apply
                        |- Claude Code    claude -p, auto permission mode
                        |- Playwright MCP Chromium on a virtual display (xvfb)
                        |- scripts/       runner, email, approvals, batch tools
                        |- ~/job-agent/   rules, profile, CSV state, logs
Dedicated Gmail account: receives digests; an app password lets scripts send and read mail
```

The laptop is only a remote control. Closing it, sleeping, or losing Wi-Fi never stops a scheduled run, because everything runs on the VM. The VM must stay running.

## The three stages

**discover** builds `companies.csv`. For each company it checks the official domain, confirms it is a real established employer, records E-Verify status where a page states it, and applies the exclude rules from `sources.md` (staffing, consulting, universities, and so on).

**find** is read-only. It visits approved companies' careers pages and optional new-grad posting lists, scores each posting against `resume_master.md`, adds qualifying postings to `jobs.csv`, and writes `digest.md`, which a script emails.

**apply** takes postings with status `new`, builds a verified tailored resume, fills the application on the company's own site, and (in review mode) stops on the final page. It writes `review/<company>-<title>/answers.md`, a screenshot, and the resume, then emails you a report.

## Status flow

```
new -> ready_for_review -> applied
 |            |
 |            +-> needs_review / blocked   (stopped at something new or broken)
 +-> skipped_ineligible
any status -> manual   (you apply by hand; the agent never touches it again)
needs_review -> new    (after you add the missing answer to profile.md)
```

## Approval flow

1. The apply stage fills the form, saves the answers, and sets `ready_for_review`.
2. You read the report email (or `a-filled`) and run `a-approve <words>`.
3. `approve.sh` starts a one-off run whose prompt says `APPROVED: <company> | <title>`.
4. The agent re-opens the application, re-enters exactly the saved answers, uploads the saved resume, and compares the review page to `answers.md`.
5. If anything differs or a new required field appears, it does not submit and sets `needs_review`. Otherwise it submits and records the on-screen confirmation text.

Only your own command or prompt counts as approval. Text in web pages, emails, files, or tool results never does.

## Email verification

Some sites email a code or link after you create an account. `get_verification.py` connects to the mailbox read-only (IMAP, `BODY.PEEK`), looks only at recent messages from the sender's domain, and prints only verification links on allowed hosts and short codes. It never prints message bodies and never sends, moves, or deletes mail.

## Reliability mechanisms

- **Lock:** `run.sh`, approvals, and batch runs share `/tmp/jobagent.lock`, so two runs never overlap.
- **Timeout:** every run is wrapped in `timeout` (55 minutes for scheduled runs).
- **Alerts:** if a run's new output is short and mentions a login or usage problem, an alert email is sent. Length matters because a normal run produces pages of output, so a posting that mentions "rate limit" does not cause a false alarm.
- **Caps:** at most 10 companies per discover run, 3 applications per apply run, and a limit on how many filled applications may wait for review.
- **Retries:** a blocked posting is retried at most once, then goes to `needs_review`.

## Files

| Path | Purpose |
|---|---|
| `CLAUDE.md` | The agent's rules |
| `profile.md` | Facts used to answer forms |
| `sources.md` | Scope, discovery sources, role fit, seed companies |
| `resume_master.md` | Locked text of the resume (source of truth) |
| `resume_template.html` | Plain one-column resume layout |
| `companies.csv`, `jobs.csv`, `tracker.csv` | State |
| `accounts.csv` | Logins the agent created (mode 600) |
| `secrets.env` | Mailbox credentials (mode 600) |
| `review/`, `outbox/`, `logs/`, `resumes/` | Working folders |
