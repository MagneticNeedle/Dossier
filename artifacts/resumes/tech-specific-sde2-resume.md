# Vibhakar Solanki's CV

- Phone: +91 81264 90848
- Email: [mail@vibhakar.dev](mailto:mail@vibhakar.dev)
- Website: [vibhakar.dev](https://vibhakar.dev/)
- GitHub: [MagneticNeedle](https://github.com/MagneticNeedle)
- LinkedIn: [vibhakarsolanki](https://linkedin.com/in/vibhakarsolanki)


# Experience
## **Founding Engineer**

*Remote*

*July 2026 – present*

*Bread Butter (bb.bio)*

- Own the AI stack end to end. Built **ai-core** from scratch, the **Python** monorepo behind bb.bio's AI features (**DSPy, LiteLLM, FastAPI**), running on **AWS ECS Fargate** with CI/CD on **GitHub Actions**.

- Built AI onboarding on **Gemini (Vertex AI)**, turning a creator's social media into 3 ready-to-publish portfolio drafts at **3.6s p50** for **under $0.01 per creator**, with **zero failed LLM calls** across 1,000+ production generations.

- Built an eval and **GEPA** prompt-optimization loop with **LLM-as-judge** on 52 real-user cases, lifting held-out quality **from 0.52 to 0.74** and cutting input tokens **66%**, with prompts, traces, and cost in **Langfuse**.

- Built the pipeline that imports creators' Instagram/YouTube posts into their portfolios and feeds AI drafts (**Node/TypeScript, BullMQ, Apify, S3**); caught a cost-tracking bug that under-reported scraping spend **~10x**.

- Designed and launched the bb.bio waitlist gate across 4 sign-in methods with bot protection, rate limiting, and an admin approval console (**Postgres, Redis, Cloudflare Turnstile**).

- Built creator analytics across the stack (**PostHog, Postgres, Next.js, d3**): fixed visitor tracking that left **100% of signups** unattributed, and shipped an audience dashboard backed by live APIs answering in **6-17 ms at 3x production volume**.



## **SDE 2**

*Remote*

*Jan 2026 – June 2026*

*VideoVerse*

- Designed and built **SmartThumbnails** from scratch in **Python/FastAPI** — reverse-engineered selection heuristics from client-published thumbnails into a layered pipeline: **PySceneDetect** scene segmentation, Laplacian sharpness filtering, and **DSPy**-structured Gemini for final selection. Reached **99.2% client acceptance** across the first 4,500 clips, replacing manual curation.

- Engineered a hybrid algorithmic + LLM pipeline for sibling-clip metadata back-fill and conflict detection, with batched updates that respect hard SLA windows — cut **SLA breaches by 25%**.

- Owned the **Datadog → OpenTelemetry** migration end to end: cross-service instrumentation and the collector pipeline.



## **SDE 1**

*Remote*

*Nov 2024 – Jan 2026*

*VideoVerse*

- Built an LLM eval harness from scratch (datasets, metrics, **Langfuse**), driving ground-truth analysis that lifted accuracy **from 68% to 92%**.

- Tuned and applied **DSPy MIPRO/COPRO** and **GEPA** prompt optimizers per service for thumbnail selection and metadata generation, raising task-level accuracy **from 30% to 87%**.

- Built a **FastAPI AI Gateway** for 5 AI services with token auth and **HTTPX** retry/backoff: **zero dropped jobs** across 50k+ clips/month.

- Engineered a **DSPy + Gemini** clip-ratings pipeline on **500k+ clips/month** with rate-limit-aware scheduling to meet SLAs.



## **Software Engineer Intern**

*Remote*

*June 2024 – Nov 2024*

*VideoVerse (joined via acquisition of LetsDive.io)*

- Built an ETL feed from **PostgreSQL/MongoDB** into **BigQuery** with **sub-100ms** latency, and rewrote the thumbnail service storage from **SQLite to PostgreSQL** with face-embedding ingestion.



# Projects
## **Battlefield Portal Library | [bfportal.gg](https://bfportal.gg/) | [https://gh.bfportal.gg](https://github.com/battlefield-portal-community/bfportal.gg/)**

*Jan 2022 – present*

- **Django/Jinja** CMS, currently migrating templates to **HTMX** for dynamic interactions without a JavaScript framework; **Cloudflare** edge caching, Docker containerization, and GitHub Actions CI/CD.



## **Gametools Network | [gametools.network](https://gametools.network/) | [github.com/community-network](https://github.com/community-network)**

*May 2022 – present*

- Open-source Stats API behind **Envoy** routing into a **Kubernetes** cluster, serving **2M+ daily requests**. Extended the existing Envoy logic and authored the Kubernetes autoscaling policies for upstream services.



# Skills
**AI / ML:** DSPy, LiteLLM, MIPRO/COPRO, GEPA, LLM-as-judge, Langfuse, MLflow, Google Gemini, VertexAI, LLM Evaluation & Optimization

**Backend:** Python, TypeScript, Go, FastAPI, Node.js/Express, Next.js, Django, PostgreSQL, MongoDB, Redis, BullMQ, BigQuery, PostHog

**Infrastructure:** AWS (ECS Fargate, SNS, S3), Terraform, Docker, Kubernetes, OpenTelemetry, Grafana, Envoy, Cloudflare, GitHub Actions

# Education
## **MIET**
*Meerut, Uttar Pradesh*


*Jan 2020 – Jan 2024*

*B.Tech* *in* *Computer Science Engineering, Minor in Data Science*


