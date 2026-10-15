# 3. Read-only mailbox helper

> Create scripts/get_verification.py, a read-only IMAP helper for the job-agent mailbox. Usage: python3 scripts/get_verification.py --from-domain <domain> [--subject-contains <text>] [--minutes 15] [--wait 120], plus --list-recent.
> 1. Load JOB_EMAIL and JOB_EMAIL_APP_PASSWORD from ~/job-agent/secrets.env only. Never accept them on the command line and never print them, even in error messages.
> 2. Connect to imap.gmail.com with IMAP4_SSL, select the mailbox read-only, and fetch with BODY.PEEK. Never send, reply, forward, move, flag, or delete anything.
> 3. Consider only messages from the last N minutes whose sender domain equals --from-domain or is a subdomain of it. Poll every 10 seconds until a match arrives or --wait seconds pass.
> 4. Output only: (a) verification or confirmation links whose host belongs to the sender's domain family or a known applicant-system domain (myworkdayjobs.com, oraclecloud.com, greenhouse.io, lever.co, ashbyhq.com, icims.com, smartrecruiters.com), and (b) 4 to 8 digit codes near words like "code" or "verify". When the subject mentions a security or verification code, also print a single 6 to 10 character letters-and-digits code that is on a line by itself or directly follows the word code. Never print the email body, other addresses, or links on unrelated hosts. If nothing matches, print NONE and exit 1.
> 5. --list-recent prints only the sender domain, the subject truncated to 80 characters, and the received time of the last 5 messages.
> 6. chmod 700 the script. Update the Accounts and email section of CLAUDE.md: the mailbox may only be read through this script, only links printed by the script may be opened, and a link whose host does not match the employer or applicant-system domain must never be opened.
> Then test it with --list-recent and show me the output.

To test the matching without waiting for a real email, send yourself a message from another address with the subject "verification test" and run the script with `--from-domain gmail.com --subject-contains test`. It should print only the sender domain and subject in list mode, never the body.
