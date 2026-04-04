#!/usr/bin/env bash
set -euo pipefail

# Add telefon column and enable user management via API
sudo -u postgres psql -d novumziv <<'SQL'
-- Telefon-Spalte hinzufügen
ALTER TABLE benutzer ADD COLUMN IF NOT EXISTS telefon TEXT;

-- View neu erstellen mit telefon + INSERT/UPDATE/DELETE für Admins
DROP VIEW IF EXISTS api.benutzer CASCADE;

CREATE OR REPLACE VIEW api.benutzer AS
  SELECT id, email, name, rolle, aktiv, erstellt_am, telefon
  FROM benutzer;

-- Authenticated können lesen
GRANT SELECT ON api.benutzer TO authenticated;

-- INSTEAD OF INSERT (neuer Benutzer mit Passwort-Hash)
CREATE OR REPLACE FUNCTION api.benutzer_insert() RETURNS TRIGGER AS $$
DECLARE
  caller_rolle TEXT;
BEGIN
  SELECT rolle INTO caller_rolle FROM public.benutzer WHERE id = (current_setting('request.jwt.claims', true)::json->>'user_id')::uuid;
  IF caller_rolle != 'admin' THEN
    RAISE EXCEPTION 'Nur Admins dürfen Benutzer anlegen' USING ERRCODE = '42501';
  END IF;
  INSERT INTO public.benutzer (email, name, rolle, telefon, passwort_hash, aktiv)
  VALUES (
    NEW.email,
    NEW.name,
    COALESCE(NEW.rolle, 'mitarbeiter'),
    NEW.telefon,
    crypt(encode(gen_random_bytes(18), 'base64'), gen_salt('bf')),
    COALESCE(NEW.aktiv, TRUE)
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_benutzer_insert
  INSTEAD OF INSERT ON api.benutzer
  FOR EACH ROW EXECUTE FUNCTION api.benutzer_insert();

-- INSTEAD OF UPDATE (Daten ändern)
CREATE OR REPLACE FUNCTION api.benutzer_update() RETURNS TRIGGER AS $$
DECLARE
  caller_rolle TEXT;
BEGIN
  SELECT rolle INTO caller_rolle FROM public.benutzer WHERE id = (current_setting('request.jwt.claims', true)::json->>'user_id')::uuid;
  IF caller_rolle != 'admin' THEN
    RAISE EXCEPTION 'Nur Admins dürfen Benutzer bearbeiten' USING ERRCODE = '42501';
  END IF;
  UPDATE public.benutzer SET
    email = COALESCE(NEW.email, OLD.email),
    name = COALESCE(NEW.name, OLD.name),
    rolle = COALESCE(NEW.rolle, OLD.rolle),
    telefon = NEW.telefon,
    aktiv = COALESCE(NEW.aktiv, OLD.aktiv)
  WHERE id = OLD.id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_benutzer_update
  INSTEAD OF UPDATE ON api.benutzer
  FOR EACH ROW EXECUTE FUNCTION api.benutzer_update();

-- INSTEAD OF DELETE (Benutzer löschen)
CREATE OR REPLACE FUNCTION api.benutzer_delete() RETURNS TRIGGER AS $$
DECLARE
  caller_rolle TEXT;
BEGIN
  SELECT rolle INTO caller_rolle FROM public.benutzer WHERE id = (current_setting('request.jwt.claims', true)::json->>'user_id')::uuid;
  IF caller_rolle != 'admin' THEN
    RAISE EXCEPTION 'Nur Admins dürfen Benutzer löschen' USING ERRCODE = '42501';
  END IF;
  DELETE FROM public.benutzer WHERE id = OLD.id;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_benutzer_delete
  INSTEAD OF DELETE ON api.benutzer
  FOR EACH ROW EXECUTE FUNCTION api.benutzer_delete();

-- Grants für INSERT/UPDATE/DELETE
GRANT INSERT, UPDATE, DELETE ON api.benutzer TO authenticated;

SELECT 'User management setup complete' AS result;
SQL
