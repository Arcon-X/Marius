---
layout: default
title: Nächstgelegene Adressen — Systemplanung
---

# Nächstgelegene Adressen — Vollständige Systemplanung

**Datum:** 3. März 2026  
**Erstellt von:** GitHub Copilot  
**Thema:** End-to-End Systemdesign — webbasiertes Adress-Routingtool mit Login, Statusverwaltung und Archivierung

---

## Entscheidungen (alle bestätigt)

| Frage | Entscheidung |
|---|---|
| Login erforderlich? | **Ja** — Benutzer werden vorab vom Admin angelegt |
| Tages-Reset? | **Nein** — nicht benötigt (Erklärung unten) |
| Besuchte Adressen | **Dauerhaft archiviert** — einsehbar, nicht gelöscht |
| Protokollierung | **Ja** — jede Adresse protokolliert Benutzer + Zeitpunkt |
| Notiz bei "Erledigt" | **Ja** — optionales Freitextfeld im Erledigt-Dialog |
| Karten-Ansicht | **Ja** — interaktive Karte mit Pins (Leaflet.js + OpenStreetMap) |

---

## Warum kein Tages-Reset?

Ein automatischer Tages-Reset würde bedeuten, dass bereits erledigte Adressen täglich wieder in den Pool zurückkehren — das widerspricht dem Ziel, Fortschritt dauerhaft zu verfolgen.

Stattdessen gilt:
- Adressen durchlaufen drei Status: `verfügbar` → `in Bearbeitung` → `archiviert`
- `archiviert` ist **dauerhaft** — nur ein Admin kann eine Adresse manuell reaktivieren
- Supervisoren können jederzeit einsehen, wer welche Adressen wann bearbeitet hat

---

## Adress-Status (Lebenszyklus)

```
VERFÜGBAR  ──[Mitarbeiter übernimmt]──►  IN BEARBEITUNG  ──[Mitarbeiter erledigt]──►  ARCHIVIERT
    ▲                                                                                       │
    └───────────────────────────[Admin reaktiviert — Ausnahmefall]───────────────────────── ┘
```

---

## Benutzerablauf (User Flow)

```
1. Mitarbeiter öffnet Webseite (Smartphone oder PC)
         ↓
2. LOGIN:
   [Benutzername / E-Mail]  [Passwort]  [Anmelden]
   (Zugangsdaten werden vom Admin vergeben)
         ↓
3. Standort ermitteln:
   [GPS automatisch] ODER [Adresse manuell eingeben]
         ↓
4. Anzahl wählen: [5]  [10]  [15]
         ↓
5. System liefert sortierte Liste (nur VERFÜGBARE Adressen):
   Rang │ Adresse                       │ Entfernung
    1   │ 1200 Wien, Grünentorgasse 12   │   180 m
    2   │ 1200 Wien, Wallensteinstr. 5   │   340 m
    3   │ 1190 Wien, Heiligenstädter 69  │   610 m
    4   │ 1200 Wien, Dresdner Str. 44    │   820 m
    5   │ 1210 Wien, Floridsdorfer Hstr. │  1,1 km
         ↓
   OPTIONAL: [Karten-Ansicht] — Pins auf OpenStreetMap-Karte
         ↓
6. Dialog: '5 Adressen reservieren?'  [Bestätigen] [Abbrechen]
         ↓
7. Status → IN BEARBEITUNG (für andere Mitarbeiter unsichtbar)
         ↓
8. Mitarbeiter besucht Adresse → klickt [✓ Erledigt markieren]
         ↓
9. Dialog mit optionalem Notizfeld:
   'Adresse als erledigt markieren?'
   Notiz (optional): [________________________________]
   [✓ Erledigt]  [Abbrechen]
         ↓
10. Status → ARCHIVIERT
    Protokoll: Benutzer + Datum + Uhrzeit + Notiz gespeichert
         ↓
11. Neue Abfrage → nächste verfügbare Adressen
```

