#!/bin/bash
# Add duplicate marking workflow (table, API view, RPCs)
set -e

sudo -u postgres psql -d novumziv << 'ENDSQL'

CREATE TABLE IF NOT EXISTS duplicate_markierungen (
  id                    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  adressen_id           UUID NOT NULL REFERENCES adressen(id) ON DELETE CASCADE,
  duplicate_group       TEXT,
  grund                 TEXT,
  status_beim_markieren TEXT NOT NULL,
  plz                   TEXT,
  ort                   TEXT,
  strasse               TEXT,
  hausnummer            TEXT,
  zusatz                TEXT,
  lat                   FLOAT,
  lon                   FLOAT,
  titel                 TEXT,
  arzt_name             TEXT,
  import_batch          TEXT,
  snapshot              JSONB NOT NULL DEFAULT '{}'::jsonb,
  markiert_von          UUID REFERENCES benutzer(id),
  markiert_am           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  restored_von          UUID REFERENCES benutzer(id),
  restored_at           TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS duplicate_markierungen_adresse_idx
  ON duplicate_markierungen(adressen_id);
CREATE INDEX IF NOT EXISTS duplicate_markierungen_markiert_idx
  ON duplicate_markierungen(markiert_am DESC);
CREATE UNIQUE INDEX IF NOT EXISTS duplicate_markierungen_active_uniq
  ON duplicate_markierungen(adressen_id)
  WHERE restored_at IS NULL;

CREATE OR REPLACE VIEW api.duplicate_markierungen AS
  SELECT id, adressen_id, duplicate_group, grund,
         status_beim_markieren, plz, ort, strasse, hausnummer, zusatz,
         lat, lon, titel, arzt_name, import_batch,
         snapshot, markiert_von, markiert_am, restored_von, restored_at
  FROM duplicate_markierungen
  ORDER BY markiert_am DESC;

GRANT SELECT ON api.duplicate_markierungen TO authenticated;

CREATE OR REPLACE FUNCTION api.mark_duplicate_adresse(
  p_adressen_id UUID,
  p_markiert_von UUID,
  p_duplicate_group TEXT DEFAULT NULL,
  p_grund TEXT DEFAULT NULL
)
RETURNS TABLE (
  markierung_id UUID,
  adressen_id UUID,
  status TEXT,
  message TEXT
) AS $$
DECLARE
  a adressen%ROWTYPE;
  has_result BOOLEAN;
  existing_id UUID;
  new_mark_id UUID;
BEGIN
  SELECT * INTO a
  FROM adressen
  WHERE id = p_adressen_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RETURN QUERY SELECT NULL::UUID, p_adressen_id, 'skipped'::TEXT, 'Adresse nicht gefunden'::TEXT;
    RETURN;
  END IF;

  IF a.status <> 'verfuegbar' OR a.benutzer_id IS NOT NULL OR a.reserviert_am IS NOT NULL THEN
    RETURN QUERY SELECT NULL::UUID, p_adressen_id, 'skipped'::TEXT, 'Adresse ist reserviert oder nicht verfuegbar'::TEXT;
    RETURN;
  END IF;

  SELECT EXISTS (
    SELECT 1
    FROM protokoll p
    WHERE p.adressen_id = p_adressen_id
      AND p.aktion IN ('waehlt_uns','waehlt_nicht','ueberlegt','kein_interesse_wahl','sonstige')
  ) INTO has_result;

  IF has_result THEN
    RETURN QUERY SELECT NULL::UUID, p_adressen_id, 'skipped'::TEXT, 'Adresse hat bereits ein Ergebnis'::TEXT;
    RETURN;
  END IF;

  SELECT dm.id INTO existing_id
  FROM duplicate_markierungen dm
  WHERE dm.adressen_id = p_adressen_id
    AND dm.restored_at IS NULL
  LIMIT 1;

  IF existing_id IS NOT NULL THEN
    RETURN QUERY SELECT existing_id, p_adressen_id, 'skipped'::TEXT, 'Adresse ist bereits als Duplikat markiert'::TEXT;
    RETURN;
  END IF;

  INSERT INTO duplicate_markierungen (
    adressen_id, duplicate_group, grund,
    status_beim_markieren,
    plz, ort, strasse, hausnummer, zusatz,
    lat, lon, titel, arzt_name, import_batch,
    snapshot, markiert_von
  )
  VALUES (
    a.id, p_duplicate_group, p_grund,
    a.status,
    a.plz, a.ort, a.strasse, a.hausnummer, a.zusatz,
    a.lat, a.lon, a.titel, a.arzt_name, a.import_batch,
    to_jsonb(a), p_markiert_von
  )
  RETURNING id INTO new_mark_id;

  UPDATE adressen
  SET status = 'archiviert',
      benutzer_id = NULL,
      reserviert_am = NULL,
      erledigt_am = COALESCE(erledigt_am, NOW())
  WHERE id = p_adressen_id;

  RETURN QUERY SELECT new_mark_id, p_adressen_id, 'marked'::TEXT, 'Adresse als Duplikat markiert'::TEXT;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION api.mark_duplicate_adresse(UUID, UUID, TEXT, TEXT) TO authenticated;

CREATE OR REPLACE FUNCTION api.restore_duplicate_adresse(
  p_markierung_id UUID,
  p_restored_von UUID
)
RETURNS TABLE (
  markierung_id UUID,
  adressen_id UUID,
  status TEXT,
  message TEXT
) AS $$
DECLARE
  dm duplicate_markierungen%ROWTYPE;
  a adressen%ROWTYPE;
  has_result BOOLEAN;
BEGIN
  SELECT * INTO dm
  FROM duplicate_markierungen
  WHERE id = p_markierung_id
    AND restored_at IS NULL
  FOR UPDATE;

  IF NOT FOUND THEN
    RETURN QUERY SELECT p_markierung_id, NULL::UUID, 'skipped'::TEXT, 'Markierung nicht gefunden oder bereits zurueckgesetzt'::TEXT;
    RETURN;
  END IF;

  SELECT * INTO a
  FROM adressen
  WHERE id = dm.adressen_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RETURN QUERY SELECT dm.id, dm.adressen_id, 'skipped'::TEXT, 'Original-Adresse nicht gefunden'::TEXT;
    RETURN;
  END IF;

  IF a.status = 'in_bearbeitung' OR a.benutzer_id IS NOT NULL OR a.reserviert_am IS NOT NULL THEN
    RETURN QUERY SELECT dm.id, dm.adressen_id, 'skipped'::TEXT, 'Adresse ist aktuell reserviert und kann nicht zurueckgesetzt werden'::TEXT;
    RETURN;
  END IF;

  SELECT EXISTS (
    SELECT 1
    FROM protokoll p
    WHERE p.adressen_id = dm.adressen_id
      AND p.aktion IN ('waehlt_uns','waehlt_nicht','ueberlegt','kein_interesse_wahl','sonstige')
  ) INTO has_result;

  IF has_result THEN
    RETURN QUERY SELECT dm.id, dm.adressen_id, 'skipped'::TEXT, 'Adresse hat bereits ein Ergebnis und bleibt archiviert'::TEXT;
    RETURN;
  END IF;

  UPDATE adressen
  SET status = 'verfuegbar',
      benutzer_id = NULL,
      reserviert_am = NULL,
      erledigt_am = NULL
  WHERE id = dm.adressen_id;

  UPDATE duplicate_markierungen
  SET restored_at = NOW(),
      restored_von = p_restored_von
  WHERE id = dm.id;

  RETURN QUERY SELECT dm.id, dm.adressen_id, 'restored'::TEXT, 'Adresse auf verfuegbar zurueckgesetzt'::TEXT;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION api.restore_duplicate_adresse(UUID, UUID) TO authenticated;

\echo '=== duplicate marking migration ready ==='
SELECT COUNT(*) AS active_duplicate_marks
FROM duplicate_markierungen
WHERE restored_at IS NULL;

ENDSQL

echo "Done."
