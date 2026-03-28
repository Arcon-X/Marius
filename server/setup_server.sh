#!/bin/bash
# ============================================================
# NOVUM-ZIV — Server Setup Script
# Hetzner Ubuntu 24.04 LTS · einmalig als root ausführen
# ============================================================
set -e

SERVER_IP="204.168.217.211"
DB_NAME="novumziv"
DB_USER="novumziv_user"
DB_PASS="$(openssl rand -base64 32 | tr -d '/+=' | head -c 32)"
POSTGREST_USER="postgrest_user"
POSTGREST_PASS="$(openssl rand -base64 32 | tr -d '/+=' | head -c 32)"
JWT_SECRET="$(openssl rand -base64 48 | tr -d '/+=' | head -c 48)"
POSTGREST_VERSION="12.2.3"

echo "============================================================"
echo "  NOVUM-ZIV Server Setup"
echo "  Server: $SERVER_IP"
echo "============================================================"
echo ""

# ── Passwörter speichern (WICHTIG: sicher aufbewahren!) ──────
cat > /root/novumziv_credentials.txt << EOF
# NOVUM-ZIV Zugangsdaten — VERTRAULICH
# Erstellt: $(date)

DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASS=$DB_PASS
POSTGREST_USER=$POSTGREST_USER
POSTGREST_PASS=$POSTGREST_PASS
JWT_SECRET=$JWT_SECRET
EOF
chmod 600 /root/novumziv_credentials.txt
echo "✓ Zugangsdaten gespeichert in /root/novumziv_credentials.txt"

# ── System aktualisieren ─────────────────────────────────────
echo ""
echo "► System aktualisieren..."
apt-get update -qq
apt-get upgrade -y -qq
apt-get install -y -qq \
    curl wget gnupg2 lsb-release \
    nginx certbot python3-certbot-nginx \
    ufw fail2ban

# ── PostgreSQL 16 + PostGIS ──────────────────────────────────
echo ""
echo "► PostgreSQL 16 + PostGIS installieren..."
curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql.gpg
echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
apt-get update -qq
apt-get install -y -qq postgresql-16 postgresql-16-postgis-3

echo "✓ PostgreSQL $(psql --version | awk '{print $3}') installiert"

# ── Datenbank einrichten ─────────────────────────────────────
echo ""
echo "► Datenbank einrichten..."
sudo -u postgres psql -q << EOSQL

-- Erweiterungen
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pgjwt;

-- Datenbank anlegen
CREATE DATABASE $DB_NAME;
EOSQL

sudo -u postgres psql -q -d $DB_NAME << EOSQL

-- Erweiterungen in DB
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Schema für PostgREST
CREATE SCHEMA IF NOT EXISTS api;

-- Rollen
CREATE ROLE anon NOLOGIN;
CREATE ROLE authenticated NOLOGIN;
CREATE ROLE $POSTGREST_USER WITH LOGIN PASSWORD '$POSTGREST_PASS';
GRANT anon, authenticated TO $POSTGREST_USER;
GRANT USAGE ON SCHEMA api TO anon, authenticated;

-- App-Benutzer für direkten DB-Zugriff
CREATE ROLE $DB_USER WITH LOGIN PASSWORD '$DB_PASS';
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
GRANT ALL ON SCHEMA api TO $DB_USER;

-- JWT Secret als DB-Setting
ALTER DATABASE $DB_NAME SET "app.jwt_secret" TO '$JWT_SECRET';

-- ── Tabellen ──────────────────────────────────────────────

CREATE TABLE benutzer (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email         TEXT UNIQUE NOT NULL,
  name          TEXT NOT NULL,
  rolle         TEXT NOT NULL DEFAULT 'mitarbeiter',
  passwort_hash TEXT NOT NULL,
  aktiv         BOOLEAN DEFAULT TRUE,
  erstellt_am   TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT rolle_check CHECK (rolle IN ('admin','mitarbeiter'))
);

CREATE TABLE adressen (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  plz           TEXT NOT NULL DEFAULT '',
  ort           TEXT NOT NULL DEFAULT 'Wien',
  strasse       TEXT NOT NULL,
  hausnummer    TEXT NOT NULL,
  zusatz        TEXT,
  lat           FLOAT NOT NULL,
  lon           FLOAT NOT NULL,
  standort      GEOMETRY(Point, 4326),
  status        TEXT NOT NULL DEFAULT 'verfuegbar',
  benutzer_id   UUID REFERENCES benutzer(id),
  reserviert_am TIMESTAMPTZ,
  erledigt_am   TIMESTAMPTZ,
  import_batch  TEXT,
  titel         TEXT,
  arzt_name     TEXT,
  CONSTRAINT status_check CHECK (status IN ('verfuegbar','in_bearbeitung','archiviert'))
);

