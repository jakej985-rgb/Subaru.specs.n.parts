#!/usr/bin/env python3
import json
import os
import re
from pathlib import Path

SPEC_DIR = Path("assets/seed/specs")

# Keywords your DAO treats as "trim-specific" filters.
# NOTE: single-letter trims need boundary-safe matching.
TRIMS = [
    "base", "premium", "limited", "touring", "sport", "wilderness",
    "ts", "gt", "sti", "rs",
    "gl", "dl", "xt",
    # single-letter historical trims:
    "l", "s",
]

# Boundary-safe patterns for each trim
def trim_patterns():
    pats = {}
    for t in TRIMS:
        if t in ("l", "s"):
            # match as standalone token or inside parentheses, not inside words
            pats[t] = re.compile(rf"(?i)(?:^|[^a-z0-9]){t}(?:[^a-z0-9]|$)")
        else:
            pats[t] = re.compile(rf"(?i)(?:^|[^a-z0-9]){re.escape(t)}(?:[^a-z0-9]|$)")
    return pats

TRIM_PATS = trim_patterns()

YEAR_RANGE_PAT = re.compile(r"(?<!\d)((?:19|20)\d{2})\s*[–-]\s*((?:19|20)\d{2})(?!\d)")
YEAR_PAT = re.compile(r"(?<!\d)((?:19|20)\d{2})(?!\d)")

def extract_year_tags(title: str):
    title = title or ""
    years = set()

    for m in YEAR_RANGE_PAT.finditer(title):
        a = int(m.group(1))
        b = int(m.group(2))
        if a > b:
            a, b = b, a
        for y in range(a, b + 1):
            years.add(str(y))

    # also pick up single years
    for m in YEAR_PAT.finditer(title):
        years.add(m.group(1))

    return sorted(years)

def extract_trim_tags(text: str):
    text = (text or "").lower()
    found = set()
    for t, pat in TRIM_PATS.items():
        if pat.search(text):
            found.add(t)
    return sorted(found)

def normalize_tags(tags: str):
    parts = [p.strip().lower() for p in (tags or "").split(",")]
    parts = [p for p in parts if p]
    # de-dupe, keep stable order-ish
    out = []
    seen = set()
    for p in parts:
        if p not in seen:
            out.append(p)
            seen.add(p)
    return out

def write_index_json(files):
    index_path = SPEC_DIR / "index.json"
    data = {"files": files}
    index_path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"Wrote {index_path} ({len(files)} files)")

def main():
    if not SPEC_DIR.exists():
        raise SystemExit(f"Missing {SPEC_DIR}")

    spec_files = sorted([p for p in SPEC_DIR.glob("*.json") if p.name != "index.json"])
    manifest_names = [p.name for p in spec_files]
    write_index_json(manifest_names)

    changed_files = 0
    changed_specs = 0

    for path in spec_files:
        specs = json.loads(path.read_text(encoding="utf-8"))
        file_modified = False

        for spec in specs:
            old = spec.get("tags", "")
            tag_list = normalize_tags(old)

            # add years from title
            years = extract_year_tags(spec.get("title", ""))
            for y in years:
                if y not in tag_list:
                    tag_list.append(y)
                    file_modified = True

            # add trims from title+body
            text = f"{spec.get('title','')} {spec.get('body','')}"
            trims = extract_trim_tags(text)
            for t in trims:
                if t not in tag_list:
                    tag_list.append(t)
                    file_modified = True

            if file_modified:
                spec["tags"] = ",".join(sorted(set(tag_list)))
                changed_specs += 1

        if file_modified:
            path.write_text(json.dumps(specs, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
            changed_files += 1
            print(f"Updated: {path.name}")

    print(f"Done. Changed files: {changed_files}, changed specs: {changed_specs}")

if __name__ == "__main__":
    main()
