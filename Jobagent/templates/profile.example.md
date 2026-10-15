# Applicant Profile (source of truth for all application forms)

GLOBAL RULE: if a field is not covered here, do NOT guess or invent. Mark the job needs_review in tracker.csv and move on. Never claim skills, degrees, or experience that are not listed here. Everything below must be true.

## Contact
Legal first name: <LEGAL FIRST NAME>
Legal last name: <LEGAL LAST NAME>
Preferred first name: <PREFERRED NAME>
Name rules: use the legal name wherever a form asks for first name, last name, or full legal name, even if the field is prefilled. Use the preferred name only in preferred-name or nickname fields. Leave middle name blank unless you list one here.
Email: <DEDICATED JOB-SEARCH EMAIL>
Phone: <PHONE>
City/State: <CITY, STATE>
Mailing address: <STREET, CITY, STATE ZIP, COUNTRY>
LinkedIn: <URL or leave out>
Portfolio: <URL or leave out>
GitHub: <URL, or "not provided: leave blank, never invent a URL">

## Education
- <SCHOOL>: <DEGREE EXACTLY AS ON YOUR RESUME>, <FIELD>. Expected graduation: <MONTH YEAR>.
- <SCHOOL>: <DEGREE>, <FIELD>. Graduated <MONTH YEAR>.
Degree wording on forms: use exactly the degrees above. Do not state a minor or concentration unless it is listed here.
GPA: <do not disclose / value>. Optional field: leave blank if "do not disclose". Required field: needs_review.
Field of study on forms: <FIELD>.

## Skills (must match the Skills section of resume_master.md)
<Languages, tools, frameworks, platforms>

## Work history (must match resume_master.md)
1. <TITLE>, <EMPLOYER>, <CITY, STATE>, <MONTH YEAR> to <MONTH YEAR>
   <Generic description. No employer-confidential product, device, or part names.>
Reason for leaving (each role): <for example: internship ended>
Eligible for rehire: <Yes/No>
Supervisor names or contact info: <not provided: free-text field "Available upon request"; required structured field: needs_review>
References: <not provided: do not invent names. If a form requires named references, needs_review>

## Work authorization and sponsorship
This section must describe your real situation and be answered truthfully. The example below is for a student on F-1 who will work on OPT and STEM OPT only. Adapt it. This is not legal or immigration advice.
Citizenship: <COUNTRY>
Example (US roles):
- Authorized to work in the US: Yes, via F-1 OPT and STEM OPT after graduation.
- Requires sponsorship now (to begin work): No.
- Requires sponsorship in the future: <No or Yes, whichever is true for you>.
- Unlimited, unrestricted, permanent, or indefinite authorization to work: No.
- US citizen or permanent resident: No.
- Any other question naming a visa or status type, and F-1/CPT/OPT reporting questions: needs_review until an answer is added here.
Example (non-US roles): not authorized to work in that country. Requires employer work-visa sponsorship from the start. Apply only if the posting, careers page, or an official sponsor register shows the employer sponsors.

## Eligibility filters
- Skip postings that explicitly refuse <your situation, for example OPT or F-1 candidates>.
- Skip roles requiring <US citizenship / permanent residency / security clearance / export-control eligibility> if these apply to you.
- A posting that only says the employer does not sponsor visas is <not a disqualifier / a disqualifier> for you.
- E-Verify: record E-Verify status when a page states it (needed for the STEM OPT extension).

## Job preferences
Employment type: Full-time
Target roles: <list>
Earliest start date: <date>
Relocation: <where>
Travel: <percent>
Work arrangement: <remote / hybrid / onsite / no preference>
Salary expectation: <range>, negotiable
Pay rule: <for example: apply regardless of posted pay / skip below $X>
Salary form rule: optional field = leave blank or "Negotiable"; single number required = <NUMBER>; range accepted = <RANGE>.

## Voluntary self-identification (EEO)
Race/ethnicity: <answer or "decline to self-identify">
Hispanic or Latino: <Yes / No / decline>
Gender: <answer or decline>
Veteran status: <answer>
Disability status: <answer>
Rule: if a form offers only a combined race and ethnicity list, choose <your option>.

## Other standard answers
Age 18 or older: <Yes>
Non-compete or non-solicitation agreement restricting work for another employer: <No>
If a question asks about ANY confidentiality or NDA obligation (not only ones restricting the new job): do not auto-answer, mark needs_review.
Politically exposed person (PEP) declarations: answer only when the wording clearly matches, and only with true answers: <related to or associated with a PEP: ...; current or former PEP: ...; close relationship with an employee of the company: ...>. Any other legal or compliance declaration: needs_review.
Consent to employer use of AI tools in recruiting or screening: <Yes/No>
How did you hear about us: Company website (or the posting source)
Cover letter: draft per application from resume_master.md and this profile only. Do not store here.