CREATE INDEX adressen_standort_idx ON adressen USING GIST(standort);
CREATE INDEX adressen_status_idx   ON adressen(status);

CREATE TABLE protokoll (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  adressen_id UUID NOT NULL REFERENCES adressen(id) ON DELETE CASCADE,
  benutzer_id UUID NOT NULL REFERENCES benutzer(id),
  aktion      TEXT NOT NULL,
  zeitpunkt   TIMESTAMPTZ DEFAULT NOW(),
  notiz       TEXT,
  CONSTRAINT aktion_check CHECK (aktion IN (
    'uebernommen','waehlt_uns','waehlt_nicht','ueberlegt',
    'kein_interesse_wahl','sonstige','reaktiviert'
  ))
);

CREATE INDEX protokoll_adressen_idx  ON protokoll(adressen_id);
CREATE INDEX protokoll_benutzer_idx  ON protokoll(benutzer_id);
CREATE INDEX protokoll_zeitpunkt_idx ON protokoll(zeitpunkt DESC);

-- ── Trigger: standort aus lat/lon ─────────────────────────

CREATE OR REPLACE FUNCTION sync_standort() RETURNS TRIGGER AS \$\$
BEGIN
  NEW.standort := ST_SetSRID(ST_MakePoint(NEW.lon, NEW.lat), 4326);
  RETURN NEW;
END;
\$\$ LANGUAGE plpgsql;

CREATE TRIGGER trg_sync_standort
  BEFORE INSERT OR UPDATE ON adressen
  FOR EACH ROW EXECUTE FUNCTION sync_standort();

-- ── API Views & Funktionen ────────────────────────────────

-- Login-Funktion
CREATE OR REPLACE FUNCTION api.login(email TEXT, passwort TEXT)
RETURNS JSON AS \$\$
DECLARE
  usr benutzer%ROWTYPE;
  token TEXT;
  secret TEXT;
BEGIN
  SELECT * INTO usr FROM benutzer WHERE benutzer.email = login.email AND aktiv = TRUE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Ungültige Zugangsdaten' USING ERRCODE = '28P01';
  END IF;
  IF crypt(passwort, usr.passwort_hash) != usr.passwort_hash THEN
    RAISE EXCEPTION 'Ungültige Zugangsdaten' USING ERRCODE = '28P01';
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
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION api.login(TEXT, TEXT) TO anon;

-- Adressen-View für API
CREATE OR REPLACE VIEW api.adressen AS
  SELECT id, plz, ort, strasse, hausnummer, zusatz,
         lat, lon, status, benutzer_id,
         reserviert_am, erledigt_am, import_batch,
         titel, arzt_name
  FROM adressen;

GRANT SELECT, UPDATE ON api.adressen TO authenticated;
GRANT SELECT ON api.adressen TO anon;

-- Protokoll-View für API
CREATE OR REPLACE VIEW api.protokoll AS
  SELECT * FROM protokoll;

GRANT SELECT, INSERT ON api.protokoll TO authenticated;

-- Benutzer-View für API (kein passwort_hash!)
CREATE OR REPLACE VIEW api.benutzer AS
  SELECT id, email, name, rolle, aktiv, erstellt_am
  FROM benutzer;

GRANT SELECT ON api.benutzer TO authenticated;

-- Nächste-Adressen-Funktion (PostGIS KNN)
CREATE OR REPLACE FUNCTION api.naechste_adressen(
  user_lat FLOAT, user_lon FLOAT, anzahl INT DEFAULT 50
)
RETURNS TABLE (
  id UUID, plz TEXT, ort TEXT, strasse TEXT,
  hausnummer TEXT, zusatz TEXT, lat FLOAT, lon FLOAT,
  titel TEXT, arzt_name TEXT, luftlinie_m FLOAT
) AS \$\$
BEGIN
  RETURN QUERY
  SELECT a.id, a.plz, a.ort, a.strasse, a.hausnummer, a.zusatz,
         a.lat, a.lon, a.titel, a.arzt_name,
         ST_Distance(a.standort::geography,
           ST_MakePoint(user_lon, user_lat)::geography) AS luftlinie_m
  FROM adressen a
  WHERE a.status = 'verfuegbar'
  ORDER BY a.standort <-> ST_SetSRID(ST_MakePoint(user_lon, user_lat), 4326)
  LIMIT anzahl;
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION api.naechste_adressen(FLOAT, FLOAT, INT) TO authenticated;