---

## Architektur

```
FRONTEND  (GitHub Pages — HTML/JS)
  ├── Login-Seite
  ├── Standort + Adresslisten-Suche
  ├── Karten-Ansicht (Leaflet.js + OpenStreetMap-Tiles)
  ├── [✓ Erledigt]-Button mit Notizfeld pro Adresse
  ├── Persönliche Archiv-Ansicht (eigene History + Notizen)
  └── Admin-Seite (Benutzerverwaltung + Auswertungen)
        │
        │ HTTPS + Supabase Auth JWT
        ↓
BACKEND  (Supabase — kostenlos)
  ├── Auth: Login / Benutzer anlegen / deaktivieren
  ├── PostgreSQL + PostGIS (KNN-Abfragen)
  ├── Row Level Security (RLS):
  │     Mitarbeiter sieht nur eigene IN-BEARBEITUNG-Adressen
  └── Protokoll-Tabelle: vollständiges Audit-Log inkl. Notizen
```

### Technologie-Stack

| Schicht | Technologie | Kosten |
|---|---|---|
| Frontend-Hosting | GitHub Pages | Kostenlos |
| Authentifizierung | Supabase Auth (E-Mail + Passwort) | Kostenlos |
| Datenbank | Supabase PostgreSQL + PostGIS | Kostenlos (500 MB) |
| REST API + Sicherheit | Supabase Auto-API + RLS | Kostenlos |
| Geolokalisierung | Browser Geolocation API | Kostenlos |
| Karten-Ansicht | Leaflet.js + OpenStreetMap-Tiles | Kostenlos |
| Geokodierung (einmalig) | Nominatim (OpenStreetMap) | Kostenlos |
| Admin-Panel | Supabase Studio (eingebaut) | Kostenlos |
| **Gesamtkosten** | | **$0 / Monat** |

---

## Datenbankstruktur

### Tabelle: `benutzer` (Supabase Auth)

| Spalte | Typ | Beschreibung |
|---|---|---|
| `id` | UUID | Eindeutige Benutzer-ID |
| `email` | TEXT | Login-E-Mail |
| `name` | TEXT | Anzeigename (z. B. "Maria K.") |
| `aktiv` | BOOLEAN | `false` = deaktiviert |
| `erstellt_am` | TIMESTAMP | Datum der Kontoerstellung |

### Tabelle: `adressen`

| Spalte | Typ | Beschreibung |
|---|---|---|
| `id` | UUID | Eindeutige ID |
| `plz` | TEXT | Postleitzahl |
| `ort` | TEXT | Stadt |
| `strasse` | TEXT | Straße + Hausnummer |
| `lat` | FLOAT | GPS-Breitengrad |
| `lon` | FLOAT | GPS-Längengrad |
| `standort` | GEOMETRY | PostGIS-Punkt (KNN-Abfragen) |
| `status` | TEXT | `verfuegbar` / `in_bearbeitung` / `archiviert` |
| `benutzer_id` | UUID | Wer hat diese Adresse übernommen/erledigt |
| `uebernommen_am` | TIMESTAMP | Zeitpunkt der Übernahme |
| `erledigt_am` | TIMESTAMP | Zeitpunkt der Archivierung |

### Tabelle: `protokoll` (vollständiges Audit-Log)

| Spalte | Typ | Beschreibung |
|---|---|---|
| `id` | UUID | Log-Eintrag ID |
| `adressen_id` | UUID | Verknüpfte Adresse |
| `benutzer_id` | UUID | Benutzer der Aktion |
| `aktion` | TEXT | `uebernommen` / `erledigt` / `reaktiviert` |
| `zeitpunkt` | TIMESTAMP | Wann |
| `notiz` | TEXT | Optionale Bemerkung des Mitarbeiters |

---

## SQL-Beispiele

### KNN — nächste 5 verfügbare Adressen

