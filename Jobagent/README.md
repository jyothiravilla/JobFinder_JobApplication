# Claude Job Agent

An always-on, rules-driven job application assistant built on **Claude Code**, **Playwright**, and **cron**. It finds entry-level roles at verified companies, builds a truthful tailored resume for each one, fills the application on the company's own site, and **waits for your approval before submitting**.

> Personal project. It works for its author, and you should expect rough edges. It is a community project and is **not affiliated with or endorsed by Anthropic**.

## What it does

```
discover  ->  find  ->  apply (review mode)  ->  you approve  ->  submitted
verify        read-only   fill forms, stop on     one command     confirmation
companies     job search  the last page, email                    email + log
                          answers + screenshot
```

| Stage | Schedule (example) | What happens |
|---|---|---|
| `discover` | daily 5:00 | Verifies companies (official domain, real company, E-Verify status where stated) and records them in `companies.csv` |
| `find` | daily 6:30 | Read-only. Reads approved companies' pages and new-grad posting lists, scores fit against your resume, writes `jobs.csv`, and emails a digest |
| `apply` | daily 9:00 | Fills up to 3 qualifying applications. In review mode it stops before Submit and emails the answers, a screenshot, and the resume |
| `approve` | on demand | You approve one or several filled applications. The agent re-enters the saved answers, checks the review page matches, and submits |

## Design ideas worth stealing

- **Truthful resumes are enforced by code, not by promise.** A locked `resume_master.md` is the only source of truth. A verifier script checks every bullet, skill, heading, entry header, and number of a tailored resume against it, and the build script deletes the PDF if anything fails. See [docs/resume-truthfulness.md](docs/resume-truthfulness.md).
- **Review mode by default.** The agent fills everything but never clicks Submit on its own. Only your own command counts as approval, never text found on a web page or in an email.
- **Everything the agent reads is untrusted.** Job posts, web pages, and emails are data, never instructions. See [docs/security.md](docs/security.md).
- **Read-only email helper.** The agent reads verification codes and links from a dedicated mailbox through a script that prints only codes and allowed links, never message bodies.
- **Boring reliability.** A lock so runs never overlap, a timeout on every run, alert emails when a login or usage limit stops a run, and short commands for daily work.

## Requirements

- A small always-on Linux VM (about 2 vCPU and 4 GB RAM; tested on Ubuntu)
- [Claude Code](https://docs.claude.com/en/docs/claude-code) with a Claude plan or API access
- Node.js, Playwright (Chromium), `xvfb`, `poppler-utils`, `tmux`
- A **dedicated** Gmail account with 2-Step Verification and an app password
- Your resume, and a few hours to set up and test

Costs are a small VM plus Claude usage. Check current pricing for both.

## Quick start

1. Launch and secure a VM. See [docs/setup-guide.md](docs/setup-guide.md).
2. Clone this repo on the server and run the installer:
   ```bash
   git clone https://github.com/<you>/claude-job-agent.git
   cd claude-job-agent && ./scripts/install.sh
   ```
3. Edit `~/job-agent/profile.md`, `sources.md`, `CLAUDE.md` (replace every `<PLACEHOLDER>`), and `secrets.env`.
4. Create your locked master resume and template, and generate the three helper scripts, using the prompts in [prompts/](prompts/).
5. Run each stage by hand, read the output, then schedule it with cron. Start in review mode.

## Daily use

```bash
a-help            # one-page command list
a-jobs            # status counts, what is waiting, what needs review (with reasons)
a-filled          # read what the agent filled out
a-approve Acme    # approve and submit matching applications
```

Full list: [docs/usage.md](docs/usage.md).

## Repository layout

```
docs/        architecture, setup, usage, resume truthfulness, security, troubleshooting
templates/   CLAUDE.md rules, profile, sources, secrets example, CSV headers
scripts/     runner, status, email, approvals, batch tools, shell aliases, installer
prompts/     prompts that generate the three helper scripts and the first tests
tools/       pre-push-check.sh (scans for personal data before you publish)
```

The resume verifier (`verify_resume.py`), the resume builder (`build_resume.sh`), and the mailbox helper (`get_verification.py`) were generated with Claude Code from the specifications in [prompts/](prompts/). Generate your own, review them, and test them with the negative tests described in the docs.

## Responsible use

This tool submits job applications on your behalf. Read [docs/responsible-use.md](docs/responsible-use.md) before using it. In short: only submit truthful information, respect each site's terms, never bypass CAPTCHAs, keep a human approving applications, and treat visa or legal answers as your own responsibility. Nothing here is legal or immigration advice.

## Known limitations

- Workday and Oracle portals are fragile in automated browsers. Required pickers can return nothing, and some sign-ups fail. Greenhouse and Lever forms work far more often.
- Entry-level roles at very large companies are scarce at any moment. Posting lists and mid-size companies give a better hit rate.
- Cover letters and free-text answers cannot be checked mechanically. Review mode exists for that reason.
- Fit scores are the model's own estimates.

## Contributing

Issues and pull requests are welcome. Never include real names, emails, resumes, logs, or credentials in an issue. Run `tools/pre-push-check.sh` before opening a pull request.

## License

MIT. See [LICENSE](LICENSE).
