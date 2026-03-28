sudo -u postgres psql -d novumziv << 'EOSQL'
CREATE OR REPLACE FUNCTION api.login(email TEXT, passwort TEXT)
RETURNS JSON AS $$
DECLARE
  usr public.benutzer%ROWTYPE;
  token TEXT;
  secret TEXT;
BEGIN
  SELECT * INTO usr FROM public.benutzer WHERE public.benutzer.email = login.email AND aktiv = TRUE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Ungueltige Zugangsdaten' USING ERRCODE = '28P01';
  END IF;
  IF crypt(passwort, usr.passwort_hash) != usr.passwort_hash THEN
    RAISE EXCEPTION 'Ungueltige Zugangsdaten' USING ERRCODE = '28P01';
  END IF;
  SELECT current_setting('app.jwt_secret') INTO secret;
  SELECT sign(
    json_build_object(
      'role', 'authenticated',
      'user_id', usr.id,
      'email', usr.email,
      'name', usr.name,
      'rolle', usr.rolle,
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
$$ LANGUAGE plpgsql SECURITY DEFINER;
EOSQL