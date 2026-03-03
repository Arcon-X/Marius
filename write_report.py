content = """\
---
layout: default
title: Nächstgelegene Adressen — Systemplanung v2
---

# Nächstgelegene Adressen — Vollständige Systemplanung

**Datum:** 3. März 2026  
**Erstellt von:** GitHub Copilot  
**Thema:** End-to-End Systemdesign für ein webbasiertes Adress-Routingtool mit Statusverwaltung

---

## Systemüberblick

Ein Mitarbeiter öffnet eine Webseite, gibt seinen Standort an (GPS oder manuell), wählt die gewünschte Anzahl an Adressen und erhält eine nach Entfernung sortierte Liste. Nach Bestätigung werden die Adressen als belegt markiert und stehen anderen Mitarbeitern nicht mehr zur Verfügung. Am Ende des Tages ist der Pool geleert — eine automatische Rücksetzung erfolgt täglich um Mitternacht.

---

## Benutzerablauf (User Flow)

```
1. Mitarbeiter öffnet Webseite (Smartphone oder PC)
          ↓
2. Standort ermitteln:
   [GPS automatisch] ODER [Adresse manuell eingeben]
          ↓
3. Anzahl gewünschter Adressen wählen (z. B. 5 / 10 / 15)
          ↓
4. System liefert sortierte Liste:
   Rang | Adresse                       | Entfernung
    1   | 1200 Wien, Grünentorgasse 12   |   180 m
    2   | 1200 Wien, Wallensteinstr. 5   |   340 m
    3   | 1190 Wien, Heiligenstädter 69  |   610 m
    4   | 1200 Wien, Dresdner Str. 44    |   820 m
    5   | 1210 Wien, Floridsdorfer Hstr. |  1,1 km
          ↓
5. Mitarbeiter prüft Liste und klickt [Adressen übernehmen]
          ↓
6. Bestätigungsdialog erscheint:
   "Diese 5 Adressen als 'In Bearbeitung' markieren?"
   [Bestätigen]  [Abbrechen]
          ↓
7. Adressen werden sofort als belegt markiert
   (nicht mehr für andere Mitarbeiter sichtbar)
          ↓
8. Mitarbeiter arbeitet die Adressen ab
          ↓
9. Neue Abfrage → nächste verfügbare Adressen
          ↓
10. Um Mitternacht: automatische Rücksetzung aller Adressen
```

---

## Architektur

### Komponenten

```
FRONTEND  (GitHub Pages — statisches HTML/JS)
  - Standortermittlung (GPS / manuelle Eingabe)
  - Auswahl der Anzahl N
  - Anzeige der sortierten Adressliste
  - Bestätigungsdialog
        |
        | REST API (HTTPS)
        ↓
BACKEND  (Supabase — kostenlos)
  - PostgreSQL Datenbank mit PostGIS
  - Automatisch generierte REST API
  - KNN-Abfrage via SQL (ST_Distance + ORDER BY)
  - Echtzeit-Statusverwaltung (belegt/frei)
        |
        | Geplanter Job (täglich 00:00 Uhr)
        ↓
AUTOMATISIERUNG  (GitHub Actions — kostenlos)
  - Cron-Job täglich um Mitternacht
  - Setzt alle Adressen auf "verfügbar" zurück
```

### Technologie-Stack

| Schicht | Technologie | Kosten |
|---|---|---|
| Frontend-Hosting | GitHub Pages | Kostenlos |
| Datenbank | Supabase (PostgreSQL + PostGIS) | Kostenlos (500 MB) |
| REST API | Supabase Auto-API | Kostenlos |
| Geolokalisierung | Browser Geolocation API | Kostenlos |
| Geokodierung (einmalig) | Nominatim (OpenStreetMap) | Kostenlos |
| Tages-Reset | GitHub Actions Cron | Kostenlos |
| **Gesamtkosten** | | **$0 / Monat** |

---

## Datenbankstruktur

### Tabelle: `adressen`

| Spalte | Typ | Beschreibung |
|---|---|---|
| `id` | UUID | Eindeutige ID |
| `plz` | TEXT | Postleitzahl |
| `ort` | TEXT | Stadt |
| `strasse` | TEXT | Straße + Hausnummer |
| `lat` | FLOAT | GPS-Breitengrad |
| `lon` | FLOAT | GPS-Längengrad |
| `standort` | GEOMETRY | PostGIS-Punkt (für KNN-Abfragen) |
| `belegt` | BOOLEAN | `true` = bereits übernommen |
| `belegt_von` | TEXT | Name/ID des Mitarbeiters |
| `belegt_um` | TIMESTAMP | Zeitpunkt der Übernahme |

### KNN-Abfrage (SQL-Beispiel)

```sql
SELECT id, plz, ort, strasse,
       ST_Distance(standort, ST_MakePoint(16.3738, 48.2082)) AS entfernung_m
FROM adressen
WHERE belegt = false
ORDER BY standort <-> ST_MakePoint(16.3738, 48.2082)
LIMIT 5;
```

> `<->` ist der PostGIS KNN-Operator — extrem schnell, auch bei 2.000 Adressen.

---

## Tages-Reset (GitHub Actions)

Jeden Tag um Mitternacht wird automatisch folgender SQL-Befehl ausgeführt:

```sql
UPDATE adressen
SET belegt = false,
    belegt_von = null,
    belegt_um = null;
```

Konfiguration in `.github/workflows/reset.yml`:

```yaml
on:
  schedule:
    - cron: '0 22 * * *'  # 22:00 UTC = 00:00 Wien (MEZ)
```

---

## Frontend — Seitenaufbau

```
+----------------------------------------+
|  Adress-Routing Tool                   |
+----------------------------------------+
|  Mein Standort:                        |
|  [GPS ermitteln]  ODER                 |
|  [Adresse eingeben_________________]   |
|                                        |
|  Anzahl Adressen: [5]                  |
|                                        |
|  [Nächste Adressen suchen]             |
+----------------------------------------+
|  Ergebnisse: (1.850 verbleibend)       |
|  --------------------------------      |
|  1.  Grünentorgasse 12, 1200 Wien      |
|      180 m                             |
|  2.  Wallensteinstraße 5, 1200 Wien    |
|      340 m                             |
|  3.  Heiligenstädter Str. 69, 1190 W.  |
|      610 m                             |
|                                        |
|  [Adressen übernehmen]                 |
+----------------------------------------+
```

### Bestätigungsdialog

```
+-------------------------------------+
|  Adressen übernehmen?               |
|                                     |
|  3 Adressen werden als              |
|  "In Bearbeitung" markiert und      |
|  sind für andere nicht mehr         |
|  sichtbar.                          |
|                                     |
|  [Bestätigen]      [Abbrechen]      |
+-------------------------------------+
```

---

## Einmaliger Setup-Prozess

```
Schritt 1:  Excel/CSV mit 2.000 Adressen bereitstellen
            ↓
Schritt 2:  Python-Skript ausführen:
            - Adressen einlesen
            - Mit Nominatim geokodieren (~33 Min.)
            - Koordinaten in Supabase-Datenbank laden
            ↓
Schritt 3:  GitHub Pages Webseite einrichten (bereits erledigt ✅)
            ↓
Schritt 4:  Supabase-Projekt anlegen (kostenlos, 5 Min.)
            ↓
Schritt 5:  GitHub Actions Cron-Reset konfigurieren
            ↓
            System läuft täglich autonom
```

---

## Skalierungsschätzung: 10 Mitarbeiter, Tagesbetrieb

| Kennzahl | Wert |
|---|---|
| Mitarbeiter | 10 |
| Adressen gesamt | 2.000 |
| Besuche pro Mitarbeiter/Tag | ~15 |
| Abfragen pro Mitarbeiter/Tag | ~4 (morgens + nach jedem Block) |
| Gesamtabfragen/Tag | ~40 |
| Abdeckung pro Tag | ~150 Adressen |
| Tage bis Pool leer | ~13–14 Arbeitstage (~3 Wochen) |

### API-Kosten

| Dienst | Kostenloses Limit | Unsere Nutzung | OK? |
|---|---|---|---|
| Supabase DB | 500 MB, 50.000 Anfragen/Monat | ~880 Anfragen/Monat | ✅ Ja |
| GitHub Pages | Unbegrenzt | Statische Seite | ✅ Ja |
| GitHub Actions | 2.000 Min./Monat | 1 Min./Tag = 31 Min. | ✅ Ja |
| Nominatim | ~1.000 Anfragen/Tag | 2.000 einmalig | ✅ Ja |
| **Gesamt** | | | **$0/Monat** |

---

## Projektplan

| Phase | Aufgabe | Aufwand | Kosten |
|---|---|---|---|
| **1** | Supabase-Projekt anlegen, Tabelle erstellen | 1 Std. | $0 |
| **2** | Python-Skript: Geokodierung + DB-Import | 2–3 Std. | $0 |
| **3** | Frontend HTML/JS entwickeln | 4–6 Std. | $0 |
| **4** | GitHub Actions Cron-Reset einrichten | 30 Min. | $0 |
| **5** | Test mit echten Adressen + Abnahme | 1–2 Std. | $0 |
| **Gesamt** | | **~1–2 Tage** | **$0** |

---

## Offene Fragen / Nächste Schritte

- [ ] Sollen Mitarbeiter sich einloggen (mit Namen/ID) oder anonym arbeiten?
- [ ] Soll der Tages-Reset täglich automatisch erfolgen, oder manuell ausgelöst werden?
- [ ] Sollen bereits besuchte Adressen dauerhaft aus dem Pool entfernt werden (nicht nur täglich zurückgesetzt)?
- [ ] Gewünschte Sprache der Weboberfläche: Deutsch
- [ ] Excel/CSV-Datei mit den 2.000 Adressen für Schritt 2 bereitstellen
"""

with open('D:/GIT/Marius/Address_Clustering_Report.md', 'w', encoding='utf-8') as f:
    f.write(content)

lines = content.count('\n')
print(f'Done. {lines} lines written.')
