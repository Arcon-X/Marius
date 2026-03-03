---
layout: default
title: NOVUM-ZIV Unterschriften — Planungsdokument
---

<style>
/* Farben basierend auf bnz-wien.at */
:root {
  --bnz-gruen:      #2C6E49;
  --bnz-gruen-hell: #4C9A6F;
  --bnz-gruen-blass:#E8F5EE;
  --bnz-dunkel:     #1A2E22;
  --bnz-grau:       #F5F5F5;
  --bnz-text:       #1C1C1C;
  --bnz-weiss:      #FFFFFF;
}
body { font-family: 'Segoe UI', Arial, sans-serif; color: var(--bnz-text); }
h1   { color: var(--bnz-dunkel); border-bottom: 4px solid var(--bnz-gruen); padding-bottom: .3em; }
h2   { color: var(--bnz-gruen); border-left: 5px solid var(--bnz-gruen); padding-left: .6em; margin-top: 2em; }
h3   { color: var(--bnz-dunkel); }
table { width:100%; border-collapse: collapse; margin: 1em 0; }
th    { background: var(--bnz-gruen); color: var(--bnz-weiss); padding: .5em .8em; text-align:left; }
td    { padding: .4em .8em; border-bottom: 1px solid #ddd; }
tr:nth-child(even) td { background: var(--bnz-grau); }
blockquote { border-left: 4px solid var(--bnz-gruen-hell); background: var(--bnz-gruen-blass); padding: .8em 1.2em; border-radius: 4px; }
code  { background: var(--bnz-grau); padding: .1em .3em; border-radius: 3px; }
pre   { background: var(--bnz-grau); border-left: 3px solid var(--bnz-gruen); padding: 1em; overflow-x: auto; }
</style>

# 📋 NOVUM-ZIV Unterschriften — Planungsdokument
**Projekt:** NOVUM-ZIV Unterschriften · **Stand:** 3. März 2026 · **Phase:** Planung  
**Organisation:** [BNZ Bündnis NOVUM–ZIV](https://www.bnz-wien.at/) · Zahnärztekammerwahl Wien 2026

> ⚠️ **Planungsdokument** — noch kein Code, keine Datenbank, keine Live-Umgebung. Alle Angaben sind Entwürfe zur internen Abstimmung.

---

## Inhaltsverzeichnis

| # | Abschnitt |
|---|---|
| 1 | [Ziel & Kontext](#1-ziel--kontext) |
| 2 | [Entscheidungen](#2-entscheidungen) |
| 3 | [Geplante Benutzerliste](#3-geplante-benutzerliste) |
| 4 | [Benutzerablauf](#4-benutzerablauf) |
| 5 | [Systemarchitektur](#5-systemarchitektur) |
| 6 | [Datenbank & Routing-Logik](#6-datenbank--routing-logik) |
| 7 | [Frontend-Ansichten & Farbschema](#7-frontend-ansichten--farbschema) |
| 8 | [Kosten & Skalierung](#8-kosten--skalierung) |
| 9 | [Projektplan](#9-projektplan) |
| 10 | [Nächste Schritte](#10-nächste-schritte) |

---

## 1 · Ziel & Kontext

> Mitarbeiter:innen des BNZ Bündnisses finden mit einem Klick die **N nächstgelegenen
> freien Adressen** aus einem Pool von ~2.000 Wiener Wahlberechtigten — sortiert nach
> **echter Gehzeit** — und protokollieren Unterschriften dauerhaft mit Namensangabe.

**Anlass:** Zahnärztekammerwahl Wien 2026  
**Bündnis:** NOVUM–ZIV (Bündnis NOVUM + Zahnärztlicher Interessenverband Österreichs)  
**Aufgabe der App:** Hausbesuche zur Unterschriftensammlung koordinieren, Fortschritt tracken, Doppelbesuche vermeiden.

---

## 2 · Entscheidungen

| Frage | Entscheidung | Begründung |
|---|---|---|
| Distanz-Art | ✅ Echte Gehstrecke (OSRM) | Relevanter als Luftlinie |
| Login? | ✅ Ja — Admin legt Benutzer an | Zuordnung Besuche → Person |
| Tages-Reset? | ❌ Nein | Fortschritt soll dauerhaft bleiben |
| Archivierung | ✅ Permanent | Besuchte Adressen bleiben archiviert |
| Notiz bei Erledigt | ✅ Ja — optionales Freitextfeld | Z. B. „Unterschrift erhalten" / „Nicht angetroffen" |
| Karten-Ansicht | ✅ Ja — Leaflet.js + OSM | Kostenlos, kein API-Key |
| Protokollierung | ✅ Ja — Audit-Log | Wer, wann, Ergebnis |

---

## 3 · Geplante Benutzerliste

Alle Kandidat:innen von bnz-wien.at als geplante App-Benutzer:innen.  
**Admin** = Dr. Marius Romanin (Projektverantwortung)  
**Mitarbeiter:innen** = alle anderen Kandidat:innen als gleichwertige Nutzer:innen

| # | Name | Funktion / Kandidatur | Rolle App | E-Mail (Platzhalter) |
|---|---|---|---|---|
| 1 | Dr. Marius Romanin | 2. Vizepräsidentin | **Admin** | marius.romanin@bnz-wien.at |
| 2 | OMR Dr. Franz Hastermann | Präsident | Mitarbeiter | franz.hastermann@bnz-wien.at |
| 3 | Drin Petra Drabo | Landesfinanzreferent:in | Mitarbeiter | petra.drabo@bnz-wien.at |
| 4 | DDr. Andreas Eder | Landesfinanzreferent:in (Sukz.) | Mitarbeiter | andreas.eder@bnz-wien.at |
| 5 | MRin DDrin Barbara Thornton | Betr. Auflagen & Qualitätssicherung | Mitarbeiter | barbara.thornton@bnz-wien.at |
| 6 | Dr. Eren Eryilmaz | Betr. Auflagen (Sukzessor) | Mitarbeiter | eren.eryilmaz@bnz-wien.at |
| 7 | Dr. Leon Golestani BSc BA MA | Referat Fortbildung | Mitarbeiter | leon.golestani@bnz-wien.at |
| 8 | Drin Julia Stella Glatz | Referat Fortbildung (Sukz.) | Mitarbeiter | julia.glatz@bnz-wien.at |
| 9 | Drin Andrietta Dossenbach | Referat Hochschulangelegenheiten | Mitarbeiter | andrietta.dossenbach@bnz-wien.at |
| 10 | Drin Andrea Gamper | Referat Hochschul. (Sukz.) | Mitarbeiter | andrea.gamper@bnz-wien.at |
| 11 | Dr. Dino Imsirovic | Referat Kassenangelegenheiten | Mitarbeiter | dino.imsirovic@bnz-wien.at |
| 12 | MR Dr. Gerhard Schager | Referat Kassen. (Sukzessor) | Mitarbeiter | gerhard.schager@bnz-wien.at |
| 13 | Dr. Paul Inkofer | Referat Niederlassung & Wahlzahnärzt:innen | Mitarbeiter | paul.inkofer@bnz-wien.at |
| 14 | Drin Andrea Bednar-Brandt | Referat Niederlassung (Sukz.) | Mitarbeiter | andrea.bednar-brandt@bnz-wien.at |
| 15 | Drin Anita Elmauthaler | Referat Soziales & Jungzahnärzt:innen | Mitarbeiter | anita.elmauthaler@bnz-wien.at |
| 16 | Drin Petra Stühlinger | Referat Soziales (Sukzessorin) | Mitarbeiter | petra.stuehlinger@bnz-wien.at |
| 17 | Drin Lama Hamisch MSc | Referat Vergemeinschaftungsformen & Angestellte | Mitarbeiter | lama.hamisch@bnz-wien.at |
| 18 | Dr. Otis Rezegh | Referat Vergemeins. (Sukzessor) | Mitarbeiter | otis.rezegh@bnz-wien.at |
| 19 | Drin Selma Husejnovic | Kommunikation / Öffentlichkeit | Mitarbeiter | selma.husejnovic@bnz-wien.at |

> ⚠️ **E-Mail-Adressen sind Platzhalter** — echte Adressen vor Setup eintragen.  
> Login-Passwörter werden beim Setup einmalig per E-Mail versendet (Supabase Auth).

**Gesamt: 19 Benutzer:innen** (1 Admin + 18 Mitarbeiter:innen)

---

## 4 · Benutzerablauf

```
┌─────────────────────────────────────────────────────────────────────┐
│            NOVUM-ZIV Unterschriften — Benutzerablauf                │
└─────────────────────────────────────────────────────────────────────┘

  ┌──────────┐
  │  START   │  Kandidat:in öffnet Webseite (Smartphone / PC)
  └────┬─────┘
       │
       ▼
  ┌──────────────────────────────┐
  │  🔐 LOGIN                    │  E-Mail + Passwort (vom Admin vergeben)
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
  │  1. Supabase: 50 räumlich nächste Adressen (Vorfilter)│
  │  2. OSRM: echte Gehzeit für jede Adresse            │
  │  3. Sortierung nach Gehminuten                       │
  └────────────┬─────────────────────────────────────────┘
               │
               ▼
  ┌──────────────────────────────────────────────────────┐
  │  📋 ERGEBNISLISTE  /  🗺️ KARTEN-ANSICHT              │
  │  Rang  Adresse                      Gehzeit          │
  │   1    Grünentorgasse 12, 1200 W.   3 min  (220 m)   │
  │   2    Wallensteinstr. 5, 1200 W.   5 min  (390 m)   │
  │   3    Heiligenstädter Str. 69      8 min  (640 m)   │
  │  Pool: X Adressen noch verfügbar                     │
  └────────────┬─────────────────────────────────────────┘
               │
               ▼
  ┌──────────────────────────────┐
  │  💬 RESERVIERUNGS-DIALOG     │  „5 Adressen übernehmen?"
  │  [✅ Bestätigen] [Abbrechen]  │  → Status: IN BEARBEITUNG
  └────────────┬─────────────────┘
               │   (Kandidat:in besucht Adresse)
               ▼
  ┌──────────────────────────────┐
  │  ✓ ERLEDIGT-DIALOG           │
  │  Ergebnis wählen:            │
  │  [✅ Unterschrift erhalten]   │
  │  [❌ Nicht angetroffen]       │
  │  [⏭️  Nicht interessiert]     │
  │  Notiz (optional): [_______] │
  │  → Status: ARCHIVIERT        │
  └────────────┬─────────────────┘
               │
       ┌───────┴────────┐
       ▼                ▼
  Alle erledigt?    Noch offen?
  → Neue Abfrage    → Weiter
  starten           mit aktiver Liste
```

**Adress-Status Lebenszyklus:**

```
  VERFÜGBAR ──[übernommen]──► IN BEARBEITUNG ──[erledigt]──► ARCHIVIERT
     ▲                                                            │
     └──────────────── Admin reaktiviert (Ausnahmefall) ──────────┘
```

---

## 5 · Systemarchitektur

```
  ┌──────────────────────────────────────────────────────────────────┐
  │  FRONTEND  —  GitHub Pages (HTML / CSS / JavaScript)             │
  │  Farben: BNZ Grün #2C6E49 · Hintergrund #FFFFFF · Text #1C1C1C  │
  │                                                                  │
  │  ┌─────────┐  ┌──────────────┐  ┌────────┐  ┌───────────────┐  │
  │  │  Login  │  │  Hauptseite  │  │  Karte │  │  Archiv /     │  │
  │  │  BNZ    │  │  Gehstrecken │  │  Routen│  │  Admin-View   │  │
  │  │  Logo   │  │  + Ergebnis  │  │  Pins  │  │  Auswertung   │  │
  │  └─────────┘  └──────────────┘  └────────┘  └───────────────┘  │
  └─────────┬────────────────────────────────────────────────────────┘
            │ Supabase JWT                  │ OSRM Routing
            ▼                              ▼
  ┌─────────────────────┐        ┌─────────────────────────────┐
  │  Supabase (gratis)  │        │  OSRM (gratis, kein Key)    │
  │  Auth + PostgreSQL  │        │  router.project-osrm.org    │
  │  19 Benutzer:innen  │        │  Fußgänger-Routing Wien     │
  │  Protokoll-Log      │        │  → Minuten + Meter          │
  └─────────────────────┘        └─────────────────────────────┘
```

---

## 6 · Datenbank & Routing-Logik

**`adressen`**

| Spalte | Typ | Beschreibung |
|---|---|---|
| `id` | UUID | Eindeutige ID |
| `plz`, `ort`, `strasse` | TEXT | Adresse |
| `lat`, `lon` | FLOAT | GPS-Koordinaten |
| `standort` | GEOMETRY | PostGIS-Punkt (Vorfilter) |
| `status` | TEXT | `verfuegbar` / `in_bearbeitung` / `archiviert` |
| `benutzer_id` | UUID | Zuständige Person |
| `erledigt_am` | TIMESTAMP | Zeitpunkt |

**`protokoll`** — Audit-Log

| Spalte | Typ | Beschreibung |
|---|---|---|
| `adressen_id` | UUID | Verknüpfte Adresse |
| `benutzer_id` | UUID | Wer |
| `aktion` | TEXT | `uebernommen` / `unterschrift` / `nicht_angetroffen` / `nicht_interessiert` |
| `zeitpunkt` | TIMESTAMP | Wann |
| `notiz` | TEXT | Optionale Bemerkung |

**Vorfilter SQL (50 Kandidaten):**
```sql
SELECT id, strasse, plz, lat, lon
FROM adressen WHERE status = 'verfuegbar'
ORDER BY standort <-> ST_MakePoint(:lon, :lat) LIMIT 50;
```

**OSRM-Abfrage (JavaScript):**
```javascript
const r = await fetch(`https://router.project-osrm.org/route/v1/foot/
  ${meinLon},${meinLat};${a.lon},${a.lat}?overview=false`);
const { duration, distance } = (await r.json()).routes[0];
// duration = Sekunden, distance = Meter
```

---

## 7 · Frontend-Ansichten & Farbschema

**Farbpalette (BNZ Wien — bnz-wien.at):**

| Farbe | Hex | Verwendung |
|---|---|---|
| BNZ Grün | `#2C6E49` | Primärfarbe, Buttons, Überschriften |
| BNZ Grün Hell | `#4C9A6F` | Hover-Zustände, Akzente |
| BNZ Grün Blass | `#E8F5EE` | Hintergründe, Tabellen-Zebrastreifen |
| BNZ Dunkel | `#1A2E22` | Seitenüberschriften, Navbar |
| Weiß | `#FFFFFF` | Seitenhintergrund |
| Text | `#1C1C1C` | Fließtext |

```
LOGIN (BNZ Design)       HAUPTSEITE                 ERLEDIGT-DIALOG
┌─────────────────┐      ┌────────────────────────┐  ┌─────────────────┐
│ ████ BNZ Logo   │      │ NOVUM-ZIV  [Abmelden]  │  │ ✓ Erledigt?     │
│  #1A2E22        │      ├────────────────────────┤  │─────────────────│
│─────────────────│      │ GPS ○  Adresse ○        │  │ Grünentorg. 12  │
│ E-Mail:         │      │ Anzahl: [5▼]            │  │ 1200 Wien       │
│ [_____________] │      │ [Liste] [Karte]          │  │                 │
│ Passwort:       │      │ [🔍 Suchen] #2C6E49     │  │ [✅ Unterschrift]│
│ [_____________] │      ├────────────────────────┤  │ [❌ Nicht angetr]│
│                 │      │ 1. Grünentorg.  3 min   │  │ [⏭  Kein Inter.] │
│ [Anmelden]      │      │ 2. Wallenstein. 5 min   │  │                 │
│  Button #2C6E49 │      │ [✅ Übernehmen]          │  │ Notiz:[_______] │
└─────────────────┘      └────────────────────────┘  └─────────────────┘
```

---

## 8 · Kosten & Skalierung

**19 Benutzer:innen · ~2.000 Wiener Adressen · Wahlkampf-Zeitraum**

| Dienst | Limit (kostenlos) | Nutzung | Status |
|---|---|---|---|
| Supabase Auth | 50.000 Nutzer | 19 Nutzer | ✅ |
| Supabase DB | 500 MB · 50k Req/Monat | <5k Req/Monat | ✅ |
| GitHub Pages | Unbegrenzt | Statisch | ✅ |
| OSRM Routing | Fair-Use · kein Key | ~5k Req/Tag | ✅ |
| Leaflet.js + OSM | Fair-Use | 19 Nutzer | ✅ |
| Nominatim (einmalig) | ~1.000/Tag | 2.000 einmalig | ✅ |
| **Gesamtkosten** | | | **$0 / Monat** |

---

## 9 · Projektplan

| Phase | Aufgabe | Aufwand |
|---|---|---|
| **1** | Supabase einrichten · Tabellen · 19 Auth-Konten | 2 Std. |
| **2** | Geokodierung + Daten-Import (Python) | 2–3 Std. |
| **3** | Frontend: BNZ-Design · Login · OSRM-Routing · Erledigt-Dialog | 8–10 Std. |
| **4** | Frontend: Karten-Ansicht mit Routen (Leaflet.js) | 3–4 Std. |
| **5** | Frontend: Archiv · Admin-Auswertung (nur Dr. Romanin) | 2–3 Std. |
| **6** | Test mit allen 19 Benutzer:innen · Abnahme · Go-Live | 2 Std. |
| **Gesamt** | | **~3 Arbeitstage** |

---

## 10 · Nächste Schritte

- [ ] **Adressliste bereitstellen** — Excel/CSV mit den ~2.000 Wiener Adressen
- [ ] **E-Mail-Adressen bestätigen** — echte E-Mails aller 19 Kandidat:innen
- [ ] **Supabase-Konto anlegen** → [supabase.com](https://supabase.com) *(5 Min.)*
- [ ] **Entwicklung freigeben** — Startschuss Phase 1

---

*Planungsdokument · NOVUM-ZIV Unterschriften · BNZ Bündnis NOVUM–ZIV · Wien 2026*  
*Farben: [bnz-wien.at](https://www.bnz-wien.at/) · Stack (geplant): GitHub Pages · Supabase · OSRM · Leaflet.js*
