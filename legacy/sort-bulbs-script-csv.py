#!/usr/bin/env python3
import csv
from pathlib import Path

INPUT = Path("bulbs_raw.csv")
OUTPUT = Path("bulbs.sorted.csv")

EXPECTED_COLS = 17  # header has 17 fields

def row_sort_key(r: dict) -> tuple:
    def as_int(x: str) -> int:
        try:
            return int(x)
        except Exception:
            return 999999

    return (
        as_int(r.get("year", "")),
        (r.get("make") or "").strip().lower(),
        (r.get("model") or "").strip().lower(),
        (r.get("trim") or "").strip().lower(),
        (r.get("body") or "").strip().lower(),
        (r.get("market") or "").strip().lower(),
        (r.get("function_key") or "").strip().lower(),
        (r.get("tech") or "").strip().lower(),
        (r.get("bulb_code") or "").strip().lower(),
    )

def parse_csv_line(line: str):
    # Use csv.reader so quoted commas (if any) are handled correctly.
    return next(csv.reader([line], skipinitialspace=False))

def main():
    text = INPUT.read_text(encoding="utf-8", errors="replace").splitlines()

    if not text:
        raise SystemExit("Input file is empty.")
    print(f"Read {len(text)} lines from input.")

    header = parse_csv_line(text[0])
    if len(header) != EXPECTED_COLS:
        raise SystemExit(
            f"Header column count is {len(header)} but expected {EXPECTED_COLS}. "
            "Make sure the first line is the header."
        )

    repaired_rows = []
    buffer = ""

    # Start from line 2 (index 1), because line 1 is the header
    for raw in text[1:]:
        if not raw.strip():
            continue

        # Accumulate lines to fix merged/broken rows
        buffer = (buffer + "\n" + raw) if buffer else raw

        # Try parsing; if not enough cols yet, keep buffering
        try:
            cols = parse_csv_line(buffer)
        except Exception:
            continue

        if len(cols) < EXPECTED_COLS:
            print(f"Skipping row {len(repaired_rows)+1} due to col count {len(cols)}: {cols}")
            continue

        # If it's more than expected, it usually means buffer contains multiple rows
        # (rare, but possible). We'll split by newline and re-feed safely.
        if len(cols) > EXPECTED_COLS:
            parts = buffer.splitlines()
            buffer = ""
            for p in parts:
                if not p.strip():
                    continue
                if buffer:
                    buffer = buffer + "\n" + p
                else:
                    buffer = p
                try:
                    c = parse_csv_line(buffer)
                except Exception:
                    continue
                if len(c) == EXPECTED_COLS:
                    repaired_rows.append(c)
                    buffer = ""
            continue

        # Exactly expected columns → accept row
        repaired_rows.append(cols)
        buffer = ""

    if buffer.strip():
        # leftover junk; keep it visible so you notice
        print("WARNING: leftover unparsed buffer at end of file:")
        print(buffer)

    # Convert to dicts
    dict_rows = []
    for cols in repaired_rows:
        d = {header[i]: (cols[i] if i < len(cols) else "") for i in range(EXPECTED_COLS)}
        dict_rows.append(d)

    # Sort
    dict_rows.sort(key=row_sort_key)

    # Write
    with OUTPUT.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=header)
        w.writeheader()
        for r in dict_rows:
            w.writerow(r)

    print(f"Wrote: {OUTPUT}  (rows: {len(dict_rows)})")

if __name__ == "__main__":
    main()
