// Import the rendercv function and all the refactored components
#import "@preview/rendercv:0.3.0": *

// Apply the rendercv template with custom configuration
#show: rendercv.with(
  name: "Software Engineer",
  title: "Software Engineer - Resume",
  footer: context { [#emph[Software Engineer -- #str(here().page())\/#str(counter(page).final().first())]] },
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
  typography-font-size-body: 9.8pt,
  typography-font-size-name: 20pt,
  typography-font-size-headline: 5pt,
  typography-font-size-connections: 10pt,
  typography-font-size-section-titles: 1.2em,
  typography-small-caps-name: false,
  typography-small-caps-headline: false,
  typography-small-caps-connections: false,
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
  header-space-below-connections: 0.3cm,
  header-connections-hyperlink: true,
  header-connections-show-icons: true,
  header-connections-display-urls-instead-of-usernames: true,
  header-connections-separator: "┃",
  header-connections-space-between-connections: 0.3cm,
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
    day: 11,
  ),
)


= Software Engineer

#connections(
  [#link("mailto:name@example.com", icon: false, if-underline: false, if-color: false)[#connection-with-icon("envelope")[name\@example.com]]],
  [#link("https://example.com/", icon: false, if-underline: false, if-color: false)[#connection-with-icon("link")[example.com]]],
  [#link("https://linkedin.com/in/your-linkedin", icon: false, if-underline: false, if-color: false)[#connection-with-icon("linkedin")[linkedin.com\/in\/your-linkedin]]],
  [#link("https://github.com/your-github", icon: false, if-underline: false, if-color: false)[#connection-with-icon("github")[github.com\/your-github]]],
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
    - Built SmartThumbnails from scratch — an AI-powered thumbnail selection service that processed #strong[4,500+ clips in its first month with a 99.2\% client acceptance rate], effectively eliminating manual thumbnail curation from broadcast workflows.

    - Engineered the service using #strong[FastAPI, PySceneDetect] for scene segmentation, Laplacian sharpness scoring for frame quality filtering, and Google Gemini via #strong[DSPy] for AI-driven final selection

    - Automated clip enrichment at scale via an event-driven pipeline, making every clip searchable and tagged the moment it's ingested.

    - Added multi-language, EPG metadata, and AI tagging support to the export pipeline, #strong[processing 11,000+ clips monthly] and letting broadcast clients localize content without manual work.

    - Automated conflict detection and metadata back-fill across sibling clips, reducing manual editorial effort and #strong[SLA breaches by 25\%].

    - Shipped an API that unified a broadcast client's scheduling data into a single queryable source, replacing fragmented manual imports

    - Migrated from #strong[Datadog to OpenTelemetry], giving the team vendor-neutral structured observability and faster production debugging.

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
    - Built an internal LLM evaluation pipeline using Langfuse and #strong[DSPy] Evaluate, improving model output accuracy #strong[from 68\% to 92\%].

    - Applied automated prompt optimization using #strong[DSPy]'s #strong[MIPRO\/COPRO] optimizers and #strong[GEPA], lifting task-level accuracy #strong[from 30\% to 87\%].

    - Built a centralized #strong[AI Gateway] handling auth, request tracking, and auto-retriggers across 5 backend AI services, processing #strong[50,000+ clips and 300+ streams monthly]

    - Engineered an LLM-powered video clip ratings pipeline using #strong[DSPy], handling over #strong[500k clips per month]

    - Established monitoring and alerting workflows using Langfuse and OTEL to enforce SLA compliance.

    - Co-led migration of entire #strong[AWS infrastructure to Terraform], improving infrastructure-as-code practices.

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
    - Originally interned at #strong[LetsDive.io] as a Django backend engineer, leading the codebase migration from #strong[#emph[#sym.ast.basic#h(0pt, weak: true) Python]#sym.ast.basic 3.9 to 3.11]; continued the role at VideoVerse #strong[following its acquisition of LetsDive.io].

    - Designed and implemented an ETL pipeline with #strong[sub-100ms latency] to optimise data processing.

    - Improved an existing thumbnail service by migrating from #strong[SQLite to PostgreSQL], adding auto-retries, and enhancing face-embedding data collection for better selection accuracy

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
    - Built a Django-based CMS serving #strong[17,000+ users], with a full frontend built on Jinja templates — currently migrating to #strong[HTMX] for faster, dynamic interactions without a JavaScript framework.

    - Containerised with Docker and automated deployments via GitHub Actions.

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
    - Developed and maintain an open-source Stats API serving #strong[3 million players], handling over #strong[2 million daily requests] via Envoy proxy and Cloudflare caching.

  ],
)

== Skills

#strong[AI \/ ML:] #strong[DSPy], MIPRO\/COPRO, GEPA, Langfuse, Google Gemini, VertexAI, Prompt Engineering, LLM Evaluation & Optimization

#strong[Backend:] #strong[Python], Go, TypeScript, FastAPI, Django, PostgreSQL, MongoDB, Redis

#strong[Infrastructure:] AWS, Terraform, Docker, OpenTelemetry, Grafana, Nginx, GitHub Actions, Envoy

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
