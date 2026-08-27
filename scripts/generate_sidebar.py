#!/usr/bin/env python3
"""Generate a complete Docsify sidebar from the root-level solution documents."""

from pathlib import Path
from urllib.parse import quote


ROOT = Path(__file__).resolve().parent.parent
OUTPUT = ROOT / "_sidebar.md"


def heading(path: Path) -> str:
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.startswith("# "):
            return line[2:].strip()
    return path.stem


files = sorted(
    (path for path in ROOT.glob("L[123]-*.md") if path.is_file()),
    key=lambda path: path.name,
)

groups = {
    "L1": "L1 基础级 · 120 题",
    "L2": "L2 进阶级 · 60 题",
    "L3": "L3 挑战级 · 45 题",
}

lines = ["- [🏠 首页](./README.md)", ""]
for level, label in groups.items():
    lines.append(f"- **{label}**")
    for path in (item for item in files if item.name.startswith(level + "-")):
        url = quote(path.name, safe="/-._~")
        lines.append(f"  - [{heading(path)}](./{url})")
    lines.append("")

OUTPUT.write_text("\n".join(lines), encoding="utf-8")
print(f"generated {OUTPUT.name}: {len(files)} problem links")
