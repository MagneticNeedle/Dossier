// Import the rendercv function and all the refactored components
#import "@preview/rendercv:0.3.0": *

// Apply the rendercv template with custom configuration
#show: rendercv.with(
  name: "Vibhakar Solanki",
  title: "Vibhakar Solanki - Resume",
  footer: context { [#emph[Vibhakar Solanki -- #str(here().page())\/#str(counter(page).final().first())]] },
  top-note: [ #emph[Last updated in May 2026] ],
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
    month: 5,
    day: 29,
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
    #strong[SDE 2]

    #emph[VideoVerse]

  ],
  [
    #emph[Remote]

    #emph[Jan 2026 – present]

  ],
  main-column-second-row: [
    - Designed and built #strong[SmartThumbnails] from scratch in #strong[Python\/FastAPI] — reverse-engineered selection heuristics from client-published thumbnails into a layered pipeline: #strong[PySceneDetect] scene segmentation, Laplacian sharpness filtering, and #strong[DSPy]-structured Gemini for final selection. Reached #strong[99.2\% client acceptance] across the first 4,500 clips, replacing manual curation.

    - Built an #strong[SNS-driven] clip enrichment pipeline issuing #strong[DSPy]-structured Gemini calls, so every clip is searchable and tagged at ingest.

    - Extended the export pipeline with multi-language, EPG, and AI tagging by routing #strong[SNS events] through the internal AI Gateway, letting broadcast clients localize content without manual work.

    - Engineered a hybrid algorithmic + LLM pipeline for sibling-clip metadata back-fill and conflict detection, with batched updates that respect hard SLA windows — cut #strong[SLA breaches by 25\%].

    - Unified two fragmented broadcast scheduling sources into a single queryable API; reconciliation logic catches shows split across source APIs that the prior manual-import workflow dropped.

    - Owned both the cross-service instrumentation refactor and the collector pipeline for the #strong[Datadog → OpenTelemetry] migration, giving the team vendor-neutral structured observability.

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
    - Built an internal LLM evaluation harness from scratch — eval datasets, metric definitions, and #strong[Langfuse] integration — and used it to drive ground-truth analysis that lifted output accuracy #strong[from 68\% to 92\%].

    - Tuned and applied #strong[DSPy MIPRO\/COPRO] and #strong[GEPA] prompt optimizers per service for thumbnail selection and metadata generation, raising task-level accuracy #strong[from 30\% to 87\%].

    - Built a #strong[FastAPI AI Gateway] fronting 5 backend AI services with service-to-service token auth and retry\/backoff baked into both FastAPI middleware and the #strong[HTTPX] transport — #strong[zero dropped jobs] across 50k+ clips and 300+ streams monthly.

    - Engineered a #strong[DSPy + Gemini] clip-ratings pipeline running on #strong[500k+ clips\/month], with rate-limit-aware scheduling so peak-load batches still complete before SLA breach.

    - Established Langfuse and OTEL alerting workflows to enforce SLA compliance across the AI services.

    - Co-led migration of AWS infrastructure to #strong[Terraform], extending the existing module structure and adding #strong[OTEL] wiring plus a #strong[Cloudflare Tunnel] for secure local access to internal services.

  ],
)

#regular-entry(
  [
    #strong[Software Engineer Intern]

    #emph[VideoVerse]

  ],
  [
    #emph[Remote]

    #emph[June 2024 – Nov 2024]

  ],
  main-column-second-row: [
    - Originally interned at #strong[LetsDive.io] as a Django backend engineer; continued the role at VideoVerse #strong[following its acquisition of LetsDive.io].

    - Designed an ETL feed from #strong[PostgreSQL and MongoDB] into #strong[BigQuery] with #strong[sub-100ms] end-to-end latency, since live frontend and backend services consume from BigQuery in the request path.

    - Rewrote the legacy thumbnail service storage layer from #strong[SQLite to PostgreSQL] with a from-scratch schema (no back-compat), and built the face-embedding ingestion and deployment that drives selection accuracy.

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
    - Open-source Stats API behind #strong[Envoy] routing into a #strong[Kubernetes] cluster, serving #strong[2M+ daily requests]; extended the existing Envoy logic and authored the Kubernetes autoscaling policies for upstream services.

  ],
)

== Skills

#strong[AI \/ ML:] DSPy, MIPRO\/COPRO, GEPA, Langfuse, Google Gemini, VertexAI, Prompt Engineering, LLM Evaluation & Optimization

#strong[Backend:] Python, Go, TypeScript, FastAPI, Django, PostgreSQL, MongoDB, Redis, BigQuery

#strong[Infrastructure:] AWS (SNS, ECS), Terraform, Docker, Kubernetes, OpenTelemetry, Grafana, Envoy, Cloudflare, GitHub Actions

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
