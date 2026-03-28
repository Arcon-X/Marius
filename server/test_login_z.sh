#!/bin/bash
echo "=== Direct PostgREST test (no Nginx) ==="
curl -sk -w "\nHTTP: %{http_code}\n" -X POST http://127.0.0.1:3000/rpc/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"zahradnik@haselbach.art","passwort":"novum2026!"}'

echo ""
echo "=== Via Nginx HTTPS ==="
curl -sk -w "\nHTTP: %{http_code}\n" -X POST https://204.168.217.211.nip.io/api/rpc/login \
  -H 'Content-Type: application/json' \
  -H 'Origin: https://arcon-x.github.io' \
  -d '{"email":"zahradnik@haselbach.art","passwort":"novum2026!"}'

echo ""
echo "=== PostgREST status ==="
systemctl is-active postgrest
