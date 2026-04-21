---
title: "Geocoding-Fehleranalyse 2026"
---

# Geocoding-Fehleranalyse 2026

Stand: 21.04.2026
Vergleichsmodus: Vorname + Nachname + Straße (ohne Hausnummer/PLZ im Delta-Match)

## Zusammenfassung

- Verbleibendes Delta: 498
- Fehlgeschlagene Geocoding-Fälle (aktuelle Fehlerliste): 361
- Fehlertypen:
  - HTTP 429 Too Many Requests: 346
  - not_found: 15
- PLZ fehlt in Fehlerfällen: 361 von 361
- Komplexe Adressmarker in Fehlerfällen (z. B. Top/Haus/Slash/OG): 274 von 361

Interpretation:
- Hauptursache ist Rate-Limiting durch den externen Geocoder (Nominatim), nicht primär falsche Daten.
- Die restlichen not_found-Fälle sind überwiegend Parsing-/Qualitätsprobleme im Adressstring.

## Detail Ursachen

### 1) Rate Limit (429)

Typisches Muster:
- Adresse an sich plausibel
- Kein eindeutiger fachlicher Datenfehler
- Geocoder lehnt wegen zu vieler Anfragen ab

Beispiele:
- Nikolai Keilmann | Rechte Wienzeile 227/36
- Kurt Kernstock | Großbauerstraße 32
- Sarah Khater MSc | Max-Winter-Platz 21/8
- Rainer Klaus | Pfeilgasse 18/24

### 2) Not Found (15 Fälle)

Häufige Unterursachen:
- Tippfehler im Straßennamen
- Haus-/Top/OG-Anteile wurden in Straßen- oder Hausnummerfeld falsch getrennt
- Sonderformate mit Zusatzteilen ohne PLZ

Beispiele:
- Sarra Altner | Rosinagsse 8/13 (Tippfehler im Straßennamen)
- Szauszan Natalia Barrak | Weimarar Straße 51/2/10 (Tippfehler)
- Melania Albert | Polgarstraße 13E/21 RH (RH im HNR-Feld)
- Robert Deak M.Sc. | Karl-Popper-Straße 8/2. OG/Top 204 (Top/OG-Mischformat)
- Walter Geyer | Costenblegasse 7 (vermutlich Tippfehler)

## Warum fehlen so oft Koordinaten?

- Der Geocoder wird mit Adressen ohne PLZ gefüttert.
- Ohne PLZ steigt die Mehrdeutigkeit, besonders bei Sonderformaten und Schreibfehlern.
- Gleichzeitige/zu häufige Anfragen triggern 429 und verhindern erfolgreiche Auflösung trotz gültiger Adresse.

## Empfohlene Maßnahmen

1. Strikter Einzelprozess für Geocoding (keine Parallelstarts).
2. Weiterhin One-Pass für Vollabdeckung; anschließend gezielter Retry nur für 429-Fälle in kleinen Batches.
3. Vor Retry eine Normalisierungsschicht für not_found-Fälle:
   - bekannte Tippfehler-Dictionary
   - Entfernen von Top/OG/Haus-Token aus Straßenfeld
   - konservative Hausnummer-Vereinfachung
4. Optional: PLZ-Nachanreicherung aus vorhandenen Bestandsmustern derselben Straße (wenn eindeutig).

## Operativer Status

- Import-Batches in Produktion:
  - import_wien_2026_20260420: 246
  - import_wien_2026_20260421: 90
- Zusätzlich vorhanden:
  - manual_2026-04-20: 2
  - manual_pending_geocode_2026-04-20: 1
- Gesamt bereits importiert aus 2026-Batches: 336

## Verwendete Dateien

- import_delta_2026_geocode_failed.json
- import_delta_2026_geocoded.json
- import_delta_2026_new.json
