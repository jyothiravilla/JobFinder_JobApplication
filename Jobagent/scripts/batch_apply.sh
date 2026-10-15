#!/bin/bash
# One-time batch: SUBMITS applications that pass every gate. Use with care.
# Usage: batch_apply.sh [min_fit] [max_applications]   (defaults 70 and 2)
export PATH="/usr/local/bin:/usr/bin:/bin:$HOME/.npm-global/bin"
JA="${JOB_AGENT_HOME:-$HOME/job-agent}"
cd "$JA" || exit 1
[ -f "$HOME/.claude_token.env" ] && { set -a; . "$HOME/.claude_token.env"; set +a; }
MIN_FIT="${1:-70}"; MAX_APPS="${2:-2}"
case "$MIN_FIT$MAX_APPS" in *[!0-9]*) echo "usage: batch_apply.sh [min_fit] [max_applications]"; exit 1;; esac
TODAY=$(date +%F); YDAY=$(date -d yesterday +%F)
mkdir -p logs
LOG="logs/batch-$(date +%F-%H%M%S).log"
exec 9>/tmp/jobagent.lock
flock -n 9 || { echo "Another run is active. Try again later."; exit 1; }
timeout 3h claude -p "BATCH APPROVED. One-time batch apply authorized by the person. Read CLAUDE.md, profile.md, sources.md, jobs.csv, tracker.csv. Apply to postings in jobs.csv with status new and date_found $YDAY or $TODAY, fit_percent at least $MIN_FIT, minimum experience within the limit in CLAUDE.md, at a company allowed by sources.md, and still open. Best fit first. Apply to at most $MAX_APPS postings in this run and stop after 3 hours. For each posting follow every other rule in CLAUDE.md. Submit only if every gate passes. Update jobs.csv and tracker.csv for each posting. End by writing digest.md with, for each posting, the company, title, result, confirmation text, and anything needing review." --permission-mode auto >> "$LOG" 2>&1
python3 scripts/send_digest.py "Job agent batch application report" >> "$LOG" 2>&1
tail -n 15 "$LOG"
