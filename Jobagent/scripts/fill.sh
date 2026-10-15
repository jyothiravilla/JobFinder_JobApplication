#!/bin/bash
# Start a background review batch. Usage: fill.sh [min_fit] [max_to_fill]
JA="${JOB_AGENT_HOME:-$HOME/job-agent}"
if pgrep -f "approve.sh|batch_apply|review_batch|run.sh|claude -p" >/dev/null; then echo "A run is active. Wait."; exit 1; fi
nohup "$JA/scripts/review_batch.sh" "${1:-60}" "${2:-5}" > /dev/null 2>&1 &
echo "review batch started: fit >= ${1:-60}, up to ${2:-5} postings. Check with a-running. An email arrives when it finishes."
