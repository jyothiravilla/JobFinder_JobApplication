# Daily usage

Run these at the server prompt (not inside Claude). Load them with `source ~/.bashrc` after installing.

## Commands

| Command | What it does |
|---|---|
| `a-help` | Prints a one-page command list |
| `a-jobs` | Status counts, what is waiting for approval, what needs review (with reasons), what is applied |
| `a-new` | Postings not yet filled, best fit first |
| `a-filled [words]` | Read what the agent filled out (q to exit), for example `a-filled Acme` |
| `a-running` | Is a run active right now |
| `a-status` | Health of recent runs and login-problem flags |
| `a-log` | Last lines of the newest approval or run log |
| `a-login` | Prints OK if the Claude login works for scheduled runs |
| `a-fill [fit] [n]` | Fill n new postings up to the last page without submitting. Default 60 and 5 |
| `a-approve words` | Approve and submit waiting applications one after another. `a-approve Acme Beta` or `a-approve all` |
| `a-mark words status` | Set a status by hand, for example `a-mark Acme manual` |
| `a-review` / `a-auto` | Review mode (waits for your approval) or auto mode (submits by itself) |
| `a-pause` / `a-resume` | Turn the scheduled apply job off or on |
| `a-stop` | Stop every run now. Use only if clearly stuck |

## Statuses

| Status | Meaning |
|---|---|
| `new` | Found, not filled yet |
| `ready_for_review` | Filled and waiting for your approval |
| `needs_review` / `blocked` | Stopped at something new or broken. The reason is in the notes |
| `manual` | You are applying by hand. The agent never touches it |
| `applied` | Submitted |
| `skipped_ineligible` | Does not qualify |

## A normal morning (about 5 minutes)

1. `a-running`, then read the digest and report emails.
2. `a-jobs` to see what is waiting.
3. `a-filled` to read the answers. Check names, contact details, authorization answers, and declarations.
4. `a-approve <words>` for the ones you are happy with.
5. `a-jobs` later, and read the "approval result" email. Count an application as submitted only when it shows the on-screen confirmation text.

## When something needs you

- **`needs_review`:** read the reason in `a-jobs`. If the agent lacked an answer, add it to `profile.md`, then reset the posting to `new` with `a-mark <words> new`.
- **A site the agent cannot handle:** open the posting link and apply yourself, then `a-mark <words> manual` (or `applied` when done).

## Schedule (example, server time)

| Time | Run | Email |
|---|---|---|
| 5:00 | discover | none |
| 6:30 | find | "Job finder digest" (only if new postings) |
| 9:00 | apply | "Job agent application report" (only if it filled something) |

Other emails: "approval result", "review batch report", and "Job agent ALERT" (login or usage problem).

## Rules of thumb

- One run at a time. `a-approve` and `a-fill` refuse to start if something is running.
- Do not edit `resume_master.md` or the rules while a run is active.
- If SSH times out, your network changed. Update the cloud firewall's SSH rule to your current IP. Scheduled runs keep working without you.
