"""Build pipeline for the dossier repo.

Run via `uv run build.py` to execute every stage in order, or
`uv run build.py <stage> [<stage> ...]` to run a subset.

Add a new stage by writing a function and decorating it with `@stage("name")`.
Stages run in registration order when no argument is passed.
"""

from __future__ import annotations

import argparse
import shlex
import subprocess
import sys
from collections.abc import Callable
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent

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
    """Render the resume PDF + PNG with rendercv."""
    run(
        ["uv", "run", "rendercv", "render", "SDE2_CV.yaml"],
        cwd=REPO_ROOT / "sources" / "resumes",
    )


@stage("og-image")
def _og_image() -> None:
    """Build the 1200x630 og:image PNG from the rendercv PNG output."""
    run(["uv", "run", str(REPO_ROOT / "deployments" / "build_og_image.py")])


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
