"""Print a stripped resume YAML to stdout — only `cv.sections`, no rendercv config.

Usage:
    uv run scripts/relevant_resume.py <path-to-resume.yaml>
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from ruamel.yaml import YAML


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("path", type=Path, help="Path to a rendercv resume YAML.")
    args = parser.parse_args(argv)

    if not args.path.is_file():
        print(f"error: not a readable file: {args.path}", file=sys.stderr)
        return 2

    yaml = YAML()
    yaml.preserve_quotes = True
    data = yaml.load(args.path)

    sections = data.get("cv", {}).get("sections") if isinstance(data, dict) else None
    if sections is None:
        print(f"error: no cv.sections in {args.path}", file=sys.stderr)
        return 3

    yaml.dump({"cv": {"sections": sections}}, sys.stdout)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
