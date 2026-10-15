#!/bin/bash
JA="${JOB_AGENT_HOME:-$HOME/job-agent}"
cd "$JA" || exit 1
echo "== now: $(date)"; echo "== cron:"; crontab -l
echo "== recent runs:"
for f in $(ls -t logs/cron-*.log 2>/dev/null | head -4); do
  echo "-- $f ($(stat -c %y "$f" | cut -d. -f1))"
  if tail -n 30 "$f" | grep -qiE "not logged in|token has expired|please run /login"; then echo "   LOGIN PROBLEM"; else echo "   $(tail -n 1 "$f" | cut -c1-150)"; fi
done
echo "== jobs found: $(($(wc -l < jobs.csv) - 1))   companies approved: $(grep -c ',approved,' companies.csv)"
echo "== running now:"; pgrep -af "claude -p" | grep -v pgrep || echo "   nothing"
