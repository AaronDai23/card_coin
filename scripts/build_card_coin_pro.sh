#!/usr/bin/env bash
# Build card_coin_pro release APK and rename to include pro + timestamp.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

STAMP="$(date +%Y%m%d_%H%M%S)"
OUT_DIR="build/app/outputs/flutter-apk"
DEFAULT_APK="${OUT_DIR}/app-card_coin_pro-release.apk"
NAMED_APK="${OUT_DIR}/card_coin_pro_${STAMP}.apk"

flutter build apk --flavor card_coin_pro -t lib/main_pro.dart --release

if [[ -f "$DEFAULT_APK" ]]; then
  mv -f "$DEFAULT_APK" "$NAMED_APK"
  echo "APK: $ROOT/$NAMED_APK"
else
  # Fallback: Gradle-renamed output under apk/
  GRADLE_APK="$(ls -t build/app/outputs/apk/card_coin_pro/release/card_coin_pro_release_*.apk 2>/dev/null | head -n1 || true)"
  if [[ -n "${GRADLE_APK}" ]]; then
    mkdir -p "$OUT_DIR"
    cp -f "$GRADLE_APK" "$NAMED_APK"
    echo "APK: $ROOT/$NAMED_APK"
  else
    echo "Build finished, but APK not found under $OUT_DIR or apk/card_coin_pro/release/"
    exit 1
  fi
fi
