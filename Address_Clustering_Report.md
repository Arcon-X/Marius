---
layout: default
title: Nächstgelegene Adressen — Lösungsbericht
---

# Nächstgelegene Adressen — Lösungsbericht

**Datum:** 3. März 2026  
**Erstellt von:** GitHub Copilot  
**Thema:** Ermittlung der N nächstgelegenen Adressen aus einer Liste von ca. 2.000 Einträgen, ausgehend von einem beliebigen Startpunkt

---

## Anforderung

Das Team verwaltet eine Liste von ca. **2.000 österreichischen Adressen** (gespeichert in Excel/CSV). Ausgehend von einer **Startadresse** und einer gewünschten **Anzahl N** soll das System die **N nächstgelegenen Adressen** aus der Liste zurückliefern — sortiert nach Entfernung vom Startpunkt.

**Beispiel:** Startpunkt Büro Jägerstraße 23/4, 1200 Wien — finde die 5 nächstgelegenen Adressen aus der Gesamtliste.

**Beispiel-Adressliste:**

| PLZ  | Ort  | Straße                    |
|------|------|---------------------------|
| 1190 | Wien | Heiligenstädter Straße 69/10 |
| 1200 | Wien | Jägerstraße 23/4          |
| 1220 | Wien | Trondheimgasse sa/1/14    |

**Anwendungsfälle:** Außendienstplanung, Haustürbesuche, Tarifzuordnung, Gebietsoptimierung.

---

## Empfohlene Lösung: Zweiphasiger Ansatz

### Phase 1 — Luftliniensuche mit KNN (Kostenlos, sofort einsetzbar)

**Funktionsweise:**
1. Jede Adresse der Liste wird **einmalig geokodiert** (in GPS-Koordinaten umgewandelt) — kostenlos über den OpenStreetMap-Dienst Nominatim, kein API-Schlüssel erforderlich. Ergebnisse werden lokal zwischengespeichert.
2. Der **Startpunkt** wird ebenfalls geokodiert (eine Anfrage).
3. Luftlinienabstände (Haversine-Formel) werden vom Startpunkt zu allen 2.000 Adressen berechnet.
4. Die Liste wird **nach Entfernung sortiert** und die Top-N Adressen zurückgegeben.
5. Ergebnisse werden in Excel exportiert, sortiert von nächster zu weitester.

**Beispielausgabe für N=5:**

| Rang | PLZ  | Ort  | Straße | Entfernung |
|------|------|------|--------|------------|
| 1 | 1200 | Wien | Grünentorgasse 12 | 180 m |
| 2 | 1200 | Wien | Wallensteinstraße 5/3 | 340 m |
| 3 | 1190 | Wien | Heiligenstädter Straße 69/10 | 610 m |
| 4 | 1200 | Wien | Dresdner Straße 44 | 820 m |
| 5 | 1210 | Wien | Floridsdorfer Hauptstraße 1 | 1,1 km |

**Technischer Stack:**

| Komponente | Werkzeug | Kosten |
|-----------|------|------|
| Geokodierung | Nominatim (OpenStreetMap) | Kostenlos |
| KNN-Suche | scipy / numpy (Haversine) | Kostenlos |
| Ein-/Ausgabe | pandas + openpyxl | Kostenlos |
| Programmiersprache | Python 3 | Kostenlos |

**Geschätzte Geokodierungszeit:** ~33 Minuten für 2.000 Adressen (Nominatim erlaubt max. 1 Anfrage/Sekunde)  
> Geokodierungsergebnisse werden in einer lokalen CSV-Datei gespeichert — alle weiteren Abfragen gegen dieselbe Liste sind **sofort** verfügbar.

**Genauigkeitshinweis:** Die Luftliniendistanz berücksichtigt keine physischen Hindernisse (Flüsse, Parks, Einbahnstraßen). Für Wien ist die Genauigkeit im Vergleich zur tatsächlichen Gehstrecke typischerweise **10–15 % Abweichung**.

---

### Phase 2 — Echte Gehstrecke (Optional, mit Kosten)

Falls reale Gehstrecken erforderlich sind (z. B. Startpunkt liegt nahe einem Fluss oder Park), kann ein Routing-API für **nur die Top-N Kandidaten** aus Phase 1 aufgerufen werden — minimales API-Volumen, maximale Genauigkeit.

