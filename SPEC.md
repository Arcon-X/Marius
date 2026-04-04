# NOVUM-ZIV Unterschriften — Technische Spezifikation

<style>
.doc-nav { position: sticky; top: .5rem; z-index: 20; background: #fff; border: 1px solid #d0d7de; border-radius: 10px; padding: .7rem; margin: .2rem 0 1rem 0; box-shadow: 0 2px 8px rgba(0,0,0,.05); }
.doc-nav-title { font-size: .8rem; color: #57606a; font-weight: 700; margin-bottom: .45rem; }
.doc-nav-links { display: flex; gap: .4rem; overflow-x: auto; padding-bottom: .15rem; }
.doc-nav-links a { text-decoration: none; border: 1px solid #d0d7de; background: #f6f8fa; color: #24292f; border-radius: 999px; padding: .32rem .72rem; white-space: nowrap; font-size: .82rem; font-weight: 600; }
.doc-nav-links a.active { background: #1f6feb; border-color: #1f6feb; color: #fff; }
</style>

<div class="doc-nav" role="navigation" aria-label="Dokumentationsnavigation">
  <div class="doc-nav-title">Dokumentation</div>
  <div class="doc-nav-links">
    <a href="/docs/index.html">Hub</a>
    <a href="/docs/import_report.html">Import</a>
    <a href="/docs/features.html">Features</a>
    <a href="/docs/technik.html">Technik</a>
    <a href="/docs/db_model.html">DB</a>
    <a href="/SPEC.html" class="active">SPEC</a>
    <a href="/docs/domain.html">Domain</a>
    <a href="/docs/tests_businesscases.html">Tests BC</a>
    <a href="/tests/backend/README.html">Tests Backend</a>
  </div>
</div>

> **Zweck dieses Dokuments:** Vollständige Entwicklerreferenz. Dieses Dokument NICHT löschen.
> Stand: 3. März 2026 · Autor: Dr. Marius Romanin (Admin)

---

## 1. Projektüberblick

| Element | Wert |
|---|---|
| **Projektname** | NOVUM-ZIV Unterschriften |
| **Organisation** | BNZ Bündnis NOVUM–ZIV |
| **Anlass** | Zahnärztekammerwahl Wien 2026 |
| **Ziel** | ~2.000 Wiener Wahlberechtigte per Hausbesuch erreichen |
| **Benutzer** | 19 Kandidat:innen (1 Admin + 18 Mitarbeiter:innen) |
| **Laufzeit** | ~2 Monate Wahlkampf, danach Daten komplett löschen |
| **Planung live** | https://204.168.217.211.nip.io |
| **Repo** | https://github.com/Arcon-X/Marius (public) |

### Kernfunktion
Kandidat:innen finden per Klick die **N nächstgelegenen freien Adressen** (sortiert nach echter
Gehzeit via OSRM) und protokollieren Unterschriften dauerhaft. Doppelbesuche werden
automatisch verhindert.

---

## 2. Architektur-Übersicht

```
┌──────────────────────────────────────┐
│  FRONTEND — GitHub Pages (kostenlos) │
│  HTML / Vanilla JS / CSS             │
│  Login · Suche · Liste · Karte       │
└──────────┬───────────────────────────┘
           │ HTTPS + JWT (Bearer Token)
           ▼
┌──────────────────────────────────────┐
│  Anexia Server (Wien, AT)            │
│  Ubuntu 24.04 LTS                    │
│  ├── PostgreSQL 16 + PostGIS 3       │
│  │     Tabellen: adressen, benutzer, │
│  │               protokoll           │
│  └── PostgREST 12 (REST-API)         │
│        Port 3000 (intern)            │
│        Nginx Reverse Proxy → :443    │
└──────────┬───────────────────────────┘
           │ OSRM HTTP (öffentlich, kostenlos)
           ▼
┌──────────────────────────────────────┐
│  router.project-osrm.org             │
│  Profil: foot (Fußgänger)            │
│  → Gehminuten + Meter                │
└──────────────────────────────────────┘
Daten: OpenStreetMap (OSM) — © OSM-Mitwirkende
Karte: Leaflet.js + OSM-Tiles (kostenlos)
Geocoding: Nominatim (einmalig beim Adress-Import)
```

### Warum kein selbst gehostetes OSRM?
Für ~2.000 Adressen und 19 Nutzer reicht der öffentliche OSRM-Endpunkt problemlos.
Kein Rate-Limit-Problem bei serialisierten Anfragen (max. 50 OSRM-Calls pro Suche).

---

## 3. Tech-Stack — Exakte Versionen

| Schicht | Technologie | Version | Hinweis |
|---|---|---|---|
| Server-OS | Ubuntu | 24.04 LTS | Anexia managed |
| Datenbank | PostgreSQL | 16 | |
| Geodaten | PostGIS | 3.x | `apt install postgis` |
| REST-Middleware | PostgREST | 12.x | Binär-Release von GitHub |
| Webserver / TLS | Nginx | aktuelle LTS | Reverse Proxy + Let's Encrypt |
| TLS-Zertifikat | Let's Encrypt / Certbot | aktuell | kostenlos |
| Frontend-Routing | router.project-osrm.org | v5 API | Fuß-Profil |
| Frontend-Karte | Leaflet.js | 1.9.x | CDN |
| Kartenmaterial | OpenStreetMap / Carto | — | kostenlos |
| Geocoding (1x) | Nominatim (nominatim.openstreetmap.org) | v1 | policy: max 1 req/s |
| Frontend-Hosting | GitHub Pages | — | kostenlos, Jekyll disabled |
| Frontend-Sprache | HTML5 + Vanilla JS (ES2020) | — | kein Framework nötig |
| Geocodierung-Script | Python | 3.12 | requests-Bibliothek |
| Adress-Import | Python + psycopg2 | — | CSV → DB |

---

## 4. Hosting & Kosten

### Option B — Anexia (Wien, AT) · **bevorzugt**
| | |
|---|---|
| **Anbieter** | Anexia Internetdienstleistungs GmbH |
| **Firmensitz** | Österreich (Klagenfurt / Wien) |
| **Rechenzentrum** | Wien, Österreich |
| **US-Bezug** | ❌ Keiner |
| **Preis** | ab ~€ 20 / Monat (VPS mit 2 vCPU, 4 GB RAM) |
| **PostgreSQL** | ✅ Problemlos installierbar |
| **AVV (DSGVO)** | ✅ Verfügbar |
| **Kündigung** | Monatlich |
| **Website** | https://www.anexia.com/de/ |

### Alternative — Hetzner (DE)
| | |
|---|---|
| **Anbieter** | Hetzner Online GmbH (Deutschland) |
| **Preis** | ab € 3,79 / Monat (CX22: 2 vCPU, 4 GB RAM) |
| **US-Bezug** | ❌ Keiner (EU-Unternehmen) |
| **Nachteil** | Deutsches Unternehmen, nicht österreichisch |

### Kostenübersicht (2 Monate Wahlkampf)

| Dienst | Anexia (AT) | Hetzner (DE) |
|---|---|---|
| Server + PostgreSQL + PostGIS | ~€ 20/Mt. | € 3,79/Mt. |
| GitHub Pages (Frontend) | € 0 | € 0 |
| OSRM (Routing) | € 0 | € 0 |
| Leaflet.js + OSM (Karte) | € 0 | € 0 |
| Nominatim (Geocoding, einmalig) | € 0 | € 0 |
| **Gesamt / Monat** | **~€ 20** | **€ 3,79** |
| **Gesamt 2 Monate** | **~€ 40** | **€ 7,58** |

Preisdifferenz: ~€ 32 für 2 Monate. Empfehlung: Anexia (österreichische Datensouveränität).

---

## 5. Datenbankschema (vollständiges SQL)

```sql
-- Erweiterungen
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Benutzer-Tabelle
CREATE TABLE benutzer (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email       TEXT UNIQUE NOT NULL,
  name        TEXT NOT NULL,
  rolle       TEXT NOT NULL DEFAULT 'mitarbeiter', -- 'admin' oder 'mitarbeiter'
  aktiv       BOOLEAN DEFAULT TRUE,
  erstellt_am TIMESTAMPTZ DEFAULT NOW()
);

-- Adressen-Tabelle
CREATE TABLE adressen (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  plz          TEXT NOT NULL,
  ort          TEXT NOT NULL DEFAULT 'Wien',
  strasse      TEXT NOT NULL,
  hausnummer   TEXT NOT NULL,
  zusatz       TEXT,                        -- Tür, Stiege etc.
  lat          FLOAT NOT NULL,
  lon          FLOAT NOT NULL,
  standort     GEOMETRY(Point, 4326),       -- PostGIS-Punkt
  status       TEXT NOT NULL DEFAULT 'verfuegbar', -- 'verfuegbar' | 'in_bearbeitung' | 'archiviert'
  benutzer_id  UUID REFERENCES benutzer(id),       -- zuständige Person (wenn in_bearbeitung)
  reserviert_am  TIMESTAMPTZ,              -- Zeitpunkt der Übernahme
  erledigt_am    TIMESTAMPTZ,              -- Zeitpunkt Abschluss
  import_batch   TEXT,                    -- Quell-Batch (z.B. 'import_2026_03')
  CONSTRAINT status_check CHECK (status IN ('verfuegbar','in_bearbeitung','archiviert'))
);

-- Spatial Index (entscheidend für Performance)
CREATE INDEX adressen_standort_idx ON adressen USING GIST(standort);
CREATE INDEX adressen_status_idx   ON adressen(status);

-- Trigger: standort automatisch aus lat/lon befüllen
CREATE OR REPLACE FUNCTION sync_standort() RETURNS TRIGGER AS $$
BEGIN
  NEW.standort := ST_SetSRID(ST_MakePoint(NEW.lon, NEW.lat), 4326);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_sync_standort
  BEFORE INSERT OR UPDATE ON adressen
  FOR EACH ROW EXECUTE FUNCTION sync_standort();

-- Protokoll / Audit-Log
CREATE TABLE protokoll (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  adressen_id  UUID NOT NULL REFERENCES adressen(id),
  benutzer_id  UUID NOT NULL REFERENCES benutzer(id),
  aktion       TEXT NOT NULL, -- 'uebernommen', 'unterschrift', 'nicht_angetroffen', 'kein_interesse', 'reaktiviert'
  zeitpunkt    TIMESTAMPTZ DEFAULT NOW(),
  notiz        TEXT,
  CONSTRAINT aktion_check CHECK (aktion IN (
    'uebernommen','unterschrift','nicht_angetroffen','kein_interesse','reaktiviert'
  ))
);

CREATE INDEX protokoll_adressen_idx  ON protokoll(adressen_id);
CREATE INDEX protokoll_benutzer_idx  ON protokoll(benutzer_id);
CREATE INDEX protokoll_zeitpunkt_idx ON protokoll(zeitpunkt DESC);

-- Issues-Tabelle (Bug/Feature-Tracking im Admin-Bereich)
CREATE TABLE issues (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  typ           TEXT NOT NULL CHECK (typ IN ('bug','feature')),
  beschreibung  TEXT NOT NULL,
  status        TEXT NOT NULL DEFAULT 'offen' CHECK (status IN ('offen','erledigt')),
  erstellt_von  UUID REFERENCES benutzer(id),
  erstellt_am   TIMESTAMPTZ DEFAULT NOW(),
  erledigt_am   TIMESTAMPTZ
);

CREATE INDEX issues_status_idx      ON issues(status);
CREATE INDEX issues_erstellt_am_idx ON issues(erstellt_am DESC);
```

---

## 6. PostgREST Konfiguration

```ini
# /etc/postgrest.conf
db-uri         = "postgres://postgrest_user:PASSWORT@localhost:5432/novumziv"
db-schemas     = "api"
db-anon-role   = "anon"
jwt-secret     = "MINDESTENS_32_ZEICHEN_GEHEIMER_SCHLUESSEL"
server-port    = 3000
server-host    = "127.0.0.1"
```

### PostgreSQL Rollen für PostgREST
```sql
-- Anonymer Benutzer (nur Login-Endpoint)
CREATE ROLE anon NOLOGIN;

-- Authentifizierter Benutzer
CREATE ROLE authenticated NOLOGIN;
GRANT USAGE ON SCHEMA api TO anon, authenticated;

-- PostgREST-Systemrolle
CREATE ROLE postgrest_user WITH LOGIN PASSWORD 'SICHERES_PASSWORT';
GRANT anon, authenticated TO postgrest_user;
```

### Nginx Reverse Proxy (Kurzform)
```nginx
server {
  listen 443 ssl;
  server_name novum-ziv.DOMAIN.at;

  ssl_certificate     /etc/letsencrypt/live/novum-ziv.DOMAIN.at/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/novum-ziv.DOMAIN.at/privkey.pem;

  location /api/ {
    proxy_pass         http://127.0.0.1:3000/;
    proxy_set_header   Host $host;
    add_header         Access-Control-Allow-Origin "https://204.168.217.211.nip.io" always;
    add_header         Access-Control-Allow-Headers "Authorization,Content-Type" always;
  }
}
```

---

## 7. Authentifizierung

**Methode:** JWT (JSON Web Token) via PostgREST + bcrypt-Passwort-Hashing

```sql
-- Login-Funktion (im api-Schema, wird von PostgREST als RPC-Endpoint exposed)
CREATE OR REPLACE FUNCTION api.login(email TEXT, passwort TEXT)
RETURNS JSON AS $$
DECLARE
  usr benutzer%ROWTYPE;
  token TEXT;
BEGIN
  SELECT * INTO usr FROM benutzer WHERE benutzer.email = login.email AND aktiv = TRUE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Ungültige Zugangsdaten' USING ERRCODE = '28P01';
  END IF;
  -- Passwort-Prüfung mit pgcrypto
  IF NOT crypt(passwort, usr.passwort_hash) = usr.passwort_hash THEN
    RAISE EXCEPTION 'Ungültige Zugangsdaten' USING ERRCODE = '28P01';
  END IF;
  -- JWT generieren (sign-Funktion von pgjwt Extension oder custom)
  token := sign(
    json_build_object('role','authenticated','user_id', usr.id, 'exp', extract(epoch from now() + interval '8 hours')),
    current_setting('app.jwt_secret')
  );
  RETURN json_build_object('token', token, 'name', usr.name, 'rolle', usr.rolle);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

**Frontend-Flow:**
1. POST `/api/rpc/login` mit `{email, passwort}` → erhält JWT
2. Token im `sessionStorage` speichern (NICHT localStorage — schließt mit Browser-Tab)
3. Alle weiteren Requests: `Authorization: Bearer <token>`
4. Token-Ablauf: 8 Stunden

---

## 8. Kernfunktion: Nächste-Adressen-Algorithmus

### Schritt 1: PostGIS-Vorfilter (SQL via PostgREST)
```sql
-- Exposed als View oder Function im api-Schema
-- Gibt 50 Kandidaten nach Luftlinie zurück (schnell)
SELECT id, strasse, hausnummer, plz, ort, lat, lon,
       ST_Distance(standort::geography,
         ST_MakePoint(:lon, :lat)::geography) AS luftlinie_m
FROM adressen
WHERE status = 'verfuegbar'
ORDER BY standort <-> ST_SetSRID(ST_MakePoint(:lon, :lat), 4326)
LIMIT 50;
```

### Schritt 2: OSRM Gehzeit-Berechnung (JavaScript)
```javascript
// Serielle Abfragen, max 1 req/s (OSRM Fair-Use)
async function calcWalkTimes(userLon, userLat, candidates) {
  const results = [];
  for (const addr of candidates) {
    const url = `https://router.project-osrm.org/route/v1/foot/` +
                `${userLon},${userLat};${addr.lon},${addr.lat}` +
                `?overview=false&steps=false`;
    const r = await fetch(url);
    const data = await r.json();
    if (data.code === 'Ok') {
      const route = data.routes[0];
      results.push({
        ...addr,
        gehzeit_s:  route.duration,   // Sekunden
        entfernung: route.distance,   // Meter
      });
    }
    await new Promise(res => setTimeout(res, 200)); // 200ms Pause
  }
  return results.sort((a, b) => a.gehzeit_s - b.gehzeit_s);
}
```

### Schritt 3: Top N anzeigen
```javascript
const N = parseInt(document.getElementById('anzahl').value); // 5 / 10 / 15
const topN = sortedResults.slice(0, N);
renderList(topN);
renderMap(topN);
```

---

## 9. Status-Lifecycle

```
VERFÜGBAR
  │
  ├──[Kandidat:in übernimmt]──▶ IN BEARBEITUNG
  │                                    │
  │                          ┌─────────┴──────────┐
  │                          ▼         ▼           ▼
  │                     UNTERSCHRIFT  NICHT     KEIN
  │                      erzielt    ANGETROFFEN INTERESSE
  │                          └─────────┬──────────┘
  │                                    ▼
  │                                ARCHIVIERT
  │                                    │
  └──[Admin reaktiviert]───────────────┘ (Ausnahmefall)
```

**Status-Werte in DB:** `verfuegbar` | `in_bearbeitung` | `archiviert`
**Ergebnis-Werte im Protokoll:** `uebernommen` | `unterschrift` | `nicht_angetroffen` | `kein_interesse` | `reaktiviert`

---

## 10. Frontend-Struktur (Vanilla JS SPA)

```
index.html  (oder GitHub Pages: index.md mit layout: null)
│
├── <head>  CSS-Variablen, mobil-optimiert
│
├── .app-bar   (fixed, oben)
│     Logo + Badge + Datum
│
├── .app-content  (scrollbarer Bereich)
│     ├── #screen-login       (nicht eingeloggt)
│     ├── #screen-main        (Suche + Ergebnisse)
│     │     ├── Standort-Eingabe (GPS oder manuell)
│     │     ├── Anzahl-Wahl (5/10/15)
│     │     ├── [Suchen]-Button → Algorithm oben
│     │     ├── #view-list  (Liste mit Gehzeiten)
│     │     └── #view-map   (Leaflet-Karte)
│     ├── #screen-done-dialog (Erledigt-Modal)
│     │     ├── Button: ✅ Unterschrift
│     │     ├── Button: ❌ Nicht angetroffen
│     │     ├── Button: ⏭ Kein Interesse
│     │     └── Textarea: Notiz (optional)
│     └── #screen-admin       (nur für admin-Rolle)
│           ├── Benutzer-Verwaltung
│           ├── Auswertung / Statistik
│           └── CSV-Export
│
└── .bottom-nav  (fixed, unten) — nur wenn eingeloggt
      Suche · Karte · Aktivität · Admin
```

### BNZ Farben (CSS-Variablen)
```css
:root {
  --g:    #2C6E49;  /* BNZ Grün (Primary) */
  --g-h:  #4C9A6F;  /* Grün Hell (Hover) */
  --g-l:  #E8F5EE;  /* Grün Blass (Background) */
  --dark: #1A2E22;  /* BNZ Dunkel (App Bar) */
  --txt:  #1C1C1C;
  --sub:  #5a5a5a;
  --bg:   #F4F7F5;
  --card: #ffffff;
  --bdr:  #D5E8DC;
}
```

---

## 11. Adress-Import (Python)

```python
# geocode_and_import.py
# Voraussetzung: pip install requests psycopg2-binary openpyxl

import time, requests, psycopg2
from openpyxl import load_workbook

DB = psycopg2.connect(
    host="SERVER-IP", dbname="novumziv",
    user="import_user", password="PASSWORT"
)

NOMINATIM = "https://nominatim.openstreetmap.org/search"
HEADERS = {"User-Agent": "NOVUM-ZIV-Import/1.0 (marius.romanin@bnz-wien.at)"}

def geocode(strasse, hausnummer, plz):
    q = f"{strasse} {hausnummer}, {plz} Wien, Austria"
    r = requests.get(NOMINATIM, params={"q": q, "format": "json", "limit": 1},
                     headers=HEADERS, timeout=10)
    results = r.json()
    if results:
        return float(results[0]["lat"]), float(results[0]["lon"])
    return None, None

wb = load_workbook("adressen.xlsx")
ws = wb.active
cur = DB.cursor()
failed = []

for row in ws.iter_rows(min_row=2, values_only=True):
    plz, strasse, hausnummer, zusatz = row[0], row[1], row[2], row[3]
    lat, lon = geocode(strasse, hausnummer, plz)
    if lat:
        cur.execute(
            "INSERT INTO adressen (plz, strasse, hausnummer, zusatz, lat, lon, import_batch) "
            "VALUES (%s, %s, %s, %s, %s, %s, 'import_2026_03')",
            (str(plz), strasse, str(hausnummer), zusatz, lat, lon)
        )
    else:
        failed.append((plz, strasse, hausnummer))
    time.sleep(1.1)  # Nominatim: max 1 req/s!

DB.commit()
print(f"Importiert. Fehlgeschlagen: {len(failed)}")
for f in failed:
    print("  FEHLER:", f)
```

---

## 12. Team — 19 Kandidat:innen

| # | Name | Rolle | E-Mail (Platzhalter) |
|---|---|---|---|
| 1 | Dr. Marius Romanin | 2. Vizepräsident:in · **ADMIN** | marius.romanin@bnz-wien.at |
| 2 | OMR Dr. Franz Hastermann | Präsident | franz.hastermann@bnz-wien.at |
| 3 | Drin Petra Drabo | Landesfinanzreferent:in | petra.drabo@bnz-wien.at |
| 4 | DDr. Andreas Eder | Landesfinanzreferent:in (Sukz.) | andreas.eder@bnz-wien.at |
| 5 | MRin DDrin Barbara Thornton | Betr. Auflagen & Qualitätssicherung | barbara.thornton@bnz-wien.at |
| 6 | Dr. Eren Eryilmaz | Betr. Auflagen (Sukzessor) | eren.eryilmaz@bnz-wien.at |
| 7 | Dr. Leon Golestani BSc BA MA | Referat Fortbildung | leon.golestani@bnz-wien.at |
| 8 | Drin Julia Stella Glatz | Referat Fortbildung (Sukz.) | julia.glatz@bnz-wien.at |
| 9 | Drin Andrietta Dossenbach | Referat Hochschulangelegenheiten | andrietta.dossenbach@bnz-wien.at |
| 10 | Drin Andrea Gamper | Referat Hochschul. (Sukz.) | andrea.gamper@bnz-wien.at |
| 11 | Dr. Dino Imsirovic | Referat Kassenangelegenheiten | dino.imsirovic@bnz-wien.at |
| 12 | MR Dr. Gerhard Schager | Referat Kassen. (Sukzessor) | gerhard.schager@bnz-wien.at |
| 13 | Dr. Paul Inkofer | Referat Niederlassung & Wahlzahnärzt:innen | paul.inkofer@bnz-wien.at |
| 14 | Drin Andrea Bednar-Brandt | Referat Niederlassung (Sukz.) | andrea.bednar-brandt@bnz-wien.at |
| 15 | Drin Anita Elmauthaler | Referat Soziales & Jungzahnärzt:innen | anita.elmauthaler@bnz-wien.at |
| 16 | Drin Petra Stühlinger | Referat Soziales (Sukzessorin) | petra.stuehlinger@bnz-wien.at |
| 17 | Drin Lama Hamisch MSc | Referat Vergemeinschaftungsformen | lama.hamisch@bnz-wien.at |
| 18 | Dr. Otis Rezegh | Referat Vergemeins. (Sukzessor) | otis.rezegh@bnz-wien.at |
| 19 | Drin Selma Husejnovic | Kommunikation / Öffentlichkeit | selma.husejnovic@bnz-wien.at |

⚠️ E-Mail-Adressen sind **Platzhalter** — vor dem ersten Login bestätigen!

---

## 13. Bestätigte Entscheidungen

| Frage | Entscheidung |
|---|---|
| Distanz-Art | ✅ Echte Gehzeit (OSRM, Fuß-Profil) |
| Hosting | ✅ Option B — Anexia (Wien, AT) |
| Login-Vergabe | ✅ Admin legt alle Konten an (keine Selbstregistrierung) |
| Tages-Reset | ❌ Nein — dauerhafter Fortschritt (kein Reset) |
| Archivierung | ✅ Permanent (bis nach der Wahl) |
| Notiz bei Erledigt | ✅ Optionales Freitextfeld |
| Karten-Ansicht | ✅ Leaflet.js + OpenStreetMap |
| Protokollierung | ✅ Vollständiger Audit-Log |

---

## 14. Offene Punkte (vor Entwicklungsstart klären)

1. **DSGVO:** Option B (Anexia, personenbez. Daten auf AT-Server) oder Option C (nur anonyme Adress-IDs) bestätigen
2. **Adressliste:** Excel/CSV mit ~2.000 Wiener Adressen bereitstellen. Enthält sie Namen? → beeinflusst Option B vs C
3. **E-Mail-Adressen:** Reale E-Mails aller 19 Kandidat:innen bestätigen (aktuell nur Platzhalter)
4. **Domain:** Subdomain für Anexia-Server? z.B. `app.bnz-wien.at` oder `novum-ziv.at`
5. **Passwort-Vergabe:** Initial-Passwörter per sicherem Kanal an Kandidat:innen verteilen

---

## 15. Projektplan (~3 Arbeitstage nach Freigabe)

| Phase | Aufgabe | Zeit |
|---|---|---|
| 0 | DSGVO finalisieren (Option B/C) | vor Start |
| 1 | Anexia-Server aufsetzen: Ubuntu + PostgreSQL + PostGIS + PostgREST + Nginx + TLS | 2–3 Std. |
| 2 | Datenbank anlegen: Schema aus §5 ausführen, Rollen, JWT-Secret | 1 Std. |
| 3 | 19 Benutzerkonten anlegen (Admin + 18) | 1 Std. |
| 4 | Adress-Import: geocode_and_import.py ausführen (~2.000 Adressen) | 2–3 Std. |
| 5 | Frontend: Login-Screen | 2 Std. |
| 6 | Frontend: Suche + OSRM-Routing + Ergebnisliste | 4–5 Std. |
| 7 | Frontend: Leaflet-Karte | 2–3 Std. |
| 8 | Frontend: Erledigt-Dialog + Protokoll-Logging | 2 Std. |
| 9 | Frontend: Admin-Bereich (Statistik, Benutzer-Verwaltung) | 2–3 Std. |
| 10 | Test mit echten Daten + Pilotbetrieb | 2 Std. |
| 11 | Go-Live — alle 19 Kandidat:innen erhalten Zugangsdaten | 1 Std. |
| 12 | **Nach der Wahl:** Server-Daten vollständig löschen (DSGVO) | 30 Min. |

---

## 16. Sicherheit & DSGVO-Checkliste

- [ ] AVV (Auftragsverarbeitungsvertrag) mit Anexia unterzeichnen
- [ ] Passwörter: bcrypt (min. 12 Runden) via `pgcrypto`
- [ ] HTTPS: Let's Encrypt, HSTS aktivieren
- [ ] JWT-Secret: min. 256 Bit, sicher generiert (`openssl rand -hex 32`)
- [ ] PostgreSQL: kein direkter Internetzugang (nur via PostgREST/Nginx)
- [ ] Backup: täglich, verschlüsselt, nur auf Anexia-Server
- [ ] Token-Ablauf: 8 Stunden (Session-basiert, kein Refresh-Token)
- [ ] Audit-Log: jede Statusänderung wird protokolliert
- [ ] Nach Wahl: `DROP DATABASE novumziv; Server kündigen`
- [ ] Kein Google Analytics, kein CDN-Tracking (alle Libs lokal oder vertrauenswürdige CDNs)

---

## 17. Screen-Mockups

```
LOGIN              HAUPTSEITE              ERLEDIGT-DIALOG
┌───────────────┐  ┌──────────────────┐  ┌───────────────┐
│  NOVUM-ZIV    │  │ NOVUM-ZIV [APP]  │  │  ✓ Erledigt?  │
│  Unterschriften│  ├──────────────────┤  │───────────────│
│───────────────│  │ GPS ○  Adresse ○ │  │ Grünentorg. 12│
│ E-Mail:       │  │ [Meine Position] │  │───────────────│
│ [___________] │  │                  │  │[✅ Unterschrift]│
│ Passwort:     │  │ Anzahl: [10 ▼]   │  │[❌ Nicht angetr]│
│ [___________] │  │ [Liste] [Karte]  │  │[⏭ Kein Inter.] │
│               │  │ [🔍 Suchen]      │  │               │
│ [Anmelden]    │  ├──────────────────┤  │ Notiz (opt.): │
│               │  │ 1. Grünentorg.12 │  │ [___________] │
│               │  │    🚶 3 min 220m │  │               │
│               │  │    [✅ Übernehmen]│  │ [Speichern]   │
│               │  │ 2. Wallenst. 14  │  └───────────────┘
│               │  │    🚶 5 min 380m │
└───────────────┘  └──────────────────┘
```

---

## 18. Git-Workflow & Dateien

| Datei | Zweck |
|---|---|
| `index.md` | Planungs-App (GitHub Pages SPA, `layout: null`) |
| `SPEC.md` | **Dieses Dokument** — technische Vollspezifikation |
| `_config.yml` | Jekyll-Konfiguration (title, theme, url) |
| `robots.txt` | `Disallow: /` — keine Suchmaschinen |
| `.github/workflows/pages.yml` | Auto-Deploy auf Push zu `main` |
| `geocode_and_import.py` | *(noch zu erstellen)* Adress-Import-Script |

### Python-Schreibmuster (WICHTIG für dieses Repo)
**IMMER Python via pylance RunCodeSnippet für Datei-Schreiboperationen verwenden.**
PowerShell `Set-Content` korrumpiert deutsche UTF-8-Zeichen (ä/ö/ü/ß).

```python
# Beispiel: Datei schreiben
with open('D:/GIT/Marius/datei.md', 'w', encoding='utf-8') as f:
    f.write(inhalt)
```

### Git-Commit-Muster
```python
import subprocess
cwd = 'D:/GIT/Marius'
subprocess.run(['git','add','-A'], cwd=cwd)
subprocess.run(['git','commit','-m','Beschreibung'], cwd=cwd)
subprocess.run(['git','push'], cwd=cwd)
```

---

*Dieses Dokument wird bei jeder relevanten Änderung aktualisiert.*
*Letzte Aktualisierung: 3. März 2026*