```sql
SELECT id, plz, ort, strasse, lat, lon,
       ST_Distance(standort, ST_MakePoint(16.3738, 48.2082)) AS entfernung_m
FROM adressen
WHERE status = 'verfuegbar'
ORDER BY standort <-> ST_MakePoint(16.3738, 48.2082)
LIMIT 5;
```

### Adresse als erledigt archivieren (mit Notiz)

```sql
UPDATE adressen
SET status = 'archiviert', erledigt_am = NOW()
WHERE id = 'ADRESS-UUID' AND benutzer_id = auth.uid();

INSERT INTO protokoll (adressen_id, benutzer_id, aktion, zeitpunkt, notiz)
VALUES ('ADRESS-UUID', auth.uid(), 'erledigt', NOW(), 'Niemand angetroffen — Zettel hinterlassen');
```

### Admin-Auswertung: Wer hat was erledigt?

```sql
SELECT b.name, COUNT(*) AS erledigt, DATE(p.zeitpunkt) AS datum
FROM protokoll p
JOIN benutzer b ON b.id = p.benutzer_id
WHERE p.aktion = 'erledigt'
GROUP BY b.name, DATE(p.zeitpunkt)
ORDER BY datum DESC, erledigt DESC;
```

---

## Frontend — Seitenaufbau

### Login
```
+----------------------------------------+
|  Adress-Routing Tool                   |
|  ─────────────────────────────────     |
|  E-Mail:    [_______________________]  |
|  Passwort:  [_______________________]  |
|                                        |
|  [Anmelden]                            |
+----------------------------------------+
```

### Hauptseite — Listenansicht
```
+----------------------------------------+
|  Hallo, Maria K.          [Abmelden]   |
+----------------------------------------+
|  Standort: [GPS] ODER [Adresse]        |
|  Anzahl:   [5 ▼]                       |
|  [Liste]  [Karte]                      |
|  [Nächste Adressen suchen]             |
+----------------------------------------+
|  Pool: 1.673 Adressen verfügbar        |
|  ───────────────────────────────────   |
|  1.  Grünentorgasse 12, 1200 Wien      |
|      180 m                             |
|  2.  Wallensteinstraße 5, 1200 Wien    |
|      340 m                             |
|  3.  Heiligenstädter Str. 69, 1190 W.  |
|      610 m                             |
|                                        |
|  [✅ Adressen übernehmen]              |
+----------------------------------------+
```

### Hauptseite — Karten-Ansicht (Leaflet.js)
```
+----------------------------------------+
|  Hallo, Maria K.          [Abmelden]   |
+----------------------------------------+
|  Standort: [GPS] ODER [Adresse]        |
|  Anzahl:   [5 ▼]    [Liste]  [Karte]  |
+----------------------------------------+
|  ┌──────────────────────────────────┐  |
|  │  🔵 (Ich — mein Standort)        │  |
|  │                                  │  |
|  │  📍1  180m                       │  |
|  │  📍2  340m    📍3  610m          │  |
|  │                  📍4  820m       │  |
|  │         📍5  1,1km               │  |
|  │  [OpenStreetMap]                 │  |
|  └──────────────────────────────────┘  |
|                                        |
|  [✅ Adressen übernehmen]              |
+----------------------------------------+
  Klick auf Pin → Adresse + Entfernung
```

### Erledigt-Dialog (mit optionaler Notiz)
```
+----------------------------------------+
|  ✓ Adresse erledigt markieren?         |
|  ─────────────────────────────────     |
|  Grünentorgasse 12, 1200 Wien          |
|                                        |
|  Notiz (optional):                     |
|  [________________________________]    |
|  z. B. "Nicht angetroffen"             |
|                                        |
|  [✓ Erledigt]     [Abbrechen]          |
+----------------------------------------+
```

