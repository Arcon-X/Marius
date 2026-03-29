#!/usr/bin/env bash
# Test the full force-pw-change flow:
# 1) Login with default pw → passwort_aendern: true
# 2) Change password to a new one
# 3) Login again with new pw → passwort_aendern: false
# 4) Reset password back to novum2026!

TOKEN=$(curl -s -X POST http://localhost:3000/rpc/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"zahradnik@haselbach.art","passwort":"novum2026!"}' | python3 -c "import sys,json;print(json.load(sys.stdin)['token'])")

echo "=== Step 1: Login with default pw ==="
curl -s -X POST http://localhost:3000/rpc/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"zahradnik@haselbach.art","passwort":"novum2026!"}' | python3 -c "import sys,json;d=json.load(sys.stdin);print('passwort_aendern:', d['passwort_aendern'])"

echo ""
echo "=== Step 2: Change password ==="
curl -s -X POST http://localhost:3000/rpc/change_password \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"altes_passwort":"novum2026!","neues_passwort":"TestPw2025!"}' 
echo "(change done)"

echo ""
echo "=== Step 3: Login with new pw ==="
curl -s -X POST http://localhost:3000/rpc/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"zahradnik@haselbach.art","passwort":"TestPw2025!"}' | python3 -c "import sys,json;d=json.load(sys.stdin);print('passwort_aendern:', d['passwort_aendern'])"

echo ""
echo "=== Step 4: Reset back to novum2026! ==="
TOKEN2=$(curl -s -X POST http://localhost:3000/rpc/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"zahradnik@haselbach.art","passwort":"TestPw2025!"}' | python3 -c "import sys,json;print(json.load(sys.stdin)['token'])")

curl -s -X POST http://localhost:3000/rpc/admin_reset_password \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $TOKEN2" \
  -d '{"target_email":"zahradnik@haselbach.art","neues_passwort":"novum2026!"}'
echo "(reset done)"

echo ""
echo "=== Verify: Login with novum2026! again ==="
curl -s -X POST http://localhost:3000/rpc/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"zahradnik@haselbach.art","passwort":"novum2026!"}' | python3 -c "import sys,json;d=json.load(sys.stdin);print('passwort_aendern:', d['passwort_aendern'])"
