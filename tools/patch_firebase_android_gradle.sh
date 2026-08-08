#!/usr/bin/env bash
# Re-apply after `flutter pub get` if Android configure fails on
# `:firebase_analytics` pulling AGP 8.1.4 from dl.google.com.
set -euo pipefail
ANALYTICS="$(dirname "$0")/../.dart_tool/package_config.json"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# Resolve firebase_analytics android/build.gradle from package_config
ANALYTICS_DIR="$(python3 - <<'PY' "$ROOT"
import json, sys, pathlib, urllib.parse
root = pathlib.Path(sys.argv[1])
cfg = json.loads((root / '.dart_tool' / 'package_config.json').read_text())
for p in cfg['packages']:
    if p['name'] == 'firebase_analytics':
        uri = p['rootUri']
        if uri.startswith('file://'):
            print(urllib.parse.unquote(uri[7:]))
        else:
            print(root / '.dart_tool' / uri)
        break
PY
)"
TARGET="$ANALYTICS_DIR/android/build.gradle"
if [[ ! -f "$TARGET" ]]; then
  echo "firebase_analytics android/build.gradle not found"
  exit 1
fi
python3 - <<'PY' "$TARGET"
from pathlib import Path
import sys, re
path = Path(sys.argv[1])
text = path.read_text()
# Strip AGP classpath line if present
new = re.sub(
    r"\s*classpath ['\"]com\.android\.tools\.build:gradle:[^'\"]+['\"]\s*\n",
    "\n",
    text,
)
# Ensure Aliyun mirrors before google() in buildscript/allprojects blocks
if "maven.aliyun.com/repository/google" not in new:
    new = new.replace(
        "repositories {\n        google()",
        "repositories {\n        maven { url 'https://maven.aliyun.com/repository/google' }\n        maven { url 'https://maven.aliyun.com/repository/public' }\n        google()",
    )
if new != text:
    path.write_text(new)
    print(f"patched {path}")
else:
    print(f"already ok: {path}")
PY
