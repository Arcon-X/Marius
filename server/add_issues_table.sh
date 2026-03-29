#!/bin/bash
# Create issues table for bug/feature tracking in admin panel
set -e

sudo -u postgres psql -d novumziv << 'ENDSQL'

-- Issues-Tabelle im api-Schema
CREATE TABLE IF NOT EXISTS api.issues (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  typ           TEXT NOT NULL CHECK (typ IN ('bug','feature')),
  beschreibung  TEXT NOT NULL,
  status        TEXT NOT NULL DEFAULT 'offen' CHECK (status IN ('offen','erledigt')),
  erstellt_von  UUID REFERENCES benutzer(id),
  erstellt_am   TIMESTAMPTZ DEFAULT NOW(),
  erledigt_am   TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS issues_status_idx ON api.issues(status);
CREATE INDEX IF NOT EXISTS issues_erstellt_am_idx ON api.issues(erstellt_am DESC);

-- Berechtigungen
GRANT SELECT, INSERT, UPDATE, DELETE ON api.issues TO authenticated;

\echo '=== issues table created ==='
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema='api' AND table_name='issues'
ORDER BY ordinal_position;

ENDSQL
echo "Done."