### Meine aktiven Adressen
```
+----------------------------------------+
|  Meine Adressen (in Bearbeitung: 3)    |
|  ───────────────────────────────────   |
|  📍 Grünentorgasse 12, 1200 Wien       |
|     Übernommen: 08:32                  |
|     [✓ Erledigt markieren]             |
|  ───────────────────────────────────   |
|  📍 Wallensteinstraße 5, 1200 Wien     |
|     Übernommen: 08:32                  |
|     [✓ Erledigt markieren]             |
+----------------------------------------+
```

### Meine erledigten Adressen (Archiv)
```
+--------------------------------------------------+
|  Meine erledigten Adressen                       |
|  ───────────────────────────────────             |
|  ✅ Grünentorgasse 12    03.03. 10:15            |
|     Notiz: (keine)                               |
|  ✅ Meidlinger Hauptstr. 02.03. 14:42            |
|     Notiz: "Nicht angetroffen — Zettel"          |
|  ✅ Thaliastraße 99      01.03. 09:08            |
|     Notiz: "Einwurf verweigert"                  |
+--------------------------------------------------+
```

---

## Einmaliger Setup-Prozess

```
Schritt 1: Supabase-Konto anlegen → supabase.com (kostenlos, 5 Min.)
           ↓
Schritt 2: Datenbank-Tabellen erstellen (SQL-Skript wird bereitgestellt)
           ↓
Schritt 3: Python-Skript ausführen:
           - Excel/CSV einlesen
           - Adressen geokodieren via Nominatim (~33 Min.)
           - Koordinaten in Supabase importieren
           ↓
Schritt 4: Mitarbeiter-Konten anlegen (Name + E-Mail pro Person)
           ↓
Schritt 5: Frontend deployen auf GitHub Pages
           ↓
Schritt 6: Test mit echten Benutzern + Abnahme
           ↓
           System läuft — kein weiterer Wartungsaufwand
```

---

## Skalierung: 10 Mitarbeiter, Tagesbetrieb

| Kennzahl | Wert |
|---|---|
| Mitarbeiter | 10 |
| Adressen im Pool | 2.000 |
| Besuche/Mitarbeiter/Tag | ~15 |
| Abfragen/Tag gesamt | ~40 |
| Abdeckung/Tag | ~150 Adressen |
| Pool leer nach | ~13–14 Arbeitstage |

| Dienst | Limit (kostenlos) | Unsere Nutzung | OK? |
|---|---|---|---|
| Supabase Auth | 50.000 Nutzer | 10 Nutzer | ✅ |
| Supabase DB | 500 MB, 50k Anfragen/Monat | <1k Anfragen/Monat | ✅ |
| GitHub Pages | Unbegrenzt | Statisch | ✅ |
| OpenStreetMap-Tiles | Fair-Use | Wenige Nutzer | ✅ |
| Nominatim | ~1.000/Tag | 2.000 einmalig | ✅ |
| **Gesamt** | | | **$0/Monat** |

---

## Projektplan

| Phase | Aufgabe | Aufwand |
|---|---|---|
| 1 | Supabase + Tabellen + Auth einrichten | 2 Std. |
| 2 | Geokodierung + DB-Import (Python) | 2–3 Std. |
| 3 | Frontend: Login + Suche + Erledigt + Notiz | 6–8 Std. |
| 4 | Frontend: Karten-Ansicht (Leaflet.js) | 3–4 Std. |
| 5 | Frontend: Archiv + Admin-Auswertung | 2–3 Std. |
| 6 | Test + Abnahme | 1–2 Std. |
| **Gesamt** | | **~2,5 Arbeitstage** |

---

## Nächste Schritte

- [ ] Supabase-Konto anlegen: https://supabase.com
- [ ] Mitarbeiterliste bereitstellen (Name + E-Mail aller Benutzer)
- [ ] Excel/CSV mit den 2.000 Adressen bereitstellen
- [ ] Entwicklung starten (Phase 1 → Supabase Setup)
