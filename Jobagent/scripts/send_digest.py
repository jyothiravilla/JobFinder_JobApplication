#!/usr/bin/env python3
"""Email digest.md to DIGEST_TO, attaching up to 6 PNG/PDF files from outbox/.
Usage: send_digest.py ["Subject prefix"]"""
import os, sys, smtplib, datetime, glob, shutil
from email.message import EmailMessage

home = os.environ.get('JOB_AGENT_HOME', os.path.expanduser('~/job-agent')).rstrip('/') + '/'
env = {}
for line in open(home + 'secrets.env'):
    line = line.strip()
    if line and not line.startswith('#') and '=' in line:
        k, v = line.split('=', 1)
        env[k.strip()] = v.strip().strip('"').strip("'")
user = env.get('JOB_EMAIL')
pw = env.get('JOB_EMAIL_APP_PASSWORD')
to = env.get('DIGEST_TO')
if not (user and pw and to):
    sys.exit('missing JOB_EMAIL, JOB_EMAIL_APP_PASSWORD or DIGEST_TO in secrets.env')
if 'example.com' in to or 'your-' in to:
    sys.exit('DIGEST_TO still looks like a placeholder')
path = home + 'digest.md'
if not os.path.exists(path) or os.path.getsize(path) == 0:
    sys.exit('no digest to send')
body = open(path).read()[:60000]
title = sys.argv[1] if len(sys.argv) > 1 else 'Job finder digest'
msg = EmailMessage()
msg['Subject'] = title + ' ' + datetime.date.today().isoformat()
msg['From'] = user
msg['To'] = to
msg.set_content(body)
outbox = home + 'outbox/'
files, total = [], 0
if os.path.isdir(outbox):
    for f in sorted(glob.glob(outbox + '*')):
        ext = os.path.splitext(f)[1].lower()
        if ext in ('.png', '.pdf') and os.path.isfile(f):
            size = os.path.getsize(f)
            if len(files) < 6 and total + size < 12000000:
                files.append(f)
                total += size
for f in files:
    ext = os.path.splitext(f)[1].lower()
    maintype, subtype = ('image', 'png') if ext == '.png' else ('application', 'pdf')
    msg.add_attachment(open(f, 'rb').read(), maintype=maintype, subtype=subtype, filename=os.path.basename(f))
with smtplib.SMTP('smtp.gmail.com', 587, timeout=60) as s:
    s.starttls()
    s.login(user, pw)
    s.send_message(msg)
stamp = datetime.datetime.now().strftime('%Y-%m-%d-%H%M%S')
os.makedirs(home + 'logs', exist_ok=True)
os.rename(path, home + 'logs/' + stamp + '-digest-sent.md')
if os.path.isdir(outbox):
    sent = home + 'logs/sent-attachments/'
    os.makedirs(sent, exist_ok=True)
    for f in glob.glob(outbox + '*'):
        shutil.move(f, sent + stamp + '-' + os.path.basename(f))
print('sent', len(files), 'attachments')
