---
layout: default
title: NOVUM-ZIV Unterschriften — Planungsdokument
---

<style>
:root {
  --bnz-gruen:      #2C6E49;
  --bnz-gruen-hell: #4C9A6F;
  --bnz-gruen-blass:#E8F5EE;
  --bnz-dunkel:     #1A2E22;
  --bnz-grau:       #F5F5F5;
  --bnz-text:       #1C1C1C;
  --bnz-weiss:      #FFFFFF;
  --bnz-warn:       #FFF8E1;
  --bnz-warn-rand:  #F9A825;
}
body { font-family: 'Segoe UI', Arial, sans-serif; color: var(--bnz-text); max-width: 900px; margin: 0 auto; padding: 1rem 1.5rem; }
h1   { color: var(--bnz-dunkel); border-bottom: 4px solid var(--bnz-gruen); padding-bottom: .3em; }
h2   { color: var(--bnz-gruen); border-left: 5px solid var(--bnz-gruen); padding-left: .6em; margin-top: 2em; }
h3   { color: var(--bnz-dunkel); margin-top: 1em; }
table { width:100%; border-collapse: collapse; margin: .5em 0; font-size: .93em; }
th    { background: var(--bnz-gruen); color: var(--bnz-weiss); padding: .45em .8em; text-align:left; }
td    { padding: .35em .8em; border-bottom: 1px solid #ddd; }
tr:nth-child(even) td { background: var(--bnz-grau); }
blockquote { border-left: 4px solid var(--bnz-gruen-hell); background: var(--bnz-gruen-blass); padding: .7em 1.2em; border-radius: 4px; margin: .5em 0; }
code  { background: var(--bnz-grau); padding: .1em .3em; border-radius: 3px; font-size: .9em; }
pre   { background: var(--bnz-grau); border-left: 3px solid var(--bnz-gruen); padding: .8em 1em; overflow-x: auto; font-size: .88em; border-radius: 0 4px 4px 0; }
.warn { border-left: 4px solid var(--bnz-warn-rand); background: var(--bnz-warn); padding: .7em 1.2em; border-radius: 4px; margin: .8em 0; }
details { border: 1px solid #b8d8c8; border-radius: 6px; margin: .5em 0; }
details[open] { border-color: var(--bnz-gruen-hell); }
details > div { padding: .5em 1.2em 1em 1.2em; }
summary { padding: .65em 1em; cursor: pointer; font-weight: 600; color: var(--bnz-dunkel);
  background: var(--bnz-gruen-blass); border-radius: 6px; user-select: none; }
details[open] > summary { border-radius: 6px 6px 0 0; border-bottom: 1px solid #b8d8c8; }
.badge-plan  { background:#E8F5EE; color:#2C6E49; border:1px solid #4C9A6F; border-radius:4px; padding:.1em .5em; font-size:.85em; font-weight:normal; }
.badge-offen { background:#FFF8E1; color:#8a6000; border:1px solid #F9A825; border-radius:4px; padding:.1em .5em; font-size:.85em; font-weight:normal; }
</style>

# 📋 NOVUM-ZIV Unterschriften
**Stand:** 3. März 2026 · **Phase:** Planung · **Org:** [BNZ Bündnis NOVUM–ZIV](https://www.bnz-wien.at/) · Zahnärztekammerwahl Wien 2026

> ⚠️ **Planungsdokument** — noch kein Code, keine Live-Umgebung. Alle Angaben sind Entwürfe zur internen Abstimmung.

---

## Schnellübersicht

| Bereich | Stand |
|---|---|
| Distanz-Methode | ✅ Echte Gehstrecke (OSRM) |
| Hosting / Datenbank | ✅ Hetzner CX22, Deutschland, EU-DSGVO |
| Login | ✅ Ja — Admin legt 19 Konten an |
| Tages-Reset | ❌ Nein — Fortschritt dauerhaft |
| Karten-Ansicht | ✅ Leaflet.js + OpenStreetMap |
| Protokollierung | ✅ Audit-Log mit Notizfeld |
| DSGVO | <span class="badge-offen">⚠️ zu besprechen</span> Option B / C |
| Gesamtkosten | **€ 3,79 / Monat** |
| Projektdauer (Schätzung) | ~3 Arbeitstage |

---

## 1 · Ziel & Kontext

> Kandidat:innen finden mit einem Klick die **N nächstgelegenen freien Adressen** aus ~2.000 Wiener Wahlberechtigten — sortiert nach echter Gehzeit — und protokollieren Unterschriften dauerhaft mit Namensangabe. Doppelbesuche werden automatisch verhindert.

---

## 2 · Entscheidungen

<details open>
<summary>📋 Alle bestätigten Entscheidungen</summary>
<div markdown="1">

| Frage | Entscheidung | Begründung |
|---|---|---|
| Distanz-Art | ✅ Echte Gehstrecke (OSRM) | Relevanter als Luftlinie |
| Hosting / Datenbank | ✅ Option B — Hetzner (EU) | DSGVO-sicher, kein US-Dienst |
| Login? | ✅ Ja — Admin legt Benutzer an | Zuordnung Besuche → Person |
| Tages-Reset? | ❌ Nein | Fortschritt soll dauerhaft bleiben |
| Archivierung | ✅ Permanent | Besuchte Adressen bleiben archiviert |
| Notiz bei Erledigt | ✅ Ja — optionales Freitextfeld | Z. B. „Unterschrift erhalten" |
| Karten-Ansicht | ✅ Ja — Leaflet.js + OSM | Kostenlos, kein API-Key |
| Protokollierung | ✅ Ja — Audit-Log | Wer, wann, Ergebnis |

</div>
</details>

---

## 3 · Datenschutz & Hosting <span class="badge-offen">⚠️ zu besprechen</span>

<div class="warn">⚠️ Die App verarbeitet personenbezogene Daten (Adressen, Logins, Besuchsprotokolle). Hosting-Entscheidung bitte vor Entwicklungsstart bestätigen.</div>

<details>
<summary>✅ Option B — Eigener Server (Hetzner) <span class="badge-plan">geplant</span></summary>
<div markdown="1">

Datenbank auf selbst gemietem EU-Server — kein US-Dienst, kein Drittanbieter hat Datenzugriff.

| Kriterium | Detail |
|---|---|
| Unternehmen | Hetzner Online GmbH — deutsches Unternehmen |
| Serverstandort | Nürnberg / Falkenstein (Deutschland) · EU |
| US-Bezug | ❌ Keiner |
| Preis | ab **€ 3,79 / Monat** (CX22 — 2 vCPU, 4 GB RAM) |
| PostgreSQL + PostGIS | ✅ Einfach installierbar |
| AVV (DSGVO-Pflicht) | ✅ Auf Anfrage verfügbar |
| Kündigung | Monatlich — nach Wahl löschen, Daten weg |

> **Alternativ (100 % österreichisch):** [anexia.com](https://www.anexia.com/de/) — Wien, ~€ 20/Mt.

```
Hetzner CX22 (€ 3,79/Mt.)
  └── Ubuntu 24.04
        ├── PostgreSQL 16 + PostGIS 3
        └── PostgREST (REST-API, kostenlos)
```

</div>
</details>

<details>
<summary>❓ Option C — Keine personenbezogenen Daten in der Cloud <span class="badge-offen">zu besprechen</span></summary>
<div markdown="1">

Nur anonymisierte Adress-IDs in der Datenbank — keine Namen der Wahlberechtigten.

| Vorteil | Nachteil |
|---|---|
| Stark reduziertes DSGVO-Risiko | Weniger nützliche Auswertungen |
| Auch mit Supabase (US) denkbar | Admin muss IDs manuell zuordnen |

> **Zu klären:** Enthält die Adressliste der Zahnärztekammer Namen, oder nur Adressen? Falls nur Adressen → Option C kaum nötig.

</div>
</details>

---

## 4 · Benutzerliste

<details>
<summary>👥 Alle 19 Kandidat:innen — 1 Admin + 18 Mitarbeiter:innen</summary>
<div markdown="1">

| # | Name | Funktion | Rolle | E-Mail (Platzhalter) |
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
| 17 | Drin Lama Hamisch MSc | Referat Vergemeinschaftungsformen | Mitarbeiter | lama.hamisch@bnz-wien.at |
| 18 | Dr. Otis Rezegh | Referat Vergemeins. (Sukzessor) | Mitarbeiter | otis.rezegh@bnz-wien.at |
| 19 | Drin Selma Husejnovic | Kommunikation / Öffentlichkeit | Mitarbeiter | selma.husejnovic@bnz-wien.at |

> ⚠️ E-Mail-Adressen sind Platzhalter — echte Adressen vor Setup eintragen.

</div>
</details>

---

## 5 · Benutzerablauf

<details>
<summary>🔄 Vollständigen Ablauf anzeigen</summary>
<div markdown="1">

```
START → LOGIN → STANDORT → ANZAHL → ROUTING → LISTE/KARTE → RESERVIEREN → BESUCHEN → ERLEDIGEN
```

```
  ┌──────────┐
  │  START   │  Kandidat:in öffnet Webseite (Smartphone / PC)
  └────┬─────┘
       ▼
  ┌──────────────────────────────┐
  │  🔐 LOGIN                    │  E-Mail + Passwort (vom Admin vergeben)
  └────────────┬─────────────────┘
               ▼
  ┌──────────────────────────────┐
  │  📍 STANDORT ERMITTELN       │  [GPS] ODER [Adresse eingeben]
  └────────────┬─────────────────┘
               ▼
  ┌──────────────────────────────┐
  │  🔢 ANZAHL WÄHLEN            │  [5]  [10]  [15]
  └────────────┬─────────────────┘
               ▼
  ┌──────────────────────────────────────────────────────┐
  │  ⚙️  ROUTING (automatisch im Hintergrund)             │
  │  1. Server: 50 räumlich nächste Adressen             │
  │  2. OSRM:   echte Gehzeit für jede Adresse           │
  │  3. Sortierung nach Gehminuten                       │
  └────────────┬─────────────────────────────────────────┘
               ▼
  ┌──────────────────────────────────────────────────────┐
  │  📋 ERGEBNISLISTE  /  🗺️ KARTE                        │
  │  1.  Grünentorgasse 12   3 min  (220 m)              │
  │  2.  Wallensteinstr. 5   5 min  (390 m)              │
  │  Pool: X Adressen noch verfügbar                     │
  └────────────┬─────────────────────────────────────────┘
               ▼
  ┌──────────────────────────────┐
  │  💬 RESERVIEREN              │  → Status: IN BEARBEITUNG
  │  [✅ Bestätigen] [Abbrechen]  │
  └────────────┬─────────────────┘
               │  (Adresse besuchen)
               ▼
  ┌──────────────────────────────┐
  │  ✓ ERLEDIGT                  │
  │  [✅ Unterschrift erhalten]   │
  │  [❌ Nicht angetroffen]       │  → ARCHIVIERT + Protokoll
  │  [⏭️  Nicht interessiert]     │
  │  Notiz (optional): [_______] │
  └──────────────────────────────┘
```

**Status-Lebenszyklus:**

```
  VERFÜGBAR ──[übernommen]──► IN BEARBEITUNG ──[erledigt]──► ARCHIVIERT
     ▲                                                            │
     └──────────────── Admin reaktiviert (Ausnahmefall) ──────────┘
```

</div>
</details>

---

## 6 · Systemarchitektur

<details>
<summary>🏗️ Architekturdiagramm anzeigen</summary>
<div markdown="1">

```
  ┌──────────────────────────────────────────────────────┐
  │  FRONTEND — GitHub Pages (kostenlos)                 │
  │  HTML / CSS (BNZ Grün #2C6E49) / JavaScript          │
  │  Login · Suche · Liste · Karte · Archiv · Admin      │
  └──────────┬───────────────────────────────────────────┘
             │ HTTPS + JWT                │ OSRM (kostenlos)
             ▼                            ▼
  ┌──────────────────────┐   ┌────────────────────────────┐
  │  Hetzner CX22 (EU)   │   │  router.project-osrm.org   │
  │  € 3,79/Monat        │   │  Fußgänger-Routing Wien    │
  │  PostgreSQL + PostGIS│   │  → Gehminuten + Meter      │
  │  PostgREST (API)     │   └────────────────────────────┘
  │  JWT-Auth            │
  └──────────────────────┘
       EU-DSGVO-konform · kein US-Dienst
```

</div>
</details>

---

## 7 · Datenbank & Routing

<details>
<summary>🗄️ Tabellenstruktur + SQL-Beispiele anzeigen</summary>
<div markdown="1">

### Tabelle `adressen`

| Spalte | Typ | Beschreibung |
|---|---|---|
| `id` | UUID | Eindeutige ID |
| `plz`, `ort`, `strasse` | TEXT | Adresse |
| `lat`, `lon` | FLOAT | GPS-Koordinaten |
| `standort` | GEOMETRY | PostGIS-Punkt (Vorfilter) |
| `status` | TEXT | `verfuegbar` / `in_bearbeitung` / `archiviert` |
| `benutzer_id` | UUID | Zuständige Person |
| `erledigt_am` | TIMESTAMP | Zeitpunkt |

### Tabelle `protokoll`

| Spalte | Typ | Beschreibung |
|---|---|---|
| `adressen_id` | UUID | Verknüpfte Adresse |
| `benutzer_id` | UUID | Wer |
| `aktion` | TEXT | `unterschrift` / `nicht_angetroffen` / `nicht_interessiert` |
| `zeitpunkt` | TIMESTAMP | Wann |
| `notiz` | TEXT | Optionale Bemerkung |

### Vorfilter SQL

```sql
SELECT id, strasse, plz, lat, lon
FROM adressen WHERE status = 'verfuegbar'
ORDER BY standort <-> ST_MakePoint(:lon, :lat) LIMIT 50;
```

### OSRM-Abfrage (JavaScript)

```javascript
const r = await fetch(
  `https://router.project-osrm.org/route/v1/foot/${meinLon},${meinLat};${a.lon},${a.lat}?overview=false`
);
const { duration, distance } = (await r.json()).routes[0];
// Sortieren nach duration (Sekunden), Top N anzeigen
```

</div>
</details>

---

## 8 · Frontend-Mockups & Farbschema

<details>
<summary>🎨 Farbpalette + Screen-Mockups anzeigen</summary>
<div markdown="1">

### BNZ Farbpalette (von bnz-wien.at)

| Farbe | Hex | Verwendung |
|---|---|---|
| BNZ Grün | `#2C6E49` | Buttons, Überschriften, Tabellen-Header |
| BNZ Grün Hell | `#4C9A6F` | Hover, Akzente |
| BNZ Grün Blass | `#E8F5EE` | Hintergründe, Zebrastreifen |
| BNZ Dunkel | `#1A2E22` | Navbar, Seitenüberschriften |

### Screen-Mockups

```
LOGIN                    HAUPTSEITE                 ERLEDIGT-DIALOG
┌─────────────────┐      ┌──────────────────────┐   ┌─────────────────┐
│ BNZ Logo        │      │ NOVUM-ZIV [Abmelden] │   │ ✓ Erledigt?     │
│─────────────────│      ├──────────────────────┤   │─────────────────│
│ E-Mail:         │      │ GPS ○  Adresse ○      │   │ Grünentorg. 12  │
│ [_____________] │      │ Anzahl: [5▼]          │   │─────────────────│
│ Passwort:       │      │ [Liste] [Karte]        │   │[✅ Unterschrift] │
│ [_____________] │      │ [🔍 Suchen]            │   │[❌ Nicht angetr.]│
│                 │      ├──────────────────────┤   │[⏭  Kein Inter.] │
│ [  Anmelden  ]  │      │ 1. Grünentorg.  3min  │   │                 │
│   #2C6E49       │      │ 2. Wallenstein. 5min  │   │ Notiz:[_______] │
└─────────────────┘      │ [✅ Übernehmen]        │   └─────────────────┘
                         └──────────────────────┘
```

</div>
</details>

---

## 9 · Kosten & Skalierung

<details>
<summary>💰 Kostenübersicht — Gesamt: €3,79 / Monat</summary>
<div markdown="1">

**19 Benutzer:innen · ~2.000 Adressen · Wahlkampf-Zeitraum**

| Dienst | Kosten | Anmerkung |
|---|---|---|
| Hetzner CX22 (Server + DB) | **€ 3,79 / Monat** | Nach Wahl löschen |
| GitHub Pages (Frontend) | € 0 | Kostenlos |
| OSRM (Routing) | € 0 | Open Source |
| Leaflet.js + OSM | € 0 | Open Source |
| Nominatim (Geokodierung, einmalig) | € 0 | 2.000 Adressen einmalig |
| **Gesamt** | **€ 3,79 / Monat** | Bei 2 Monaten: **€ 7,58 gesamt** |

</div>
</details>

---

## 10 · Projektplan

<details>
<summary>📅 Alle Phasen — Schätzung ~3 Arbeitstage</summary>
<div markdown="1">

| Phase | Aufgabe | Aufwand |
|---|---|---|
| **0** | DSGVO-Entscheidung finalisieren (Option B / C) | Besprechung |
| **1** | Hetzner-Server · PostgreSQL + PostGIS | 2–3 Std. |
| **2** | Auth-System · 19 Konten anlegen | 2 Std. |
| **3** | Geokodierung + Daten-Import (Python) | 2–3 Std. |
| **4** | Frontend: Login · Routing · Erledigt-Dialog | 8–10 Std. |
| **5** | Frontend: Karten-Ansicht (Leaflet.js) | 3–4 Std. |
| **6** | Frontend: Archiv · Admin-Auswertung | 2–3 Std. |
| **7** | Test · Go-Live | 2 Std. |
| **8** | Nach Wahl: Server löschen, Daten vernichten | 30 Min. |
| **Gesamt** | | **~3–3,5 Arbeitstage** |

</div>
</details>

---

## 11 · Nächste Schritte

- [ ] <span class="badge-offen">zu besprechen</span> **DSGVO** — Option B (Hetzner) oder Option C bestätigen
- [ ] **Adressliste** bereitstellen — Excel/CSV mit ~2.000 Wiener Adressen
- [ ] **E-Mail-Adressen** aller 19 Kandidat:innen bestätigen
- [ ] **Hetzner-Konto anlegen** → [hetzner.com/cloud](https://www.hetzner.com/cloud)
- [ ] **Entwicklung freigeben** — Startschuss Phase 1

---

*Planungsdokument · NOVUM-ZIV Unterschriften · BNZ Bündnis NOVUM–ZIV · Wien 2026*  
*Stack (geplant): GitHub Pages · Hetzner · PostgreSQL · OSRM · Leaflet.js*
