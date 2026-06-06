#!/usr/bin/env bash
set -euo pipefail

# Upload an IPA to App Store Connect using xcrun altool.
# Required env:
#   ASC_KEY_ID       App Store Connect API Key ID
#   ASC_ISSUER_ID    App Store Connect Issuer ID
# Optional env:
#   IPA_PATH         Absolute or relative path to .ipa
#   API_PRIVATE_KEYS_DIR  Defaults to ~/.appstoreconnect/private_keys
#   ASC_KEY_PATH     Full path to AuthKey_<ASC_KEY_ID>.p8 (overrides lookup)

usage() {
  cat <<'EOF'
Usage:
  scripts/upload_to_app_store.sh [--ipa <path>] [--bundle-id <id>] [--type ios]

Examples:
  ASC_KEY_ID=XXXX ASC_ISSUER_ID=YYYY \
  scripts/upload_to_app_store.sh --ipa build/ios/ipa/Runner.ipa

  IPA_PATH=/tmp/ipa/Runner.ipa ASC_KEY_ID=XXXX ASC_ISSUER_ID=YYYY \
  scripts/upload_to_app_store.sh

Notes:
  - Lookup order for API key file:
      1) ASC_KEY_PATH
      2) API_PRIVATE_KEYS_DIR/AuthKey_<ASC_KEY_ID>.p8
      3) ~/Downloads/AuthKey_<ASC_KEY_ID>.p8
  - API private key file must exist at:
      ~/.appstoreconnect/private_keys/AuthKey_<ASC_KEY_ID>.p8
    or under API_PRIVATE_KEYS_DIR.
EOF
}

IPA_PATH_ARG=""
BUNDLE_ID=""
APP_TYPE="ios"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --ipa)
      IPA_PATH_ARG="${2:-}"
      shift 2
      ;;
    --bundle-id)
      BUNDLE_ID="${2:-}"
      shift 2
      ;;
    --type)
      APP_TYPE="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

: "${ASC_KEY_ID:?ASC_KEY_ID is required}"
: "${ASC_ISSUER_ID:?ASC_ISSUER_ID is required}"

IPA_PATH="${IPA_PATH_ARG:-${IPA_PATH:-}}"
if [[ -z "$IPA_PATH" ]]; then
  # Prefer exported IPA path from the workflow; fallback to first ipa found in repo.
  if [[ -n "${RUNNER_TEMP:-}" && -d "${RUNNER_TEMP}/ipa" ]]; then
    IPA_PATH="$(find "${RUNNER_TEMP}/ipa" -maxdepth 1 -name '*.ipa' -print -quit)"
  fi
fi
if [[ -z "$IPA_PATH" ]]; then
  IPA_PATH="$(find . -type f -name '*.ipa' -print -quit)"
fi

if [[ -z "$IPA_PATH" || ! -f "$IPA_PATH" ]]; then
  echo "IPA not found. Provide --ipa <path> or set IPA_PATH." >&2
  exit 1
fi

API_PRIVATE_KEYS_DIR="${API_PRIVATE_KEYS_DIR:-$HOME/.appstoreconnect/private_keys}"

if [[ -n "${ASC_KEY_PATH:-}" ]]; then
  ASC_KEY_PATH="${ASC_KEY_PATH}"
else
  ASC_KEY_PATH="${API_PRIVATE_KEYS_DIR}/AuthKey_${ASC_KEY_ID}.p8"
  if [[ ! -f "$ASC_KEY_PATH" ]]; then
    DOWNLOADS_KEY_PATH="$HOME/Downloads/AuthKey_${ASC_KEY_ID}.p8"
    if [[ -f "$DOWNLOADS_KEY_PATH" ]]; then
      ASC_KEY_PATH="$DOWNLOADS_KEY_PATH"
    fi
  fi
fi

if [[ ! -f "$ASC_KEY_PATH" ]]; then
  echo "API key file not found: $ASC_KEY_PATH" >&2
  echo "Checked: ASC_KEY_PATH, ${API_PRIVATE_KEYS_DIR}, and ~/Downloads." >&2
  echo "Place AuthKey_${ASC_KEY_ID}.p8 under ${API_PRIVATE_KEYS_DIR} or pass ASC_KEY_PATH." >&2
  exit 1
fi

echo "Uploading IPA: $IPA_PATH"
echo "Using API key: $ASC_KEY_ID"

cmd=(
  xcrun altool --upload-app
  --file "$IPA_PATH"
  --type "$APP_TYPE"
  --apiKey "$ASC_KEY_ID"
  --apiIssuer "$ASC_ISSUER_ID"
)

if [[ -n "$BUNDLE_ID" ]]; then
  cmd+=(--bundle-id "$BUNDLE_ID")
fi

"${cmd[@]}"

echo "Upload request submitted successfully."
