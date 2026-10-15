#!/bin/bash
# Read saved answers for filled applications. Usage: filled.sh [words...]
JA="${JOB_AGENT_HOME:-$HOME/job-agent}"
cd "$JA/review" 2>/dev/null || { echo "no review folder"; exit 1; }
for f in */answers.md; do
  [ -f "$f" ] || continue
  if [ "$#" -eq 0 ] || echo "$f" | grep -qi -E "$(IFS='|'; echo "$*")"; then echo "=================== $f"; fold -s -w 110 "$f"; fi
done | less
