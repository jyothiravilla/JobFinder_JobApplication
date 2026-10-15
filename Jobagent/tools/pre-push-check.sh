#!/bin/bash
# Scan this repository for personal data and secrets before you publish it.
# Usage: tools/pre-push-check.sh [private-terms-file]
# The optional file holds your own names and private terms, one per line (keep it OUTSIDE the repo).
cd "$(dirname "$0")/.." || exit 1
FAIL=0
bad() { echo "!! $1"; FAIL=1; }

echo "Checking for files that must never be committed..."
for f in secrets.env .env .claude_token.env accounts.csv profile.md resume_master.md resume_template.html jobs.csv companies.csv tracker.csv digest.md scripts/banned_terms.txt; do
  [ -e "$f" ] && bad "private file present: $f"
done
for d in resumes review outbox logs backup-names; do
  [ -d "$d" ] && bad "private folder present: $d"
done
PDFS=$(find . -path ./.git -prune -o -name '*.pdf' -print)
[ -n "$PDFS" ] && bad "PDF files present: $PDFS"

echo "Scanning file contents..."
EX=(--exclude-dir=.git --exclude=pre-push-check.sh)
scan() { # label, regex, [filter-out regex]
  local hits
  if [ -n "$3" ]; then hits=$(grep -rInE "${EX[@]}" -e "$2" . | grep -vE "$3"); else hits=$(grep -rInE "${EX[@]}" -e "$2" .); fi
  [ -n "$hits" ] && { bad "$1"; echo "$hits" | cut -c1-170; }
}
scan "Claude or API token" 'sk-ant-[A-Za-z0-9_-]{10,}'
scan "AWS access key" 'AKIA[0-9A-Z]{16}'
scan "GitHub token" 'gh[pousr]_[A-Za-z0-9]{20,}'
scan "private key block" 'BEGIN [A-Z ]*PRIVATE KEY'
scan "phone number" '\b[0-9]{3}[-. ][0-9]{3}[-. ][0-9]{4}\b'
scan "email address (only example domains and no-reply allowed)" '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' 'example\.(com|org|net)|noreply\.github\.com|your-|where-you-read'
scan "IPv4 address" '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' '0\.0\.0\.0|127\.0\.0\.1'
scan "password-like value in a secrets line" '^(JOB_EMAIL_APP_PASSWORD|CLAUDE_CODE_OAUTH_TOKEN)=[A-Za-z0-9_-]{12,}' '16lettersnospaces'

if [ -n "$1" ]; then
  if [ -f "$1" ]; then
    echo "Scanning for your private terms from $1..."
    while IFS= read -r term; do
      [ -z "$term" ] && continue
      hits=$(grep -rInEi "${EX[@]}" -e "$term" .)
      [ -n "$hits" ] && { bad "private term found: $term"; echo "$hits" | cut -c1-170; }
    done < "$1"
  else
    bad "terms file not found: $1"
  fi
fi

echo
if [ "$FAIL" -eq 0 ]; then echo "OK: nothing suspicious found. Still read 'git status' before you push."; else echo "FAILED: fix the items above before publishing."; fi
exit $FAIL
