"""Build pipeline for the dossier repo.

Run via `uv run dossier.py` to execute every stage in order, or
`uv run dossier.py <stage> [<stage> ...]` to run a subset.

Add a new stage by writing a function and decorating it with `@stage("name")`.
Stages run in registration order when no argument is passed.
"""

from __future__ import annotations

import argparse
import shlex
import shutil
import subprocess
import sys
from collections.abc import Callable
from datetime import date
from pathlib import Path, PurePosixPath

import markdown
from ruamel.yaml import YAML

REPO_ROOT = Path(__file__).resolve().parent
RESUMES_DIR = REPO_ROOT / "sources" / "resumes"
RESUME_YAML_TECH = RESUMES_DIR / "SDE2_CV_v2.yaml"
RESUME_YAML_IMPACT = RESUMES_DIR / "SDE2_CV.yaml"
RESUME_YAML = RESUME_YAML_TECH
ANON_YAML = RESUMES_DIR / "SDE2_CV.anon.generated.yaml"
CF_WORKER_DIR = REPO_ROOT / "deployments" / "cf-workers"
PUBLIC_DIR = CF_WORKER_DIR / "public"
PUBLISHED_PDF = PUBLIC_DIR / "vibhakar-solanki-sde2-resume.pdf"
PUBLISHED_PDF_TECH = PUBLIC_DIR / "vibhakar-solanki-sde2-resume-tech.pdf"
PUBLISHED_PDF_IMPACT = PUBLIC_DIR / "vibhakar-solanki-sde2-resume-impact.pdf"
PUBLISHED_PDF_TECH_MOBILE = PUBLIC_DIR / "vibhakar-solanki-sde2-resume-tech-mobile.pdf"
PUBLISHED_PDF_IMPACT_MOBILE = PUBLIC_DIR / "vibhakar-solanki-sde2-resume-impact-mobile.pdf"
PUBLISHED_MD_TECH = PUBLIC_DIR / "vibhakar-solanki-sde2-resume-tech.md"
PUBLISHED_MD_IMPACT = PUBLIC_DIR / "vibhakar-solanki-sde2-resume-impact.md"
# HTML renders of the Markdown, bundled into the worker (not served on their own).
INLINE_HTML_TECH = CF_WORKER_DIR / "resume-tech.html"
INLINE_HTML_IMPACT = CF_WORKER_DIR / "resume-impact.html"
PROJECTS_CONTEXT = REPO_ROOT / "sources" / "contexts" / "projects.md"
PUBLISHED_MD_PROJECTS = PUBLIC_DIR / "projects.md"
PUBLISHED_SITEMAP = PUBLIC_DIR / "sitemap.xml"
PUBLIC_SITE = "https://resume.vibhakar.dev"

RENDER_PATH_KEYS = ("typst_path", "pdf_path", "markdown_path", "html_path", "png_path")

ANON_HEADER_OVERRIDES = {
    "name": "Software Engineer",
    "email": "name@example.com",
    "website": "https://example.com",
}
ANON_SOCIAL_OVERRIDES = {"LinkedIn": "your-linkedin", "GitHub": "your-github"}

# Phone variant: a narrow, single continuous page, with dates and locations
# folded into the main column so nothing needs a right-hand column.
MOBILE_PAGE_WIDTH = "4in"
MOBILE_DESIGN_OVERRIDES = {
    "page": {
        "top_margin": "0.4cm",
        "bottom_margin": "0.5cm",
        "left_margin": "0.15in",
        "right_margin": "0.15in",
        # Collides with the centred name at this width.
        "show_top_note": False,
    },
    "typography": {
        "alignment": "left",
        "font_size": {"body": "9.5pt", "name": "18pt", "connections": "8.5pt"},
    },
    "header": {"space_below_name": "0.3cm", "space_below_connections": "0.3cm"},
    "section_titles": {"space_above": "0.45cm", "space_below": "0.25cm"},
    "entries": {"date_and_location_width": "0cm", "space_between_columns": "0cm"},
    "templates": {
        "experience_entry": {
            "main_column": "**POSITION**\n*COMPANY · LOCATION · DATE*\nSUMMARY\nHIGHLIGHTS",
            "date_and_location_column": "",
        },
        "normal_entry": {
            "main_column": "**NAME**\n*DATE*\nSUMMARY\nHIGHLIGHTS",
            "date_and_location_column": "",
        },
        "education_entry": {
            "main_column": "**INSTITUTION**\n*DEGREE* *in* *AREA*\n*LOCATION · DATE*\nSUMMARY\nHIGHLIGHTS",
            "date_and_location_column": "",
        },
    },
}


def _load_resume_yaml(path: Path = RESUME_YAML) -> tuple[YAML, dict]:
    yaml = YAML()
    yaml.preserve_quotes = True
    return yaml, yaml.load(path)


def _resolve_render_path(render_command: dict, key: str) -> Path:
    output_folder = (RESUMES_DIR / render_command["output_folder"]).resolve()
    return Path(render_command[key].replace("OUTPUT_FOLDER", str(output_folder)))


