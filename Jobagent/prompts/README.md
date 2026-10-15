# Prompts

Three helper scripts are generated with Claude Code instead of being shipped here, because they depend on your resume template. Run the prompts in order from `~/job-agent` in a Claude Code session (`claude --permission-mode auto`), read the code Claude writes, and run the tests it proposes.

| Order | File | Creates |
|---|---|---|
| 1 | `01-resume-master-and-template.md` | `resume_master.md` and `resume_template.html` |
| 2 | `02-verify-resume-and-build.md` | `scripts/verify_resume.py` and `scripts/build_resume.sh` |
| 3 | `03-get-verification.md` | `scripts/get_verification.py` |
| 4 | `04-first-tests.md` | Supervised tests of each stage |

After generating them, lock the master with `chmod 444 resume_master.md`, and review each script yourself. These scripts are security controls, so do not trust them without tests.
