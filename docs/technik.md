---
title: "NOVUM-ZIV — Technische Dokumentation & Kosten"
---

# NOVUM-ZIV Unterschriften — Technische Dokumentation & Kosten

> **Stand:** März 2026 · **Projekt:** BNZ Bündnis NOVUM–ZIV · Zahnärztekammerwahl Wien 2026

---

## 1. Architektur

```
┌─────────────────────────────────────────────┐
│  GitHub Pages (kostenlos)                   │
│  index.html — Single-File Vanilla JS App    │
│  Jekyll · HTTPS · CDN                       │
└──────────────┬──────────────────────────────┘
               │ HTTPS + JWT Bearer Token
               ▼
┌─────────────────────────────────────────────┐
│  Hetzner VPS (Falkenstein/Wien)             │
│  Ubuntu 24.04 LTS                           │
│  ┌─────────────────────────────────────┐    │
│  │ Nginx (Reverse Proxy + TLS)        │    │
│  │ Let's Encrypt Zertifikat           │    │
│  │ Rate-Limit: 30 req/min (API)       │    │
│  └──────────┬──────────────────────────┘    │
│             │ :3000 (localhost)              │
│  ┌──────────▼──────────────────────────┐    │
│  │ PostgREST 12.2.3                   │    │
│  │ REST-API über SQL Views            │    │
│  └──────────┬──────────────────────────┘    │
│             │ Unix Socket / TCP              │
│  ┌──────────▼──────────────────────────┐    │
│  │ PostgreSQL 16 + PostGIS 3          │    │
│  │ DB: novumziv                       │    │
│  │ Schema: public + api               │    │
│  └─────────────────────────────────────┘    │
└─────────────────────────────────────────────┘
               │
    ┌──────────┴──────────┐
    ▼                     ▼
┌────────────┐    ┌────────────────┐
│ Nominatim  │    │ OSRM           │
│ Geocoding  │    │ Fußgänger-     │
│ (einmalig) │    │ Routing        │
└────────────┘    └────────────────┘
```

---

## 2. Tech-Stack

| Schicht | Technologie | Version | Zweck |
|---|---|---|---|
| **Server-OS** | Ubuntu | 24.04 LTS | Hetzner VPS |
| **Datenbank** | PostgreSQL | 16 | Relationale Daten |
| **Geodaten** | PostGIS | 3.x | KNN-Suche, Geo-Indexe |
| **REST-API** | PostgREST | 12.2.3 | Automatische REST-API aus SQL Views |
| **Webserver** | Nginx | aktuell | Reverse Proxy, TLS, Rate-Limiting, CORS |
| **TLS** | Let's Encrypt | aktuell | Kostenloses HTTPS-Zertifikat |
| **Frontend** | Vanilla JS (ES2020) | — | Kein Framework, Single-File |
| **Karte** | Leaflet.js | 1.9.x | Interaktive OpenStreetMap-Karte |
| **Routing** | OSRM | v5 API | Fußgänger-Gehzeiten |
| **Geocoding** | Nominatim | v1 | Adress-zu-Koordinaten |
| **Hosting** | GitHub Pages | — | Frontend-Deployment via Git Push |
| **Python** | Python | 3.12 | Import-Scripts, Geocoding, Server-Utils |

---

## 3. Server-Details

| Parameter | Wert |
|---|---|
| **IP** | 204.168.217.211 |
| **Domain** | 204.168.217.211.nip.io (nip.io Wildcard DNS) |
| **SSH-Key** | `id_ed25519_novumziv2` |
| **SSH-User** | root |
| **API-Endpunkt** | `https://204.168.217.211.nip.io/api` |
| **PostgREST-Port** | 3000 (nur localhost) |
| **Nginx Rate-Limit** | 30 Requests/Minute (API-Zone) |
| **Python venv** | `/root/venv_verify` (für Server-Scripts) |

---

## 4. Datenbank-Schema

### Tabelle `benutzer`

| Spalte | Typ | Beschreibung |
|---|---|---|
| `id` | UUID (PK) | Auto-generiert |
| `email` | TEXT UNIQUE | Login-Adresse |
| `name` | TEXT | Anzeigename |
| `rolle` | TEXT | `admin` oder `mitarbeiter` |
| `passwort_hash` | TEXT | bcrypt-Hash |
| `telefon` | TEXT | Telefonnummer (optional) |
| `aktiv` | BOOLEAN | Account aktiv/deaktiviert |
| `erstellt_am` | TIMESTAMPTZ | Erstellungszeitpunkt |

