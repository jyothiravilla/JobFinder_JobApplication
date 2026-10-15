#!/bin/bash
# Fill several new postings up to the final page. Never submits.
# Usage: review_batch.sh [min_fit] [max_to_fill]   (defaults 60 and 5)
export PATH="/usr/local/bin:/usr/bin:/bin:$HOME/.npm-global/bin"
JA="${JOB_AGENT_HOME:-$HOME/job-agent}"
cd "$JA" || exit 1
[ -f "$HOME/.claude_token.env" ] && { set -a; . "$HOME/.claude_token.env"; set +a; }
MIN_FIT="${1:-60}"; MAX="${2:-5}"
case "$MIN_FIT$MAX" in *[!0-9]*) echo "usage: review_batch.sh [min_fit] [max_to_fill]"; exit 1;; esac
mkdir -p logs
LOG="logs/review-batch-$(date +%F-%H%M%S).log"
exec 9>/tmp/jobagent.lock
flock -n 9 || { echo "Another run is active. Try again later."; exit 1; }
timeout 3h claude -p "REVIEW BATCH. Review mode applies: never click the final Submit button, and this is not an approval. Read CLAUDE.md, profile.md, sources.md, jobs.csv, tracker.csv. Fill applications up to the final review page for postings in jobs.csv with status new, fit_percent at least $MIN_FIT, minimum experience within the limit in CLAUDE.md, at a company allowed by sources.md, and still open. Best fit first. Fill at most $MAX postings in this run and stop after 3 hours. The waiting-queue cap in CLAUDE.md does not apply to this run. For each posting follow every other rule in CLAUDE.md. Postings you skip become skipped_ineligible with a one-line reason. Write digest.md with, for each filled posting, the full answers and the Approve with line, plus every needs_review item." --permission-mode auto >> "$LOG" 2>&1
python3 scripts/send_digest.py "Job agent review batch report" >> "$LOG" 2>&1
tail -n 15 "$LOG"
