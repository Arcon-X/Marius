#!/bin/bash
echo "=== 1. Check user exists ==="
sudo -u postgres psql -d novumziv -c "SELECT id, email, rolle, LEFT(passwort_hash,30)||'...' as hash_prefix FROM benutzer WHERE email='zahradnik@haselbach.art';"

echo ""
echo "=== 2. curl login test (direct via Nginx) ==="
curl -sk -w "\nHTTP: %{http_code}\n" -X POST https://204.168.217.211.nip.io/api/rpc/login \
  -H "Content-Type: application/json" \
  -H "Origin: https://204.168.217.211.nip.io" \
  -d '{"email":"zahradnik@haselbach.art","passwort":"novum2026!"}'

echo ""
echo "=== 3. curl login test (direct PostgREST) ==="
curl -sk -w "\nHTTP: %{http_code}\n" -X POST http://127.0.0.1:3000/rpc/login \
  -H "Content-Type: application/json" \
  -d '{"email":"zahradnik@haselbach.art","passwort":"novum2026!"}'

echo ""
echo "=== 4. PostgREST recent logs ==="
journalctl -u postgrest --since "2 hours ago" --no-pager | grep -E "400|403|login" | tail -15
