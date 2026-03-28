#!/bin/bash
# NOVUM-ZIV — Passwort- und E-Mail-Änderungsfunktionen hinzufügen
# Einmalig auf dem Server ausführen

set -e

echo "► Passwort-Änderungsfunktion anlegen..."
sudo -u postgres psql -d novumziv << 'EOSQL'

-- Passwort ändern (verifiziert altes Passwort)
CREATE OR REPLACE FUNCTION api.change_password(
  altes_passwort TEXT,
  neues_passwort TEXT
) RETURNS JSON AS $$
DECLARE
  uid UUID;
  usr benutzer%ROWTYPE;
BEGIN
  uid := current_setting('request.jwt.claims', true)::json->>'user_id';
  IF uid IS NULL THEN
    RAISE EXCEPTION 'Nicht angemeldet' USING ERRCODE = '28P01';
  END IF;

  SELECT * INTO usr FROM benutzer WHERE id = uid AND aktiv = TRUE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Benutzer nicht gefunden' USING ERRCODE = '28P01';
  END IF;

  IF crypt(altes_passwort, usr.passwort_hash) != usr.passwort_hash THEN
    RAISE EXCEPTION 'Aktuelles Passwort ist falsch' USING ERRCODE = '28P01';
  END IF;

  IF length(neues_passwort) < 6 THEN
    RAISE EXCEPTION 'Neues Passwort muss mindestens 6 Zeichen haben' USING ERRCODE = 'P0001';
  END IF;

  UPDATE benutzer SET passwort_hash = crypt(neues_passwort, gen_salt('bf'))
  WHERE id = uid;

  RETURN json_build_object('success', true, 'message', 'Passwort geändert');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION api.change_password(TEXT, TEXT) TO authenticated;

-- E-Mail ändern
CREATE OR REPLACE FUNCTION api.change_email(
  neue_email TEXT
) RETURNS JSON AS $$
DECLARE
  uid UUID;
  existing INT;
BEGIN
  uid := current_setting('request.jwt.claims', true)::json->>'user_id';
  IF uid IS NULL THEN
    RAISE EXCEPTION 'Nicht angemeldet' USING ERRCODE = '28P01';
  END IF;

  IF neue_email IS NULL OR neue_email = '' OR neue_email NOT LIKE '%@%' THEN
    RAISE EXCEPTION 'Ungültige E-Mail-Adresse' USING ERRCODE = 'P0001';
  END IF;

  SELECT COUNT(*) INTO existing FROM benutzer
  WHERE email = lower(neue_email) AND id != uid;
  IF existing > 0 THEN
    RAISE EXCEPTION 'E-Mail-Adresse wird bereits verwendet' USING ERRCODE = '23505';
  END IF;

  UPDATE benutzer SET email = lower(neue_email) WHERE id = uid;

  RETURN json_build_object('success', true, 'message', 'E-Mail geändert');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION api.change_email(TEXT) TO authenticated;

-- Passwort-Reset durch Admin
CREATE OR REPLACE FUNCTION api.admin_reset_password(
  target_email TEXT,
  neues_passwort TEXT
) RETURNS JSON AS $$
DECLARE
  uid UUID;
  admin_rolle TEXT;
BEGIN
  uid := current_setting('request.jwt.claims', true)::json->>'user_id';
  SELECT rolle INTO admin_rolle FROM benutzer WHERE id = uid AND aktiv = TRUE;

  IF admin_rolle != 'admin' THEN
    RAISE EXCEPTION 'Nur Admins können Passwörter zurücksetzen' USING ERRCODE = '42501';
  END IF;

  IF length(neues_passwort) < 6 THEN
    RAISE EXCEPTION 'Passwort muss mindestens 6 Zeichen haben' USING ERRCODE = 'P0001';
  END IF;

  UPDATE benutzer SET passwort_hash = crypt(neues_passwort, gen_salt('bf'))
  WHERE email = lower(target_email) AND aktiv = TRUE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Benutzer nicht gefunden' USING ERRCODE = 'P0002';
  END IF;

  RETURN json_build_object('success', true, 'message', 'Passwort für ' || target_email || ' zurückgesetzt');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION api.admin_reset_password(TEXT, TEXT) TO authenticated;

EOSQL

echo "✓ Funktionen angelegt: api.change_password, api.change_email, api.admin_reset_password"
echo "► PostgREST neustarten..."
systemctl restart postgrest
echo "✓ Fertig!"
