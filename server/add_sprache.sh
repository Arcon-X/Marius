#!/bin/bash
set -e
sudo -u postgres psql -d novumziv << 'ENDSQL'
-- Spalte sprache hinzufügen (Default: 'de')
ALTER TABLE adressen ADD COLUMN IF NOT EXISTS sprache TEXT NOT NULL DEFAULT 'de';

-- View neu erstellen mit sprache-Spalte
DROP VIEW IF EXISTS api.adressen;
CREATE VIEW api.adressen AS
  SELECT id, plz, ort, strasse, hausnummer, zusatz,
         lat, lon, status, benutzer_id, reserviert_am, erledigt_am,
         import_batch, titel, arzt_name, geo_name, sprache
  FROM public.adressen;

-- Grants wiederherstellen
GRANT SELECT ON api.adressen TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON api.adressen TO authenticated;
GRANT UPDATE (sprache) ON public.adressen TO authenticated;

\echo '=== Spalte prüfen ==='
SELECT column_name FROM information_schema.columns
WHERE table_schema='public' AND table_name='adressen' AND column_name='sprache';

\echo '=== View prüfen ==='
SELECT column_name FROM information_schema.columns
WHERE table_schema='api' AND table_name='adressen'
ORDER BY ordinal_position;

NOTIFY pgrst, 'reload schema';
\echo 'Schema reload gesendet.'
ENDSQL
echo "Done."
