#!/usr/bin/env bash
BASE_URL="${BASE_URL:-http://localhost:3000}"

curl -s -X POST "${BASE_URL}/rpc/login" \
  -H 'Content-Type: application/json' \
  -d '{"email":"zahradnik@haselbach.art","passwort":"novum2026!"}' | python3 -m json.tool
