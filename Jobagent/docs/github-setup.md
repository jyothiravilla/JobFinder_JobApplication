# Publishing this project to GitHub

## Before you push

1. Replace `<YOUR NAME>` in `LICENSE` and `<you>` in the README and setup guide.
2. Make sure no personal data is present. The repository must contain only templates, scripts, prompts, and docs:
   ```bash
   ./tools/pre-push-check.sh
   ```
   To also search for your own names and private terms, put them one per line in a local file outside the repo and pass it:
   ```bash
   ./tools/pre-push-check.sh ~/private-terms.txt
   ```
3. Use a GitHub no-reply commit email so your real address is not in the history:
   ```bash
   git config user.name "Your Name"
   git config user.email "<id>+<username>@users.noreply.github.com"
   ```
   (Find the exact address under GitHub Settings, Emails.)
4. Decide public or private. Start private if unsure. A public repo about automated applications may attract attention, so keep the responsible-use document prominent.

## Push

With the GitHub CLI:
```bash
git init -b main
git add -A
git status          # read the list: no profile.md, secrets.env, resumes, logs, or CSV state
git commit -m "Initial commit"
gh repo create claude-job-agent --private --source=. --push
```

Without it, create an empty repository on github.com, then:
```bash
git remote add origin https://github.com/<you>/claude-job-agent.git
git push -u origin main
```

## Repository settings

- **About / description:** Rules-driven job application agent on Claude Code, Playwright, and cron. Finds entry-level roles, builds truthful tailored resumes, fills applications, and waits for your approval.
- **Topics:** `claude-code`, `mcp`, `playwright`, `job-search`, `automation`, `ai-agent`, `cron`, `resume`
- Turn on secret scanning and push protection (Settings, Code security).
- Add branch protection if others will contribute.

## If you pushed something private by mistake

Assume it is exposed. Rotate any credential, then remove the file from history with `git filter-repo` or by recreating the repository. Deleting the file in a new commit is not enough.
