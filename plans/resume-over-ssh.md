# SSH resume deployment — local image + scaffolding

## Context

The cf-workers deployment serves the resume over HTTP at `resume.vibhakar.dev`. The user wants a parallel deployment target where `ssh <host>` prints the resume in a styled terminal view and exits. SSH is TCP-only, so it can't piggyback on Cloudflare Workers — it needs a long-running process, packaged as a Docker container.

**Scope for this plan:**
- Code changes (scaffolding around Go binary).
- A working **local** Docker image + `docker compose up` that you can hit with `ssh -p 2222 localhost`.
- The Go SSH server itself — **you write it** as a learning exercise. The agent must NOT scaffold `main.go`, `go.mod`, struct definitions, or any Go source.

**Deferred to follow-up plans (not addressed here):**
- Moving the cf-worker (HTTP) deployment off Cloudflare onto the VPS.
- Cloudflare proxy / SSL conflict on `resume.vibhakar.dev`.
- Resolving the `openssh-server already on :22` conflict on the VPS (second IP vs sshpiper vs port swap).
- Production deploy mechanism (GHCR push + Watchtower likely).
- DNS choices for the SSH hostname.

This plan ships a container that runs locally on `:2222` and is **production-deploy-ready in shape** but not wired to the VPS yet.

## Approach

A small **Go binary** (user writes) using **`charmbracelet/wish`** (SSH server framework) + **`charmbracelet/lipgloss`** (ANSI styling). On connect, the server parses one of the two resume YAMLs and renders it with lipgloss directly to the SSH session, then closes the session.

Anyone may connect: any pubkey accepted (mirrors `ssh git.charm.sh`), plus a keyboard-interactive auth that accepts with no challenges so clients without a key still get in.

Username routes to variant, matching the cf-worker's `/tech` and `/impact`:

| SSH command | Variant |
|---|---|
| `ssh -p 2222 tech@localhost` | `sources/resumes/SDE2_CV_v2.yaml` |
| `ssh -p 2222 impact@localhost` | `sources/resumes/SDE2_CV.yaml` |
| `ssh -p 2222 localhost` (defaults to current user) | tech (default) |
| any other username | tech, with a one-line hint |

## Folder layout

```
deployments/ssh/
├── (Go source — user writes)
├── sources/               # YAMLs copied here by publish-ssh stage; gitignored
├── Dockerfile             # the agent CAN write this
├── docker-compose.yml     # the agent CAN write this
├── .dockerignore          # the agent CAN write this
├── .gitignore             # the agent CAN write this (ignore sources/, host_key/)
└── README.md              # the agent CAN write this
```

## Design constraints the Go code must satisfy

These are requirements/contracts, not code. The agent must not implement them.

- **Auth — "allow everyone":**
  - Pubkey callback returns `true` for every key.
  - Keyboard-interactive callback returns success with zero challenges.
  - Plain "no auth" isn't a valid SSH option; the two callbacks above are the canonical workaround.
- **Host key persistence:** load/generate at `/data/host_key` so restarts don't trigger "host key changed" warnings on clients. The compose volume mounts `/data`.
- **Listen port:** binary listens on `:2222` (unprivileged so it can run as non-root inside the container).
- **Render-and-exit:** middleware writes the styled output, returns, and Wish closes the session. Must work for both PTY (`ssh host`) and non-PTY (`ssh -T host`, `ssh host | cat`) sessions.
- **Width-aware styling:** read PTY width if present, fall back to ~100 cols, clamp lipgloss containers so narrow terminals don't wrap awkwardly.
- **Color degradation:** lipgloss handles `$TERM`/`COLORTERM` → 256/16/no-color automatically; no manual handling needed.
- **YAML source:** the two `SDE2_CV*.yaml` files. The Go program only needs the fields actually displayed (header, summary, experience, projects, skills, education) — no need to mirror the full rendercv schema.

## What the agent WILL write

### 1. `deployments/ssh/Dockerfile` — multi-stage

