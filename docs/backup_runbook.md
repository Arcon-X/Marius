---
title: "NOVUM-ZIV - Backup and Restore Runbook"
---

# Backup and Restore Runbook

## Goal

Prevent production data loss before functional changes.

This runbook defines the mandatory safety gate:

1. Full DB backup
2. Full project/config backup
3. Checksum verification
4. Restore smoke test
5. Go/No-Go decision

## Preconditions

- PostgreSQL client tools installed: pg_dump, pg_dumpall, pg_restore, psql
- Enough disk space in backup root (recommended: >= 5 GB free)
- Operator has credentials and permissions
- Backup path is readable by the DB user context

## 1) Full backup (mandatory)

Run on production host:

```bash
DB_NAME=novumziv \
DB_USER=postgres \
PROJECT_ROOT=/srv/novumziv \
BACKUP_ROOT=/var/backups/novumziv \
RUN_RESTORE_SMOKE_TEST=1 \
bash server/backup_full_production.sh
```

Expected output:

- Timestamped folder in backup root
- Files:
  - novumziv.dump
  - novumziv.sql.gz
  - globals.sql
  - project_backup.tar.gz
  - SHA256SUMS.txt
  - backup_meta.txt

## 2) Verify backup artifacts

The backup script already writes and checks checksums.
For manual verification:

```bash
cd /var/backups/novumziv/<timestamp>
sha256sum -c SHA256SUMS.txt
```

## 3) Restore smoke test (mandatory)

If not already run with RUN_RESTORE_SMOKE_TEST=1, execute with that flag.
The script restores to a temporary DB and runs count queries on:

- benutzer
- adressen
- protokoll

Proceed only if all checks pass.

## 4) Optional full restore (disaster recovery)

Restore DB and project from a selected backup folder:

```bash
BACKUP_DIR=/var/backups/novumziv/<timestamp> \
DB_NAME=novumziv \
DB_USER=postgres \
RESTORE_DATABASE=1 \
RESTORE_PROJECT=1 \
bash server/restore_from_full_backup.sh
```

## 5) Change window rule

No production-facing change is allowed unless all are true:

- Full backup completed
- Checksums validated
- Restore smoke test passed
- Backup path and timestamp documented in change ticket

## Notes

- Keep the newest pre-change backup immutable for at least 24h after deploy.
- For DB operations as postgres user, avoid unreadable paths like /root; use /tmp or dedicated backup folders with proper permissions.
