#!/bin/bash
set -euo pipefail

TARGET_EMAIL="${TARGET_EMAIL:-}"
TARGET_PASS="${TARGET_PASS:-}"

if [[ -z "$TARGET_EMAIL" || -z "$TARGET_PASS" ]]; then
  echo "ERROR: TARGET_EMAIL und TARGET_PASS muessen gesetzt sein."
  exit 1
fi

# Hash mit PostgreSQL's eigenem crypt() neu erstellen (erzeugt $2a$ Format)
sudo -u postgres psql -d novumziv -c \
  "UPDATE public.benutzer SET passwort_hash = crypt('${TARGET_PASS}', gen_salt('bf', 10)) WHERE email = '${TARGET_EMAIL}';"

# Verifizieren
sudo -u postgres psql -d novumziv -t -c \
  "SELECT email, left(passwort_hash,7) AS hash_prefix FROM public.benutzer WHERE email = '${TARGET_EMAIL}';"

echo "DONE"
