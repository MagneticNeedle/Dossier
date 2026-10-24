// Import the rendercv function and all the refactored components
#import "@preview/rendercv:0.3.0": *

// Apply the rendercv template with custom configuration
#show: rendercv.with(
  name: "Vibhakar Solanki",
  title: "Vibhakar Solanki - Resume",
  footer: context { [#emph[Vibhakar Solanki -- #str(here().page())\/#str(counter(page).final().first())]] },
  top-note: [ #emph[Last updated in Oct 2026] ],
  locale-catalog-language: "en",
  text-direction: ltr,
  page-size: "us-letter",
  page-top-margin: 0.5cm,
  page-bottom-margin: 0.1cm,
  page-left-margin: 0.15in,
  page-right-margin: 0.15in,
  page-show-footer: false,
  page-show-top-note: true,
  colors-body: rgb(0, 0, 0),
  colors-name: rgb(0, 0, 0),
  colors-headline: rgb(0, 0, 0),
  colors-connections: rgb(0, 0, 0),
  colors-section-titles: rgb(0, 0, 0),
  colors-links: rgb(0, 0, 0),
  colors-footer: rgb(128, 128, 128),
  colors-top-note: rgb(128, 128, 128),
  typography-line-spacing: 0.7em,
  typography-alignment: "justified",
  typography-date-and-location-column-alignment: right,
  typography-font-family-body: "Helvetica",
  typography-font-family-name: "Helvetica",
  typography-font-family-headline: "Helvetica",
  typography-font-family-connections: "Helvetica",
  typography-font-family-section-titles: "Helvetica",
  typography-font-size-body: 9.3pt,
  typography-font-size-name: 20pt,
  typography-font-size-headline: 5pt,
  typography-font-size-connections: 9.5pt,
  typography-font-size-section-titles: 1.2em,
  typography-small-caps-name: false,
  typography-small-caps-headline: false,
  typography-small-caps-connections: true,
  typography-small-caps-section-titles: false,
  typography-bold-name: true,
  typography-bold-headline: false,
  typography-bold-connections: false,
  typography-bold-section-titles: true,
  links-underline: true,
  links-show-external-link-icon: true,
  header-alignment: center,
  header-photo-width: 3.5cm,
  header-space-below-name: 0.5cm,
  header-space-below-headline: 0.7cm,
  header-space-below-connections: 0.5cm,
  header-connections-hyperlink: true,
  header-connections-show-icons: true,
  header-connections-display-urls-instead-of-usernames: true,
  header-connections-separator: "┃",
  header-connections-space-between-connections: 0pt,
  section-titles-type: "with_full_line",
  section-titles-line-thickness: 0.5pt,
  section-titles-space-above: 0.5cm,
  section-titles-space-below: 0.3cm,
  sections-allow-page-break: true,
  sections-space-between-text-based-entries: 0.3em,
  sections-space-between-regular-entries: 0.5em,
  entries-date-and-location-width: 4.15cm,
  entries-side-space: 0.2cm,
  entries-space-between-columns: 0.1cm,
  entries-allow-page-break: false,
  entries-short-second-row: false,
  entries-degree-width: 1cm,
  entries-summary-space-left: 0cm,
  entries-summary-space-above: 0cm,
  entries-highlights-bullet:  "◦" ,
  entries-highlights-nested-bullet:  "◦" ,
  entries-highlights-space-left: 0.15cm,
  entries-highlights-space-above: 0cm,
  entries-highlights-space-between-items: 0cm,
  entries-highlights-space-between-bullet-and-text: 0.5em,
  date: datetime(
    year: 2026,
    month: 10,
    day: 24,
  ),
)


= Vibhakar Solanki

#connections(
  [#link("mailto:mail@vibhakar.dev", icon: false, if-underline: false, if-color: false)[#connection-with-icon("envelope")[mail\@vibhakar.dev]]],
  [#link("tel:+91-81264-90848", icon: false, if-underline: false, if-color: false)[#connection-with-icon("phone")[+91 81264 90848]]],
  [#link("https://vibhakar.dev/", icon: false, if-underline: false, if-color: false)[#connection-with-icon("link")[vibhakar.dev]]],
  [#link("https://github.com/MagneticNeedle", icon: false, if-underline: false, if-color: false)[#connection-with-icon("github")[github.com\/MagneticNeedle]]],
  [#link("https://linkedin.com/in/vibhakarsolanki", icon: false, if-underline: false, if-color: false)[#connection-with-icon("linkedin")[linkedin.com\/in\/vibhakarsolanki]]],
)


== Experience

#regular-entry(
  [
    #strong[Founding Engineer]

    #emph[Bread Butter (bb.bio)]

  ],
  [
    #emph[Remote]

    #emph[July 2026 – present]

  ],
  main-column-second-row: [
    - Own the AI stack end to end. Built #strong[ai-core] from scratch, the #strong[Python] monorepo behind bb.bio's AI features (#strong[DSPy, LiteLLM, FastAPI]), running on #strong[AWS ECS Fargate] with CI\/CD on #strong[GitHub Actions].

    - Built AI onboarding on #strong[Gemini (Vertex AI)], turning a creator's social media into 3 ready-to-publish portfolio drafts at #strong[3.6s p50] for #strong[under \$0.01 per creator], with #strong[zero failed LLM calls] across 1,000+ production generations.

    - Built an eval and #strong[GEPA] prompt-optimization loop with #strong[LLM-as-judge] on 52 real-user cases, lifting held-out quality #strong[from 0.52 to 0.74] and cutting input tokens #strong[66\%], with prompts, traces, and cost in #strong[Langfuse].

    - Built the pipeline that imports creators' Instagram\/YouTube posts into their portfolios and feeds AI drafts (#strong[Node\/TypeScript, BullMQ, Apify, S3]); caught a cost-tracking bug that under-reported scraping spend #strong[\~10x].

    - Designed and launched the bb.bio waitlist gate across 4 sign-in methods with bot protection, rate limiting, and an admin approval console (#strong[Postgres, Redis, Cloudflare Turnstile]).

    - Built creator analytics across the stack (#strong[PostHog, Postgres, Next.js, d3]): fixed visitor tracking that left #strong[100\% of signups] unattributed, and shipped an audience dashboard backed by live APIs answering in #strong[6-17 ms at 3x production volume].

  ],
)

#regular-entry(
  [
    #strong[SDE 2]

    #emph[VideoVerse]

  ],
  [
    #emph[Remote]

    #emph[Jan 2026 – June 2026]

  ],
  main-column-second-row: [
    - Designed and built #strong[SmartThumbnails] from scratch in #strong[Python\/FastAPI] — reverse-engineered selection heuristics from client-published thumbnails into a layered pipeline: #strong[PySceneDetect] scene segmentation, Laplacian sharpness filtering, and #strong[DSPy]-structured Gemini for final selection. Reached #strong[99.2\% client acceptance] across the first 4,500 clips, replacing manual curation.

    - Engineered a hybrid algorithmic + LLM pipeline for sibling-clip metadata back-fill and conflict detection, with batched updates that respect hard SLA windows — cut #strong[SLA breaches by 25\%].

    - Owned the #strong[Datadog → OpenTelemetry] migration end to end: cross-service instrumentation and the collector pipeline.

  ],
)

#regular-entry(
  [
    #strong[SDE 1]

    #emph[VideoVerse]

  ],
  [
    #emph[Remote]

    #emph[Nov 2024 – Jan 2026]

  ],
  main-column-second-row: [
    - Built an LLM eval harness from scratch (datasets, metrics, #strong[Langfuse]), driving ground-truth analysis that lifted accuracy #strong[from 68\% to 92\%].

    - Tuned and applied #strong[DSPy MIPRO\/COPRO] and #strong[GEPA] prompt optimizers per service for thumbnail selection and metadata generation, raising task-level accuracy #strong[from 30\% to 87\%].

    - Built a #strong[FastAPI AI Gateway] for 5 AI services with token auth and #strong[HTTPX] retry\/backoff: #strong[zero dropped jobs] across 50k+ clips\/month.

    - Engineered a #strong[DSPy + Gemini] clip-ratings pipeline on #strong[500k+ clips\/month] with rate-limit-aware scheduling to meet SLAs.

  ],
)

#regular-entry(
  [
    #strong[Software Engineer Intern]

    #emph[VideoVerse (joined via acquisition of LetsDive.io)]

  ],
  [
    #emph[Remote]

    #emph[June 2024 – Nov 2024]

  ],
  main-column-second-row: [
    - Built an ETL feed from #strong[PostgreSQL\/MongoDB] into #strong[BigQuery] with #strong[sub-100ms] latency, and rewrote the thumbnail service storage from #strong[SQLite to PostgreSQL] with face-embedding ingestion.

  ],
)

== Projects

#regular-entry(
  [
    #strong[Battlefield Portal Library | #link("https://bfportal.gg/")[bfportal.gg] | #link("https://github.com/battlefield-portal-community/bfportal.gg/")[https:\/\/gh.bfportal.gg]]

  ],
  [
    #emph[Jan 2022 – present]

  ],
  main-column-second-row: [
    - #strong[Django\/Jinja] CMS, currently migrating templates to #strong[HTMX] for dynamic interactions without a JavaScript framework; #strong[Cloudflare] edge caching, Docker containerization, and GitHub Actions CI\/CD.

  ],
)

#regular-entry(
  [
    #strong[Gametools Network | #link("https://gametools.network/")[gametools.network] | #link("https://github.com/community-network")[github.com\/community-network]]

  ],
  [
    #emph[May 2022 – present]

  ],
  main-column-second-row: [
    - Open-source Stats API behind #strong[Envoy] routing into a #strong[Kubernetes] cluster, serving #strong[2M+ daily requests]. Extended the existing Envoy logic and authored the Kubernetes autoscaling policies for upstream services.

  ],
)

== Skills

#strong[AI \/ ML:] DSPy, LiteLLM, MIPRO\/COPRO, GEPA, LLM-as-judge, Langfuse, MLflow, Google Gemini, VertexAI, LLM Evaluation & Optimization

#strong[Backend:] Python, TypeScript, Go, FastAPI, Node.js\/Express, Next.js, Django, PostgreSQL, MongoDB, Redis, BullMQ, BigQuery, PostHog

#strong[Infrastructure:] AWS (ECS Fargate, SNS, S3), Terraform, Docker, Kubernetes, OpenTelemetry, Grafana, Envoy, Cloudflare, GitHub Actions

== Education

#education-entry(
  [
    #strong[MIET]

    #emph[B.Tech] #emph[in] #emph[Computer Science Engineering, Minor in Data Science]

  ],
  [
    #emph[Meerut, Uttar Pradesh]

    #emph[Jan 2020 – Jan 2024]

  ],
  main-column-second-row: [
  ],
)
