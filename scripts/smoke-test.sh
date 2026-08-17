#!/usr/bin/env bash

set -euo pipefail

base_url="${KEYCLOAK_URL:-http://localhost:8080}"
health_url="${KEYCLOAK_HEALTH_URL:-http://localhost:9000/health/ready}"
max_attempts=60
login_path="/realms/coder/protocol/openid-connect/auth?client_id=coder-theme-preview&redirect_uri=http%3A%2F%2Flocalhost%3A8080%2Ftheme-preview&response_type=code&scope=openid"

for ((attempt = 1; attempt <= max_attempts; attempt++)); do
  if curl --fail --silent --show-error "${health_url}" >/dev/null 2>&1; then
    break
  fi

  if ((attempt == max_attempts)); then
    echo "Keycloak did not become ready at ${health_url}" >&2
    exit 1
  fi

  sleep 1
done

login_page="$(curl --fail --silent --show-error "${base_url}${login_path}")"

grep --quiet 'coder.css' <<<"${login_page}"
grep --quiet 'kc-form-login' <<<"${login_page}"
grep --quiet 'Welcome back.' <<<"${login_page}"

css_path="$(grep -oE '/resources/[^\"]+/login/coder/css/coder.css' <<<"${login_page}" | head -n 1)"

if [[ -z "${css_path}" ]]; then
  echo "Could not resolve the Coder theme stylesheet from the login page" >&2
  exit 1
fi

curl --fail --silent --show-error "${base_url}${css_path}" | grep --quiet -- '--coder-black: #090b0b'

echo "OK: Keycloak is ready, the coder realm is imported, and the custom theme is served."
