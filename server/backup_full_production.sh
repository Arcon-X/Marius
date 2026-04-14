#!/usr/bin/env bash
set -euo pipefail

# Full production safety backup for NOVUM-ZIV:
# - PostgreSQL full backup (custom + plain SQL)
# - PostgreSQL globals backup (roles, grants)
# - Project/config backup as tar.gz
# - SHA256 checksums for all generated artifacts
# - Optional restore smoke test into temporary DB
#
# Required tools: pg_dump, pg_dumpall, psql, pg_restore, tar, sha256sum, gzip
# Run example:
#   DB_NAME=novumziv PROJECT_ROOT=/srv/novumziv bash server/backup_full_production.sh

DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-novumziv}"
DB_USER="${DB_USER:-postgres}"

BACKUP_ROOT="${BACKUP_ROOT:-/var/backups/novumziv}"
PROJECT_ROOT="${PROJECT_ROOT:-/srv/novumziv}"
POSTGREST_CONF="${POSTGREST_CONF:-/etc/postgrest.conf}"
NGINX_CONF_DIR="${NGINX_CONF_DIR:-/etc/nginx}"
ENV_FILE="${ENV_FILE:-$PROJECT_ROOT/seva.env}"

# Minimum free disk space required in GB for backup target.
MIN_FREE_GB="${MIN_FREE_GB:-5}"

# Set to 1 to run restore smoke test into temporary database.
RUN_RESTORE_SMOKE_TEST="${RUN_RESTORE_SMOKE_TEST:-1}"
RESTORE_DB_NAME="${RESTORE_DB_NAME:-${DB_NAME}_restore_smoke}"

TS="$(date +%Y%m%d_%H%M%S)"
RUN_DIR="${BACKUP_ROOT}/${TS}"
DB_CUSTOM_DUMP="${RUN_DIR}/${DB_NAME}.dump"
DB_SQL_DUMP="${RUN_DIR}/${DB_NAME}.sql.gz"
DB_GLOBALS_SQL="${RUN_DIR}/globals.sql"
PROJECT_TGZ="${RUN_DIR}/project_backup.tar.gz"
CHECKSUM_FILE="${RUN_DIR}/SHA256SUMS.txt"
META_FILE="${RUN_DIR}/backup_meta.txt"

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "ERROR: Required command not found: $1"
    exit 1
  }
}

require_path_if_exists() {
  local path="$1"
  local label="$2"
  if [[ ! -e "$path" ]]; then
    echo "WARN: ${label} not found: ${path}"
  fi
}

echo "============================================================"
echo " NOVUM-ZIV FULL PRODUCTION BACKUP"
echo " DB        : ${DB_NAME} (${DB_HOST}:${DB_PORT}, user=${DB_USER})"
echo " Project   : ${PROJECT_ROOT}"
echo " Backup dir: ${RUN_DIR}"
echo "============================================================"

need_cmd pg_dump
need_cmd pg_dumpall
need_cmd pg_restore
need_cmd psql
need_cmd tar
need_cmd sha256sum
need_cmd gzip
need_cmd df

mkdir -p "${RUN_DIR}"

FREE_KB="$(df -Pk "${BACKUP_ROOT}" | awk 'NR==2{print $4}')"
FREE_GB="$((FREE_KB / 1024 / 1024))"
if (( FREE_GB < MIN_FREE_GB )); then
  echo "ERROR: Not enough free space in ${BACKUP_ROOT}."
  echo "Need >= ${MIN_FREE_GB} GB, available ~${FREE_GB} GB."
  exit 1
fi

require_path_if_exists "${PROJECT_ROOT}" "PROJECT_ROOT"
require_path_if_exists "${POSTGREST_CONF}" "POSTGREST_CONF"
require_path_if_exists "${NGINX_CONF_DIR}" "NGINX_CONF_DIR"
require_path_if_exists "${ENV_FILE}" "ENV_FILE"

echo "[1/6] Database custom dump (.dump)"
pg_dump \
  -h "${DB_HOST}" \
  -p "${DB_PORT}" \
  -U "${DB_USER}" \
  -Fc "${DB_NAME}" \
  -f "${DB_CUSTOM_DUMP}"

