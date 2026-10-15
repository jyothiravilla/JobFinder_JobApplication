#!/bin/bash
# Approve ONE filled application: approve.sh "Company" "Job title"
export PATH="/usr/local/bin:/usr/bin:/bin:$HOME/.npm-global/bin"
JA="${JOB_AGENT_HOME:-$HOME/job-agent}"
cd "$JA" || exit 1
[ -f "$HOME/.claude_token.env" ] && { set -a; . "$HOME/.claude_token.env"; set +a; }
if [ "$#" -ne 2 ]; then echo 'usage: approve.sh "Company" "Job title"'; exit 1; fi
COMPANY="$1"; TITLE="$2"
mkdir -p logs
LOG="logs/approve-$(date +%F-%H%M%S).log"
exec 9>/tmp/jobagent.lock
flock -n 9 || { echo "Another run is active. Try again in a few minutes."; exit 1; }
timeout 40m claude -p "APPROVED: $COMPANY | $TITLE. Read CLAUDE.md, profile.md, jobs.csv, and tracker.csv, then follow the Approvals section of CLAUDE.md for exactly this one posting. End by writing digest.md with the result." --permission-mode auto >> "$LOG" 2>&1
python3 scripts/send_digest.py "Job agent approval result" >> "$LOG" 2>&1
tail -n 20 "$LOG"