def _suffix_render_paths(render_command: dict, suffix: str) -> None:
    for key in RENDER_PATH_KEYS:
        path = PurePosixPath(render_command[key])
        render_command[key] = str(path.with_name(f"{path.stem}.{suffix}{path.suffix}"))


def _deep_merge(target: dict, overrides: dict) -> None:
    for key, value in overrides.items():
        if isinstance(value, dict) and isinstance(target.get(key), dict):
            _deep_merge(target[key], value)
        else:
            target[key] = value

Stage = Callable[[], None]
STAGES: dict[str, Stage] = {}


def stage(name: str) -> Callable[[Stage], Stage]:
    def register(fn: Stage) -> Stage:
        if name in STAGES:
            raise RuntimeError(f"stage '{name}' already registered")
        STAGES[name] = fn
        return fn

    return register


def run(cmd: list[str], *, cwd: Path | None = None) -> None:
    where = f"  (cwd={cwd.relative_to(REPO_ROOT)})" if cwd else ""
    print(f"$ {shlex.join(cmd)}{where}", file=sys.stderr)
    subprocess.run(cmd, cwd=cwd, check=True)


@stage("render")
def _render() -> None:
    """Render both resume variants (tech + impact) with rendercv."""
    for yaml_path in (RESUME_YAML_TECH, RESUME_YAML_IMPACT):
        run(
            ["uv", "run", "rendercv", "render", yaml_path.name],
            cwd=RESUMES_DIR,
        )


@stage("render-mobile")
def _render_mobile() -> None:
    """Render a narrow, single-page phone variant of both resumes."""
    # Imported lazily: only this stage compiles Typst in-process.
    from rendercv.renderer.pdf_png import get_package_path, get_typst_compiler

    # rendercv only knows named paper sizes. Patch the temporary copy of its
    # Typst package it compiles against so `page-size` also accepts a
    # (width, height) dictionary.
    lib_typ = next(get_package_path().glob("preview/rendercv/*/lib.typ"))
    lib_source = lib_typ.read_text()
    paper_arg = "    paper: page-size,\n"
    if paper_arg not in lib_source:
        raise RuntimeError(f"rendercv template changed; can't find {paper_arg!r}")
    lib_typ.write_text(
        lib_source.replace(
            paper_arg,
            "    ..if type(page-size) == dictionary { page-size }"
            " else { (paper: page-size) },\n",
        )
    )

    for yaml_path in (RESUME_YAML_TECH, RESUME_YAML_IMPACT):
        yaml, data = _load_resume_yaml(yaml_path)
        _deep_merge(data["design"], MOBILE_DESIGN_OVERRIDES)
        render_command = data["settings"]["render_command"]
        _suffix_render_paths(render_command, "mobile")
        # Emit Typst only; the page size is set below before compiling.
        render_command["dont_generate_pdf"] = True
        render_command["dont_generate_png"] = True
        render_command["dont_generate_markdown"] = True
        generated = yaml_path.with_name(f"{yaml_path.stem}.mobile.generated.yaml")
        with generated.open("w") as f:
            yaml.dump(data, f)
        run(["uv", "run", "rendercv", "render", generated.name], cwd=RESUMES_DIR)

        typst_path = _resolve_render_path(render_command, "typst_path")
        source = typst_path.read_text()
        page_size = f'  page-size: "{data["design"]["page"]["size"]}",\n'
        if page_size not in source:
            raise RuntimeError(f"can't find {page_size!r} in {typst_path.name}")
        typst_path.write_text(
            source.replace(
                page_size,
                f"  page-size: (width: {MOBILE_PAGE_WIDTH}, height: auto),\n",
            )
        )
        pdf_path = _resolve_render_path(render_command, "pdf_path")
        get_typst_compiler(generated, typst_path.parent).compile(
            input=typst_path, format="pdf", output=pdf_path
        )
        print(f"wrote {pdf_path.relative_to(REPO_ROOT)}", file=sys.stderr)


@stage("publish-pdf")
def _publish_pdf() -> None:
    """Copy both rendered resume PDFs (letter + phone) into deployments/cf-workers/public for the worker."""
    _, tech = _load_resume_yaml(RESUME_YAML_TECH)
    _, impact = _load_resume_yaml(RESUME_YAML_IMPACT)
    tech_pdf = _resolve_render_path(tech["settings"]["render_command"], "pdf_path")
    impact_pdf = _resolve_render_path(impact["settings"]["render_command"], "pdf_path")
    shutil.copyfile(tech_pdf, PUBLISHED_PDF_TECH)
    shutil.copyfile(impact_pdf, PUBLISHED_PDF_IMPACT)
    shutil.copyfile(tech_pdf, PUBLISHED_PDF)
    shutil.copyfile(tech_pdf.with_name(f"{tech_pdf.stem}.mobile.pdf"), PUBLISHED_PDF_TECH_MOBILE)
    shutil.copyfile(
        impact_pdf.with_name(f"{impact_pdf.stem}.mobile.pdf"), PUBLISHED_PDF_IMPACT_MOBILE
    )


