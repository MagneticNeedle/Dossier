# Dossier

> Your work history, automatically turned into professional documents.

Dossier collects your git commits, code diffs, and Linear tasks to automatically generate a brag document, a one-page resume, and a multi-page CV — then publishes them to the web via GitHub Pages.

---

## How it works

```
Git commits + diffs  ──┐
                        ├──▶  Data collector  ──▶  AI synthesizer  ──▶  Document generator
Linear tasks        ──┘                                                       │
                                                                               ▼
                                                              Brag doc / Resume / CV (PDF)
                                                                               │
                                                                               ▼
                                                                     GitHub Pages (pdf.js)
```

1. **Collect** — Walks every repository in your `/projects` directory, pulling commit messages and diffs. Simultaneously fetches all Linear issues you worked on via the Linear API.
2. **Synthesize** — Combines the raw data into structured context: what you shipped, what problems you solved, who you collaborated with.
3. **Generate** — Produces three documents using that context:
   - **Brag document** — 5–10 pages covering goals, projects, collaboration, mentorship, design/documentation contributions, company building, learning, and outside-of-work highlights.
   - **Resume** — One page, generated with [RenderCV](https://github.com/sinaatalay/rendercv).
   - **CV** — Multi-page, generated with [RenderCV](https://github.com/sinaatalay/rendercv).
4. **Publish** — A CI/CD pipeline builds the PDFs and deploys them to GitHub Pages, rendered in the browser via [pdf.js](https://mozilla.github.io/pdf.js/).

---

## Documents generated

### Brag Document
A structured self-review covering:
- Goals for this year and next
- Projects shipped
- Collaboration & mentorship
- Design & documentation
- Company building contributions
- What you learned
- Outside of work

### Resume (1 page)
Concise and ATS-friendly. Pulls the most impactful highlights from your brag document and git/Linear history.

### CV (multi-page)
Full career record with detailed project descriptions, technologies used, and measurable outcomes.

---

## Data sources

| Source | What it provides |
|--------|-----------------|
| Git repositories (`/projects/**`) | Commit messages, diffs, project names, activity timeline |
| Linear API | Tasks worked on, issue titles, cycle/project context |
| Generated brag document | Narrative context fed into resume and CV generation |

---

## Tech stack

- **Data collection** — Python scripts for git traversal and Linear API integration
- **Document generation** — [RenderCV](https://github.com/sinaatalay/rendercv) for resume and CV
- **CI/CD** — GitHub Actions for automated builds on a schedule or push
- **Web viewer** — GitHub Pages + [pdf.js](https://mozilla.github.io/pdf.js/) for in-browser PDF display

---

## Project structure

```
dossier/
├── collectors/
│   ├── git.py          # Walk /projects, extract commits and diffs
│   └── linear.py       # Fetch Linear tasks via API
├── generators/
│   ├── brag.py         # Generate brag document
│   ├── resume.py       # Generate one-page resume (RenderCV)
│   └── cv.py           # Generate multi-page CV (RenderCV)
├── web/                # GitHub Pages site (pdf.js viewer)
├── .github/
│   └── workflows/
│       └── generate.yml  # CI/CD pipeline
├── config.yaml         # Linear token, projects path, output settings
└── README.md
```

---

## Setup

```bash
git clone https://github.com/your-username/dossier
cd dossier
pip install -r requirements.txt
cp config.example.yaml config.yaml
# Add your Linear API token and projects path to config.yaml
python run.py
```

---

## CI/CD pipeline

The GitHub Actions workflow:
1. Runs on a schedule (e.g. weekly) or on push to `main`
2. Executes all collectors and generators
3. Commits updated PDFs to the `gh-pages` branch
4. GitHub Pages serves the pdf.js viewer pointing at the latest PDFs

---

## License

MIT