- **Builder stage:** `golang:1.23-alpine`, copies `go.mod`/`go.sum`, runs `go mod download`, copies source + `sources/*.yaml`, builds a static binary (`CGO_ENABLED=0`).
- **Runtime stage:** `gcr.io/distroless/static:nonroot`, copies the binary + YAMLs, exposes `2222`, runs as non-root.

### 2. `deployments/ssh/docker-compose.yml` — single service

- Port mapping `2222:2222` (host:container). Plain numeric default per user's choice; production-port concern deferred.
- Named volume mounted at `/data` for host-key persistence (`dossier-ssh-data:/data`).
- `restart: unless-stopped`.
- No image registry tag yet — uses local `build: .`. Tag/registry choice belongs to the deploy follow-up plan.

### 3. `deployments/ssh/.dockerignore`

- Excludes everything except `*.go`, `go.mod`, `go.sum`, `sources/*.yaml`.
- Explicit so the build context stays small and predictable.

### 4. `deployments/ssh/.gitignore`

- Ignores `sources/` (populated by `publish-ssh`, not source-of-truth) and any local `host_key`/data files if the user runs outside docker.

### 5. `deployments/ssh/README.md`

Covers, in this order:
- One-paragraph "what this is" and the username routing table.
- Local build: `cd deployments/ssh && docker build -t dossier-ssh .` (preceded by `uv run dossier.py publish-ssh` from repo root).
- Local run: `docker compose up -d` then `ssh -p 2222 localhost`.
- Why port 2222 by default (avoids colliding with any existing sshd on dev/VPS machines).
- Host-key persistence: where it lives, why it matters.
- Pointer to `charmbracelet/wish` and `charmbracelet/lipgloss` docs for the Go implementation the user is writing.
- A "Deploying to production" stub section that says: *deferred — see follow-up plan for VPS migration, DNS, port-22 routing, and Watchtower-based pull deploys*.

### 6. `dossier.py` — new stage `publish-ssh`

One stage, parallel to `publish-pdf`. ~6 lines.

```python
SSH_DIR = REPO_ROOT / "deployments" / "ssh"

@stage("publish-ssh")
def _publish_ssh() -> None:
    """Copy resume YAMLs into deployments/ssh/sources/ for the Dockerfile to COPY in."""
    dest = SSH_DIR / "sources"
    dest.mkdir(exist_ok=True)
    shutil.copyfile(RESUME_YAML_TECH, dest / RESUME_YAML_TECH.name)
    shutil.copyfile(RESUME_YAML_IMPACT, dest / RESUME_YAML_IMPACT.name)
```

**No `deploy-ssh` stage in this plan** — production deploy is deferred.

## Precondition (before any stage runs)

Verify the working tree is on a branch **other than `main`** before making any edits or commits. Concretely:

```bash
branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$branch" = "main" ] || [ "$branch" = "master" ]; then
  echo "refusing to work on $branch; create a feature branch first (e.g. git switch -c feat/ssh-deployment)" >&2
  exit 1
fi
```

If the check fails, **stop and ask the user** to switch to a feature branch (suggest `feat/ssh-deployment`). Do not auto-create the branch.

## Stages — each stage is one atomic commit

The agent's work breaks into four small commits, in order. User-authored Go code lives in separate commits the user makes; the agent does not touch those.

### Stage 1 — `chore(ssh): scaffold deployments/ssh/ and add publish-ssh pipeline stage`

Files:
- `dossier.py` — add `SSH_DIR` constant and the `publish-ssh` stage function.
- `deployments/ssh/.gitignore` — ignore `sources/`, local host_key files, and Go build artifacts.

Verify before commit: `uv run dossier.py publish-ssh` runs cleanly and creates `deployments/ssh/sources/SDE2_CV*.yaml`.

### Stage 2 — `feat(ssh): add Dockerfile and dockerignore for SSH deployment`

