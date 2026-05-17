---
description: Evaluate whether a job description is a fit using the two resume YAMLs; recommend which version to send and surface gaps, missing certs, and interview prep.
argument-hint: <paste JD text> | <path/to/jd.txt>
---

You are evaluating whether a given job description (JD) is a fit for Vibhakar Solanki, using the two resume YAMLs in this repo as the **sole source of truth** for his experience. Do not invent experience that isn't in the YAMLs.

## Step 1 — Resolve the input

The user-provided argument is:

```
$ARGUMENTS
```

- If the argument is empty or whitespace only, ask the user to paste a JD or pass a file path, then stop.
- If the argument looks like a file path (single line, no prose, file exists on disk), read it with the Read tool and treat its contents as the JD.
- Otherwise, treat the argument verbatim as the JD text.

## Step 2 — Load the resumes

Read both YAMLs (do not edit them):

- `sources/resumes/SDE2_CV.yaml` — **impact-specific** framing (business outcomes, scale numbers, customer acceptance). Renders to `impact-specific-sde2-resume.pdf`.
- `sources/resumes/SDE2_CV_v2.yaml` — **tech-specific** framing (named tools, architectural depth, lower-level engineering choices). Renders to `tech-specific-sde2-resume.pdf`.

The `cv.sections.experience`, `cv.sections.projects`, `cv.sections.skills`, and `cv.sections.education` blocks are what matters. Ignore `design`, `locale`, and `settings`.

## Step 3 — Analyze and produce the report

Be candid, not cheerleading. A weak fit must say so. Cite YAML evidence (quote the relevant bullet) whenever you claim a strength. Produce the following markdown report — every section is required.

### Verdict

One of **Strong fit** / **Marginal fit** / **Skip**, followed by a single one-line reason that captures the most load-bearing factor in either direction.

Rough rubric:
- **Strong** — most must-haves covered by lived YAML evidence; level matches; domain matches.
- **Marginal** — half the must-haves covered, or level/domain is adjacent but not exact; would need tailoring or a strong narrative.
- **Skip** — core stack/domain/level mismatch (e.g., role wants 8+ yrs Swift/iOS), or hard requirements absent.

### JD signals

Extract from the JD:
- **Must-haves**: hard requirements (years, named tools, domain expertise, location, clearance, etc.).
- **Nice-to-haves**: bonus skills.
- **Level/scope**: IC level, team size, ownership expected.
- **Domain**: AI/ML, infra, backend, data, frontend, etc.
- **Red flags** (if any): unrealistic seniority bar, narrow legacy stack, on-call expectations, etc.

### Coverage

Two columns or two bulleted lists:
- **Matched** — each JD requirement that the YAMLs back up, with a short quote from the matching bullet (and which YAML it came from).
- **Missing** — JD requirements not present in either YAML.

### Resume to send

Recommend exactly one of `SDE2_CV.yaml` (impact-specific) or `SDE2_CV_v2.yaml` (tech-specific). Cite the JD signal that drove the choice.

Heuristic:
- JD leans on **named tools, architectural depth, deep-IC framing** → tech-specific (`SDE2_CV_v2.yaml`).
- JD leans on **ownership, scale, customer outcomes, generalist/early-team energy** → impact-specific (`SDE2_CV.yaml`).
- When it's a coin-flip, prefer impact-specific and say so.

### Gaps

Honest red flags (missing requirements, level mismatch, domain stretch). For each, suggest how to address it (existing YAML bullet to lean on, adjacent experience to bridge with, or "acknowledge and move on").

### Tailoring

Optional concrete tweaks to the chosen resume (rephrase a bullet, swap an emphasis, surface a project). Only suggest tweaks that are accurate to the candidate's actual experience — do not fabricate.

### Missing certifications

**Always include this section, even on a Skip verdict.**

Scan the JD for any certifications it names — e.g., AWS Solutions Architect, AWS Developer, GCP Professional Data Engineer, CKA, CKAD, Terraform Associate, Security+, CISSP, PMP, Scrum Master, Azure Fundamentals, etc. For each cert mentioned in the JD that is **not** in either resume YAML (check `cv.sections.skills` and any other section), list it with whether it was framed as required vs. preferred in the JD.

If the JD lists no certifications at all, write exactly: `JD lists no certifications.`

---

Output the report directly — no preamble like "here is your report." Use the section headings above verbatim.

For cover-letter / recruiter-screen highlights run `/yap-for`; for interview prep run `/prep-for`.
