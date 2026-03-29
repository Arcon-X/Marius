#!/bin/bash
# Full login flow test through Nginx
echo "=== 1. Preflight OPTIONS ==="
curl -sk -D- -X OPTIONS \
  -H 'Origin: https://204.168.217.211.nip.io' \
  -H 'Access-Control-Request-Method: POST' \
  -H 'Access-Control-Request-Headers: content-type' \
  https://204.168.217.211.nip.io/api/rpc/login 2>/dev/null | head -15

echo ""
echo "=== 2. Actual POST (wrong credentials) ==="
curl -sk -D- -X POST \
  -H 'Origin: https://204.168.217.211.nip.io' \
  -H 'Content-Type: application/json' \
  -d '{"email":"test@example.com","passwort":"wrongpw"}' \
  https://204.168.217.211.nip.io/api/rpc/login 2>/dev/null | head -20

echo ""
echo "=== 3. Actual POST (valid user) ==="
curl -sk -D- -X POST \
  -H 'Origin: https://204.168.217.211.nip.io' \
  -H 'Content-Type: application/json' \
  -d '{"email":"marius.romanin@bnz-wien.at","passwort":"novum2026!"}' \
  https://204.168.217.211.nip.io/api/rpc/login 2>/dev/null | head -20

echo ""
echo "=== 4. PostgREST logs ==="
journalctl -u postgrest --no-pager -n 10 2>/dev/null
