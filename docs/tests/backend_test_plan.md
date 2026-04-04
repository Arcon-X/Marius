# Backend Test Plan (separat)

Ziel: API, Datenkonsistenz und Berechtigungen reproduzierbar pruefen.

## 1. Scope

- PostgREST Endpunkte: /api/adressen, /api/protokoll, /api/benutzer, /api/issues
- RPC Endpunkte: /api/rpc/login, /api/rpc/admin_reset_password (falls aktiv)
- Kern-Workflows: Claim, Archivierung, Korrektur, Reaktivierung, Snapshot, Verifizierung

## 2. Testumgebung

- Eigene Testdatenbank oder isoliertes Schema
- Mindestens 2 Testuser: admin, mitarbeiter
- Seed mit 10-20 Adressen (gemischte Stati)
- UTC + Europe/Vienna Zeitpruefung fuer Zeitstempel

## 3. Priorisierte Testbloecke

### A) Auth und Rollen (P1)

1. Login erfolgreich (gueltig)
2. Login abgelehnt (ungueltig)
3. Auth erforderlich fuer geschuetzte Endpunkte
4. Rolle mitarbeiter darf Admin-only Aktionen nicht
5. Rolle admin darf Admin-Aktionen

### B) Adressen-Statusmaschine (P1)

1. verfuegbar -> in_bearbeitung (Claim)
2. in_bearbeitung -> archiviert (Ergebnis)
3. archiviert -> verfuegbar (Reaktivierung)
4. Verbotene Transitionen werden abgelehnt
5. erledigt_am/reserviert_am werden konsistent gesetzt/geleert

### C) Race Conditions / Parallelitaet (P1)

1. Doppel-Claim parallel auf dieselbe Adresse
2. Erwartung: genau ein erfolgreicher Claim
3. Zweiter Request liefert 0 betroffene Zeilen oder semantischen Misserfolg

### D) Protokoll-Konsistenz (P1)

1. Jeder Ergebnis-Write erzeugt Protokolleintrag
2. Snapshot "bearbeitet" enthaelt old-Felder als JSON
3. Reaktivierung schreibt "reaktiviert"
4. Ergebniskorrektur erzeugt neuen Result-Logeintrag
5. Chronologie nach zeitpunkt.desc stimmt

### E) Statistik-Korrektheit (P1)

1. Nur letzter gueltiger Result-Log pro Adresse zaehlt
2. Alte Resultate nach Reaktivierung zaehlen nicht
3. Korrektur ersetzt alte Kategorie (keine Doppelzaehlung)
4. Chart-Gesamtsumme == Anzahl aktiver letzter Ergebnisse

### F) Datenvalidierung (P2)

1. Pflichtfelder fuer adresse/protokoll
2. Check-Constraints fuer status/aktion
3. PLZ/Koordinaten Datentypen korrekt
4. Fehlerhafte Payload -> 4xx mit klarer Meldung

### G) Issues-Workflow (P2)

1. Issue anlegen
2. Issue patchen (Status/Notiz)
3. Issue loeschen (nur berechtigt)

### H) Verify Script Integrationspunkte (P3)

1. /rpc/login Token abrufbar
2. PATCH verifiziert=true erfolgreich
3. Snapshot protokolliert bei Website-Aenderung
4. Batch-Limit und Fehlerbehandlung nachvollziehbar

## 4. Testdesign

- API-Tests als black-box via HTTP (requests/curl)
- Datenpruefung durch Read-after-Write
- Jede Testklasse mit Setup/Teardown
- Idempotente Seeds (reset vor Lauf)

## 5. Beispiel-Testfaelle (minimal)

- BE-001 login_success
- BE-002 login_invalid_credentials
- BE-010 claim_atomic_single_winner
- BE-020 archive_write_sets_status_and_timestamp
- BE-021 correction_creates_new_result_event
- BE-022 reactivation_invalidates_old_results
- BE-030 snapshot_contains_old_values
- BE-040 issues_crud_permissions

## 6. Ausfuehrungsstrategie

Phase 1 (Sofort):
- P1 Auth, Status, Race, Statistik

Phase 2:
- P2 Validierung + Issues

Phase 3:
- P3 Verify-Job Integrationsfaelle

## 7. Reporting

Pro Lauf erfassen:
- Commit/Build ID
- Zielumgebung
- Anzahl Tests (pass/fail/skip)
- Defects nach Schweregrad
- Reproduzierbare Request/Response Samples

## 8. Empfohlene Umsetzung

- Python pytest + requests
- Fixtures fuer admin/mitarbeiter Tokens
- Helper fuer seed/reset
- Optional: nightly Run gegen Staging