EOSQL

echo "✓ Datenbank eingerichtet"

# ── PostgREST installieren ───────────────────────────────────
echo ""
echo "► PostgREST $POSTGREST_VERSION installieren..."
cd /tmp
wget -q "https://github.com/PostgREST/postgrest/releases/download/v${POSTGREST_VERSION}/postgrest-v${POSTGREST_VERSION}-linux-static-x64.tar.xz"
tar -xf "postgrest-v${POSTGREST_VERSION}-linux-static-x64.tar.xz"
mv postgrest /usr/local/bin/postgrest
chmod +x /usr/local/bin/postgrest
echo "✓ PostgREST $(postgrest --version) installiert"

# PostgREST Konfiguration
mkdir -p /etc/postgrest
cat > /etc/postgrest/novumziv.conf << EOF
db-uri         = "postgres://$POSTGREST_USER:$POSTGREST_PASS@localhost:5432/$DB_NAME"
db-schemas     = "api"
db-anon-role   = "anon"
jwt-secret     = "$JWT_SECRET"
server-port    = 3000
server-host    = "127.0.0.1"
log-level      = "warn"
EOF
chmod 600 /etc/postgrest/novumziv.conf

# PostgREST als systemd-Service
cat > /etc/systemd/system/postgrest.service << EOF
[Unit]
Description=PostgREST API Server for NOVUM-ZIV
After=postgresql.service
Requires=postgresql.service

[Service]
ExecStart=/usr/local/bin/postgrest /etc/postgrest/novumziv.conf
Restart=always
RestartSec=5
User=www-data
Group=www-data

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable postgrest
systemctl start postgrest
echo "✓ PostgREST läuft auf Port 3000"

# ── Firewall (UFW) ───────────────────────────────────────────
echo ""
echo "► Firewall konfigurieren..."
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP (für Certbot)
ufw allow 443/tcp   # HTTPS
ufw --force enable
echo "✓ Firewall aktiv (22, 80, 443)"

# ── Nginx konfigurieren ──────────────────────────────────────
echo ""
echo "► Nginx konfigurieren..."
cat > /etc/nginx/sites-available/novumziv << EOF
server {
    listen 80;
    server_name $SERVER_IP;

    location /api/ {
        proxy_pass         http://127.0.0.1:3000/;
        proxy_set_header   Host \$host;
        proxy_set_header   X-Real-IP \$remote_addr;

        # CORS für GitHub Pages
        add_header Access-Control-Allow-Origin  "https://arcon-x.github.io" always;
        add_header Access-Control-Allow-Headers "Authorization,Content-Type,Prefer" always;
        add_header Access-Control-Allow-Methods "GET,POST,PATCH,DELETE,OPTIONS" always;

        if (\$request_method = OPTIONS) {
            return 204;
        }
    }

    location /health {
        return 200 'OK';
        add_header Content-Type text/plain;
    }
}
EOF

ln -sf /etc/nginx/sites-available/novumziv /etc/nginx/sites-enabled/novumziv
rm -f /etc/nginx/sites-enabled/default
nginx -t && systemctl reload nginx
echo "✓ Nginx konfiguriert"

# ── Zusammenfassung ──────────────────────────────────────────
echo ""
echo "============================================================"
echo "  ✅ Setup abgeschlossen!"
echo "============================================================"
echo ""
echo "  API erreichbar unter: http://$SERVER_IP/api/"
echo "  Health-Check:         http://$SERVER_IP/health"
echo ""
echo "  Zugangsdaten: /root/novumziv_credentials.txt"
echo ""
echo "  Nächste Schritte:"
echo "  1. python create_users.py (Benutzerkonten anlegen)"
echo "  2. psql -U $DB_USER -d $DB_NAME -f import.sql (Adressen importieren)"
echo "  3. Domain + TLS einrichten (certbot)"
echo ""
echo "  JWT_SECRET (für index.md):"
echo "  $JWT_SECRET"
echo "============================================================"
