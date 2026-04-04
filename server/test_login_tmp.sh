#!/bin/bash
set -euo pipefail

LOGIN_EMAIL="${LOGIN_EMAIL:-}"
LOGIN_PASS="${LOGIN_PASS:-}"

if [[ -z "$LOGIN_EMAIL" || -z "$LOGIN_PASS" ]]; then
  echo "ERROR: LOGIN_EMAIL und LOGIN_PASS muessen gesetzt sein."
  exit 1
fi

echo "=== PostgREST login test ==="
curl -sk -w "\nHTTP: %{http_code}\n" -X POST http://127.0.0.1:3000/rpc/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"${LOGIN_EMAIL}\",\"passwort\":\"${LOGIN_PASS}\"}"
