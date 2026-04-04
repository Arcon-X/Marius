#!/usr/bin/env bash
set -euo pipefail

DB_NAME="${DB_NAME:-novumziv}"
BACKUP_DIR="${BACKUP_DIR:-/tmp}"
RUN_TS="$(date +%Y%m%d_%H%M%S)"
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_before_reset_${RUN_TS}.dump"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SQL_FILE="${SCRIPT_DIR}/reset_all_addresses.sql"

if [[ ! -f "$SQL_FILE" ]]; then
  echo "ERROR: SQL file not found: $SQL_FILE"
  exit 1
fi

echo "============================================================"
echo " NOVUM-ZIV Voll-Reset (Adressen + Protokoll)"
echo " DB: $DB_NAME"
echo " Backup: $BACKUP_FILE"
echo "============================================================"
echo ""
echo "Dieser Vorgang setzt alle Adressen auf Initialzustand und loescht protokoll."
read -r -p "Zum Fortfahren exakt RESET eingeben: " CONFIRM

if [[ "$CONFIRM" != "RESET" ]]; then
  echo "Abgebrochen."
  exit 1
fi

echo "[1/3] Backup erstellen..."
sudo -u postgres pg_dump -Fc "$DB_NAME" -f "$BACKUP_FILE"

echo "[2/3] Reset-SQL ausfuehren..."
sudo -u postgres psql -d "$DB_NAME" -f "$SQL_FILE"

echo "[3/3] Ergebnis pruefen..."
sudo -u postgres psql -d "$DB_NAME" -c "SELECT status, COUNT(*) AS c FROM adressen GROUP BY status ORDER BY status;"
sudo -u postgres psql -d "$DB_NAME" -c "SELECT COUNT(*) AS protokoll_eintraege FROM protokoll;"
sudo -u postgres psql -d "$DB_NAME" -c "SELECT COUNT(*) AS verifiziert_true FROM adressen WHERE verifiziert = true;"

echo ""
echo "Fertig. Backup liegt unter: $BACKUP_FILE"
