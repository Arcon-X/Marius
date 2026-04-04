#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://localhost:3000}"
LOGIN_EMAIL="${LOGIN_EMAIL:-}"
LOGIN_PASS="${LOGIN_PASS:-}"

if [[ -z "$LOGIN_EMAIL" || -z "$LOGIN_PASS" ]]; then
  echo "ERROR: LOGIN_EMAIL und LOGIN_PASS muessen gesetzt sein."
  exit 1
fi

curl -s -X POST "${BASE_URL}/rpc/login" \
  -H 'Content-Type: application/json' \
  -d "{\"email\":\"${LOGIN_EMAIL}\",\"passwort\":\"${LOGIN_PASS}\"}" | python3 -m json.tool