| Anbieter | Kostenloses Kontingent | Kosten je Abfrage (N=5) | Hinweis |
|---|---|---|---|
| **Google Maps Distance Matrix API** | $200 Guthaben/Monat | ~$0,005 je Abfrage | Einfach, sehr genau |
| **OpenRouteService (ORS)** | 500 Anfragen/Tag kostenlos | ~$0 im kostenlosen Tarif | EU-basiert, ideal für Österreich |
| **HERE Maps Matrix Routing** | 1.000 Anfragen/Tag kostenlos | ~$0 im kostenlosen Tarif | |
| **OSRM (selbst gehostet)** | Unbegrenzt | Nur Serverkosten | Beste Wahl bei hohem Volumen |

**Kostenoptimierte Hybridstrategie:**
- Phase 1 (kostenlos) reduziert die 2.000 Adressen auf die 20 nächstgelegenen Kandidaten
- Phase 2 ruft das Routing-API nur für diese 20 Kandidaten auf
- Ergebnis: Top-N nach echter Gehstrecke sortiert
- API-Aufrufe werden von 2.000 auf 20 reduziert — **99 % Kostenersparnis**

---

## Empfohlener Projektplan

```
Phase 1 (Woche 1):  Alle 2.000 Adressen geokodieren + KNN-Tool implementieren  →  $0 Kosten
Phase 2 (Woche 2):  Tests mit echten Startadressen, Ergebniskontrolle
Phase 3 (nach Bedarf):  Routing-API ergänzen, falls Luftliniengenauigkeit nicht ausreicht
```

---

## Ausgabe

Das Tool nimmt entgegen:
- **Startadresse** (PLZ + Ort + Straße oder Freitext)
- **N** — Anzahl der zurückzugebenden nächstgelegenen Adressen

Und liefert eine sortierte Excel-Ausgabe:

| Spalte | Beschreibung |
|---|---|
| `Rang` | 1 = nächste, 2 = zweitnächste, usw. |
| `PLZ` | Postleitzahl |
| `Ort` | Stadt |
| `Straße` | Straßenadresse |
| `Breitengrad` | GPS-Breitengrad |
| `Längengrad` | GPS-Längengrad |
| `Entfernung_m` | Luftlinienabstand vom Startpunkt in Metern |
| `Gehstrecke_m` *(Phase 2)* | Echte Gehstrecke in Metern (optional) |

Optional kann auch eine **interaktive HTML-Karte** erzeugt werden, die den Startpunkt und die N nächstgelegenen Adressen als Pins anzeigt.

---

## Nächste Schritte

- [ ] Standardwert für N bestätigen (z. B. 5 nächste? 10? Konfigurierbar je Abfrage?)
- [ ] Ausgabeformat bestätigen (nur Excel oder auch HTML-Karte mit Pins)
- [ ] Excel/CSV-Datei mit den 2.000 Adressen für die Entwicklung bereitstellen
- [ ] Entscheidung: ist Phase 2 (echte Gehstrecke) nach Review von Phase 1 notwendig?

---

## Zusammenfassung

| | Phase 1 (Luftlinien-KNN) | Phase 2 (Routing-API) |
|---|---|---|
| **Kosten** | $0 | $0 im kostenlosen Tarif bei geringem Volumen |
| **Genauigkeit** | Gut (±10–15 % ggü. echter Gehstrecke) | Hoch (reale Straßenführung) |
| **Geschwindigkeit** | ~33 Min. Geokodierung (einmalig), danach sofort | +1–2 Sek. je Abfrage durch API-Aufruf |
| **Komplexität** | Niedrig | Niedrig–Mittel |
| **Empfehlung** | Ja — hier starten | Nur ergänzen, wenn Genauigkeit kritisch ist |

---

## Ablauf — Einfache Darstellung

```
Eingabe:  "Jägerstraße 23/4, 1200 Wien"  +  N = 5
        ↓
Startadresse geokodieren  →  (Breitengrad, Längengrad)
        ↓
Entfernung zum Startpunkt für alle 2.000 Adressen berechnen
        ↓
Nach Entfernung sortieren, Top 5 zurückgeben
        ↓
Export nach Excel + optionale HTML-Karte
```

---

## Skalierungsschätzung: 10 Mitarbeiter, tägliche Routenplanung

