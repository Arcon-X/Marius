#!/bin/bash
# Fix login function to select from public.benutzer (has passwort_hash)
# instead of api.benutzer view (which strips it for security)
set -e

sudo -u postgres psql -d novumziv << 'ENDSQL'

-- First verify the issue
\echo '=== api.benutzer view columns ==='
SELECT column_name FROM information_schema.columns
WHERE table_schema='api' AND table_name='benutzer' ORDER BY ordinal_position;

\echo '=== public.benutzer table columns ==='
SELECT column_name FROM information_schema.columns
WHERE table_schema='public' AND table_name='benutzer' ORDER BY ordinal_position;

-- Drop and recreate the login function using public.benutzer
CREATE OR REPLACE FUNCTION api.login(email TEXT, passwort TEXT)
RETURNS JSON LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  usr public.benutzer%ROWTYPE;
  token TEXT;
  secret TEXT;
  fail_count INT;
  client_ip TEXT;
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
    'user_id', usr.id
  );
END;
$$;

\echo '=== Login-Test kann manuell mit LOGIN_EMAIL/LOGIN_PASS erfolgen ==='

ENDSQL

echo "Done."