Files:
- `deployments/ssh/Dockerfile` — multi-stage as described above.
- `deployments/ssh/.dockerignore` — allowlist `*.go`, `go.mod`, `go.sum`, `sources/*.yaml`.

Verify before commit: `docker build` is *not* required to succeed yet (Go source doesn't exist yet) — but the Dockerfile should be syntactically valid (`docker build --check .` or equivalent passes).

### Stage 3 — `feat(ssh): add docker-compose for local SSH deployment`

Files:
- `deployments/ssh/docker-compose.yml` — `build: .`, `2222:2222`, named volume `dossier-ssh-data:/data`, `restart: unless-stopped`.

Verify before commit: `docker compose config` validates without errors.

### Stage 4 — `docs(ssh): add README for SSH deployment`

Files:
- `deployments/ssh/README.md` — content described in the "What the agent WILL write" section.

Verify before commit: links resolve, fenced code blocks render, commands shown are the same ones used in the Verification section below.

### User stages (informational — agent does not write these)

After Stage 4 the user writes their Go code in one or more of their own commits (`feat(ssh): wish-based SSH server`, etc.), then the verification steps below run end-to-end.

### Stage 5 (post-implementation) — `docs: mention SSH deployment in top-level README`

Triggered by the reminder section at the end of this plan. The agent makes this commit only after the user confirms the SSH deployment is working end-to-end.

## Critical files (existence map)

| Path | Who writes it |
|---|---|
| `deployments/ssh/main.go` (and other `.go`) | **User** |
| `deployments/ssh/go.mod`, `go.sum` | **User** (`go mod init` + `go get`) |
| `deployments/ssh/Dockerfile` | Agent |
| `deployments/ssh/docker-compose.yml` | Agent |
| `deployments/ssh/.dockerignore` | Agent |
| `deployments/ssh/.gitignore` | Agent |
| `deployments/ssh/README.md` | Agent |
| `dossier.py` (`publish-ssh` stage, ~6 lines) | Agent |

## Files to read for context (read-only inputs)

- `/Users/vverse/projects/dossier/sources/resumes/SDE2_CV_v2.yaml` — tech YAML schema
- `/Users/vverse/projects/dossier/sources/resumes/SDE2_CV.yaml` — impact YAML schema
- `/Users/vverse/projects/dossier/deployments/cf-workers/worker.js` — reference for variant routing and metadata so SSH output stays consistent with web
- `/Users/vverse/projects/dossier/dossier.py` — mirror the style of `publish-pdf` when adding `publish-ssh`

## Verification (once user finishes Go code)

1. **YAML publish:** `uv run dossier.py publish-ssh` → both YAMLs appear under `deployments/ssh/sources/`.
2. **Image build:** `cd deployments/ssh && docker build -t dossier-ssh .` → image builds clean.
3. **Run:** `docker compose up -d` → logs show "listening on :2222".
4. **Connect (default):** `ssh -p 2222 -o StrictHostKeyChecking=no localhost` → tech resume renders, session exits 0.
5. **Connect (variant):** `ssh -p 2222 -o StrictHostKeyChecking=no impact@localhost` → impact resume renders.
6. **No-TTY path:** `ssh -p 2222 -T localhost | head` → readable text (or stripped ANSI) without garbled escapes.
7. **No-key client:** `ssh -p 2222 -o BatchMode=yes -o PreferredAuthentications=keyboard-interactive,publickey localhost` → still connects (keyboard-interactive succeeds with zero challenges).
8. **Host-key persistence:** `docker compose restart`, reconnect → no "host key changed" warning on the client.

## Post-implementation reminder

Once the SSH deployment is working end-to-end, **update the top-level `README.md`** at `/Users/vverse/projects/dossier/README.md` to:
- Mention the new SSH deployment target alongside the cf-workers one.
- Refresh the pipeline diagram / stage list to include `publish-ssh`.
- Add a usage line showing `ssh -p 2222 localhost` (or the eventual production hostname once the follow-up VPS plan lands).