### Annahmen

| Parameter | Wert |
|---|---|
| Außendienstmitarbeiter | 10 |
| Adressen im Pool | 2.000 |
| Besuche pro Mitarbeiter pro Tag | ~15 |
| KNN-Abfragen pro Mitarbeiter pro Tag | 1 (Morgenplanung) + 1 Neuplanung mittags = **2** |
| N (zurückgegebene nächste Adressen) | 5 |
| Arbeitstage pro Monat | 22 |

---

### Anfragevolumen im Detail

#### Geokodierungs-Anfragen (Nominatim / OpenStreetMap)

| Ereignis | Anfragen | Häufigkeit |
|---|---|---|
| Ersteinrichtung — alle 2.000 Adressen geokodieren | 2.000 | **Einmalig**, danach gecacht |
| Täglich — Startpunkt je Mitarbeiter geokodieren | 10 | Pro Tag |
| Täglich — Neuplanung mittags (optional) | 10 | Pro Tag |
| **Gesamt täglich (nach Einrichtung)** | **~20 Anfragen/Tag** | |
| **Gesamt monatlich** | **~440 Anfragen/Monat** | |

> Nominatim erlaubt ~1 Anfrage/Sekunde und ist für normalen Gebrauch ausgelegt — 20 Anfragen/Tag sind vernachlässigbar.

---

#### KNN-Berechnung — Phase 1 Luftlinie (Kein API)

Alle Berechnungen laufen **lokal** in Python. Keine externen Anfragen je Abfrage.

| Ereignis | API-Aufrufe |
|---|---|
| Entfernung zu allen 2.000 Adressen berechnen | **0** — lokal berechnet |
| Sortieren und Top 5 ausgeben | **0** |
| **Kosten** | **$0, dauerhaft** |

---

#### Gehstrecken-Verfeinerung — Phase 2 (Optionales API)

Strategie: Luftlinie auf Top-20-Kandidaten eingrenzen, dann Routing-API nur für diese 20 aufrufen.

| Ereignis | Elemente je Abfrage | Abfragen/Tag | Elemente/Tag |
|---|---|---|---|
| 10 Mitarbeiter × 2 Abfragen | 20 Kandidaten | 20 Abfragen | **400 Elemente/Tag** |
| Monatlich (22 Tage) | | | **~8.800 Elemente/Monat** |

**Kosten je Anbieter:**

| Anbieter | Kostenloses Kontingent | Monatliche Nutzung | Monatliche Kosten |
|---|---|---|---|
| **Nominatim + Phase 1** | Unbegrenzt | 440 Geokodierungen | **$0** |
| **OpenRouteService (ORS)** | 500 Anfragen/Tag | 400 Elemente/Tag | **$0** (weit unter dem Limit) |
| **Google Maps Distance Matrix** | $200 Guthaben/Monat | 8.800 Elemente × $0,005 | **~$0,44/Monat** |
| **OSRM selbst gehostet** | Unbegrenzt | Unbegrenzt | **$0** (nur Serverkosten) |

---

### Abdeckung — Wie lange für alle 2.000 Adressen?

```
10 Mitarbeiter × 15 Besuche/Tag = 150 Adressen pro Tag
2.000 Adressen ÷ 150 pro Tag = ~13–14 Arbeitstage ≈ 3 Wochen
```

> Mitarbeiter tendieren zu ähnlichen geografischen Zonen, wenn sie vom gleichen Startpunkt starten — verschiedene Startpunkte je Mitarbeiter maximieren die tägliche Abdeckung.

---

### Fazit — Reichen kostenlose Kontingente aus?

| Kennzahl | Kostenloses Limit | Unsere Nutzung | Ausreichend? |
|---|---|---|---|
| Nominatim Geokodierung | ~1.000 Anfragen/Tag sicher | 20 Anfragen/Tag | ✅ Ja |
| ORS Routing-API | 500 Anfragen/Tag | ~20 Anfragen/Tag | ✅ Ja |
| Google Maps Guthaben | $200/Monat | ~$0,44/Monat | ✅ Ja |

**Fazit: 10 Mitarbeiter mit täglicher Routenplanung gegen 2.000 Adressen verursachen $0/Monat Kosten im kostenlosen Tarif. Selbst mit Google Maps liegen die Kosten unter $1/Monat.**
