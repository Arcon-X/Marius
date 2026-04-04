-- NOVUM-ZIV: Voll-Reset aller Adressen auf Initialzustand
-- Ergebnis:
--   1) Alle Adressen wieder verfuegbar/unzugewiesen
--   2) Verifizierungsdaten geloescht
--   3) Audit-Protokoll geloescht

BEGIN;

-- Protokoll komplett leeren (historische Bearbeitungen entfernen)
DELETE FROM protokoll;

-- Alle Adressen auf "nie bearbeitet" zuruecksetzen
UPDATE adressen
SET
  status = 'verfuegbar',
  benutzer_id = NULL,
  reserviert_am = NULL,
  erledigt_am = NULL,
  verifiziert = FALSE,
  website = NULL;

COMMIT;
