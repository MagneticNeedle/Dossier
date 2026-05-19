---
description: Draft a short "why this company" note (80–150 words) from a JD plus optional company URL and one specific finding.
argument-hint: <paste JD text> | <path/to/jd.txt>
---

You are drafting a "What interests you about working for this company?" note for Vibhakar Solanki, grounded in (a) the JD, (b) optionally the company's own website copy, (c) optionally one specific thing the user found outside the JD, and (d) the two resume YAMLs as the **sole source of truth** for his experience. Do not invent experience that isn't in the YAMLs. Do not fake familiarity with tech Vibhakar has no experience with.

## Step 1 — Resolve the JD

The user-provided argument is:

```
$ARGUMENTS
```

- If the argument is non-empty:
  - If it looks like a file path (single line, no prose, file exists on disk), read it with the Read tool and treat its contents as the JD.
  - Otherwise, treat the argument verbatim as the JD text.
- If the argument is empty or whitespace only, fall back to the clipboard:
  - Run `pbpaste` via the Bash tool to grab clipboard contents.
  - Sanity-check: the clipboard looks like a JD if it is at least ~400 characters AND contains at least one JD-flavored signal (case-insensitive match against any of: `responsibilities`, `requirements`, `qualifications`, `experience`, `you'll`, `we're looking`, `role`, `engineer`, `developer`).
  - If it fails the check, print a one-line warning ("Clipboard doesn't look like a JD, paste one or pass a file path.") and stop.
  - If it passes, tell the user once ("Using JD from clipboard (N chars).") and use the clipboard contents as the JD.

## Step 2 — Ask the user (both optional)

In a single AskUserQuestion turn, ask for:

1. **Company URL** (optional) — homepage, about, or careers page.
2. **One specific thing you found about them outside the JD** (optional) — a recent launch, a founder blog post, a Twitter/LinkedIn thread, their stance on a technical or product problem, traction numbers from Wellfound, etc.

Rules:
- If the user skips either or both, accept and move on.
- If the user provides a generic non-specific hook ("their website", "they seem cool", "looks interesting"), push back **once** and ask for a specific. If the second answer is still generic, treat the hook as skipped.

## Step 3 — Fetch the URL (only if provided)

If a URL was given, WebFetch it and extract:
- What the product actually does, in their own words (not marketing fluff).
- Any concrete stage / size / growth signals: Series stage, headcount, growth multiples, "hiring our first X", customer counts, traction numbers.

If the page is pure marketing with no substance, note that in the trace and lean on JD + hook.

## Step 4 — Load resume data

Run `scripts/relevant_resume.py` against each YAML to get the stripped sections (drops rendercv `design`/`locale`/`settings` noise):

- `uv run scripts/relevant_resume.py sources/resumes/SDE2_CV.yaml` — **impact-specific** framing (business outcomes, scale numbers, customer acceptance).
- `uv run scripts/relevant_resume.py sources/resumes/SDE2_CV_v2.yaml` — **tech-specific** framing (named tools, architectural depth, lower-level engineering choices).

The script prints YAML to stdout containing only `cv.sections` (experience / projects / skills / education).

Framing rule: product/biz-flavored JD → pull from impact YAML; systems/AI-flavored JD → pull from tech YAML; mixed JD → mix.

## Step 5 — Infer team shape, then confirm

From the JD + URL signals, classify the company as one of:

- **Small team** — founding eng, < ~20 people, "wear many hats" language, early-stage funding.
- **Scaling fast** — Series B+, strong growth numbers, "ship fast" language, rapid headcount growth.
- **Both** — small team that's also scaling fast.
- **Neither** — established / steady-state, or no signal either way.

State your read in one short line ("Reading this as: small team, scaling fast — sound right?") and wait for the user to confirm or correct before drafting. If the user just says "go" or confirms, proceed.

## Step 6 — Draft the note

A single paragraph, **80–150 words**, that:

- Opens with the specific thing the user found (their hook) and **why it lands with Vibhakar** — connect it to something concrete from the YAMLs. If no hook was provided, lead with the strongest specific signal from the URL fetch or JD instead.
- Connects his background to the role: one or two grounded fit points pulled from the YAMLs.
- If **small team**: one line on his range across AI / backend / infra, grounded in YAML bullets.
- If **scaling fast**: one line on operating at pace — pull volume / ownership signals from YAML bullets.
- If **both**: blend the two.
- If **neither**: skip that beat; focus on fit.
- Closes naturally. No "I would be honored…" type closings.

**Hard rules:**

- Conversational, not corporate. "I want to work on X because Y" is fine. "I would be honored to have the opportunity to contribute to…" is not.
- No generic praise ("great culture", "innovative team", "exciting mission").
- No leading with perks, salary, equity, or remote work.
- Don't make it mostly about Vibhakar — the question is about *them*.
- Don't fake familiarity with tech he has no experience with (check the YAMLs).
- Don't restate the resume verbatim — pull a thread, don't list bullets.
- No buzzwords: "disruptive", "synergy", "passionate about innovation".
- Word count is hard: under 80 or over 150 → redraft before showing.

## Step 7 — Sanitize

Before showing the note, pipe the paragraph through `scripts/no_emdash.py` to replace em-dashes (—) with `, `:

```
printf '%s' "$NOTE" | uv run scripts/no_emdash.py
```

Use the sanitized output as the final paragraph. Do not sanitize the **What I used** section.

## Step 8 — Output

Print the output below, and also pipe the sanitized paragraph (just the note, not the **What I used** section) into the clipboard:

```
printf '%s' "$NOTE" | pbcopy
```

Output in this order, nothing else:

### Note

The sanitized paragraph.

### What I used

2–3 lines max:
- **Hook:** which user-provided signal you led with (or "no external hook — note is weaker, rerun with one for a stronger result" if both URL and hook were skipped).
- **YAML bullet(s):** which bullet(s) you pulled from, and which YAML (impact vs tech).
- **Team shape:** small / scaling / both / neither.