### Tabelle `adressen`

| Spalte | Typ | Beschreibung |
|---|---|---|
| `id` | UUID (PK) | Auto-generiert |
| `plz` | TEXT | Postleitzahl |
| `ort` | TEXT | Default: 'Wien' |
| `strasse` | TEXT | Straßenname |
| `hausnummer` | TEXT | Hausnummer inkl. Stiege/Tür |
| `zusatz` | TEXT | Optionaler Zusatz |
| `lat` / `lon` | FLOAT | Koordinaten (WGS84) |
| `standort` | GEOMETRY(Point, 4326) | PostGIS-Punkt (Auto-Trigger) |
| `status` | TEXT | `verfuegbar`, `in_bearbeitung`, `archiviert` |
| `benutzer_id` | UUID (FK) | Zugewiesene Person |
| `reserviert_am` | TIMESTAMPTZ | Zeitpunkt der Übernahme |
| `erledigt_am` | TIMESTAMPTZ | Zeitpunkt des Abschlusses |
| `import_batch` | TEXT | Import-Kennung |
| `titel` | TEXT | z. B. „Dr.", „DDr." |
| `arzt_name` | TEXT | Name des Zahnarztes |
| `geo_name` | TEXT | Gebäude, Viertel (Nominatim) |
| `sprache` | TEXT | `de`, `pa` etc. |
| `verifiziert` | BOOLEAN | Praxis verifiziert? |
| `website` | TEXT | Offizielle Website-URL |

### Tabelle `protokoll`

| Spalte | Typ | Beschreibung |
|---|---|---|
| `id` | UUID (PK) | Auto-generiert |
| `adressen_id` | UUID (FK) | Referenzierte Adresse |
| `benutzer_id` | UUID (FK) | Handelnde Person |
| `aktion` | TEXT | Aktions-Typ (CHECK Constraint) |
| `zeitpunkt` | TIMESTAMPTZ | Wann |
| `notiz` | TEXT | Freitext / JSON-Snapshot |

**Erlaubte Aktionen:** `uebernommen`, `waehlt_uns`, `waehlt_nicht`, `ueberlegt`, `kein_interesse_wahl`, `sonstige`, `reaktiviert`, `bearbeitet`

### Indexe

- `adressen_standort_idx` — GiST-Index für PostGIS KNN-Suche
- `adressen_status_idx` — B-Tree auf Status
- `protokoll_adressen_idx` — B-Tree auf Adressen-ID
- `protokoll_benutzer_idx` — B-Tree auf Benutzer-ID
- `protokoll_zeitpunkt_idx` — B-Tree DESC auf Zeitpunkt

---

## 5. API-Schicht (PostgREST Views)

### `api.adressen` (View)
- **SELECT:** 19 Spalten (alle relevanten Felder)
- **UPDATE:** Für `authenticated` Rolle
- Trigger `sync_standort` aktualisiert PostGIS-Punkt bei lat/lon-Änderung

### `api.protokoll` (View)
- **SELECT, INSERT:** Für `authenticated` Rolle

### `api.benutzer` (View)
- **SELECT:** Alle authentifizierten Benutzer
- **INSERT/UPDATE/DELETE:** Via INSTEAD OF Trigger (nur Admins)
- Passwort-Hash wird *nicht* exponiert

### `api.login(email, passwort)` (RPC)
- Prüft bcrypt-Hash → gibt JWT-Token (8h Gültigkeit) zurück
- Enthält: `user_id`, `email`, `name`, `rolle`, `exp`
- Zugriff: `anon` Rolle (vor Login)

### `api.naechste_adressen(lat, lon, anzahl)` (RPC)
- PostGIS KNN-Suche: Nächste N freie Adressen per Luftlinie
- Gibt Distanz in Metern mit zurück

---

## 6. Sicherheits-Maßnahmen

