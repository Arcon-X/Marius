#!/usr/bin/env bash
set -euo pipefail

# Fix UUID cast in benutzer trigger functions
sudo -u postgres psql -d novumziv <<'SQL'

-- Fix INSERT trigger: cast user_id to uuid + qualify schema
CREATE OR REPLACE FUNCTION api.benutzer_insert() RETURNS TRIGGER AS $$
DECLARE
  caller_rolle TEXT;
BEGIN
  SELECT rolle INTO caller_rolle FROM public.benutzer
    WHERE id = (current_setting('request.jwt.claims', true)::json->>'user_id')::uuid;
  IF caller_rolle != 'admin' THEN
    RAISE EXCEPTION 'Nur Admins dürfen Benutzer anlegen' USING ERRCODE = '42501';
  END IF;
  INSERT INTO public.benutzer (email, name, rolle, telefon, passwort_hash, aktiv)
  VALUES (
    NEW.email,
    NEW.name,
    COALESCE(NEW.rolle, 'mitarbeiter'),
    NEW.telefon,
    crypt(COALESCE(NEW.email, 'changeme'), gen_salt('bf')),
    COALESCE(NEW.aktiv, TRUE)
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fix UPDATE trigger: cast user_id to uuid + qualify schema
CREATE OR REPLACE FUNCTION api.benutzer_update() RETURNS TRIGGER AS $$
DECLARE
  caller_rolle TEXT;
BEGIN
  SELECT rolle INTO caller_rolle FROM public.benutzer
    WHERE id = (current_setting('request.jwt.claims', true)::json->>'user_id')::uuid;
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

-- Fix DELETE trigger: cast user_id to uuid + qualify schema
CREATE OR REPLACE FUNCTION api.benutzer_delete() RETURNS TRIGGER AS $$
DECLARE
  caller_rolle TEXT;
BEGIN
  SELECT rolle INTO caller_rolle FROM public.benutzer
    WHERE id = (current_setting('request.jwt.claims', true)::json->>'user_id')::uuid;
  IF caller_rolle != 'admin' THEN
    RAISE EXCEPTION 'Nur Admins dürfen Benutzer löschen' USING ERRCODE = '42501';
  END IF;
  DELETE FROM public.benutzer WHERE id = OLD.id;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Reload PostgREST schema cache
NOTIFY pgrst, 'reload schema';

SELECT 'All 3 trigger functions fixed (uuid cast) + schema reloaded' AS result;
SQL
