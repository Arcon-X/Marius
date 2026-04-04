#!/bin/bash
set -euo pipefail

LOGIN_EMAIL="${LOGIN_EMAIL:-}"
LOGIN_PASS="${LOGIN_PASS:-}"

if [[ -z "$LOGIN_EMAIL" || -z "$LOGIN_PASS" ]]; then
  echo "ERROR: LOGIN_EMAIL und LOGIN_PASS muessen gesetzt sein."
  exit 1
fi

echo "=== Direct PostgREST test (no Nginx) ==="
curl -sk -w "\nHTTP: %{http_code}\n" -X POST http://127.0.0.1:3000/rpc/login \
  -H 'Content-Type: application/json' \
  -d "{\"email\":\"${LOGIN_EMAIL}\",\"passwort\":\"${LOGIN_PASS}\"}"

echo ""
echo "=== Via Nginx HTTPS ==="
curl -sk -w "\nHTTP: %{http_code}\n" -X POST https://204.168.217.211.nip.io/api/rpc/login \
  -H 'Content-Type: application/json' \
  -H 'Origin: https://204.168.217.211.nip.io' \
  -d "{\"email\":\"${LOGIN_EMAIL}\",\"passwort\":\"${LOGIN_PASS}\"}"

echo ""
echo "=== PostgREST status ==="
systemctl is-active postgrest