| Maßnahme | Details |
|---|---|
| **HTTPS** | Let's Encrypt TLS, erzwungen via Nginx |
| **JWT-Auth** | PostgREST verifiziert Token, 8h Ablauf |
| **Content Security Policy** | Whitelist für Scripts, API, Tiles |
| **CORS** | `Access-Control-Allow-Origin` auf Frontend-Domain |
| **Rate-Limiting** | Nginx: 30 req/min pro IP |
| **Passwort-Hashing** | bcrypt via `pgcrypto` (`gen_salt('bf')`) |
| **Brute-Force-Schutz** | Client: 5 Fehlversuche → 60s Sperre |
| **SQL-Injection** | Verhindert durch PostgREST (parametrisierte Queries) |
| **Admin-Only Triggers** | Team-Management: Server-seitige Rollenprüfung in SECURITY DEFINER Funktionen |
| **Kein Passwort in View** | `api.benutzer` exponiert nur id, email, name, rolle, telefon, aktiv |

---

## 7. Nginx-Konfiguration

```nginx
server {
    listen 443 ssl http2;
    server_name 204.168.217.211.nip.io;

    ssl_certificate     /etc/letsencrypt/live/.../fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/.../privkey.pem;

    # Rate-Limiting
    limit_req_zone $binary_remote_addr zone=api:10m rate=30r/m;

    location /api/ {
        limit_req zone=api burst=10 nodelay;
        proxy_pass http://127.0.0.1:3000/;
        proxy_hide_header Access-Control-Allow-Origin;
        add_header Access-Control-Allow-Origin "https://arcon-x.github.io" always;
        add_header Access-Control-Allow-Methods "GET, POST, PATCH, DELETE, OPTIONS" always;
        add_header Access-Control-Allow-Headers "Authorization, Content-Type, Prefer, Accept" always;
    }
}
```

---

## 8. Datei-Struktur

```
NOVUM-ZIV/
├── index.html              ← Gesamte Frontend-App (~3.500 Zeilen)
├── _config.yml             ← Jekyll-Konfiguration
├── robots.txt              ← Suchmaschinen-Ausschluss
├── SPEC.md                 ← Entwickler-Spezifikation
├── adressen_geocoded.json  ← Geocodierte Adressdaten
├── import.sql              ← SQL-Import der Adressen
├── verify_adressen.py      ← Auto-Verifizierungs-Script (DDG)
├── update_geo_names.py     ← Batch Geo-Name Update
│
├── docs/
│   ├── features.md         ← Feature-Dokumentation
│   └── technik.md          ← Technische Dokumentation (diese Datei)
│
├── ARCHIV/
│   ├── import_report.md    ← Import-Statistik & Qualitätsprüfung
│   ├── adressen_import.csv ← Original-Importdaten
│   ├── geocode_*.py        ← Geocoding-Scripts
│   └── ...
│
└── server/
    ├── setup_server.sh     ← Server-Ersteinrichtung (komplett)
    ├── setup_tls.sh        ← TLS/Let's Encrypt Setup
    ├── create_users.py     ← Benutzerkonten anlegen
    ├── harden_server.sh    ← Server-Härtung
    ├── add_verification.sh ← DB-Migration: Verifizierung
    ├── add_user_mgmt.sh    ← DB-Migration: Team-Management
    ├── update_geo_names.sh ← Geo-Name Batch-Update
    ├── fix_cors.sh         ← CORS-Fix für Nginx
    └── upload_and_run.ps1  ← Deployment-Script (PowerShell)
```

---

## 9. Deployment-Workflow

### Frontend (GitHub Pages)
```bash
git add .
git commit -m "Feature XYZ"
git push origin main
# → GitHub Pages baut automatisch via Jekyll
# → Live in ~30 Sekunden auf https://arcon-x.github.io/Marius/
```

### Server-Migrationen
```powershell
# SSH-Key setzen
$SSH_KEY = "$env:USERPROFILE\.ssh\id_ed25519_novumziv2"

# Script hochladen und ausführen
scp -i $SSH_KEY server/script.sh root@204.168.217.211:/tmp/
ssh -i $SSH_KEY root@204.168.217.211 "bash /tmp/script.sh"

# SQL direkt ausführen
scp -i $SSH_KEY file.sql root@204.168.217.211:/tmp/
ssh -i $SSH_KEY root@204.168.217.211 "sudo -u postgres psql -d novumziv -f /tmp/file.sql"
```

### Bulk-Updates (Rate-Limit umgehen)
Für Massen-Updates direkt via `psql` statt API (Nginx limitiert auf 30 req/min):
```bash
ssh root@server "sudo -u postgres psql -d novumziv -c 'UPDATE ...'"
```

