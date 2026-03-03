---
layout: default
title: Adress-Routing Tool
---

# 📍 Adress-Routing Tool — One Pager
**Datum:** 3. März 2026 · **Version:** 2.0 · **Status:** In Planung

---

## Inhaltsverzeichnis

| # | Abschnitt |
|---|---|
| 1 | [Ziel & Idee](#1-ziel--idee) |
| 2 | [Bestätigte Entscheidungen](#2-bestätigte-entscheidungen) |
| 3 | [Benutzerablauf](#3-benutzerablauf) |
| 4 | [Systemarchitektur](#4-systemarchitektur) |
| 5 | [Datenbank & Routing-Logik](#5-datenbank--routing-logik) |
| 6 | [Frontend-Ansichten](#6-frontend-ansichten) |
| 7 | [Kosten & Skalierung](#7-kosten--skalierung) |
| 8 | [Projektplan](#8-projektplan) |
| 9 | [Nächste Schritte](#9-nächste-schritte) |

---

## 1 · Ziel & Idee

> Mitarbeiter finden mit einem Klick die **N nächstgelegenen freien Adressen** aus einem Pool von ~2.000 Wiener Adressen — sortiert nach **echter Gehzeit** (nicht Luftlinie), visualisiert auf einer Karte. Besuchte Adressen werden dauerhaft protokolliert.

**Distanz-Ansatz: Echte Gehstrecke via OSRM**

| | Luftlinie (verworfen) | Gehstrecke via OSRM ✅ |
|---|---|---|
| Genauigkeit | Grob — ignoriert Straßen | Exakt — echter Fußweg |
| Kosten | $0 | $0 — OSRM ist Open Source |
| API-Key nötig | Nein | Nein |
| Datenbasis | GPS-Abstand | OpenStreetMap-Straßennetz |
| Geschwindigkeit | Sofort | ~100 ms pro Adresse |

**Kernfunktionen:**
- 🚶 Routing via OSRM (Open Source Routing Machine) — kostenlos, kein API-Key
- 🗺️ Karten-Ansicht mit Pins und echten Routen (Leaflet.js + OpenStreetMap)
- ✅ Erledigt-markieren mit optionaler Notiz
- 🔒 Login pro Mitarbeiter (Admin legt Konten an)
- 📋 Vollständiges Audit-Log (wer, wann, was, Notiz)

---

## 2 · Bestätigte Entscheidungen

| Frage | Entscheidung | Begründung |
|---|---|---|
| Distanz-Art | ✅ Echte Gehstrecke (OSRM) | Relevanter als Luftlinie |
| Login? | ✅ Ja — Admin legt Benutzer an | Zuordnung Besuche → Person |
| Tages-Reset? | ❌ Nein | Fortschritt soll dauerhaft bleiben |
| Archivierung | ✅ Permanent | Erledigte Adressen bleiben archiviert |
| Notiz bei Erledigt | ✅ Ja — optionales Freitextfeld | Z. B. „Nicht angetroffen" |
| Karten-Ansicht | ✅ Ja — Leaflet.js + OSM | Kostenlos, kein API-Key |
| Protokollierung | ✅ Ja — Audit-Log | Admin-Auswertung jederzeit |

---

## 3 · Benutzerablauf

```
┌─────────────────────────────────────────────────────────────────────┐
│                         BENUTZERABLAUF                              │
└─────────────────────────────────────────────────────────────────────┘

  ┌──────────┐
  │  START   │  Mitarbeiter öffnet Webseite (Smartphone / PC)
  └────┬─────┘
       │
       ▼
  ┌──────────────────────────────┐
  │  🔐 LOGIN                    │  E-Mail + Passwort
  │  (Admin hat Konto angelegt)  │  → JWT-Token via Supabase Auth
  └────────────┬─────────────────┘
               │
               ▼
  ┌──────────────────────────────┐
  │  📍 STANDORT ERMITTELN       │  [GPS automatisch]
  │                              │  ODER [Adresse eingeben]
  └────────────┬─────────────────┘
               │
               ▼
  ┌──────────────────────────────┐
  │  🔢 ANZAHL WÄHLEN            │  [5]  [10]  [15]
  └────────────┬─────────────────┘
               │
               ▼
  ┌──────────────────────────────────────────────────────┐
  │  ⚙️  ROUTING (automatisch im Hintergrund)             │
  │                                                      │
  │  1. Supabase: 50 nächste Adressen vorab filtern      │
  │  2. OSRM-API: echte Gehzeit für jede Adresse         │
  │  3. Sortierung nach Gehminuten                       │
  └────────────┬─────────────────────────────────────────┘
               │
               ▼
  ┌──────────────────────────────────────────────────────┐
  │  📋 ERGEBNISLISTE  /  🗺️ KARTEN-ANSICHT              │
  │                                                      │
  │  Rang  Adresse                    Gehzeit            │
  │   1    Grünentorgasse 12, 1200 W.  3 min  (220 m)   │
  │   2    Wallensteinstr. 5, 1200 W.  5 min  (390 m)   │
  │   3    Heiligenstädter Str. 69     8 min  (640 m)   │
  │                                                      │
  │  Pool: 1.673 verfügbare Adressen                     │
  └────────────┬─────────────────────────────────────────┘
               │
               ▼
  ┌──────────────────────────────┐
  │  💬 RESERVIERUNGS-DIALOG     │  „5 Adressen übernehmen?"
  │  [✅ Bestätigen] [Abbrechen]  │  → Status: IN BEARBEITUNG
  └────────────┬─────────────────┘
               │
               │   (Mitarbeiter besucht Adresse)
               ▼
  ┌──────────────────────────────┐
  │  ✓ ERLEDIGT-DIALOG           │  Adresse anklicken
  │                              │  Notiz (optional): [_______]
  │  [✓ Erledigt] [Abbrechen]    │  → Status: ARCHIVIERT
  └────────────┬─────────────────┘
               │
       ┌───────┴────────┐
       │                │
       ▼                ▼
  Alle erledigt?    Noch offen?
  → Neue Abfrage    → Weiter arbeiten
  starten           mit aktiver Liste

     ┌──────────┐
     │   ENDE   │  Archiv + Protokoll dauerhaft einsehbar
     └──────────┘
```

**Adress-Status Lebenszyklus:**

```
  VERFÜGBAR ──────────────► IN BEARBEITUNG ──────────────► ARCHIVIERT
     ▲   [Mitarbeiter           [Mitarbeiter                    │
     │    übernimmt]             erledigt]                      │
     │                                                          │
     └──────── Admin reaktiviert (Ausnahmefall) ────────────────┘
```

---

## 4 · Systemarchitektur

```
  ┌─────────────────────────────────────────────────────────────────┐
  │  FRONTEND  —  GitHub Pages (HTML / CSS / JavaScript)            │
  │                                                                 │
  │  ┌─────────┐  ┌──────────────┐  ┌────────┐  ┌──────────────┐  │
  │  │  Login  │  │  Hauptseite  │  │  Karte │  │  Archiv /    │  │
  │  │         │  │  Gehstrecken │  │  Routen│  │  Admin-View  │  │
  │  └─────────┘  └──────────────┘  └────────┘  └──────────────┘  │
  └──────────┬──────────────────────────────────────────────────────┘
             │                              │
             │ Supabase Auth JWT            │ OSRM Routing API
             ▼                              ▼
  ┌─────────────────────┐        ┌──────────────────────────────┐
  │  BACKEND — Supabase │        │  OSRM  (router.project-      │
  │                     │        │  osrm.org  —  kostenlos)     │
  │  Auth + PostgreSQL  │        │                              │
  │  Adress-Pool        │        │  GET /route/v1/foot/         │
  │  Protokoll-Log      │        │  lon1,lat1;lon2,lat2         │
  │  RLS pro Benutzer   │        │  → Gehminuten + Meter        │
  └─────────────────────┘        └──────────────────────────────┘
```

**Routing-Ablauf im Frontend (JavaScript):**

```
1. Supabase:  50 räumlich nächste verfügbare Adressen holen (Vorfilter)
2. OSRM:      Für jede der 50 Adressen: echte Gehzeit abfragen
              (parallel — ~50 Requests in <2 Sek.)
3. Sortieren: Nach Gehminuten aufsteigend
4. Anzeigen:  Top N in Liste + Karte
```

---

## 5 · Datenbank & Routing-Logik

**`adressen`** — Haupttabelle

| Spalte | Typ | Beschreibung |
|---|---|---|
| `id` | UUID | Eindeutige ID |
| `plz`, `ort`, `strasse` | TEXT | Adresse |
| `lat`, `lon` | FLOAT | GPS-Koordinaten |
| `standort` | GEOMETRY | PostGIS-Punkt (Vorfilter) |
| `status` | TEXT | `verfuegbar` / `in_bearbeitung` / `archiviert` |
| `benutzer_id` | UUID | Zuständiger Mitarbeiter |
| `erledigt_am` | TIMESTAMP | Zeitpunkt der Archivierung |

**`protokoll`** — Audit-Log

| Spalte | Typ | Beschreibung |
|---|---|---|
| `adressen_id` | UUID | Verknüpfte Adresse |
| `benutzer_id` | UUID | Wer hat die Aktion durchgeführt |
| `aktion` | TEXT | `uebernommen` / `erledigt` / `reaktiviert` |
| `zeitpunkt` | TIMESTAMP | Wann |
| `notiz` | TEXT | Optionale Bemerkung |

**Schritt 1 — Vorfilter (Supabase SQL, 50 Kandidaten):**

```sql
SELECT id, strasse, plz, ort, lat, lon
FROM adressen
WHERE status = 'verfuegbar'
ORDER BY standort <-> ST_MakePoint(16.3738, 48.2082)
LIMIT 50;
```

**Schritt 2 — Echte Gehzeit (OSRM, JavaScript):**

```javascript
// Für jede der 50 Kandidaten-Adressen:
const res = await fetch(
  `https://router.project-osrm.org/route/v1/foot/
   ${meinLon},${meinLat};${adresse.lon},${adresse.lat}
   ?overview=false`
);
const data = await res.json();
const gehsekunden = data.routes[0].duration;  // z. B. 187 Sek. = ~3 Min.
const meter       = data.routes[0].distance;  // z. B. 220 m
```

**Schritt 3 — Sortieren + Top N zurückgeben (JavaScript):**

```javascript
kandidaten
  .sort((a, b) => a.gehsekunden - b.gehsekunden)
  .slice(0, anzahl);  // Top 5 / 10 / 15
```

---

## 6 · Frontend-Ansichten

```
LOGIN              HAUPTSEITE (Liste)         KARTE              ERLEDIGT-DIALOG
┌──────────────┐   ┌──────────────────────┐   ┌──────────────┐   ┌──────────────┐
│ Routing Tool │   │ Hallo, Maria [Logout]│   │🔵 Ich        │   │ ✓ Erledigt?  │
│              │   ├──────────────────────┤   │   ╲Route 1   │   │──────────────│
│ E-Mail:      │   │ Standort: [GPS][Adr] │   │  📍1  📍2   │   │ Grünentorg.  │
│ [__________] │   │ Anzahl:  [5▼]        │   │        📍3   │   │ 12, 1200 W.  │
│              │   │ [Liste] [Karte]       │   │   📍4        │   │              │
│ Passwort:    │   │ [Adressen suchen]    │   │      📍5     │   │ Notiz:       │
│ [__________] │   ├──────────────────────┤   │              │   │ [__________] │
│              │   │ Pool: 1.673 frei     │   │ [OSM-Karte]  │   │              │
│ [Anmelden]   │   │ 1. Grünentorg.  3min │   │              │   │[✓] [Abbr.]   │
└──────────────┘   │ 2. Wallenstein. 5min │   └──────────────┘   └──────────────┘
                   │ 3. Heiligenst.  8min │
                   │ [✅ Übernehmen]       │
                   └──────────────────────┘

AKTIVE ADRESSEN                    ARCHIV (eigene History)
┌──────────────────────────────┐   ┌────────────────────────────────────┐
│ In Bearbeitung (2)           │   │ Meine erledigten Adressen          │
│──────────────────────────────│   │────────────────────────────────────│
│ 📍 Grünentorgasse 12         │   │ ✅ Grünentorgasse 12   03.03 10:15 │
│    Übernommen: 08:32         │   │    Notiz: (keine)                  │
│    [✓ Erledigt markieren]    │   │ ✅ Meidlinger Hstr.    02.03 14:42 │
│──────────────────────────────│   │    Notiz: „Nicht angetroffen"      │
│ 📍 Wallensteinstr. 5         │   │ ✅ Thaliastraße 99     01.03 09:08 │
│    Übernommen: 08:32         │   │    Notiz: „Einwurf verweigert"     │
│    [✓ Erledigt markieren]    │   └────────────────────────────────────┘
└──────────────────────────────┘
```

---

## 7 · Kosten & Skalierung

**10 Mitarbeiter · 15 Besuche/Tag · 2.000 Adressen im Pool**

| Kennzahl | Wert |
|---|---|
| Abdeckung pro Tag | ~150 Adressen |
| Pool aufgebraucht nach | ~13–14 Arbeitstage |
| OSRM-Requests/Abfrage | ~50 (Vorfilter-Kandidaten) |
| OSRM-Requests/Tag | ~2.000 (40 Abfragen × 50) |
| OSRM-Limit | Kein offizielles Limit (Fair-Use) |

| Dienst | Kostenlos-Limit | Nutzung | Status |
|---|---|---|---|
| Supabase Auth | 50.000 Nutzer | 10 Nutzer | ✅ |
| Supabase DB | 500 MB · 50k Req/Monat | <1k Req/Monat | ✅ |
| GitHub Pages | Unbegrenzt | Statisch | ✅ |
| OSRM (Routing) | Fair-Use · kein API-Key | ~2k Req/Tag | ✅ |
| Leaflet.js + OSM-Tiles | Fair-Use | Wenige Nutzer | ✅ |
| Nominatim (Geokodierung) | ~1.000/Tag | 2.000 einmalig | ✅ |
| **Gesamtkosten** | | | **$0/Monat** |

> **Hinweis:** Bei stark erhöhtem Volumen kann OSRM einfach selbst gehostet werden (kostenlos, eigener Server). Alternativ: OpenRouteService (2.000 Req/Tag kostenlos, API-Key erforderlich).

---

## 8 · Projektplan

| Phase | Aufgabe | Aufwand |
|---|---|---|
| **1** | Supabase einrichten · Tabellen · Auth | 2 Std. |
| **2** | Geokodierung + Daten-Import (Python) | 2–3 Std. |
| **3** | Frontend: Login · OSRM-Routing · Erledigt + Notiz | 8–10 Std. |
| **4** | Frontend: Karten-Ansicht mit Routen (Leaflet.js) | 3–4 Std. |
| **5** | Frontend: Archiv · Admin-Auswertung | 2–3 Std. |
| **6** | Test · Abnahme · Go-Live | 1–2 Std. |
| **Gesamt** | | **~2,5–3 Arbeitstage** |

---

## 9 · Nächste Schritte

- [ ] **Supabase-Konto anlegen** → [supabase.com](https://supabase.com) *(5 Min.)*
- [ ] **Mitarbeiterliste** bereitstellen — Name + E-Mail aller Benutzer
- [ ] **Adressliste** bereitstellen — Excel/CSV mit den ~2.000 Wiener Adressen
- [ ] **Entwicklung starten** — Phase 1: Supabase Setup + Tabellen

---

*Alle Kosten: **$0/Monat** · Stack: GitHub Pages · Supabase · OSRM · Leaflet.js · OpenStreetMap*
