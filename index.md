---
layout: default
title: Adress-Routing Tool
---

# 📍 Adress-Routing Tool — One Pager
**Datum:** 3. März 2026 · **Version:** 1.0 · **Status:** In Planung

---

## Inhaltsverzeichnis

| # | Abschnitt |
|---|---|
| 1 | [Ziel & Idee](#1-ziel--idee) |
| 2 | [Bestätigte Entscheidungen](#2-bestätigte-entscheidungen) |
| 3 | [Benutzerablauf](#3-benutzerablauf) |
| 4 | [Systemarchitektur](#4-systemarchitektur) |
| 5 | [Datenbank](#5-datenbank) |
| 6 | [Frontend-Ansichten](#6-frontend-ansichten) |
| 7 | [Kosten & Skalierung](#7-kosten--skalierung) |
| 8 | [Projektplan](#8-projektplan) |
| 9 | [Nächste Schritte](#9-nächste-schritte) |

---

## 1 · Ziel & Idee

> Mitarbeiter finden mit einem Klick die **N nächstgelegenen freien Adressen** aus einem Pool von ~2.000 Wiener Adressen — sortiert nach Luftlinie, visualisiert auf einer Karte. Besuchte Adressen werden dauerhaft protokolliert.

**Kernfunktionen:**
- 🔍 GPS-basierte KNN-Suche (K nächste Nachbarn)
- 🗺️ Karten-Ansicht mit Pins (Leaflet.js + OpenStreetMap)
- ✅ Erledigt-markieren mit optionaler Notiz
- 🔒 Login pro Mitarbeiter (Admin legt Konten an)
- 📋 Vollständiges Audit-Log (wer, wann, was, Notiz)

---

## 2 · Bestätigte Entscheidungen

| Frage | Entscheidung | Begründung |
|---|---|---|
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
  │  📋 ERGEBNISLISTE  /  🗺️ KARTEN-ANSICHT              │
  │                                                      │
  │  Rang  Adresse                     Entfernung        │
  │   1    Grünentorgasse 12, 1200 W.    180 m           │
  │   2    Wallensteinstr. 5, 1200 W.    340 m           │
  │   3    Heiligenstädter Str. 69       610 m           │
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
  │  │         │  │  Liste + KNN │  │  Pins  │  │  Admin-View  │  │
  │  └─────────┘  └──────────────┘  └────────┘  └──────────────┘  │
  └─────────────────────────┬───────────────────────────────────────┘
                            │  HTTPS + Supabase Auth JWT
                            ▼
  ┌─────────────────────────────────────────────────────────────────┐
  │  BACKEND  —  Supabase (kostenlos)                               │
  │                                                                 │
  │  ┌──────────────┐  ┌───────────────────┐  ┌─────────────────┐  │
  │  │  Auth        │  │  PostgreSQL        │  │  Row Level      │  │
  │  │  Login /     │  │  + PostGIS         │  │  Security (RLS) │  │
  │  │  JWT Tokens  │  │  KNN <-> Operator  │  │  pro Benutzer   │  │
  │  └──────────────┘  └───────────────────┘  └─────────────────┘  │
  │                                                                 │
  │  ┌──────────────────────────────────────────────────────────┐   │
  │  │  Protokoll-Tabelle: Audit-Log (wer · wann · was · Notiz) │   │
  │  └──────────────────────────────────────────────────────────┘   │
  └─────────────────────────────────────────────────────────────────┘
```

---

## 5 · Datenbank

**`adressen`** — Haupttabelle

| Spalte | Typ | Beschreibung |
|---|---|---|
| `id` | UUID | Eindeutige ID |
| `plz`, `ort`, `strasse` | TEXT | Adresse |
| `lat`, `lon` | FLOAT | GPS-Koordinaten |
| `standort` | GEOMETRY | PostGIS-Punkt für KNN |
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

**KNN-Abfrage (nächste 5 verfügbare Adressen):**

```sql
SELECT strasse, plz, ort,
       ST_Distance(standort, ST_MakePoint(16.3738, 48.2082)) AS meter
FROM adressen
WHERE status = 'verfuegbar'
ORDER BY standort <-> ST_MakePoint(16.3738, 48.2082)
LIMIT 5;
```

---

## 6 · Frontend-Ansichten

```
LOGIN              HAUPTSEITE (Liste)         KARTE              ERLEDIGT-DIALOG
┌──────────────┐   ┌──────────────────────┐   ┌──────────────┐   ┌──────────────┐
│ Routing Tool │   │ Hallo, Maria [Logout]│   │🔵 Ich        │   │ ✓ Erledigt?  │
│              │   ├──────────────────────┤   │              │   │──────────────│
│ E-Mail:      │   │ Standort: [GPS][Adr] │   │  📍1  📍2   │   │ Grünentorg.  │
│ [__________] │   │ Anzahl:  [5▼]        │   │        📍3   │   │ 12, 1200 W.  │
│              │   │ [Liste] [Karte]       │   │   📍4        │   │              │
│ Passwort:    │   │ [Adressen suchen]    │   │      📍5     │   │ Notiz:       │
│ [__________] │   ├──────────────────────┤   │              │   │ [__________] │
│              │   │ Pool: 1.673 frei     │   │ [OSM-Karte]  │   │              │
│ [Anmelden]   │   │ 1. Grünentorg. 180m  │   │              │   │[✓] [Abbr.]   │
└──────────────┘   │ 2. Wallenstein. 340m │   └──────────────┘   └──────────────┘
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
| API-Kosten laufend | $0 / Monat |

| Dienst | Kostenlos-Limit | Nutzung | Status |
|---|---|---|---|
| Supabase Auth | 50.000 Nutzer | 10 Nutzer | ✅ |
| Supabase DB | 500 MB · 50k Req/Monat | <1k Req/Monat | ✅ |
| GitHub Pages | Unbegrenzt | Statisch | ✅ |
| Leaflet.js + OSM-Tiles | Fair-Use | Wenige Nutzer | ✅ |
| Nominatim (Geokodierung) | ~1.000/Tag | 2.000 einmalig | ✅ |
| **Gesamtkosten** | | | **$0/Monat** |

---

## 8 · Projektplan

| Phase | Aufgabe | Aufwand |
|---|---|---|
| **1** | Supabase einrichten · Tabellen · Auth | 2 Std. |
| **2** | Geokodierung + Daten-Import (Python) | 2–3 Std. |
| **3** | Frontend: Login · KNN-Suche · Erledigt + Notiz | 6–8 Std. |
| **4** | Frontend: Karten-Ansicht (Leaflet.js) | 3–4 Std. |
| **5** | Frontend: Archiv · Admin-Auswertung | 2–3 Std. |
| **6** | Test · Abnahme · Go-Live | 1–2 Std. |
| **Gesamt** | | **~2,5 Arbeitstage** |

---

## 9 · Nächste Schritte

- [ ] **Supabase-Konto anlegen** → [supabase.com](https://supabase.com) *(5 Min.)*
- [ ] **Mitarbeiterliste** bereitstellen — Name + E-Mail aller Benutzer
- [ ] **Adressliste** bereitstellen — Excel/CSV mit den ~2.000 Wiener Adressen
- [ ] **Entwicklung starten** — Phase 1: Supabase Setup + Tabellen

---

*Alle Kosten: **$0/Monat** · Stack: GitHub Pages · Supabase · Leaflet.js · OpenStreetMap*
