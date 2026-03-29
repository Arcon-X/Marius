#!/bin/bash
echo "=== PostgREST login test ==="
curl -sk -w "\nHTTP: %{http_code}\n" -X POST http://127.0.0.1:3000/rpc/login \
  -H "Content-Type: application/json" \
  -d '{"email":"zahradnik@haselbach.art","passwort":"Artcecil1975"}'
