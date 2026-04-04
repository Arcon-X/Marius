#!/usr/bin/env bash
set -euo pipefail

# Test the full force-pw-change flow:
# 1) Login with default pw → passwort_aendern: true
# 2) Change password to a new one
# 3) Login again with new pw → passwort_aendern: false
# 4) Reset password back to initial

LOGIN_EMAIL="${LOGIN_EMAIL:-}"
INITIAL_PASS="${INITIAL_PASS:-}"
NEW_PASS="${NEW_PASS:-TestPw2025!}"

if [[ -z "$LOGIN_EMAIL" || -z "$INITIAL_PASS" ]]; then
  echo "ERROR: LOGIN_EMAIL und INITIAL_PASS muessen gesetzt sein."
  exit 1
fi

TOKEN=$(curl -s -X POST http://localhost:3000/rpc/login \
  -H 'Content-Type: application/json' \
  -d "{\"email\":\"${LOGIN_EMAIL}\",\"passwort\":\"${INITIAL_PASS}\"}" | python3 -c "import sys,json;print(json.load(sys.stdin)['token'])")

echo "=== Step 1: Login with default pw ==="
curl -s -X POST http://localhost:3000/rpc/login \
  -H 'Content-Type: application/json' \
  -d "{\"email\":\"${LOGIN_EMAIL}\",\"passwort\":\"${INITIAL_PASS}\"}" | python3 -c "import sys,json;d=json.load(sys.stdin);print('passwort_aendern:', d['passwort_aendern'])"

echo ""
echo "=== Step 2: Change password ==="
curl -s -X POST http://localhost:3000/rpc/change_password \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $TOKEN" \
  -d "{\"altes_passwort\":\"${INITIAL_PASS}\",\"neues_passwort\":\"${NEW_PASS}\"}" 
echo "(change done)"

echo ""
echo "=== Step 3: Login with new pw ==="
curl -s -X POST http://localhost:3000/rpc/login \
  -H 'Content-Type: application/json' \
  -d "{\"email\":\"${LOGIN_EMAIL}\",\"passwort\":\"${NEW_PASS}\"}" | python3 -c "import sys,json;d=json.load(sys.stdin);print('passwort_aendern:', d['passwort_aendern'])"

echo ""
echo "=== Step 4: Reset back to initial ==="
TOKEN2=$(curl -s -X POST http://localhost:3000/rpc/login \
  -H 'Content-Type: application/json' \
  -d "{\"email\":\"${LOGIN_EMAIL}\",\"passwort\":\"${NEW_PASS}\"}" | python3 -c "import sys,json;print(json.load(sys.stdin)['token'])")

curl -s -X POST http://localhost:3000/rpc/admin_reset_password \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $TOKEN2" \
  -d "{\"target_email\":\"${LOGIN_EMAIL}\",\"neues_passwort\":\"${INITIAL_PASS}\"}"
echo "(reset done)"

echo ""
echo "=== Verify: Login with initial password again ==="
curl -s -X POST http://localhost:3000/rpc/login \
  -H 'Content-Type: application/json' \
  -d "{\"email\":\"${LOGIN_EMAIL}\",\"passwort\":\"${INITIAL_PASS}\"}" | python3 -c "import sys,json;d=json.load(sys.stdin);print('passwort_aendern:', d['passwort_aendern'])"
