#!/bin/bash
set -euo pipefail

TARGET_EMAIL="${TARGET_EMAIL:-}"
LOGIN_EMAIL="${LOGIN_EMAIL:-}"
LOGIN_PASS="${LOGIN_PASS:-}"
API_BASE="${API_BASE:-https://204.168.217.211.nip.io/api}"

if [[ -z "$TARGET_EMAIL" || -z "$LOGIN_EMAIL" || -z "$LOGIN_PASS" ]]; then
  echo "ERROR: TARGET_EMAIL, LOGIN_EMAIL und LOGIN_PASS muessen gesetzt sein."
  exit 1
fi

echo "=== 1. Check user exists ==="
sudo -u postgres psql -d novumziv -c "SELECT id, email, rolle, LEFT(passwort_hash,30)||'...' as hash_prefix FROM benutzer WHERE email='${TARGET_EMAIL}';"

echo ""
echo "=== 2. curl login test (direct via Nginx) ==="
curl -sk -w "\nHTTP: %{http_code}\n" -X POST "${API_BASE}/rpc/login" \
  -H "Content-Type: application/json" \
  -H "Origin: https://204.168.217.211.nip.io" \
  -d "{\"email\":\"${LOGIN_EMAIL}\",\"passwort\":\"${LOGIN_PASS}\"}"

echo ""
echo "=== 3. curl login test (direct PostgREST) ==="
curl -sk -w "\nHTTP: %{http_code}\n" -X POST http://127.0.0.1:3000/rpc/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"${LOGIN_EMAIL}\",\"passwort\":\"${LOGIN_PASS}\"}"

echo ""
echo "=== 4. PostgREST recent logs ==="
journalctl -u postgrest --since "2 hours ago" --no-pager | grep -E "400|403|login" | tail -15
