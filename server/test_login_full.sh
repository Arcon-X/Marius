#!/bin/bash
# Full login flow test through Nginx
SERVER_DOMAIN="${SERVER_DOMAIN:-204.168.217.211.nip.io}"
BASE_URL="${BASE_URL:-https://${SERVER_DOMAIN}}"
LOGIN_EMAIL="${LOGIN_EMAIL:-}"
LOGIN_PASS="${LOGIN_PASS:-}"

if [[ -z "$LOGIN_EMAIL" || -z "$LOGIN_PASS" ]]; then
  echo "ERROR: LOGIN_EMAIL und LOGIN_PASS muessen gesetzt sein."
  exit 1
fi

echo "=== 1. Preflight OPTIONS ==="
curl -sk -D- -X OPTIONS \
  -H "Origin: ${BASE_URL}" \
  -H 'Access-Control-Request-Method: POST' \
  -H 'Access-Control-Request-Headers: content-type' \
  "${BASE_URL}/api/rpc/login" 2>/dev/null | head -15

echo ""
echo "=== 2. Actual POST (wrong credentials) ==="
curl -sk -D- -X POST \
  -H "Origin: ${BASE_URL}" \
  -H 'Content-Type: application/json' \
  -d '{"email":"test@example.com","passwort":"wrongpw"}' \
  "${BASE_URL}/api/rpc/login" 2>/dev/null | head -20

echo ""
echo "=== 3. Actual POST (valid user) ==="
curl -sk -D- -X POST \
  -H "Origin: ${BASE_URL}" \
  -H 'Content-Type: application/json' \
  -d "{\"email\":\"${LOGIN_EMAIL}\",\"passwort\":\"${LOGIN_PASS}\"}" \
  "${BASE_URL}/api/rpc/login" 2>/dev/null | head -20

echo ""
echo "=== 4. PostgREST logs ==="
journalctl -u postgrest --no-pager -n 10 2>/dev/null
