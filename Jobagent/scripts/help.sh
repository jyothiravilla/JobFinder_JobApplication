#!/bin/bash
cat << 'TXT'
JOB AGENT COMMANDS  (type these at the server prompt, not inside Claude)

LOOK
  a-jobs              status counts, what is waiting for approval, what needs review (with reasons), what is applied
  a-new               postings not yet filled, best fit first
  a-filled [words]    read what the agent filled out (q to exit). Example: a-filled Acme
  a-running           is a run active right now
  a-status            health of recent runs, flags login problems
  a-log               last lines of the newest approval or run log
  a-login             prints OK if the Claude login works for scheduled runs

DO
  a-fill [fit] [n]    fill n new postings up to the last page, never submits. Default 60 5. Example: a-fill 70 5
  a-approve words     approve and submit waiting applications one after another. Example: a-approve Acme Beta  or  a-approve all
  a-mark words status set a status by hand. Example: a-mark Acme manual   (manual = I apply myself, applied, new, skipped_ineligible)

CONTROL
  a-review / a-auto   review mode (waits for your approval) or auto mode (submits by itself)
  a-pause / a-resume  turn the scheduled apply job off or on
  a-stop              stop every run now (only if clearly stuck)

STATUSES
  new = found, not filled     ready_for_review = filled, waiting for you     needs_review / blocked = stopped, see reason in a-jobs
  manual = you apply by hand  applied = submitted                            skipped_ineligible = does not qualify

SCHEDULE (server time, example)
  5:00 discover companies   6:30 find jobs (digest email)   9:00 apply (fills up to 3, report email)

EVERY DAY
  1 a-running   2 read the emails   3 a-jobs   4 a-filled   5 a-approve ...   6 a-jobs later to confirm

RULES
  One run at a time.  Count an application as submitted only when the result email shows the confirmation text.
  SSH timeout = your network changed: set the cloud firewall SSH rule to your current IP.   Guide: docs/usage.md
TXT
