#!/bin/bash
# Hash mit PostgreSQL's eigenem crypt() neu erstellen (erzeugt $2a$ Format)
sudo -u postgres psql -d novumziv -c \
  "UPDATE public.benutzer SET passwort_hash = crypt('novum2026!', gen_salt('bf', 10)) WHERE email = 'zahradnik@haselbach.art';"

# Verifizieren
sudo -u postgres psql -d novumziv -t -c \
  "SELECT email, left(passwort_hash,7) AS hash_prefix FROM public.benutzer WHERE email = 'zahradnik@haselbach.art';"

echo "DONE"
