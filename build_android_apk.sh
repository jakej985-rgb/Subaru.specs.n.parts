#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_PROJ="$ROOT_DIR/SubaruPartsSuite/SubaruParts.App/SubaruParts.App.csproj"
FRAMEWORK="${TFM:-net9.0-android}"
CONFIG="Release"
OUTPUT_DIR="$ROOT_DIR/SubaruPartsSuite/SubaruParts.App/bin/$CONFIG/$FRAMEWORK/publish"

if ! command -v dotnet >/dev/null 2>&1; then
  echo "dotnet CLI is not installed. Install .NET 9 SDK with the MAUI Android workload." >&2
  exit 1
fi

dotnet restore "$APP_PROJ"
dotnet publish "$APP_PROJ" -f "$FRAMEWORK" -c "$CONFIG" -p:AndroidPackageFormat=apk

APK_PATH=$(find "$OUTPUT_DIR" -name "*.apk" | head -n 1)
if [ -z "$APK_PATH" ]; then
  echo "No APK was produced at $OUTPUT_DIR" >&2
  exit 1
fi

DEST_PATH="$ROOT_DIR/SubaruParts.App-${CONFIG}.apk"
cp "$APK_PATH" "$DEST_PATH"

echo "APK copied to $DEST_PATH"
