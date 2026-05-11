/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run "npm run dev" in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run "npm run deploy" to publish your worker
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */

const RESUME_PDF = "/resume.pdf";
const RESUME_VIEWER = `/pdfjs/web/viewer?file=${encodeURIComponent(RESUME_PDF)}#zoom=page-width`;
const RESUME_URL = "https://vibhakar.dev";
const PREVIEW_IMAGE = "https://resume.vibhakar.dev/og-image.png";
const TITLE = "Vibhakar Solanki | SDE 2 @ VideoVerse | AI Video Pipelines";
const DESCRIPTION =
  "SDE 2 at VideoVerse building AI-powered video pipelines with FastAPI, DSPy, and OpenTelemetry. Python, Go, AWS, Terraform.";

const PERSON_SCHEMA = {
  "@context": "https://schema.org",
  "@type": "Person",
  name: "Vibhakar Solanki",
  givenName: "Vibhakar",
  familyName: "Solanki",
  email: "mailto:mail@vibhakar.com",
  url: RESUME_URL,
  jobTitle: "SDE 2",
  worksFor: {
    "@type": "Organization",
    name: "VideoVerse",
    url: "https://videoverse.com",
  },
  alumniOf: {
    "@type": "CollegeOrUniversity",
    name: "Meerut Institute of Engineering and Technology",
    sameAs: "https://miet.ac.in",
  },
  knowsAbout: [
    "AI Video Pipelines",
    "LLM Evaluation & Optimization",
    "Prompt Engineering",
    "DSPy",
    "MIPRO",
    "COPRO",
    "GEPA",
    "Langfuse",
    "Google Gemini",
    "VertexAI",
    "Python",
    "Go",
    "TypeScript",
    "FastAPI",
    "Django",
    "PostgreSQL",
    "MongoDB",
    "Redis",
    "AWS",
    "Terraform",
    "Docker",
    "OpenTelemetry",
    "Grafana",
    "Nginx",
    "GitHub Actions",
    "Envoy",
  ],
  sameAs: [
    "https://www.linkedin.com/in/solankivibhakar",
    "https://github.com/MagneticNeedle",
  ],
};

export default {
  async fetch(request) {
    const html = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>${TITLE}</title>
  <meta name="description" content="${DESCRIPTION}">

  <meta property="og:type" content="profile">
  <meta property="og:title" content="${TITLE}">
  <meta property="og:description" content="${DESCRIPTION}">
  <meta property="og:image" content="${PREVIEW_IMAGE}">
  <meta property="og:url" content="${RESUME_URL}">
  <meta property="profile:first_name" content="Vibhakar">
  <meta property="profile:last_name" content="Solanki">

  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="${TITLE}">
  <meta name="twitter:description" content="${DESCRIPTION}">
  <meta name="twitter:image" content="${PREVIEW_IMAGE}">

  <script type="application/ld+json">${JSON.stringify(PERSON_SCHEMA)}</script>

  <style>
    body {
      height: 100dvh;
      overflow: hidden;
      margin: 0;
    }
  </style>
</head>
<body>
  <iframe
    src="${RESUME_VIEWER}"
    height="100%"
    width="100%"
    style="border: none;">
  </iframe>
</body>
</html>`;

    return new Response(html, {
      headers: {
        "content-type": "text/html;charset=UTF-8",
      },
    });
  },
};
