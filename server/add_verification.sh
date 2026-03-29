#!/bin/bash
# Add verifiziert + website columns to adressen and recreate API view
set -e

sudo -u postgres psql -d novumziv << 'ENDSQL'
-- Add new columns
ALTER TABLE adressen ADD COLUMN IF NOT EXISTS verifiziert BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE adressen ADD COLUMN IF NOT EXISTS website TEXT;

-- Recreate API view with all columns including new ones
DROP VIEW IF EXISTS api.adressen;
CREATE VIEW api.adressen AS
  SELECT id, plz, ort, strasse, hausnummer, zusatz,
         lat, lon, status, benutzer_id, reserviert_am, erledigt_am,
         import_batch, titel, arzt_name, geo_name, sprache,
         verifiziert, website
  FROM public.adressen;

-- Restore grants
GRANT SELECT ON api.adressen TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON api.adressen TO authenticated;
GRANT UPDATE (verifiziert, website) ON public.adressen TO authenticated;

\echo '=== View columns ==='
SELECT column_name FROM information_schema.columns
WHERE table_schema='api' AND table_name='adressen'
ORDER BY ordinal_position;

NOTIFY pgrst, 'reload schema';
\echo 'Schema reload sent.'
ENDSQL
echo "Done."
