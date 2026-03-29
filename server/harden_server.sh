#!/bin/bash
# NOVUM-ZIV — Server Hardening
# Nginx: Rate Limiting, Security Headers, CORS restriction
# PostgREST: Disable OpenAPI, anon-Zugriff einschränken
# DB: Login-Throttling via failed_logins Tabelle
set -e

echo "═══════════════════════════════════════════════"
echo "  NOVUM-ZIV Server Hardening"
echo "═══════════════════════════════════════════════"

# ── 1. NGINX HARDENING ──────────────────────────────────

echo ""
echo "► [1/4] Nginx Konfiguration härten ..."

cat > /etc/nginx/sites-available/novumziv << 'NGINX_CONF'
# Rate Limiting: 5 requests/min für Login, 30/min allgemein
limit_req_zone $binary_remote_addr zone=login:10m rate=5r/m;
limit_req_zone $binary_remote_addr zone=api:10m rate=30r/m;

server {
    listen 443 ssl;
    server_name 204.168.217.211.nip.io;

    ssl_certificate /etc/letsencrypt/live/204.168.217.211.nip.io/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/204.168.217.211.nip.io/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    # ── Security Headers ──
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "DENY" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;

    # ── CORS: Same-origin (kein GitHub Pages mehr) ──
    set $cors_origin "";
    if ($http_origin = "https://204.168.217.211.nip.io") {
        set $cors_origin $http_origin;
    }

    # ── Request Body Limit ──
    client_max_body_size 64k;

    # ── Login Endpoint: strenges Rate Limiting ──
    location /api/rpc/login {
        limit_req zone=login burst=3 nodelay;
        limit_req_status 429;

        # CORS
        add_header Access-Control-Allow-Origin $cors_origin always;
        add_header Access-Control-Allow-Methods "POST, OPTIONS" always;
        add_header Access-Control-Allow-Headers "Content-Type, Authorization, Prefer" always;
        add_header Access-Control-Max-Age 3600 always;

        # Security Headers (müssen in jedem location-Block wiederholt werden)
        add_header Strict-Transport-Security "max-age=63072000; includeSubDomains" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-Frame-Options "DENY" always;

        if ($request_method = 'OPTIONS') {
            return 204;
        }

        proxy_pass http://127.0.0.1:3000/rpc/login;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # ── Passwort-Endpunkte: auch streng limitiert ──
    location ~ ^/api/rpc/(change_password|change_email|admin_reset_password)$ {
        limit_req zone=login burst=2 nodelay;
        limit_req_status 429;

        add_header Access-Control-Allow-Origin $cors_origin always;
        add_header Access-Control-Allow-Methods "POST, OPTIONS" always;
        add_header Access-Control-Allow-Headers "Content-Type, Authorization, Prefer" always;
        add_header Access-Control-Max-Age 3600 always;
        add_header Strict-Transport-Security "max-age=63072000; includeSubDomains" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-Frame-Options "DENY" always;

        if ($request_method = 'OPTIONS') {
            return 204;
        }

        proxy_pass http://127.0.0.1:3000/$1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # ── Allgemeine API: moderates Rate Limiting ──
    location /api/ {
        limit_req zone=api burst=10 nodelay;
        limit_req_status 429;

        add_header Access-Control-Allow-Origin $cors_origin always;
        add_header Access-Control-Allow-Methods "GET, POST, PATCH, DELETE, OPTIONS" always;
        add_header Access-Control-Allow-Headers "Content-Type, Authorization, Prefer" always;
        add_header Access-Control-Max-Age 3600 always;
        add_header Strict-Transport-Security "max-age=63072000; includeSubDomains" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-Frame-Options "DENY" always;

        if ($request_method = 'OPTIONS') {
            return 204;
        }

        proxy_pass http://127.0.0.1:3000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Verberge PostgREST Server-Header
        proxy_hide_header Server;
        proxy_hide_header X-Powered-By;
    }

    # ── Frontend: Statische Dateien ──
    root /var/www/novumziv;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # Verberge Nginx Version
    server_tokens off;
}

server {
    listen 80;
    server_name 204.168.217.211.nip.io;
    return 301 https://$host$request_uri;
}
NGINX_CONF

# Symlink sicherstellen
ln -sf /etc/nginx/sites-available/novumziv /etc/nginx/sites-enabled/novumziv

# Nginx Konfiguration testen
nginx -t
echo "✓ Nginx Konfiguration OK"

# ── 2. POSTGREST HARDENING ──────────────────────────────

echo ""
echo "► [2/4] PostgREST Konfiguration härten ..."

# OpenAPI-Schema deaktivieren (verhindert Schema-Leak an /api/)
if ! grep -q 'openapi-mode' /etc/postgrest/novumziv.conf; then
    echo 'openapi-mode   = "disabled"' >> /etc/postgrest/novumziv.conf
    echo "  + openapi-mode = disabled hinzugefügt"
else
    echo "  = openapi-mode bereits konfiguriert"
fi

# Max Rows begrenzen
if ! grep -q 'max-rows' /etc/postgrest/novumziv.conf; then
    echo 'max-rows       = 2000' >> /etc/postgrest/novumziv.conf
    echo "  + max-rows = 2000 hinzugefügt"
else
    echo "  = max-rows bereits konfiguriert"
fi

echo "✓ PostgREST Konfiguration OK"

# ── 3. DATENBANK HARDENING ──────────────────────────────

echo ""
echo "► [3/4] Datenbank: Login-Throttling + anon einschränken ..."

sudo -u postgres psql -d novumziv << 'EOSQL'

-- Tabelle für fehlgeschlagene Login-Versuche
CREATE TABLE IF NOT EXISTS login_versuche (
    id          SERIAL PRIMARY KEY,
    email       TEXT NOT NULL,
    ip_addr     TEXT,
    zeitpunkt   TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_login_versuche_email ON login_versuche(email, zeitpunkt);

-- Alte Einträge automatisch bereinigen (> 1 Stunde)
CREATE OR REPLACE FUNCTION cleanup_login_versuche() RETURNS VOID AS $$
BEGIN
    DELETE FROM login_versuche WHERE zeitpunkt < NOW() - INTERVAL '1 hour';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Login-Funktion mit Brute-Force-Schutz ersetzen
CREATE OR REPLACE FUNCTION api.login(email TEXT, passwort TEXT)
RETURNS JSON AS $$
DECLARE
  usr public.benutzer%ROWTYPE;
  token TEXT;
  secret TEXT;
  fail_count INT;
  client_ip TEXT;
BEGIN
  -- Client-IP aus Nginx X-Forwarded-For Header
  client_ip := coalesce(
    current_setting('request.headers', true)::json->>'x-forwarded-for',
    current_setting('request.headers', true)::json->>'x-real-ip',
    'unknown'
  );

  -- Alte Versuche bereinigen
  PERFORM cleanup_login_versuche();

  -- Fehlgeschlagene Versuche der letzten 15 Minuten zählen
  SELECT COUNT(*) INTO fail_count
  FROM login_versuche
  WHERE login_versuche.email = login.email
    AND zeitpunkt > NOW() - INTERVAL '15 minutes';

  -- Nach 10 Fehlversuchen: Account für 15 Min gesperrt
  IF fail_count >= 10 THEN
    RAISE EXCEPTION 'Zu viele Fehlversuche. Bitte 15 Minuten warten.'
      USING ERRCODE = '28P01';
  END IF;

  -- Benutzer suchen (explizit public.benutzer, da api.benutzer ein View ohne passwort_hash ist)
  SELECT * INTO usr FROM public.benutzer
  WHERE public.benutzer.email = lower(login.email) AND aktiv = TRUE;

  IF NOT FOUND THEN
    -- Fehlversuch loggen (auch bei unbekannter E-Mail, gegen Enumeration)
    INSERT INTO login_versuche (email, ip_addr) VALUES (lower(login.email), client_ip);
    RAISE EXCEPTION 'Ungültige Zugangsdaten' USING ERRCODE = '28P01';
  END IF;

  IF crypt(passwort, usr.passwort_hash) != usr.passwort_hash THEN
    INSERT INTO login_versuche (email, ip_addr) VALUES (lower(login.email), client_ip);
    RAISE EXCEPTION 'Ungültige Zugangsdaten' USING ERRCODE = '28P01';
  END IF;

  -- Erfolg: Fehlversuche löschen
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
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Login-Funktion für anon UND authenticated erreichbar
GRANT EXECUTE ON FUNCTION api.login(TEXT, TEXT) TO anon;
GRANT EXECUTE ON FUNCTION api.login(TEXT, TEXT) TO authenticated;

-- Anon-Zugriff auf adressen (PII) entfernen
REVOKE SELECT ON api.adressen FROM anon;

-- Sicherstellen: login_versuche-Tabelle nur für SECURITY DEFINER Funktionen
REVOKE ALL ON login_versuche FROM PUBLIC;
REVOKE ALL ON login_versuche FROM anon;
REVOKE ALL ON login_versuche FROM authenticated;

-- DELETE-Rechte auf protokoll entfernen (nur Admin via resetAll braucht es)
-- Behalten: nur authenticated braucht SELECT + INSERT
-- Note: resetAll() wird über authenticated ausgeführt, also DELETE bleibt bei authenticated

EOSQL

echo "✓ Datenbank gehärtet"

# ── 4. DIENSTE NEUSTARTEN ───────────────────────────────

echo ""
echo "► [4/4] Dienste neustarten ..."

systemctl restart postgrest
echo "  ✓ PostgREST neugestartet"

systemctl reload nginx
echo "  ✓ Nginx neugeladen"

echo ""
echo "═══════════════════════════════════════════════"
echo "  ✅ Hardening abgeschlossen!"
echo ""
echo "  Maßnahmen:"
echo "  • Nginx: Rate Limiting (5/min Login, 30/min API)"
echo "  • Nginx: HSTS, X-Content-Type-Options, X-Frame-Options"
echo "  • Nginx: CORS nur für 204.168.217.211.nip.io (same-origin)"
echo "  • Nginx: Server-Header verborgen"
echo "  • PostgREST: OpenAPI-Schema deaktiviert"
echo "  • PostgREST: Max 2000 Rows pro Request"
echo "  • DB: Login-Throttling (10 Versuche → 15min Sperre)"
echo "  • DB: Anon-Zugriff auf Adressen entfernt"
echo "  • DB: JWT enthält 'iat' Claim"
echo "═══════════════════════════════════════════════"
