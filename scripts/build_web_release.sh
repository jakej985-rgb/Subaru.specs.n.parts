#!/usr/bin/env bash
# ==============================================================================
# Subaru Specs & Parts - Production Web Release Build for M3tal-Hub
# Builds the Flutter Web bundle configured for deployment under /subaru-specs-n-parts/
# ==============================================================================

set -euo pipefail

BASE_HREF="${1:-/subaru-specs-n-parts/}"

# Ensure trailing slash on base href
[[ "$BASE_HREF" != */ ]] && BASE_HREF="${BASE_HREF}/"
# Ensure leading slash on base href
[[ "$BASE_HREF" != /* ]] && BASE_HREF="/${BASE_HREF}"

echo "===================================================="
echo "Building Subaru Specs & Parts Web Release"
echo "Target Base Href: ${BASE_HREF}"
echo "===================================================="

# Check if flutter command is present
if ! command -v flutter &> /dev/null; then
  echo "Error: flutter command not found in PATH." >&2
  exit 1
fi

echo "--> Resolving Flutter dependencies..."
flutter pub get

# If database generation code is missing, run build_runner
if [[ ! -f "lib/data/db/app_db.g.dart" ]]; then
  echo "--> Running code generator for Drift database..."
  dart run build_runner build --delete-conflicting-outputs
fi

echo "--> Compiling Web bundle..."
flutter build web --release --base-href "${BASE_HREF}"

# Verification
if [[ ! -f "build/web/index.html" ]]; then
  echo "Error: build/web/index.html was not generated!" >&2
  exit 1
fi

echo "--> Verifying base href injection in index.html..."
if grep -q "base href=\"${BASE_HREF}\"" "build/web/index.html" || grep -q "base href='${BASE_HREF}'" "build/web/index.html"; then
  echo "Base href verified successfully: ${BASE_HREF}"
else
  echo "Warning: Exact base href pattern not matched, checking base tag:"
  grep -i "<base" "build/web/index.html" || true
fi

echo "===================================================="
echo "Subaru Specs & Parts Web build ready at: build/web"
echo "===================================================="
