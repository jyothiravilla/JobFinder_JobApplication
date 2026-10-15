#!/bin/bash
# Set a posting's status by hand. Usage: mark.sh word1 [word2 ...] status
JA="${JOB_AGENT_HOME:-$HOME/job-agent}"
[ "$#" -lt 2 ] && { echo "usage: a-mark Acme manual   (statuses: manual, applied, new, skipped_ineligible, needs_review, ready_for_review, blocked)"; exit 1; }
STATUS="${@: -1}"
KEYS=("${@:1:$#-1}")
JA="$JA" MARK_STATUS="$STATUS" MARK_KEYS="${KEYS[*]}" python3 - << 'PY'
import csv, os, datetime
status = os.environ['MARK_STATUS']
keys = os.environ['MARK_KEYS'].lower().split()
allowed = ('manual', 'applied', 'new', 'skipped_ineligible', 'needs_review', 'ready_for_review', 'blocked')
if status not in allowed:
    raise SystemExit('status must be one of: ' + ', '.join(allowed))
base = os.environ['JA'].rstrip('/') + '/'
def hit(r):
    t = (r['company'] + ' ' + r['title']).lower()
    return all(k in t for k in keys)
rows = list(csv.DictReader(open(base + 'jobs.csv', newline='')))
m = [r for r in rows if hit(r)]
if len(m) != 1:
    print('Need exactly one match, found', len(m))
    for r in m: print('  ', r['status'], '|', r['company'], '|', r['title'])
    raise SystemExit(1)
stamp = 'marked ' + status + ' by hand on ' + datetime.date.today().isoformat()
for fn in ('jobs.csv', 'tracker.csv'):
    rs = list(csv.DictReader(open(base + fn, newline='')))
    if not rs: continue
    fields = list(rs[0].keys()); n = 0
    for r in rs:
        if hit(r):
            r['status'] = status
            r['notes'] = ((r.get('notes') or '') + ' | ' + stamp).strip(' |')
            n += 1
    with open(base + fn, 'w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=fields); w.writeheader(); w.writerows(rs)
    print(fn + ': updated', n, 'row(s)')
print('->', m[0]['company'], '|', m[0]['title'], 'is now', status)
PY
