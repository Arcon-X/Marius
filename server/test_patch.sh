#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://127.0.0.1:3000}"

LOGIN_RESP=$(curl -s -X POST "${BASE_URL}/rpc/login" \
  -H 'Content-Type: application/json' \
  -d '{"email":"zahradnik@haselbach.art","passwort":"novum2026!"}')
echo "LOGIN RESPONSE: $LOGIN_RESP"
TOKEN=$(echo "$LOGIN_RESP" | python3 -c "
import sys, json
d = json.load(sys.stdin)
if isinstance(d, list): d = d[0]
print(d.get('token', d) if isinstance(d, dict) else d)
")

echo "TOKEN obtained: ${TOKEN:0:20}..."

echo "--- Testing PATCH ---"
curl -s -X PATCH "${BASE_URL}/benutzer?id=eq.7d69ec23-6fcc-4476-8305-2f22991015ab" \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Prefer: return=representation' \
  -d '{"name":"TestName","email":"test@example.com","telefon":null,"rolle":"mitarbeiter"}' \
  -w '\nHTTP_CODE:%{http_code}\n'

echo "--- Testing view columns ---"
sudo -u postgres psql -d novumziv -c "SELECT column_name, data_type FROM information_schema.columns WHERE table_schema='api' AND table_name='benutzer' ORDER BY ordinal_position;"

echo "--- Testing trigger existence ---"
sudo -u postgres psql -d novumziv -c "SELECT tgname, tgtype FROM pg_trigger WHERE tgrelid = 'api.benutzer'::regclass;"

echo "--- PostgREST schema cache ---"
sudo -u postgres psql -d novumziv -c "NOTIFY pgrst, 'reload schema';"
echo "Schema cache reloaded"
