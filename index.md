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
.warn { border-left: 4px solid var(--bnz-warn-rand); background: var(--bnz-warn); padding: .8em 1.2em; border-radius: 4px; margin: 1em 0; }
.plan { border-left: 4px solid var(--bnz-gruen); background: var(--bnz-gruen-blass); padding: .8em 1.2em; border-radius: 4px; margin: 1em 0; }
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
| 3 | [Datenschutz & Hosting — zu besprechen](#3-datenschutz--hosting--zu-besprechen) |
| 4 | [Geplante Benutzerliste](#4-geplante-benutzerliste) |
| 5 | [Benutzerablauf](#5-benutzerablauf) |
| 6 | [Systemarchitektur](#6-systemarchitektur) |
| 7 | [Datenbank & Routing-Logik](#7-datenbank--routing-logik) |
| 8 | [Frontend-Ansichten & Farbschema](#8-frontend-ansichten--farbschema) |
| 9 | [Kosten & Skalierung](#9-kosten--skalierung) |
| 10 | [Projektplan](#10-projektplan) |
| 11 | [Nächste Schritte](#11-nächste-schritte) |

---

## 1 · Ziel & Kontext

> Mitarbeiter:innen des BNZ Bündnisses finden mit einem Klick die **N nächstgelegenen
> freien Adressen** aus einem Pool von ~2.000 Wiener Wahlberechtigten — sortiert nach
> **echter Gehzeit** — und protokollieren Unterschriften dauerhaft mit Namensangabe.

**Anlass:** Zahnärztekammerwahl Wien 2026  
**Bündnis:** NOVUM–ZIV  
**Aufgabe der App:** Hausbesuche koordinieren, Fortschritt tracken, Doppelbesuche vermeiden.

---

## 2 · Entscheidungen

| Frage | Entscheidung | Begründung |
|---|---|---|
| Distanz-Art | ✅ Echte Gehstrecke (OSRM) | Relevanter als Luftlinie |
| Hosting / Datenbank | ✅ Option B — eigener Server (Hetzner) | DSGVO-sicher, kein US-Dienst |
| Login? | ✅ Ja — Admin legt Benutzer an | Zuordnung Besuche → Person |
| Tages-Reset? | ❌ Nein | Fortschritt soll dauerhaft bleiben |
| Archivierung | ✅ Permanent | Besuchte Adressen bleiben archiviert |
| Notiz bei Erledigt | ✅ Ja — optionales Freitextfeld | Z. B. „Unterschrift erhalten" |
| Karten-Ansicht | ✅ Ja — Leaflet.js + OSM | Kostenlos, kein API-Key |
| Protokollierung | ✅ Ja — Audit-Log | Wer, wann, Ergebnis |

---

## 3 · Datenschutz & Hosting — zu besprechen

<div class="warn">
⚠️ <strong>Zu besprechen</strong> — Die App verarbeitet personenbezogene Daten (Adressen von Wahlberechtigten, Mitarbeiter-Logins, Besuchsprotokolle). Die Hosting-Entscheidung hat rechtliche Konsequenzen (DSGVO). Bitte vor Entwicklungsstart klären.
</div>

### Was ist datenschutzrelevant?

| Datenkategorie | Konkret | DSGVO? |
|---|---|---|
| Adressen der Wahlberechtigten | Name + Adresse aus Mitgliederliste | ⚠️ Ja — Zweckbindung beachten |
| Mitarbeiter-Logins | E-Mail + Passwort | ✅ Ja |
| Besuchsprotokolle | Wer war wann wo, Ergebnis | ✅ Ja |

Nach der Wahl müssen **alle** personenbezogenen Daten gelöscht und der Server abgeschaltet werden.

---

### ❓ Option B — Eigener Server (EU) · **geplant**

Datenbank läuft auf einem **selbst gemieteten Server** in der EU — kein US-Dienst, kein Drittanbieter hat Zugriff auf die Daten.

**Empfohlener Anbieter: Hetzner Cloud**

| Kriterium | Detail |
|---|---|
| Unternehmen | Hetzner Online GmbH — deutsches Unternehmen |
| Serverstandort | Nürnberg / Falkenstein (Deutschland) · EU-DSGVO |
| US-Bezug | ❌ Keiner — rein europäisches Unternehmen |
| Preis | ab **€ 3,79 / Monat** (CX22 — 2 vCPU, 4 GB RAM) |
| PostgreSQL + PostGIS | ✅ Einfach installierbar |
| Vertrag / DPA | ✅ Auftragsverarbeitungsvertrag (AVV) auf Anfrage |
| Kündigung | Monatlich · nach der Wahl einfach löschen |

> **Alternativ (100 % österreichisch):** [anexia](https://www.anexia.com/de/) — Wiener Unternehmen, Rechenzentrum Wien, teurer (~€ 20/Monat), aber maximale DSGVO-Sicherheit. Sinnvoll wenn die Zahnärztekammer darauf besteht.

**Was auf dem Server läuft:**
```
Hetzner CX22 (€ 3,79/Mt.)
  └── Ubuntu 24.04 LTS
        ├── PostgreSQL 16 + PostGIS 3
        │     ├── Tabelle: adressen (2.000 Zeilen)
        │     └── Tabelle: protokoll (Audit-Log)
        └── PostgREST (REST-API, kostenlos)
              → Verbindung vom Frontend per HTTPS
```

---

### ❓ Option C — Keine personenbezogenen Daten in der Cloud · zu besprechen

Nur **anonymisierte Adress-IDs** werden in der Datenbank gespeichert — keine Namen, keine Vor-/Nachnamen der Wahlberechtigten.

| Vorteil | Nachteil |
|---|---|
| Stark reduziertes DSGVO-Risiko | Weniger nützliche Auswertungen |
| Auch mit Supabase (US-Dienst) denkbar | Admin muss IDs manuell zuordnen |
| Einfacherer Datenschutz-Nachweis | Notizen können keine Namen enthalten |

> Zu klären: Enthält die Adressliste der Zahnärztekammer Namen der Mitglieder, oder nur Adressen? Falls nur Adressen → Option C kaum nötig, da ohnehin keine Namen verarbeitet werden.

---

## 4 · Geplante Benutzerliste

**Admin:** Dr. Marius Romanin · **Mitarbeiter:innen:** alle 18 weiteren Kandidat:innen

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
| 17 | Drin Lama Hamisch MSc | Referat Vergemeinschaftungsformen | Mitarbeiter | lama.hamisch@bnz-wien.at |
| 18 | Dr. Otis Rezegh | Referat Vergemeins. (Sukzessor) | Mitarbeiter | otis.rezegh@bnz-wien.at |
| 19 | Drin Selma Husejnovic | Kommunikation / Öffentlichkeit | Mitarbeiter | selma.husejnovic@bnz-wien.at |

> ⚠️ E-Mail-Adressen sind Platzhalter — echte Adressen vor Setup eintragen.

---

## 5 · Benutzerablauf

```
┌─────────────────────────────────────────────────────────────────────┐
│            NOVUM-ZIV Unterschriften — Benutzerablauf                │
└─────────────────────────────────────────────────────────────────────┘

  ┌──────────┐
  │  START   │  Kandidat:in öffnet Webseite (Smartphone / PC)
  └────┬─────┘
       ▼
  ┌──────────────────────────────┐
  │  🔐 LOGIN                    │  E-Mail + Passwort (vom Admin vergeben)
  └────────────┬─────────────────┘
               ▼
  ┌──────────────────────────────┐
  │  📍 STANDORT ERMITTELN       │  [GPS automatisch] ODER [Adresse eingeben]
  └────────────┬─────────────────┘
               ▼
  ┌──────────────────────────────┐
  │  🔢 ANZAHL WÄHLEN            │  [5]  [10]  [15]
  └────────────┬─────────────────┘
               ▼
  ┌──────────────────────────────────────────────────────┐
  │  ⚙️  ROUTING (automatisch im Hintergrund)             │
  │  1. Server: 50 räumlich nächste Adressen (Vorfilter) │
  │  2. OSRM: echte Gehzeit für jede Adresse             │
  │  3. Sortierung nach Gehminuten                       │
  └────────────┬─────────────────────────────────────────┘
               ▼
  ┌──────────────────────────────────────────────────────┐
  │  📋 ERGEBNISLISTE  /  🗺️ KARTEN-ANSICHT              │
  │  1. Grünentorgasse 12, 1200 W.   3 min  (220 m)      │
  │  2. Wallensteinstr. 5, 1200 W.   5 min  (390 m)      │
  │  Pool: X Adressen noch verfügbar                     │
  └────────────┬─────────────────────────────────────────┘
               ▼
  ┌──────────────────────────────┐
  │  💬 RESERVIERUNGS-DIALOG     │  → Status: IN BEARBEITUNG
  │  [✅ Bestätigen] [Abbrechen]  │
  └────────────┬─────────────────┘
               │  (Kandidat:in besucht Adresse)
               ▼
  ┌──────────────────────────────┐
  │  ✓ ERLEDIGT-DIALOG           │
  │  [✅ Unterschrift erhalten]   │  → ARCHIVIERT + Protokoll
  │  [❌ Nicht angetroffen]       │
  │  [⏭️  Nicht interessiert]     │
  │  Notiz (optional): [_______] │
  └────────────┬─────────────────┘
               ▼
       Neue Abfrage starten
```

**Adress-Status:**
```
  VERFÜGBAR ──[übernommen]──► IN BEARBEITUNG ──[erledigt]──► ARCHIVIERT
     ▲                                                            │
     └──────────────── Admin reaktiviert (Ausnahmefall) ──────────┘
```

---

## 6 · Systemarchitektur

**Geplant: Option B — eigener Hetzner-Server (EU)**

```
  ┌──────────────────────────────────────────────────────────────────┐
  │  FRONTEND  —  GitHub Pages (HTML / CSS / JavaScript)             │
  │  Farben: BNZ Grün #2C6E49                                        │
  │  ┌─────────┐  ┌──────────────┐  ┌────────┐  ┌───────────────┐  │
  │  │  Login  │  │  Hauptseite  │  │  Karte │  │  Archiv /     │  │
  │  │  (JWT)  │  │  Gehstrecken │  │  Routen│  │  Admin-View   │  │
  │  └─────────┘  └──────────────┘  └────────┘  └───────────────┘  │
  └──────────┬───────────────────────────────────────────────────────┘
             │ HTTPS + JWT-Auth                  │ OSRM (kostenlos)
             ▼                                   ▼
  ┌──────────────────────────┐        ┌──────────────────────────┐
  │  Hetzner CX22            │        │  router.project-osrm.org │
  │  € 3,79/Monat            │        │  Fußgänger-Routing Wien  │
  │  Standort: Deutschland   │        │  → Minuten + Meter       │
  │                          │        └──────────────────────────┘
  │  PostgreSQL 16           │
  │  + PostGIS 3             │
  │  + PostgREST (API)       │
  │  + Auth (selbst gebaut   │
  │    oder Authelia/JWT)    │
  └──────────────────────────┘
       ↑ EU-DSGVO-konform
       ↑ Kein US-Unternehmen
       ↑ Nur wir haben Zugriff
```

---

## 7 · Datenbank & Routing-Logik

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
| `aktion` | TEXT | `unterschrift` / `nicht_angetroffen` / `nicht_interessiert` |
| `zeitpunkt` | TIMESTAMP | Wann |
| `notiz` | TEXT | Optionale Bemerkung |

**Vorfilter SQL:**
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
```

---

## 8 · Frontend-Ansichten & Farbschema

**Farbpalette (BNZ Wien):**

| Farbe | Hex | Verwendung |
|---|---|---|
| BNZ Grün | `#2C6E49` | Primärfarbe, Buttons, Überschriften |
| BNZ Grün Hell | `#4C9A6F` | Hover, Akzente |
| BNZ Grün Blass | `#E8F5EE` | Hintergründe, Zebrastreifen |
| BNZ Dunkel | `#1A2E22` | Seitenüberschriften, Navbar |
| Weiß | `#FFFFFF` | Seitenhintergrund |

```
LOGIN                    HAUPTSEITE                 ERLEDIGT-DIALOG
┌─────────────────┐      ┌──────────────────────┐   ┌─────────────────┐
│ BNZ Logo        │      │ NOVUM-ZIV [Abmelden] │   │ ✓ Erledigt?     │
│─────────────────│      ├──────────────────────┤   │─────────────────│
│ E-Mail:         │      │ GPS ○  Adresse ○      │   │ Grünentorg. 12  │
│ [_____________] │      │ Anzahl: [5▼]          │   │ 1200 Wien       │
│ Passwort:       │      │ [Liste] [Karte]        │   │                 │
│ [_____________] │      │ [🔍 Suchen]            │   │[✅ Unterschrift] │
│                 │      ├──────────────────────┤   │[❌ Nicht angetr.]│
│ [Anmelden]      │      │ 1. Grünentorg.  3min  │   │[⏭  Kein Inter.] │
│  #2C6E49        │      │ 2. Wallenstein. 5min  │   │                 │
└─────────────────┘      │ [✅ Übernehmen]        │   │ Notiz:[_______] │
                         └──────────────────────┘   └─────────────────┘
```

---

## 9 · Kosten & Skalierung

**19 Benutzer:innen · ~2.000 Wiener Adressen · Wahlkampf-Zeitraum**

| Dienst | Kosten | Anmerkung |
|---|---|---|
| Hetzner CX22 (Server + DB) | **€ 3,79 / Monat** | Nur für Wahlkampf-Dauer, danach löschen |
| GitHub Pages (Frontend) | € 0 | Kostenlos |
| OSRM (Routing) | € 0 | Open Source, kein API-Key |
| Leaflet.js + OSM | € 0 | Open Source |
| Nominatim (Geokodierung, einmalig) | € 0 | 2.000 Adressen einmalig |
| **Gesamt** | **€ 3,79 / Monat** | |

> Bei 2 Monaten Wahlkampf: **€ 7,58 Gesamtkosten.**

---

## 10 · Projektplan

| Phase | Aufgabe | Aufwand |
|---|---|---|
| **0** | DSGVO-Entscheidung finalisieren (Option B / C) | Besprechung |
| **1** | Hetzner-Server mieten · PostgreSQL + PostGIS installieren | 2–3 Std. |
| **2** | Auth-System einrichten (JWT-Login, 19 Konten) | 2 Std. |
| **3** | Geokodierung + Daten-Import (Python) | 2–3 Std. |
| **4** | Frontend: BNZ-Design · Login · OSRM-Routing · Erledigt-Dialog | 8–10 Std. |
| **5** | Frontend: Karten-Ansicht (Leaflet.js) | 3–4 Std. |
| **6** | Frontend: Archiv · Admin-Auswertung | 2–3 Std. |
| **7** | Test mit allen 19 Benutzer:innen · Go-Live | 2 Std. |
| **8** | Nach Wahl: Server löschen, Daten vernichten | 30 Min. |
| **Gesamt** | | **~3–3,5 Arbeitstage** |

---

## 11 · Nächste Schritte

- [ ] **DSGVO-Entscheidung** — Option B (Hetzner) oder Option C besprechen und bestätigen
- [ ] **Adressliste bereitstellen** — Excel/CSV mit den ~2.000 Wiener Adressen
- [ ] **E-Mail-Adressen bestätigen** — echte E-Mails aller 19 Kandidat:innen
- [ ] **Hetzner-Konto anlegen** → [hetzner.com/cloud](https://www.hetzner.com/cloud) *(5 Min.)*
- [ ] **Entwicklung freigeben** — Startschuss Phase 1

---

*Planungsdokument · NOVUM-ZIV Unterschriften · BNZ Bündnis NOVUM–ZIV · Wien 2026*  
*Farben: [bnz-wien.at](https://www.bnz-wien.at/) · Stack (geplant): GitHub Pages · Hetzner · PostgreSQL · OSRM · Leaflet.js*
