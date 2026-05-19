---
description: Generate Must-skim / Refresher / Deep-dive interview prep for a JD using the tech-specific resume YAML.
argument-hint: <paste JD text> | <path/to/jd.txt>
---

You are generating interview prep for Vibhakar Solanki against a given job description (JD), using the tech-specific resume YAML in this repo as the **sole source of truth** for what he has actually shipped. Do not invent experience that isn't in the YAML.

## Step 1 — Resolve the input

The user-provided argument is:

```
$ARGUMENTS
```

- If the argument is empty or whitespace only, ask the user to paste a JD or pass a file path, then stop.
- If the argument looks like a file path (single line, no prose, file exists on disk), read it with the Read tool and treat its contents as the JD.
- Otherwise, treat the argument verbatim as the JD text.

## Step 2 — Load the resume

Run `scripts/relevant_resume.py` against the tech-specific YAML to get the stripped sections (drops rendercv `design`/`locale`/`settings` noise):

- `uv run scripts/relevant_resume.py sources/resumes/SDE2_CV_v2.yaml` — **tech-specific** framing (named tools, architectural depth, lower-level engineering choices).

Do **not** load `SDE2_CV.yaml` (impact-specific) — interview prep is scoped to the tech-specific resume only.

The script prints YAML to stdout containing only `cv.sections` (experience / projects / skills / education).

## Step 3 — Output

Output **only** the Interview prep section — no other sections, no preamble.

### Interview prep

Split into three buckets:

- **Must-skim** — gaps where the JD expects something the candidate hasn't shipped (or has shipped only an adjacent variant). Example: JD wants Kafka, candidate has SNS/SQS — skim Kafka semantics, partitions, consumer groups.
- **Refresher** — things the candidate has shipped but should re-load into working memory before the interview. Cite the YAML bullet that earns the topic.
- **Deep-dive** — concepts likely to show up in a system-design or architecture round given the role's domain (e.g., for an AI infra role: token-level latency vs. throughput tradeoffs, batching strategies, retry/backoff under rate limits).

Keep each item to a single line. Prefer 3–6 items per bucket; do not pad.
