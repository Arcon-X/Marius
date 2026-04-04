#!/usr/bin/env bash
set -euo pipefail

# Fix: use public.benutzer in all settings functions (same bug as triggers)
sudo -u postgres psql -d novumziv <<'SQL'

-- Fix change_password: public.benutzer instead of benutzer
CREATE OR REPLACE FUNCTION api.change_password(
  altes_passwort TEXT,
  neues_passwort TEXT
) RETURNS JSON AS $$
DECLARE
  uid UUID;
  usr public.benutzer%ROWTYPE;
BEGIN
  uid := current_setting('request.jwt.claims', true)::json->>'user_id';
  IF uid IS NULL THEN
    RAISE EXCEPTION 'Nicht angemeldet' USING ERRCODE = '28P01';
  END IF;

  SELECT * INTO usr FROM public.benutzer WHERE id = uid AND aktiv = TRUE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Benutzer nicht gefunden' USING ERRCODE = '28P01';
  END IF;

  IF crypt(altes_passwort, usr.passwort_hash) != usr.passwort_hash THEN
    RAISE EXCEPTION 'Aktuelles Passwort ist falsch' USING ERRCODE = '28P01';
  END IF;

  IF length(neues_passwort) < 12 THEN
    RAISE EXCEPTION 'Neue Passphrase muss mindestens 12 Zeichen haben' USING ERRCODE = 'P0001';
  END IF;

  UPDATE public.benutzer SET passwort_hash = crypt(neues_passwort, gen_salt('bf'))
  WHERE id = uid;

  RETURN json_build_object('success', true, 'message', 'Passwort geändert');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fix change_email: public.benutzer
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

  SELECT COUNT(*) INTO existing FROM public.benutzer
  WHERE email = lower(neue_email) AND id != uid;
  IF existing > 0 THEN
    RAISE EXCEPTION 'E-Mail-Adresse wird bereits verwendet' USING ERRCODE = '23505';
  END IF;

  UPDATE public.benutzer SET email = lower(neue_email) WHERE id = uid;

  RETURN json_build_object('success', true, 'message', 'E-Mail geändert');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fix admin_reset_password: public.benutzer
CREATE OR REPLACE FUNCTION api.admin_reset_password(
  target_email TEXT,
  neues_passwort TEXT
) RETURNS JSON AS $$
DECLARE
  uid UUID;
  admin_rolle TEXT;
BEGIN
  uid := current_setting('request.jwt.claims', true)::json->>'user_id';
  SELECT rolle INTO admin_rolle FROM public.benutzer WHERE id = uid AND aktiv = TRUE;

  IF admin_rolle != 'admin' THEN
    RAISE EXCEPTION 'Nur Admins können Passwörter zurücksetzen' USING ERRCODE = '42501';
  END IF;

  IF length(neues_passwort) < 12 THEN
    RAISE EXCEPTION 'Passphrase muss mindestens 12 Zeichen haben' USING ERRCODE = 'P0001';
  END IF;

  UPDATE public.benutzer SET passwort_hash = crypt(neues_passwort, gen_salt('bf'))
  WHERE email = lower(target_email) AND aktiv = TRUE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Benutzer nicht gefunden' USING ERRCODE = 'P0002';
  END IF;

  RETURN json_build_object('success', true, 'message', 'Passwort für ' || target_email || ' zurückgesetzt');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

NOTIFY pgrst, 'reload schema';
SELECT 'All 3 settings functions fixed with public.benutzer' AS result;
SQL
