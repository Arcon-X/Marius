#!/usr/bin/env bash
set -euo pipefail

# Restore helper for artifacts created by backup_full_production.sh.
# WARNING: This can overwrite a live database and project files.
# Recommended: restore into staging first.
#
# Example:
#   BACKUP_DIR=/var/backups/novumziv/20260414_120000 \
#   DB_NAME=novumziv \
#   PROJECT_RESTORE_ROOT=/srv \
#   bash server/restore_from_full_backup.sh

BACKUP_DIR="${BACKUP_DIR:-}"
DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-novumziv}"
DB_USER="${DB_USER:-postgres}"
PROJECT_RESTORE_ROOT="${PROJECT_RESTORE_ROOT:-/}"
RESTORE_DATABASE="${RESTORE_DATABASE:-0}"
RESTORE_PROJECT="${RESTORE_PROJECT:-0}"

if [[ -z "${BACKUP_DIR}" ]]; then
  echo "ERROR: BACKUP_DIR is required."
  exit 1
fi

DB_CUSTOM_DUMP="${BACKUP_DIR}/${DB_NAME}.dump"
PROJECT_TGZ="${BACKUP_DIR}/project_backup.tar.gz"
CHECKSUM_FILE="${BACKUP_DIR}/SHA256SUMS.txt"

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "ERROR: Required command not found: $1"
    exit 1
  }
}

need_cmd sha256sum
need_cmd pg_restore
need_cmd psql
need_cmd tar

if [[ ! -f "${CHECKSUM_FILE}" ]]; then
  echo "ERROR: checksum file missing: ${CHECKSUM_FILE}"
  exit 1
fi

if [[ ! -f "${DB_CUSTOM_DUMP}" && "${RESTORE_DATABASE}" == "1" ]]; then
  echo "ERROR: DB dump not found: ${DB_CUSTOM_DUMP}"
  exit 1
fi

if [[ ! -f "${PROJECT_TGZ}" && "${RESTORE_PROJECT}" == "1" ]]; then
  echo "ERROR: Project backup not found: ${PROJECT_TGZ}"
  exit 1
fi

echo "Verifying checksums in ${BACKUP_DIR}"
(
  cd "${BACKUP_DIR}"
  sha256sum -c "$(basename "${CHECKSUM_FILE}")"
)

if [[ "${RESTORE_DATABASE}" != "1" && "${RESTORE_PROJECT}" != "1" ]]; then
  echo "Nothing to restore. Set RESTORE_DATABASE=1 and/or RESTORE_PROJECT=1"
  exit 0
fi

echo "============================================================"
echo " NOVUM-ZIV RESTORE"
echo " Backup dir: ${BACKUP_DIR}"
echo " DB        : ${DB_NAME} (${DB_HOST}:${DB_PORT})"
echo " Restore DB: ${RESTORE_DATABASE}"
echo " Restore FS: ${RESTORE_PROJECT}"
echo "============================================================"
read -r -p "Type RESTORE to continue: " CONFIRM
if [[ "${CONFIRM}" != "RESTORE" ]]; then
  echo "Aborted."
  exit 1
fi

if [[ "${RESTORE_DATABASE}" == "1" ]]; then
  echo "[1/2] Restoring database ${DB_NAME}"
  pg_restore \
    -h "${DB_HOST}" \
    -p "${DB_PORT}" \
    -U "${DB_USER}" \
    --clean --if-exists --no-owner --no-privileges \
    -d "${DB_NAME}" "${DB_CUSTOM_DUMP}"

  psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" -v ON_ERROR_STOP=1 -c "SELECT COUNT(*) AS benutzer FROM benutzer;"
  psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" -v ON_ERROR_STOP=1 -c "SELECT COUNT(*) AS adressen FROM adressen;"
  psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" -v ON_ERROR_STOP=1 -c "SELECT COUNT(*) AS protokoll FROM protokoll;"
fi

if [[ "${RESTORE_PROJECT}" == "1" ]]; then
  echo "[2/2] Restoring project/config archive into ${PROJECT_RESTORE_ROOT}"
  tar -xzf "${PROJECT_TGZ}" -C "${PROJECT_RESTORE_ROOT}"
fi

echo "Restore completed."
