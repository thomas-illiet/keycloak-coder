#!/usr/bin/env bash

set -euo pipefail

base_url="${KEYCLOAK_URL:-http://localhost:8080}"
health_url="${KEYCLOAK_HEALTH_URL:-http://localhost:9000/health/ready}"
max_attempts=60
login_path="/realms/bnp-paribas/protocol/openid-connect/auth?client_id=coder-theme-preview&redirect_uri=http%3A%2F%2Flocalhost%3A8080%2Ftheme-preview&response_type=code&scope=openid"

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
master_login_page="$(
  curl --fail --silent --show-error --get "${base_url}/realms/master/protocol/openid-connect/auth" \
    --data-urlencode 'client_id=account-console' \
    --data-urlencode "redirect_uri=${base_url}/realms/master/account/" \
    --data-urlencode 'response_type=code' \
    --data-urlencode 'scope=openid' \
    --data-urlencode 'code_challenge=E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM' \
    --data-urlencode 'code_challenge_method=S256'
)"
welcome_page="$(curl --fail --silent --show-error "${base_url}/")"
account_page="$(curl --fail --silent --show-error "${base_url}/realms/bnp-paribas/account/")"

grep --quiet 'coder.css' <<<"${login_page}"
grep --quiet 'kc-form-login' <<<"${login_page}"
grep --quiet 'Welcome back.' <<<"${login_page}"
grep --quiet 'id="kc-social-providers"' <<<"${login_page}"
grep --quiet 'id="social-corporate-oidc"' <<<"${login_page}"
grep --quiet 'aria-label="OpenID Connect"' <<<"${login_page}"
grep --quiet '/broker/corporate-oidc/login' <<<"${login_page}"
grep --quiet '>code station</div>' <<<"${login_page}"
if grep --quiet 'coder.css' <<<"${master_login_page}"; then
  grep --quiet '>code station</div>' <<<"${master_login_page}"
  if grep --quiet 'class="kc-logo-text"' <<<"${master_login_page}"; then
    echo "The themed master login page still renders the Keycloak logo" >&2
    exit 1
  fi
else
  grep --quiet 'class="kc-logo-text"' <<<"${master_login_page}"
fi
grep --quiet 'welcome.css' <<<"${welcome_page}"
grep --quiet 'Code Station is ready.' <<<"${welcome_page}"
grep --quiet 'realm bnp-paribas ready' <<<"${welcome_page}"
grep --quiet 'data-page-id="account"' <<<"${account_page}"
grep --quiet '"logo": "logo.svg"' <<<"${account_page}"

css_path="$(grep -oE '/resources/[^\"]+/login/coder/css/coder.css' <<<"${login_page}" | head -n 1)"
welcome_css_path="$(grep -oE 'resources/[^\"]+/welcome/coder/css/welcome.css' <<<"${welcome_page}" | head -n 1)"
account_resources_path="$(grep -oE '/resources/[^\"]+/account/coder' <<<"${account_page}" | head -n 1)"

if [[ -z "${css_path}" ]]; then
  echo "Could not resolve the Coder theme stylesheet from the login page" >&2
  exit 1
fi

if [[ -z "${welcome_css_path}" ]]; then
  echo "Could not resolve the Code Station stylesheet from the welcome page" >&2
  exit 1
fi

if [[ -z "${account_resources_path}" ]]; then
  echo "Could not resolve the Code Station Account Console resources" >&2
  exit 1
fi

welcome_css_path="/${welcome_css_path#/}"

login_css="$(curl --fail --silent --show-error "${base_url}${css_path}")"
welcome_css="$(curl --fail --silent --show-error "${base_url}${welcome_css_path}")"
account_logo="$(curl --fail --silent --show-error "${base_url}${account_resources_path}/logo.svg")"
master_logo_rule="$(grep -A 1 -- '#kc-header-wrapper :is(.kc-logo-text, img, picture, svg)' <<<"${login_css}")"

grep --quiet -- '--coder-black: #090b0b' <<<"${login_css}"
grep --quiet -- '--code-station-accent: #00a76d' <<<"${login_css}"
grep --quiet -- 'display: none !important' <<<"${master_logo_rule}"
grep --fixed-strings --quiet -- '#kc-social-providers a[id^="social-"]' <<<"${login_css}"
grep --quiet -- '--station-black: #090b0b' <<<"${welcome_css}"
grep --quiet -- '--station-accent: #00a76d' <<<"${welcome_css}"
grep --fixed-strings --quiet -- '<svg' <<<"${account_logo}"
grep --fixed-strings --quiet -- '<title>code station</title>' <<<"${account_logo}"
grep --fixed-strings --quiet -- '>code station</text>' <<<"${account_logo}"

echo "OK: Keycloak is ready, the bnp-paribas realm is imported, and the login, account, and welcome themes are served."
