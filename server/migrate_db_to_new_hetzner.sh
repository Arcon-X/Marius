#!/usr/bin/env bash
set -euo pipefail

# Database migration helper (old Hetzner -> new Hetzner)
# Uses pg_dump custom format, secure copy, restore, and row-count checks.
#
# Required environment variables:
#   OLD_HOST          default: 204.168.217.211
#   NEW_HOST          e.g. 203.0.113.10
# Optional environment variables:
#   SSH_USER          default: root
#   SSH_KEY           default: ~/.ssh/id_ed25519_novumziv2
#   DB_NAME           default: novumziv
#   DB_PORT           default: 5432
#   DUMP_PATH         default: /tmp/novumziv_YYYYmmdd_HHMMSS.dump
#   SKIP_RESTORE      default: 0 (set to 1 to only create/copy dump)
#
# Example:
#   NEW_HOST=203.0.113.10 \
#   SSH_KEY=~/.ssh/id_ed25519_novumziv2 \
#   bash server/migrate_db_to_new_hetzner.sh

OLD_HOST="${OLD_HOST:-204.168.217.211}"
NEW_HOST="${NEW_HOST:-}"
SSH_USER="${SSH_USER:-root}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/id_ed25519_novumziv2}"
DB_NAME="${DB_NAME:-novumziv}"
DB_PORT="${DB_PORT:-5432}"
SKIP_RESTORE="${SKIP_RESTORE:-0}"
DUMP_PATH="${DUMP_PATH:-/tmp/${DB_NAME}_$(date +%Y%m%d_%H%M%S).dump}"

if [[ -z "$NEW_HOST" ]]; then
  echo "ERROR: NEW_HOST is required."
  exit 1
fi

if [[ ! -f "$SSH_KEY" ]]; then
  echo "ERROR: SSH key not found at $SSH_KEY"
  exit 1
fi

echo "=== NOVUM-ZIV DB Migration ==="
echo "Old host: $OLD_HOST"
echo "New host: $NEW_HOST"
echo "DB name : $DB_NAME"
echo "Dump    : $DUMP_PATH"
echo ""

SSH_OLD=(ssh -i "$SSH_KEY" "$SSH_USER@$OLD_HOST")
SSH_NEW=(ssh -i "$SSH_KEY" "$SSH_USER@$NEW_HOST")
SCP_CMD=(scp -i "$SSH_KEY")

echo "[1/6] Baseline row counts on old host"
"${SSH_OLD[@]}" "sudo -u postgres psql -p $DB_PORT -d $DB_NAME -c \"SELECT 'benutzer' AS t, COUNT(*) AS c FROM benutzer UNION ALL SELECT 'adressen', COUNT(*) FROM adressen UNION ALL SELECT 'protokoll', COUNT(*) FROM protokoll ORDER BY t;\""

echo ""
echo "[2/6] Creating pg_dump on old host"
"${SSH_OLD[@]}" "sudo -u postgres pg_dump -p $DB_PORT -Fc $DB_NAME -f $DUMP_PATH"

echo ""
echo "[3/6] Copy dump to local machine"
LOCAL_DUMP="$(basename "$DUMP_PATH")"
"${SCP_CMD[@]}" "$SSH_USER@$OLD_HOST:$DUMP_PATH" "./$LOCAL_DUMP"

echo ""
echo "[4/6] Copy dump to new host"
"${SCP_CMD[@]}" "./$LOCAL_DUMP" "$SSH_USER@$NEW_HOST:$DUMP_PATH"

if [[ "$SKIP_RESTORE" == "1" ]]; then
  echo ""
  echo "SKIP_RESTORE=1 set. Dump transfer done."
  exit 0
fi

echo ""
echo "[5/6] Restoring dump on new host"
"${SSH_NEW[@]}" "sudo -u postgres pg_restore -p $DB_PORT --clean --if-exists --no-owner --no-privileges -d $DB_NAME $DUMP_PATH"

echo ""
echo "[6/6] Parity checks on new host"
"${SSH_NEW[@]}" "sudo -u postgres psql -p $DB_PORT -d $DB_NAME -c \"SELECT 'benutzer' AS t, COUNT(*) AS c FROM benutzer UNION ALL SELECT 'adressen', COUNT(*) FROM adressen UNION ALL SELECT 'protokoll', COUNT(*) FROM protokoll ORDER BY t;\""
"${SSH_NEW[@]}" "curl -sf http://127.0.0.1:3000/rpc/login -H 'Content-Type: application/json' -d '{\"email\":\"zahradnik@haselbach.art\",\"passwort\":\"novum2026!\"}' >/dev/null && echo 'PostgREST login endpoint reachable'"

echo ""
echo "Migration complete. Keep old server online for rollback window."
