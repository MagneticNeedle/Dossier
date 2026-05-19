"""Replace em-dashes (—) with ", " in stdin, collapsing surrounding spaces.

Usage:
    echo "alpha — beta — gamma" | uv run scripts/no_emdash.py
    # alpha, beta, gamma
"""

from __future__ import annotations

import re
import sys


def main() -> int:
    sys.stdout.write(re.sub(r"[ \t]*—[ \t]*", ", ", sys.stdin.read()))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
