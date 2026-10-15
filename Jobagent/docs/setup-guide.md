# Setup guide

Commands assume Ubuntu and the default user `ubuntu`. Adapt as needed, and check current documentation for Claude Code and Playwright, since install steps change.

## 1. Server

1. Launch a VM with about 2 vCPU and 4 GB RAM (smaller will struggle with Chromium plus Claude Code). On AWS EC2 a `t3.medium` works. Choose Ubuntu LTS and 30 GB of disk.
2. Create an SSH key and import its public key into your provider:
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/jobagent_ed25519 -C "job-agent"
   ```
   On Windows PowerShell use `"$env:USERPROFILE\.ssh\jobagent_ed25519"` for the path. Never upload the private key.
3. Allow inbound SSH (port 22) only from your own IP. When your network changes, update that rule.
4. Set a billing budget with an email alert before you do anything else.
5. Connect: `ssh -i ~/.ssh/jobagent_ed25519 ubuntu@<SERVER_IP>`.

If the VM has 2 GB of RAM, add swap:
```bash
sudo fallocate -l 4G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

## 2. System packages

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git tmux curl unzip xvfb poppler-utils
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
sudo timedatectl set-timezone <Your/Timezone>   # for example America/Chicago; cron uses the server clock
```

## 3. Claude Code

Install without `sudo`, so Claude Code can update itself:
```bash
mkdir -p ~/.npm-global && npm config set prefix ~/.npm-global
echo 'export PATH=$HOME/.npm-global/bin:$PATH' >> ~/.bashrc && source ~/.bashrc
npm install -g @anthropic-ai/claude-code
tmux new -s agent
claude
```
On a server with no browser, Claude Code prints a login link. Open it on your laptop, sign in, and paste the code back.

## 4. Browser tool (Playwright MCP)

```bash
npx playwright install --with-deps chromium
claude mcp add --scope user playwright -- xvfb-run -a --server-args="-screen 0 1920x1080x24" npx @playwright/mcp@latest --browser chromium --user-data-dir $HOME/browser-profile
cd ~/job-agent 2>/dev/null; claude mcp list
```

- Use `--scope user`. The default local scope only works in the folder where you ran the command, so the tool would be missing inside `~/job-agent`.
- The browser runs headed on a virtual display, not `--headless`. Some sites handle that better.
- The persistent `--user-data-dir` keeps logins between runs.

## 5. Mailbox

1. Create a **dedicated** Gmail account for the agent. It is the master key to every job-site account the agent creates, so never reuse your personal account.
2. Turn on 2-Step Verification with a phone number as the second step, then create an app password named `job-agent` (myaccount.google.com/apppasswords). If the option is missing, 2-Step Verification is not fully on, the account is managed by a school or employer, or only security keys are configured.
3. Put the values in `~/job-agent/secrets.env` (mode 600), and set `DIGEST_TO` to the address where you want to read digests.

## 6. Install the agent files

```bash
git clone https://github.com/<you>/claude-job-agent.git
cd claude-job-agent && ./scripts/install.sh && source ~/.bashrc
```

Then edit `~/job-agent/profile.md`, `sources.md`, and `CLAUDE.md` (replace every `<PLACEHOLDER>`), and put your resume PDF in `~/job-agent/resumes/`.

## 7. Master resume, template, and helper scripts

Use the prompts in [prompts/](../prompts/) in this order: master resume and template, resume verifier and builder, mailbox helper. Lock the master afterward with `chmod 444 resume_master.md`. Run the negative tests so you know the verifier catches fake content.

## 8. Test by hand, then schedule

```bash
nohup ~/job-agent/scripts/run.sh discover > /dev/null 2>&1 &
nohup ~/job-agent/scripts/run.sh find > /dev/null 2>&1 &
```

Runs can take 5 to 40 minutes, and the log stays empty until the end, because `claude -p` prints only when it finishes. Read the `logs/` summaries and `companies.csv` / `jobs.csv`. Send yourself a test digest:
```bash
echo "test" > ~/job-agent/digest.md && python3 ~/job-agent/scripts/send_digest.py
```

Add the schedule (times are server-local):
```bash
(crontab -l 2>/dev/null; echo "0 5 * * * $HOME/job-agent/scripts/run.sh discover"; echo "30 6 * * * $HOME/job-agent/scripts/run.sh find"; echo "0 9 * * * $HOME/job-agent/scripts/run.sh apply") | crontab -
```

Keep `MODE: review` in `CLAUDE.md` until several applications have gone through cleanly.

## 9. Keep the login alive

Scheduled runs share Claude Code's saved login. If a run says "Not logged in", sign in again, or create a long-lived token with `claude setup-token`, store it in `~/.claude_token.env` (mode 600), and let `run.sh` load it. To copy the login link off a server when you cannot select it, run this in a second tmux window:
```bash
for p in $(tmux list-panes -a -F '#{pane_id}'); do tmux capture-pane -p -J -S -300 -t "$p"; done | grep -o 'https://claude.com/cai/oauth/authorize[^[:space:]]*' | tail -1
```

## 10. Safe maintenance

- Reboot with `sudo reboot`, never "Stop instance" on a cloud console (it changes the public IP).
- Check `pgrep -f "claude -p"` before rebooting or editing files the agent uses.