@stage("publish-md")
def _publish_md() -> None:
    """Copy both rendered resume Markdown files and the project deep-dives into deployments/cf-workers/public for agents, plus HTML renders the worker inlines."""
    variants = (
        (RESUME_YAML_TECH, PUBLISHED_MD_TECH, INLINE_HTML_TECH, PUBLISHED_PDF_TECH, "Tech", "Impact", "/impact"),
        (RESUME_YAML_IMPACT, PUBLISHED_MD_IMPACT, INLINE_HTML_IMPACT, PUBLISHED_PDF_IMPACT, "Impact", "Tech", "/tech"),
    )
    for yaml_path, published_md, inline_html, published_pdf, focus, other_focus, other_path in variants:
        _, data = _load_resume_yaml(yaml_path)
        md_path = _resolve_render_path(data["settings"]["render_command"], "markdown_path")
        # Point agents at the other variant and the PDF, since they only get this page.
        preamble = (
            f"> {focus}-focused version. {other_focus}-focused: {PUBLIC_SITE}{other_path}"
            f" · PDF: {PUBLIC_SITE}/{published_pdf.name}"
            f" · Project deep-dives: {PUBLIC_SITE}/{PUBLISHED_MD_PROJECTS.name}\n\n"
        )
        published = preamble + md_path.read_text(encoding="utf-8")
        published_md.write_text(published, encoding="utf-8")
        # Fetchers that get the HTML page (browser UAs) don't follow the PDF iframe.
        inline_html.write_text(markdown.markdown(published) + "\n", encoding="utf-8")

    preamble = f"> Project deep-dives by Vibhakar Solanki. Resume: {PUBLIC_SITE}/\n\n"
    PUBLISHED_MD_PROJECTS.write_text(
        preamble + PROJECTS_CONTEXT.read_text(encoding="utf-8"), encoding="utf-8"
    )


@stage("publish-sitemap")
def _publish_sitemap() -> None:
    """Write sitemap.xml for the canonical resume pages, stamped with today's date."""
    # /tech serves the same page as /, so only / is listed.
    lastmod = date.today().isoformat()
    urls = "".join(
        f"  <url>\n    <loc>{PUBLIC_SITE}{path}</loc>\n    <lastmod>{lastmod}</lastmod>\n  </url>\n"
        for path in ("/", "/impact")
    )
    PUBLISHED_SITEMAP.write_text(
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'
        f"{urls}</urlset>\n",
        encoding="utf-8",
    )

@stage("render-anon")
def _render_anon() -> None:
    """Render an anonymized resume (header redacted) for public feedback."""
    yaml, data = _load_resume_yaml()
    for key, value in ANON_HEADER_OVERRIDES.items():
        data["cv"][key] = value
    for entry in data["cv"].get("social_networks", []):
        if entry["network"] in ANON_SOCIAL_OVERRIDES:
            entry["username"] = ANON_SOCIAL_OVERRIDES[entry["network"]]
    _suffix_render_paths(data["settings"]["render_command"], "anon")
    # Markdown is only published for the named variants.
    data["settings"]["render_command"]["dont_generate_markdown"] = True
    with ANON_YAML.open("w") as f:
        yaml.dump(data, f)
    run(["uv", "run", "rendercv", "render", ANON_YAML.name], cwd=RESUMES_DIR)


@stage("og-image")
def _og_image() -> None:
    """Build the 1200x630 og:image PNG from the rendercv PNG output."""
    _, data = _load_resume_yaml()
    png_path = _resolve_render_path(data["settings"]["render_command"], "png_path")
    # rendercv suffixes `_1` for multi-page docs; prefer that if present.
    paged = png_path.with_name(f"{png_path.stem}_1{png_path.suffix}")
    source = paged if paged.exists() else png_path
    script = REPO_ROOT / "deployments" / "scripts" / "build_og_image.py"
    run(["uv", "run", str(script), str(source)])


@stage("deploy-worker")
def _deploy_worker() -> None:
    """Deploy the Cloudflare Worker (publishes public/ assets to resume.vibhakar.{dev,in})."""
    run(["npx", "wrangler", "deploy"], cwd=CF_WORKER_DIR)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Build pipeline for dossier. Stages run in registration order."
    )
    parser.add_argument(
        "stages",
        nargs="*",
        help="Stages to run in the given order. Defaults to every stage.",
    )
    parser.add_argument(
        "--list",
        action="store_true",
        help="List available stages and exit.",
    )
    args = parser.parse_args(argv)

    if args.list:
        width = max(len(name) for name in STAGES)
        for name, fn in STAGES.items():
            doc = (fn.__doc__ or "").strip().splitlines()[0]
            print(f"  {name:<{width}}  {doc}")
        return 0

    targets = args.stages or list(STAGES)
    unknown = [s for s in targets if s not in STAGES]
    if unknown:
        print(
            f"error: unknown stage(s): {', '.join(unknown)}. "
            f"Available: {', '.join(STAGES)}",
            file=sys.stderr,
        )
        return 2

    for name in targets:
        print(f"==> {name}", file=sys.stderr)
        STAGES[name]()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
