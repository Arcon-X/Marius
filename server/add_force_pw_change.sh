#!/usr/bin/env bash
set -euo pipefail

# Force password change on first login + reset all users to novum2026!
sudo -u postgres psql -d novumziv <<'SQL'

-- 1) Modify login function: return passwort_aendern flag when password = novum2026!
CREATE OR REPLACE FUNCTION api.login(email TEXT, passwort TEXT)
RETURNS JSON AS $$
DECLARE
  usr public.benutzer%ROWTYPE;
  token TEXT;
  secret TEXT;
  fail_count INT;
  client_ip TEXT;
  pw_default BOOLEAN;
BEGIN
  client_ip := coalesce(
    current_setting('request.headers', true)::json->>'x-forwarded-for',
    current_setting('request.headers', true)::json->>'x-real-ip',
    'unknown'
  );

  PERFORM cleanup_login_versuche();

  SELECT COUNT(*) INTO fail_count
  FROM login_versuche
  WHERE login_versuche.email = login.email
    AND zeitpunkt > NOW() - INTERVAL '15 minutes';

  IF fail_count >= 10 THEN
    RAISE EXCEPTION 'Zu viele Fehlversuche. Bitte 15 Minuten warten.'
      USING ERRCODE = '28P01';
  END IF;

  SELECT * INTO usr FROM public.benutzer
  WHERE public.benutzer.email = lower(login.email) AND aktiv = TRUE;

  IF NOT FOUND THEN
    INSERT INTO login_versuche (email, ip_addr) VALUES (lower(login.email), client_ip);
    RAISE EXCEPTION 'Ungültige Zugangsdaten' USING ERRCODE = '28P01';
  END IF;

  IF crypt(passwort, usr.passwort_hash) != usr.passwort_hash THEN
    INSERT INTO login_versuche (email, ip_addr) VALUES (lower(login.email), client_ip);
    RAISE EXCEPTION 'Ungültige Zugangsdaten' USING ERRCODE = '28P01';
  END IF;

  DELETE FROM login_versuche WHERE login_versuche.email = lower(login.email);

  -- Check if password is default "novum2026!"
  pw_default := crypt('novum2026!', usr.passwort_hash) = usr.passwort_hash;

  SELECT current_setting('app.jwt_secret') INTO secret;
  SELECT sign(
    json_build_object(
      'role', 'authenticated',
      'user_id', usr.id,
      'email', usr.email,
      'name', usr.name,
      'rolle', usr.rolle,
      'iat', extract(epoch from now())::integer,
      'exp', extract(epoch from now() + interval '8 hours')::integer
    )::json,
    secret
  ) INTO token;

  RETURN json_build_object(
    'token', token,
    'name', usr.name,
    'rolle', usr.rolle,
    'user_id', usr.id,
    'passwort_aendern', pw_default
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION api.login(TEXT, TEXT) TO anon;
GRANT EXECUTE ON FUNCTION api.login(TEXT, TEXT) TO authenticated;

-- 2) Reset all users to novum2026!
UPDATE public.benutzer
SET passwort_hash = crypt('novum2026!', gen_salt('bf'));

-- 3) Reload PostgREST schema
NOTIFY pgrst, 'reload schema';

SELECT 'Login flag + password reset complete' AS result;
SQL
