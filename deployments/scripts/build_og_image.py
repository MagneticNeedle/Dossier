# /// script
# requires-python = ">=3.11"
# dependencies = ["pillow"]
# ///
"""Build the 1200x630 og:image PNG from the rendercv PNG output.

Resolves paths relative to this file so it can be run from any CWD.
Run via `uv run deployments/scripts/build_og_image.py [path/to/source.png]` —
uv resolves Pillow from the inline script metadata above. With no argument,
falls back to the default impact-specific rendercv outputs.
"""

import argparse
from pathlib import Path

from PIL import Image

OG_WIDTH = 1200
OG_HEIGHT = 630

REPO_ROOT = Path(__file__).resolve().parent.parent.parent
RESUME_PNG_DIR = REPO_ROOT / "artifacts" / "resumes"
OUTPUT_PATH = REPO_ROOT / "deployments" / "cf-workers" / "public" / "og-image.png"

# rendercv suffixes page numbers for multi-page docs; single-page may or may
# not have a suffix depending on version. Try both.
DEFAULT_CANDIDATES = [
    RESUME_PNG_DIR / "impact-specific-sde2-resume_1.png",
    RESUME_PNG_DIR / "impact-specific-sde2-resume.png",
]


def _resolve_source(arg: Path | None) -> Path:
    if arg is not None:
        if not arg.exists():
            raise SystemExit(f"Source PNG not found: {arg}")
        return arg
    source = next((p for p in DEFAULT_CANDIDATES if p.exists()), None)
    if source is None:
        raise SystemExit(
            f"No rendercv PNG found. Looked for: {[str(p) for p in DEFAULT_CANDIDATES]}"
        )
    return source


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument(
        "source",
        nargs="?",
        type=Path,
        help="Path to the source PNG. Defaults to the impact-specific rendercv output.",
    )
    args = parser.parse_args()
    source = _resolve_source(args.source)

    img = Image.open(source)

    # Scale so width == OG_WIDTH, preserving aspect ratio.
    new_height = round(img.height * OG_WIDTH / img.width)
    img = img.resize((OG_WIDTH, new_height), Image.LANCZOS)

    if new_height < OG_HEIGHT:
        raise SystemExit(
            f"Resized height ({new_height}) is shorter than og target ({OG_HEIGHT}); "
            "source PNG is too wide for a top-anchored crop."
        )

    # Top-anchored crop to OG dimensions.
    img = img.crop((0, 0, OG_WIDTH, OG_HEIGHT))

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    img.save(OUTPUT_PATH, format="PNG", optimize=True)
    print(f"wrote {OUTPUT_PATH} ({img.width}x{img.height}) from {source.name}")


if __name__ == "__main__":
    main()
