# Testreport nach Business-Cases

Stand: 04.04.2026

## Testlauf-Setup

- Umgebung: Produktion (`https://204.168.217.211.nip.io/api`)
- Kommando (kanonischer Lauf):

```bash
pytest -q --import-mode=importlib --ignore=ARCHIV
```

- Ergebnis: **5 passed, 5 warnings**
- Laufzeit: **37.46s**

Hinweis:
- Ein unbereinigter Lauf ohne `--ignore=ARCHIV` sammelt doppelte, archivierte Testdateien und führt zu Doppelzählungen bzw. Modulkollisionen.

## Business-Case 1: Authentifizierung

### BC1.1 Login mit gültigen Zugangsdaten
- Testfall: `test_login_rpc_success`
- Erwartung: Login liefert Token
- Ergebnis: **PASS**

### BC1.2 Login mit ungültigem Passwort
- Testfall: `test_login_rpc_invalid_password`
- Erwartung: Kein 2xx-Status
- Ergebnis: **PASS**

## Business-Case 2: Reservierung (Concurrency)

### BC2.1 Adresse kann nur einmal atomar übernommen werden
- Testfall: `test_claim_is_atomic_single_winner`
- Erwartung: Erster Claim gewinnt, zweiter Claim trifft 0 Zeilen
- Ergebnis: **PASS**

## Business-Case 3: Ergebniskorrektur im Archiv

### BC3.1 Letztes korrigiertes Ergebnis ist fachlich aktiv
- Testfall: `test_result_correction_latest_result_wins`
- Erwartung: Neues Ergebnis überschreibt vorheriges Ergebnis
- Ergebnis: **PASS**

## Business-Case 4: Reaktivierung

### BC4.1 Reaktiviert invalidiert ältere Ergebnisse
- Testfall: `test_reaktiviert_invalidates_old_results`
- Erwartung: Nach `reaktiviert` gelten frühere Resultate nicht mehr
- Ergebnis: **PASS**

## Mobile-Scan (iPhone + Android)

Geprüfte Geräteklassen (Portrait):
- iPhone SE (375x667)
- iPhone 12/13/14 (390x844)
- iPhone XR/11 (414x896)
- iPhone 14 Pro Max (430x932)
- Galaxy S8/S9/S10 (360x740)
- Galaxy S20/S21/S22 (360x800)
- Pixel 5 (393x851)
- Pixel 7/8 (412x915)

Prüfumfang:
- Tabs: Suchen, Meine, Karte, Archiv, Admin
- Horizontales Overflow, abgeschnittene Controls, tab-basierte Layoutstabilität

Ergebnis:
- **Keine globalen horizontalen Overflow-Probleme** in geprüften Tabs
- **Karte-Tab**: horizontal scrollbare Filter-Chips sind erwartetes Verhalten (kein Bug)
- **Keine blockierenden mobilen Darstellungsfehler** identifiziert

## Warnings aus Testlauf

- `server/test_ddg.py`: Upstream-Hinweis, dass `duckduckgo_search` in `ddgs` umbenannt wurde
- Keine funktionale Auswirkung auf die Business-Cases oben
