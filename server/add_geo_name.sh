#!/bin/bash
set -e
sudo -u postgres psql -d novumziv << 'ENDSQL'
-- Add geo_name column if not exists
ALTER TABLE adressen ADD COLUMN IF NOT EXISTS geo_name TEXT;

-- Grant access via api view: recreate view to include the new column
CREATE OR REPLACE VIEW api.adressen AS
  SELECT id, plz, ort, strasse, hausnummer AS hnr, zusatz,
         lat, lon, status, benutzer_id, reserviert_am, erledigt_am,
         import_batch, titel, arzt_name AS name, geo_name
  FROM public.adressen;

-- Make sure authenticated role can update it
GRANT UPDATE (geo_name) ON public.adressen TO authenticated;

\echo '=== Column check ==='
SELECT column_name FROM information_schema.columns
WHERE table_schema='public' AND table_name='adressen' AND column_name='geo_name';

\echo '=== View check ==='
SELECT column_name FROM information_schema.columns
WHERE table_schema='api' AND table_name='adressen' AND column_name='geo_name';
ENDSQL

echo "Done."
