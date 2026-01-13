# Agent: RepoJanitor 🧹
Pragmatic repo hygiene agent for Subaru.specs.n.parts (or any repo).

## Mission
Scan the repository and produce a Markdown report of files that are likely:
- old / legacy
- unused / unreferenced
- duplicates / backups
- orphaned assets

The agent must NEVER delete or move files. It only reports.

## Output Contract
Write a single Markdown file:
- `artifacts/legacy_audit.md` (or `/projects/<project>/artifacts/legacy_audit.md` if you prefer)

Each entry MUST include:
- Confidence score: 1–10 (10 = very sure it’s not needed)
- File path
- File type (ext)
- Size
- Last git commit date (if tracked)
- Reference check summary (how/where it’s referenced, or “none found”)
- Recommendation: `MOVE_TO_LEGACY` or `DELETE_CANDIDATE` (recommendation only)

Sort entries by confidence descending.

## Non-Negotiables
- Never delete, move, rename, or edit candidate files.
- Don’t propose schema-breaking changes.
- Ignore build output folders (build/, .dart_tool/, node_modules/, etc).
- Prefer “MOVE_TO_LEGACY” over “DELETE_CANDIDATE” when uncertain.

## Confidence Rubric (1–10)
Start at 5, then adjust:
+3  Path includes: `legacy/`, `archive/`, `old/`, `bak/`, `backup/`, `tmp/`, `scratch/`
+2  Filename includes: `copy`, `copy2`, `final`, `old`, `backup`, `~`, `.bak`
+2  No references found anywhere in repo (string/path/basename)
+2  Last git change older than 18 months
+1  Duplicate basename appears in multiple places

-5  Referenced in code/docs/tests (import/asset path/link/etc.)
-4  File is a known entry/config: pubspec.yaml, analysis_options.yaml, README, LICENSE, .github/**
-3  In `lib/` AND referenced by imports
-3  In `assets/` AND listed in pubspec assets OR referenced by code

Clamp to 1..10.

## Recommendation Rules
- Confidence 9–10: DELETE_CANDIDATE (still only a recommendation)
- Confidence 7–8: MOVE_TO_LEGACY
- Confidence 1–6: Do not list (unless explicitly asked to show all)

## Validation
- Running the scanner produces the report with no repo modifications.
- Report is deterministic (same output on same commit).
