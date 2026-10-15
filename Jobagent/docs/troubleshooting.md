# Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| SSH "Connection timed out" | Your network changed, so the firewall no longer matches your IP | Edit the inbound rule: SSH from My IP. If the instance is stopped, start it |
| Terminal fills with `35;134;27M` text | Mouse mode left on after a dropped connection | Close the window, or run `printf '\e[?1000l\e[?1002l\e[?1003l\e[?1006l'; stty sane` |
| `Not logged in` in a cron log | Claude login expired | Sign in again, or create a long-lived token with `claude setup-token` |
| Run looks frozen, log is empty | Normal: `claude -p` prints only at the end | Check `ps -o etime`, new folders in `review/`, and `free -h`. The timeout ends it |
| "No such file" for a script | An install or setup step was skipped | Re-run `scripts/install.sh` |
| Email error: recipient not valid | A placeholder was left in `secrets.env` | Set the real address in `DIGEST_TO` |
| Digest email bounced | `DIGEST_TO` was a placeholder | Fix it and resend |
| Browser tools missing in a session | MCP server added with local scope in another folder | Re-add with `--scope user` |
| Picker shows "No Items" | Typeahead not triggered or blocked | Type slowly and wait. If it persists, apply by hand |
| Job-site account locked | Wrong passwords or simultaneous sign-ins | Reset the password by email, then update `accounts.csv` |
| `cat` on a PDF prints gibberish | PDFs are binary | Use `pdftotext`, `pdffonts`, `pdfinfo` |
| Approval says nothing to approve | No row is `ready_for_review`, or placeholder names were used | Run `a-jobs` first and use real words from the company or title |
| `grep "^MODE:"` shows two lines | The rules text also starts a line with MODE | Use the anchored pattern `^MODE: (review|auto)$` |
| Apply run did nothing | Too many applications already waiting, or no posting meets the fit bar | Approve or clear some, or run `a-fill` |
| Fit scores show 0% in a list | A script could not parse `~85` or `85%` | Use `a-new`, which parses numbers |

## Quick diagnostics

```bash
pgrep -af "run.sh|approve.sh|claude -p" | cut -c1-90
a-status
tail -c 600 ~/job-agent/logs/cron-$(date +%F)-apply.log
grep CRON /var/log/syslog | tail -5
```
