#!/usr/bin/env bash
set -euo pipefail

FLUTTER_DIR="${HOME}/flutter"

if ! command -v flutter >/dev/null 2>&1; then
  if [ ! -d "${FLUTTER_DIR}" ]; then
    git clone https://github.com/flutter/flutter.git --depth 1 --branch stable "${FLUTTER_DIR}"
  fi
  export PATH="${FLUTTER_DIR}/bin:${PATH}"
fi

flutter --version
flutter config --enable-web

# Ensure .env exists during cloud builds because it is listed as a Flutter asset.
if [ ! -f ".env" ]; then
  cat > .env <<EOF
API_BASE_URL=${API_BASE_URL:-https://asrtoidea-production.up.railway.app/api/v1}
REQUEST_TIMEOUT_SECONDS=${REQUEST_TIMEOUT_SECONDS:-30}
EOF
fi

flutter pub get
flutter build web --release