---

## 10. Externe Dienste

| Dienst | URL | Kosten | Nutzung |
|---|---|---|---|
| **GitHub Pages** | github.com | € 0 | Frontend-Hosting |
| **OSRM** | router.project-osrm.org | € 0 | Fußgänger-Routing |
| **Nominatim** | nominatim.openstreetmap.org | € 0 | Geocoding (max 1 req/s) |
| **OpenStreetMap Tiles** | tile.openstreetmap.org | € 0 | Kartenmaterial |
| **Leaflet.js** | unpkg.com CDN | € 0 | Karten-Bibliothek |
| **nip.io** | nip.io | € 0 | Wildcard-DNS für IP → Domain |
| **Let's Encrypt** | letsencrypt.org | € 0 | TLS-Zertifikat |

---

## 11. Kostenaufstellung

### Einmalige Kosten

| Posten | Betrag |
|---|---|
| Domain (nip.io) | € 0 (Wildcard-DNS) |
| TLS-Zertifikat | € 0 (Let's Encrypt) |
| Adress-Geocoding | € 0 (Nominatim) |
| Setup & Entwicklung | Eigenleistung |

### Laufende Kosten (pro Monat)

| Posten | Anbieter | Kosten/Monat |
|---|---|---|
| **VPS Server** | Hetzner (CX22: 2 vCPU, 4 GB RAM, 40 GB SSD) | **€ 3,79** |
| GitHub Pages | GitHub | € 0 |
| OSRM Routing | Öffentlich | € 0 |
| Nominatim | Öffentlich | € 0 |
| OSM Tiles | Öffentlich | € 0 |
| **Gesamt** | | **€ 3,79** |

### Gesamtkosten (2 Monate Wahlkampf)

| | Betrag |
|---|---|
| Server (2 × € 3,79) | **€ 7,58** |
| Alles andere | € 0 |
| **Gesamt** | **€ 7,58** |

> **Hinweis:** Alle externen Dienste (Routing, Geocoding, Karten, Hosting, DNS, TLS) sind kostenlos.
> Die einzige laufende Ausgabe ist der Hetzner-Server.

### Alternative: Anexia (österreichisches Hosting)

| | Hetzner (DE) | Anexia (AT) |
|---|---|---|
| Standort | Falkenstein, DE | Wien, AT |
| Preis/Monat | € 3,79 | ~€ 20 |
| 2 Monate | € 7,58 | ~€ 40 |
| Datensouveränität | 🇪🇺 EU | 🇦🇹 Österreich |

---

## 12. Datenvolumen

| Tabelle | Zeilen | Beschreibung |
|---|---|---|
| `adressen` | 1.485 | Wiener Zahnarztpraxen |
| `benutzer` | ~21 | Kandidat:innen + Admin |
| `protokoll` | wachsend | ~5–10 Einträge/Tag |

Gesamte DB-Größe: < 50 MB (inkl. PostGIS-Indexe).

---

## 13. Bekannte Limitierungen

| Thema | Status | Details |
|---|---|---|
| **Auto-Verifizierung** | ⏸️ Pausiert | DuckDuckGo-Suche lieferte 87% Spam. Google CSE benötigt Kreditkarte. Timer gestoppt. |
| **OSRM Rate-Limit** | ⚠️ Vorsicht | Öffentlicher Endpunkt, keine Garantie. Max 50 Calls pro Suche. |
| **Nominatim Rate-Limit** | ✅ OK | 1 req/s Policy. Bulk-Geocoding über Server-Script mit Delay. |
| **Single-File Frontend** | ℹ️ Design-Entscheidung | Gesamte App in einer HTML-Datei (~3.500 Zeilen). Funktioniert, aber nicht ideal für Teamarbeit. |
| **Kein Offline-Modus** | ℹ️ | App benötigt Internetverbindung. localStorage cached aber Daten. |

---

## 14. Ansprechpartner

| Rolle | Name | Kontakt |
|---|---|---|
| **Projektleitung & Admin** | Dr. Marius Romanin | zahradnik@haselbach.art |
| **Server-Zugang** | SSH-Key | `id_ed25519_novumziv2` |
| **Repository** | GitHub | github.com/Arcon-X/Marius |
| **Live-App** | GitHub Pages | arcon-x.github.io/Marius |
