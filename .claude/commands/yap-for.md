---
description: Draft 3–5 cover-letter / recruiter-screen highlights from a JD using the two resume YAMLs.
argument-hint: <paste JD text> | <path/to/jd.txt>
---

You are drafting cover-letter / recruiter-screen talking points for Vibhakar Solanki against a given job description (JD), using the two resume YAMLs in this repo as the **sole source of truth** for his experience. Do not invent experience that isn't in the YAMLs.

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

- `sources/resumes/SDE2_CV.yaml` — **impact-specific** framing (business outcomes, scale numbers, customer acceptance).
- `sources/resumes/SDE2_CV_v2.yaml` — **tech-specific** framing (named tools, architectural depth, lower-level engineering choices).

The `cv.sections.experience`, `cv.sections.projects`, `cv.sections.skills`, and `cv.sections.education` blocks are what matters. Ignore `design`, `locale`, and `settings`.

## Step 3 — Output

Output **only** the Talking points — no other sections, no preamble.

### Talking points

3–5 highlights, each one sentence, framed for use in a cover letter or recruiter screen. Each one should map to a JD requirement and quote-or-paraphrase a YAML bullet (note which YAML the bullet came from). Do not fabricate experience.