echo "[2/6] Database plain SQL dump (.sql.gz)"
pg_dump \
  -h "${DB_HOST}" \
  -p "${DB_PORT}" \
  -U "${DB_USER}" \
  -Fp "${DB_NAME}" \
  | gzip -c > "${DB_SQL_DUMP}"

echo "[3/6] Globals backup (roles/grants)"
pg_dumpall \
  -h "${DB_HOST}" \
  -p "${DB_PORT}" \
  -U "${DB_USER}" \
  --globals-only > "${DB_GLOBALS_SQL}"

echo "[4/6] Project + config backup archive"
# Store key runtime assets in one archive for fast rollback.
# Missing optional files are skipped by checking existence first.
TMP_LIST="${RUN_DIR}/project_filelist.txt"
: > "${TMP_LIST}"

if [[ -d "${PROJECT_ROOT}" ]]; then
  echo "${PROJECT_ROOT}" >> "${TMP_LIST}"
fi
if [[ -f "${POSTGREST_CONF}" ]]; then
  echo "${POSTGREST_CONF}" >> "${TMP_LIST}"
fi
if [[ -d "${NGINX_CONF_DIR}" ]]; then
  echo "${NGINX_CONF_DIR}" >> "${TMP_LIST}"
fi
if [[ -f "${ENV_FILE}" ]]; then
  echo "${ENV_FILE}" >> "${TMP_LIST}"
fi

if [[ -s "${TMP_LIST}" ]]; then
  tar -czf "${PROJECT_TGZ}" -T "${TMP_LIST}"
else
  echo "ERROR: Nothing to archive. Check PROJECT_ROOT/paths."
  exit 1
fi

echo "[5/6] Checksums + metadata"
(
  cd "${RUN_DIR}"
  sha256sum "$(basename "${DB_CUSTOM_DUMP}")" "$(basename "${DB_SQL_DUMP}")" "$(basename "${DB_GLOBALS_SQL}")" "$(basename "${PROJECT_TGZ}")" > "$(basename "${CHECKSUM_FILE}")"
)

{
  echo "timestamp=${TS}"
  echo "db_host=${DB_HOST}"
  echo "db_port=${DB_PORT}"
  echo "db_name=${DB_NAME}"
  echo "db_user=${DB_USER}"
  echo "project_root=${PROJECT_ROOT}"
  echo "postgrest_conf=${POSTGREST_CONF}"
  echo "nginx_conf_dir=${NGINX_CONF_DIR}"
  echo "env_file=${ENV_FILE}"
  echo "run_restore_smoke_test=${RUN_RESTORE_SMOKE_TEST}"
} > "${META_FILE}"

if [[ "${RUN_RESTORE_SMOKE_TEST}" == "1" ]]; then
  echo "[6/6] Restore smoke test into temporary DB: ${RESTORE_DB_NAME}"
  psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d postgres \
    -v ON_ERROR_STOP=1 -c "DROP DATABASE IF EXISTS ${RESTORE_DB_NAME};"
  psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d postgres \
    -v ON_ERROR_STOP=1 -c "CREATE DATABASE ${RESTORE_DB_NAME};"

  pg_restore \
    -h "${DB_HOST}" \
    -p "${DB_PORT}" \
    -U "${DB_USER}" \
    --clean --if-exists --no-owner --no-privileges \
    -d "${RESTORE_DB_NAME}" "${DB_CUSTOM_DUMP}"

  psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${RESTORE_DB_NAME}" -v ON_ERROR_STOP=1 -c "SELECT COUNT(*) AS benutzer FROM benutzer;"
  psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${RESTORE_DB_NAME}" -v ON_ERROR_STOP=1 -c "SELECT COUNT(*) AS adressen FROM adressen;"
  psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${RESTORE_DB_NAME}" -v ON_ERROR_STOP=1 -c "SELECT COUNT(*) AS protokoll FROM protokoll;"
fi

echo ""
echo "Backup completed successfully."
echo "Artifacts: ${RUN_DIR}"
echo "Checksums: ${CHECKSUM_FILE}"
