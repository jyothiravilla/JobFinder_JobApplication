#!/bin/bash
# List postings with status new, best fit first (parses 85, 85%, ~85)
JA="${JOB_AGENT_HOME:-$HOME/job-agent}"
JA="$JA" python3 - << 'PY'
import csv, os, re
rows = [r for r in csv.DictReader(open(os.path.join(os.environ['JA'], 'jobs.csv'), newline='')) if r['status'] == 'new']
def fit(r):
    m = re.search(r'\d+', str(r.get('fit_percent') or ''))
    return int(m.group()) if m else -1
print(len(rows), 'new postings, best fit first:')
for r in sorted(rows, key=fit, reverse=True):
    f = fit(r)
    print((str(f) + '%' if f >= 0 else '?').rjust(4), r['company'], '|', r['title'][:55], '|', (r.get('experience_required') or '')[:25])
PY
