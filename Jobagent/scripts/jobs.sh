#!/bin/bash
# Status overview
JA="${JOB_AGENT_HOME:-$HOME/job-agent}"
pgrep -f "approve.sh|batch_apply|review_batch|run.sh|claude -p" >/dev/null && echo ">> a run is active right now" || echo ">> nothing running"
JA="$JA" python3 - << 'PY'
import csv, os, textwrap, collections
rows = list(csv.DictReader(open(os.path.join(os.environ['JA'], 'jobs.csv'), newline='')))
print(dict(collections.Counter(r['status'] for r in rows)))
for st in ['ready_for_review', 'needs_review', 'blocked', 'applied']:
    for r in rows:
        if r['status'] == st:
            print('\n[' + st + '] ' + r['company'] + ' | ' + r['title'])
            if st in ('needs_review', 'blocked'):
                print(textwrap.fill((r.get('notes') or '')[:500], width=95, initial_indent='    ', subsequent_indent='    '))
PY
