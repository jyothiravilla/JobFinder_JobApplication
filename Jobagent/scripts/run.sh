#!/bin/bash
# Scheduled runner: run.sh discover|find|apply
export PATH="/usr/local/bin:/usr/bin:/bin:$HOME/.npm-global/bin"
JA="${JOB_AGENT_HOME:-$HOME/job-agent}"
cd "$JA" || exit 1
[ -f "$HOME/.claude_token.env" ] && { set -a; . "$HOME/.claude_token.env"; set +a; }
STAGE="$1"
case "$STAGE" in discover|find|apply) ;; *) echo "usage: run.sh discover|find|apply"; exit 1;; esac
mkdir -p logs
LOG="logs/cron-$(date +%F)-$STAGE.log"
exec 9>/tmp/jobagent.lock
flock -n 9 || { echo "$(date): previous run still active, skipping" >> "$LOG"; exit 0; }
START=$(stat -c %s "$LOG" 2>/dev/null || echo 0)
timeout 55m claude -p "Read CLAUDE.md, profile.md, and sources.md. Run the $STAGE stage now, following every rule and limit in CLAUDE.md. End by writing the run summary file described in CLAUDE.md." --permission-mode auto >> "$LOG" 2>&1
NEW=$(tail -c +$((START+1)) "$LOG")
if [ "$STAGE" = "find" ]; then python3 scripts/send_digest.py "Job finder digest" >> "$LOG" 2>&1; fi
if [ "$STAGE" = "apply" ]; then python3 scripts/send_digest.py "Job agent application report" >> "$LOG" 2>&1; fi
# Alert only when the run's new output is short AND mentions a login or usage problem
if [ "${#NEW}" -lt 600 ] && echo "$NEW" | grep -qiE "not logged in|token has expired|please run /login|usage limit|rate limit|hit your limit"; then
  echo "Job agent: the $STAGE run on $(date) hit a Claude login or usage problem. See logs/cron-$(date +%F)-$STAGE.log on the server." > digest.md
  python3 scripts/send_digest.py "Job agent ALERT" >> "$LOG" 2>&1
fi
