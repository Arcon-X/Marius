#!/usr/bin/env bash
curl -s -X POST http://localhost:3000/rpc/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"zahradnik@haselbach.art","passwort":"novum2026!"}' | python3 -m json.tool
