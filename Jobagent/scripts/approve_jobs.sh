#!/bin/bash
# Approve one or several filled applications in the background, one after another.
# Usage: approve_jobs.sh all    or    approve_jobs.sh word1 word2 ...
JA="${JOB_AGENT_HOME:-$HOME/job-agent}"
cd "$JA" || exit 1
[ "$#" -eq 0 ] && { echo 'usage: approve_jobs.sh all   or   approve_jobs.sh Acme Beta'; exit 1; }
pgrep -f "approve.sh|batch_apply|review_batch|run.sh|claude -p" >/dev/null && { echo "A run is active. Wait."; exit 1; }
JA="$JA" python3 - "$@" > /tmp/approve_queue.txt << 'PY'
import csv, os, sys
keys = [k.lower() for k in sys.argv[1:]]
for r in csv.DictReader(open(os.path.join(os.environ['JA'], 'jobs.csv'), newline='')):
    if r['status'] != 'ready_for_review':
        continue
    text = (r['company'] + ' ' + r['title']).lower()
    if keys == ['all'] or any(k in text for k in keys):
        print(r['company'] + '|||' + r['title'])
PY
[ -s /tmp/approve_queue.txt ] || { echo "No matching ready_for_review postings."; exit 1; }
echo "Approving one after another:"; sed 's/|||/  |  /' /tmp/approve_queue.txt
nohup bash -c 'while IFS= read -r line <&3; do c="${line%%|||*}"; t="${line#*|||}"; "'"$JA"'/scripts/approve.sh" "$c" "$t" </dev/null; done 3< /tmp/approve_queue.txt' > /dev/null 2>&1 &
