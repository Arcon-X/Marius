---
title: "NOVUM-ZIV - DB Model"
---

<style>
.site-header { display: none !important; }
.doc-nav { position: sticky; top: .5rem; z-index: 20; background: #fff; border: 1px solid #d0d7de; border-radius: 10px; padding: .7rem; margin: .2rem 0 1rem 0; box-shadow: 0 2px 8px rgba(0,0,0,.05); }
.doc-nav-title { font-size: .8rem; color: #57606a; font-weight: 700; margin-bottom: .45rem; }
.doc-nav-links { display: flex; gap: .4rem; overflow-x: auto; padding-bottom: .15rem; }
.doc-nav-links a { text-decoration: none; border: 1px solid #d0d7de; background: #f6f8fa; color: #24292f; border-radius: 999px; padding: .32rem .72rem; white-space: nowrap; font-size: .82rem; font-weight: 600; }
.doc-nav-links a.active { background: #1f6feb; border-color: #1f6feb; color: #fff; }
</style>

# NOVUM-ZIV - DB Model

<div class="doc-nav" role="navigation" aria-label="Dokumentationsnavigation">
  <div class="doc-nav-title">Dokumentation</div>
  <div class="doc-nav-links">
    <a href="/docs/index.html">Hub</a>
    <a href="/docs/import_report.html">Import</a>
    <a href="/docs/features.html">Features</a>
    <a href="/docs/technik.html">Technik</a>
    <a href="/docs/db_model.html" class="active">DB</a>
    <a href="/SPEC.html">SPEC</a>
    <a href="/docs/domain.html">Domain</a>
  </div>
</div>

> Stand: 04.04.2026
> Scope: Aktuelles produktives Self-Hosting Modell (PostgreSQL + PostGIS + PostgREST)

## 1. Source of Truth

Dieses Dokument ist aus den aktuellen Setup-/Migrationsskripten abgeleitet:

- server/setup_server.sh
- server/add_issues_table.sh
- server/add_geo_name.sh
- server/add_sprache.sh
- server/add_verification.sh
- server/add_protokoll_bearbeitet.sh
- server/fix_settings_functions.sh

Falls es Abweichungen gibt, gelten die SQL-Definitionen in diesen Skripten.

## 2. Engine und Schema

- Datenbank: PostgreSQL 16
- Extensions: postgis, uuid-ossp, pgcrypto (plus pgjwt fuer JWT Signing)
- API-Schema: api
- Auth-Rollen: anon, authenticated, postgrest_user

## 3. Entity Model

### 3.1 benutzer

Zweck: User-Konten fuer Login und Rollen.

Spalten:
- id UUID PRIMARY KEY DEFAULT uuid_generate_v4()
- email TEXT UNIQUE NOT NULL
- name TEXT NOT NULL
- rolle TEXT NOT NULL DEFAULT 'mitarbeiter' CHECK (rolle IN ('admin','mitarbeiter'))
- passwort_hash TEXT NOT NULL
- aktiv BOOLEAN DEFAULT TRUE
- erstellt_am TIMESTAMPTZ DEFAULT NOW()

### 3.2 adressen

Zweck: Adress-Pool fuer Team-Workflows.

Spalten:
- id UUID PRIMARY KEY DEFAULT uuid_generate_v4()
- plz TEXT NOT NULL DEFAULT ''
- ort TEXT NOT NULL DEFAULT 'Wien'
- strasse TEXT NOT NULL
- hausnummer TEXT NOT NULL
- zusatz TEXT
- lat FLOAT NOT NULL
- lon FLOAT NOT NULL
- standort GEOMETRY(Point, 4326)
- status TEXT NOT NULL DEFAULT 'verfuegbar' CHECK (status IN ('verfuegbar','in_bearbeitung','archiviert'))
- benutzer_id UUID REFERENCES benutzer(id)
- reserviert_am TIMESTAMPTZ
- erledigt_am TIMESTAMPTZ
- import_batch TEXT
- titel TEXT
- arzt_name TEXT

Indizes:
- adressen_standort_idx (GIST auf standort)
- adressen_status_idx (B-Tree auf status)

Trigger:
- trg_sync_standort BEFORE INSERT/UPDATE
- sync_standort() setzt standort = ST_SetSRID(ST_MakePoint(lon, lat), 4326)

### 3.3 protokoll

Zweck: Audit-Log fuer Aktionen auf Adressen.

Spalten:
- id UUID PRIMARY KEY DEFAULT uuid_generate_v4()
- adressen_id UUID NOT NULL REFERENCES adressen(id) ON DELETE CASCADE
- benutzer_id UUID NOT NULL REFERENCES benutzer(id)
- aktion TEXT NOT NULL CHECK (aktion IN (
  'uebernommen','waehlt_uns','waehlt_nicht','ueberlegt',
  'kein_interesse_wahl','sonstige','reaktiviert','bearbeitet'
))
- zeitpunkt TIMESTAMPTZ DEFAULT NOW()
- notiz TEXT

Indizes:
- protokoll_adressen_idx
- protokoll_benutzer_idx
- protokoll_zeitpunkt_idx (DESC)

Reporting-Hinweis:
- uebernommen je Benutzer: Filter `aktion = 'uebernommen'`
- zurueckgegeben je Benutzer: Filter `aktion = 'reaktiviert'` und `notiz = 'Zurückgegeben'`
- Es existiert derzeit kein separater Aktionstyp `zurueckgegeben`.

### 3.4 api.issues

Zweck: Admin-Ticketing fuer Bugs/Features.

Spalten:
- id UUID PRIMARY KEY DEFAULT uuid_generate_v4()
- typ TEXT NOT NULL CHECK (typ IN ('bug','feature'))
- beschreibung TEXT NOT NULL
- status TEXT NOT NULL DEFAULT 'offen' CHECK (status IN ('offen','erledigt'))
- erstellt_von UUID REFERENCES benutzer(id)
- erstellt_am TIMESTAMPTZ DEFAULT NOW()
- erledigt_am TIMESTAMPTZ

Indizes:
- issues_status_idx
- issues_erstellt_am_idx (DESC)

## 4. Relationships

- benutzer (1) -> (N) adressen ueber adressen.benutzer_id
- benutzer (1) -> (N) protokoll ueber protokoll.benutzer_id
- adressen (1) -> (N) protokoll ueber protokoll.adressen_id
- benutzer (1) -> (N) api.issues ueber api.issues.erstellt_von

## 5. API Projection (PostgREST)

### 5.1 Views

- api.adressen
  - Projektion aus adressen
  - Grants: SELECT, UPDATE fuer authenticated; SELECT fuer anon

- api.protokoll
  - Projektion aus protokoll
  - Grants: SELECT, INSERT fuer authenticated

- api.benutzer
  - Projektion aus benutzer ohne passwort_hash
  - Grants: SELECT fuer authenticated

### 5.2 RPCs

- api.login(email TEXT, passwort TEXT) RETURNS JSON
  - prueft bcrypt hash
  - erstellt JWT mit role=authenticated, user_id, email, name, rolle, exp
  - Grant EXECUTE fuer anon

- api.naechste_adressen(user_lat FLOAT, user_lon FLOAT, anzahl INT DEFAULT 50)
  - PostGIS KNN auf freie Adressen (status='verfuegbar')
  - liefert Distanz (luftlinie_m)
  - Grant EXECUTE fuer authenticated

## 6. Security Notes

- passwort_hash wird nie via api.benutzer exposed
- JWT Secret liegt als DB setting app.jwt_secret
- PostgREST bindet an 127.0.0.1:3000 (reverse proxy ueber Nginx)
- Rollenmodell trennt anon und authenticated

## 7. Operational Defaults

- Primare Produktiv-URL aktuell: https://204.168.217.211.nip.io
- Verifier fallback API: https://204.168.217.211.nip.io/api
- API in Frontend ueber relativen Pfad /api

## 8. Change Process

Bei DB-Aenderungen:
1. SQL zuerst in server/setup_server.sh oder separates server/*.sh Migrationsskript
2. Danach dieses Dokument aktualisieren
3. Danach Smoke-Tests ausfuehren (test_login.sh, test_patch.sh, test_login_full.sh)
