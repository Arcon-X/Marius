---
title: "Adress-Import Report – Ärztekammerwahl Wien 2026"
---

# Adress-Import Report

<style>
.site-header { display: none !important; }
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
    <a href="/docs/import_report.html" class="active">Import</a>
    <a href="/docs/features.html">Features</a>
    <a href="/docs/technik.html">Technik</a>
    <a href="/docs/db_model.html">DB</a>
    <a href="/SPEC.html">SPEC</a>
    <a href="/docs/domain.html">Domain</a>
  </div>
</div>

**Projekt:** NOVUM-ZIV Unterschriften – BNZ Bündnis NOVUM–ZIV  
**Quelle:** `Zahnarztekammer_260223_211026.xlsx` (Tabelle „Table 1")  
**Erstellt:** 28. März 2026

---

## Ergebnis auf einen Blick

| Kennzahl | Wert |
|---|---|
| Einträge in der Excel-Datei | **1.491** |
| Erfolgreich geocodiert | **1.485** (99,6 %) |
| Nicht gefunden | **6** (0,4 %) |
| Geocoding-Dienst | Nominatim (nominatim.openstreetmap.org) |

---

## Methodik: 3-Stufen-Geocoding

Die Adressen wurden in drei aufeinanderfolgenden Schritten geocodiert.  
Jeder Schritt behandelte nur jene Einträge, die im vorherigen Schritt **nicht** aufgelöst werden konnten.

### Schritt 1 – Direktes Geocoding (`geocode_addresses.py`)

Das Skript liest die Excel-Datei (Spalte A: `Nachname Vorname (Titel.)`, Spalte B: `Straße HNr, PLZ Wien [Tel]`), parst Name und Adresse und stellt für jeden Eintrag eine strukturierte Anfrage an die Nominatim-API:

```
https://nominatim.openstreetmap.org/search
  ?street=<Straße> <HNr>
  &city=Wien
  &postalcode=<PLZ>
  &country=Austria
  &format=json
```

Zwischen allen Anfragen wird 1,1 Sekunden gewartet (Nominatim Rate-Limit: max. 1 req/s).

**Ergebnis Schritt 1:** 1.209 Adressen gefunden

---

### Schritt 2 – Vereinfachte Hausnummer (`geocode_retry.py`)

Viele Wiener Adressen enthalten komplexe Hausnummern wie `31-33/2/7`, `5a/3/12` oder `49a/Top 6`. Nominatim kann diese Formen oft nicht auflösen.

Das Skript extrahiert nur den **ersten numerischen Teil** der Hausnummer (z. B. `31-33/2/7` → `31`) und fragt erneut an.

**Ergebnis Schritt 2:** +201 weitere Adressen gefunden

---

### Schritt 3 – Straßenfeld-Bereinigung & Tippfehler-Korrekturen (`geocode_final.py`)

Beim Parsing in Schritt 1 wurden bei einigen Einträgen Teile der Hausnummer fälschlicherweise dem Straßenfeld zugeschlagen (z. B. `strasse = "Zschokkegasse 140/OG"`, `hnr = "2"`).  
Die Funktion `extract_clean_street_and_hnr()` erkennt solche Fälle und extrahiert Straßenname und Hausnummer korrekt.

Zusätzlich wurden bekannte Tippfehler in der Quelldatei korrigiert:

| Falsch (Original) | Richtig (korrigiert) |
|---|---|
| Wolllzeile | Wollzeile |
| Wassergase | Wassergasse |
| Garnisonstraße | Garnisongasse |

Für Adressen, bei denen eine andere Ordination in exakt derselben Straße+PLZ bereits gefunden wurde, werden die Koordinaten aus dem lokalen Cache übernommen (kein weiterer API-Aufruf nötig).

**Ergebnis Schritt 3:** +75 direkt neu gefunden, +29 aus Cache = **+104 Adressen**

---

## Gesamtstatistik nach Schritt

| Schritt | Methode | Neu gefunden | Kumuliert |
|---|---|---|---|
| Schritt 1 | Direkte Nominatim-Abfrage | 1.209 | 1.209 |
| Schritt 2 | Vereinfachte Hausnummer | 201 | 1.410 |
| Schritt 3 | Straßenfeld-Bereinigung + Typo-Fix | 75 | 1.485 |
| Schritt 3 | Koordinaten-Cache (gleiche Adresse) | 29 | 1.485 |
| – | Nicht geocodiert | 6 | – |
| **Gesamt** | | **1.491** | |

---

## Verteilung nach Postleitzahl

| PLZ | Anzahl | PLZ | Anzahl | PLZ | Anzahl |
|---|---|---|---|---|---|
| 1010 | 136 | 1090 | 249 | 1180 | 45 |
| 1020 | 88 | 1100 | 96 | 1190 | 58 |
| 1030 | 81 | 1110 | 32 | 1200 | 24 |
| 1040 | 39 | 1120 | 40 | 1210 | 64 |
| 1050 | 56 | 1130 | 42 | 1220 | 86 |
| 1060 | 65 | 1140 | 43 | 1230 | 46 |
| 1070 | 34 | 1150 | 33 | PLZ fehlt | 3 |
| 1080 | 49 | 1160 | 35 | | |
| | | 1170 | 41 | | |

Der stärkste Bezirk ist **1090 (Alsergrund)** mit 249 Einträgen (16,8 % der gecodierten Adressen).

---

## Nicht aufgelöste Adressen (6 Einträge)

Diese 6 Adressen konnten auch nach allen drei Schritten nicht geocodiert werden:

| ID | Arzt/Ärztin | Adresse | Grund |
|---|---|---|---|
| a0155 | DDr. Ioana Brana | Pernerstorfer Gasse 5/1/7, 1100 Wien | Straße nicht in OSM |
| a0274 | DDr. Gabriela Eisenmenger | Billrothstraße 49a/Top 6, 1190 Wien | Hausnummer 49a nicht gefunden |
| a0568 | Prim. Dr. Philip Jesch | Hertha Firnbergstraße 10/1/1, 1100 Wien | Straße nicht in OSM |
| a0599 | Dr. Stefanie Karlsböck | Wiedner Gürtel 13 Icon Vienna Turm 24.15 OG, 1100 Wien | Gebäudename im Adressfeld |
| a1058 | Dr. Sandra Raunig | Krankenhausstraße 9, Wien | PLZ fehlt in Quelldatei |
| a1246 | Dr. Karin Slowak-Hajek | Schöllerhofgasse 5/3, 1020 Wien | Straße nicht in OSM |

Diese Adressen können manuell über [maps.google.com](https://maps.google.com) oder [maps.wien.gv.at](https://maps.wien.gv.at) nachgepflegt werden.

---

## Datenbankbeschreibung

### Infrastruktur

```
Frontend  ──────────────────────────────────────────────────
  GitHub Pages (kostenlos)
  HTML / Vanilla JS / CSS
  Leaflet.js 1.9.x + OpenStreetMap-Tiles
  Routing: router.project-osrm.org (Fußprofil)
    │
    │ HTTPS + JWT (Bearer Token)
    ▼
Backend  ───────────────────────────────────────────────────
  VPS-Server (Ubuntu 24.04 LTS)
  PostgreSQL 16 + PostGIS 3
  PostgREST 12 (REST-API, Port 3000 intern)
  Nginx Reverse Proxy → :443 / Let's Encrypt TLS
    │
    │ HTTP (öffentlich, kostenlos)
    ▼
  router.project-osrm.org  (Gehminuten + Meter)
```

### Tabellen

#### `adressen`

| Spalte | Typ | Beschreibung |
|---|---|---|
| `id` | UUID | Primärschlüssel |
| `plz` | TEXT | Postleitzahl (z. B. `1090`) |
| `ort` | TEXT | Standardmäßig `Wien` |
| `strasse` | TEXT | Straßenname |
| `hausnummer` | TEXT | Hauptnummer (z. B. `31`) |
| `zusatz` | TEXT | Stiege, Türnummer, Top etc. |
| `lat` / `lon` | FLOAT | WGS-84-Koordinaten |
| `standort` | GEOMETRY(Point, 4326) | PostGIS-Punkt (automatisch via Trigger befüllt) |
| `status` | TEXT | `verfuegbar` · `in_bearbeitung` · `archiviert` |
| `benutzer_id` | UUID → `benutzer` | Zuständige Kandidatin/Kandidat |
| `reserviert_am` | TIMESTAMPTZ | Zeitpunkt der Übernahme |
| `erledigt_am` | TIMESTAMPTZ | Zeitpunkt des Abschlusses |
| `import_batch` | TEXT | Quell-Batch (`import_april_2021`) |
| `titel` | TEXT | Akademischer Titel |
| `arzt_name` | TEXT | Vor- und Nachname |

Auf `standort` liegt ein **GIST-Spatial-Index** für effiziente Umkreissuche.

#### `benutzer`

| Spalte | Typ | Beschreibung |
|---|---|---|
| `id` | UUID | Primärschlüssel |
| `email` | TEXT | Eindeutige Login-E-Mail |
| `name` | TEXT | Anzeigename |
| `rolle` | TEXT | `admin` oder `mitarbeiter` |
| `aktiv` | BOOLEAN | Konto aktiv/gesperrt |
| `erstellt_am` | TIMESTAMPTZ | Erstellungszeitpunkt |

#### `protokoll`

Vollständiger Audit-Log jeder Aktion.

| Spalte | Typ | Beschreibung |
|---|---|---|
| `id` | UUID | Primärschlüssel |
| `adressen_id` | UUID → `adressen` | Betroffene Adresse |
| `benutzer_id` | UUID → `benutzer` | Handelnde Person |
| `aktion` | TEXT | `uebernommen` · `waehlt_uns` · `waehlt_nicht` · `ueberlegt` · `kein_interesse_wahl` · `sonstige` · `reaktiviert` · `bearbeitet` |
| `zeitpunkt` | TIMESTAMPTZ | Zeitstempel |
| `notiz` | TEXT | Optionaler Freitext |

### SEED_ADRESSEN (Demo-Modus)

Ohne aktive Serververbindung lädt die App **1.485 Adressen** direkt aus dem eingebetteten JavaScript-Array `SEED_ADRESSEN` in `index.md`. Dieses Array wird von `generate_seed.py` aus `adressen_geocoded.json` generiert. Es ermöglicht vollständige Offline-Demos ohne Datenbank.

Jeder SEED-Eintrag:
```json
{ "id": "a0001", "plz": "1050", "strasse": "Hamburgerstraße",
  "hnr": "7", "titel": "Dr.", "name": "Sarah Abdel-Hamied",
  "lat": 48.1953042, "lon": 16.3553268 }
```

---

## Import-Skripte

| Skript | Aufgabe |
|---|---|
| `geocode_addresses.py` | Schritt 1: Excel lesen, Nominatim-Geocoding |
| `geocode_retry.py` | Schritt 2: Nicht gefundene mit vereinfachter HNr nochmals versuchen |
| `geocode_final.py` | Schritt 3: Straßenfeld bereinigen, Typo-Korrekturen, Cache |
| `generate_seed.py` | `adressen_geocoded.json` → `SEED_ADRESSEN` in `index.md` + `import.sql` |
| `import.sql` | PostgreSQL-INSERT-Statements für alle 1.485 gecodierten Adressen |

---

*Alle Geodaten: © OpenStreetMap-Mitwirkende, ODbL.*  
*Geocoding: Nominatim – [Usage Policy](https://operations.osmfoundation.org/policies/nominatim/)*
