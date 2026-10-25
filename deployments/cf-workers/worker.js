/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run "npm run dev" in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run "npm run deploy" to publish your worker
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */

const RESUME_PDFS = {
  tech: "/vibhakar-solanki-sde2-resume-tech.pdf",
  impact: "/vibhakar-solanki-sde2-resume-impact.pdf",
};
// Narrow single-page renders for phones; see the render-mobile stage.
const RESUME_PDFS_MOBILE = {
  tech: "/vibhakar-solanki-sde2-resume-tech-mobile.pdf",
  impact: "/vibhakar-solanki-sde2-resume-impact-mobile.pdf",
};
// Phone browsers put "Mobi" in the UA; tablets don't, so they keep the letter page.
const PHONE_UA = /Mobi/i;
const viewerFor = (pdf) =>
  `/pdfjs/web/viewer?file=${encodeURIComponent(pdf)}#zoom=auto`;
const RESUME_URL = "https://vibhakar.dev";
const PREVIEW_IMAGE = "https://resume.vibhakar.dev/og-image.png";
const TITLE = "Vibhakar Solanki | Founding Engineer @ Bread Butter | AI Engineer";
const DESCRIPTION =
  "Founding Engineer at Bread Butter (bb.bio), owning the AI stack with DSPy, LiteLLM, and FastAPI on AWS. Previously built AI video pipelines at VideoVerse.";

const PROFILE_PAGE_SCHEMA = {
  "@context": "https://schema.org",
  "@type": "ProfilePage",
  dateCreated: "2026-05-11T13:14:00+05:30",
  dateModified: "2026-10-24T22:00:00+05:30",
  mainEntity: {
    "@type": "Person",
    name: "Vibhakar Solanki",
    givenName: "Vibhakar",
    familyName: "Solanki",
    email: "mailto:mail@vibhakar.dev",
    url: RESUME_URL,
    jobTitle: "Founding Engineer",
    description: DESCRIPTION,
    worksFor: {
      "@type": "Organization",
      name: "Bread Butter",
      url: "https://bb.bio",
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
      "LiteLLM",
      "Google Gemini",
      "VertexAI",
      "Python",
      "Go",
      "TypeScript",
      "Node.js",
      "Next.js",
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
  },
};

// Social unfurlers (Slackbot, Twitterbot, LinkedInBot, Discordbot, WhatsApp,
// FacebookBot/facebookexternalhit, Meta-ExternalAgent, TelegramBot) are
// intentionally EXCLUDED so they still get HTML and OG previews keep working.
const AGENT_UA =
  /GPTBot|ChatGPT-User|OAI-SearchBot|ClaudeBot|Claude-User|Claude-Web|anthropic-ai|PerplexityBot|Perplexity-User|Google-Extended|Googlebot|Bingbot|Applebot-Extended|CCBot|Bytespider|DuckDuckBot|YouBot|cohere-ai|Diffbot|Amazonbot|curl|wget|python-requests|httpx|node-fetch|Go-http-client/i;

export default {
  async fetch(request) {
    const pathname = new URL(request.url).pathname.replace(/\/+$/, "") || "/";
    const variantByPath = { "/": "tech", "/tech": "tech", "/impact": "impact" };
    const variant = variantByPath[pathname];
    if (!variant) {
      return new Response("Not found", { status: 404 });
    }

    const ua = request.headers.get("user-agent") || "";
    const accept = request.headers.get("accept") || "";
    const isAgent =
      !ua ||
      AGENT_UA.test(ua) ||
      (accept && !accept.includes("text/html") && !accept.includes("*/*"));
    if (isAgent) {
      const pdfUrl = new URL(RESUME_PDFS[variant], request.url);
      const pdfResp = await fetch(pdfUrl, request);
      return new Response(pdfResp.body, {
        status: pdfResp.status,
        headers: {
          "content-type": "application/pdf",
          "content-disposition": `inline; filename="${RESUME_PDFS[variant].slice(1)}"`,
          "cache-control":
            pdfResp.headers.get("cache-control") || "public, max-age=3600",
        },
      });
    }

    const pdfs = PHONE_UA.test(ua) ? RESUME_PDFS_MOBILE : RESUME_PDFS;
    const resumeViewer = viewerFor(pdfs[variant]);
    const html = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
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

  <script type="application/ld+json">${JSON.stringify(PROFILE_PAGE_SCHEMA)}</script>

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
    src="${resumeViewer}"
    height="100%"
    width="100%"
    style="border: none;">
  </iframe>
</body>
</html>`;

    return new Response(html, {
      headers: {
        "content-type": "text/html;charset=UTF-8",
        vary: "User-Agent",
      },
    });
  },
};
