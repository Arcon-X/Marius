#!/bin/bash
set -e
sudo -u postgres psql -d novumziv << 'ENDSQL'
-- Drop and recreate view to add geo_name
DROP VIEW api.adressen;
CREATE VIEW api.adressen AS
  SELECT id, plz, ort, strasse, hausnummer, zusatz,
         lat, lon, status, benutzer_id, reserviert_am, erledigt_am,
         import_batch, titel, arzt_name, geo_name
  FROM public.adressen;

-- Restore grants
GRANT SELECT ON api.adressen TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON api.adressen TO authenticated;

\echo '=== View columns ==='
SELECT column_name FROM information_schema.columns
WHERE table_schema='api' AND table_name='adressen'
ORDER BY ordinal_position;

NOTIFY pgrst, 'reload schema';
\echo 'Schema reload sent.'
ENDSQL
echo "Done."
