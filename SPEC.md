# NOVUM-ZIV - Technische Spezifikation (Ist-Stand)

<style>
.site-header { display: none !important; }
.doc-nav { position: sticky; top: .5rem; z-index: 20; background: #fff; border: 1px solid #d0d7de; border-radius: 10px; padding: .7rem; margin: .2rem 0 1rem 0; box-shadow: 0 2px 8px rgba(0,0,0,.05); }
.doc-nav-title { font-size: .8rem; color: #57606a; font-weight: 700; margin-bottom: .45rem; }
.doc-nav-links { display: flex; gap: .4rem; overflow-x: auto; padding-bottom: .15rem; }
.doc-nav-links a { text-decoration: none; border: 1px solid #d0d7de; background: #f6f8fa; color: #24292f; border-radius: 999px; padding: .32rem .72rem; white-space: nowrap; font-size: .82rem; font-weight: 600; }
.doc-nav-links a.active { background: #1f6feb; border-color: #1f6feb; color: #fff; }
</style>

<div class="doc-nav" role="navigation" aria-label="Dokumentationsnavigation">
  <div class="doc-nav-title">Dokumentation</div>
  <div class="doc-nav-links">
    <a href="/docs/index.html">Hub</a>
    <a href="/docs/import_report.html">Import</a>
    <a href="/docs/features.html">Features</a>
    <a href="/docs/technik.html">Technik</a>
    <a href="/docs/db_model.html">DB</a>
    <a href="/SPEC.html" class="active">SPEC</a>
    <a href="/docs/domain.html">Domain</a>
    <a href="/docs/tests_businesscases.html">Tests BC</a>
    <a href="/tests/backend/README.html">Tests Backend</a>
  </div>
</div>

> Stand: 04.04.2026
> Dieses Dokument beschreibt den aktuellen Produktivzustand. Es ersetzt das fruehere Planungsdokument.

---

## 1. Projektstatus

NOVUM-ZIV ist produktiv als mobile-first Web-App im Einsatz.

Kernworkflow:
1. Adresse suchen (GPS oder manuelle Position)
2. Adresse atomar uebernehmen
3. Ergebnis erfassen oder Adresse bearbeiten
4. Verlauf und Reporting aus Audit-Protokoll auswerten

Aktuell sind Abschlussreports direkt im Admin-Bereich verlinkt:
- Executive Summary
- Business KPI Report

---

## 2. Systemarchitektur

```
Frontend (GitHub Pages)
  index.html (Single-File SPA, Vanilla JS)
  |
  | HTTPS + JWT Bearer
  v
Backend (VPS)
  Nginx -> PostgREST -> PostgreSQL 16 + PostGIS
  |
  +-- externe Dienste: OSRM (Routing), Nominatim (Geocoding)
```

Wichtige Eigenschaften:
- API relativ via /api
- JWT-basierte Authentifizierung
- Datenhaltung zentral in PostgreSQL
- Client-Cache in localStorage als Performance-Layer

---

## 3. Technologie-Stand

- Ubuntu 24.04 LTS
- PostgreSQL 16
- PostGIS 3.x
- PostgREST 12.x
- Nginx + TLS (Let's Encrypt)
- Frontend: HTML + Vanilla JS + CSS
- Karte: Leaflet + OpenStreetMap Tiles
- Routing: router.project-osrm.org (foot)
- Geocoding: Nominatim

---

## 4. Fachliches Datenmodell

### 4.1 Tabellen

- benutzer
- adressen
- protokoll
- api.issues

### 4.2 Statuswerte adressen

- verfuegbar
- in_bearbeitung
- archiviert

### 4.3 Aktionswerte protokoll

- uebernommen
- waehlt_uns
- waehlt_nicht
- ueberlegt
- kein_interesse_wahl
- sonstige
- reaktiviert
- bearbeitet

Hinweis:
- bearbeitet speichert Aenderungssnapshots fuer Adressmutationen.
- In UI/Verlauf werden diese Snapshots lesbar als Felddifferenzen dargestellt.

---

## 5. Persistenz- und Konsistenzregeln

Die App wurde auf DB-first Verhalten gehaertet:

1. Claim ist strikt serverbestaetigt.
2. Ergebnis-/Statusaenderungen gelten erst nach erfolgreichem DB-Write.
3. Wenn Protokollspeicherung fehlschlaegt, wird die Aenderung verworfen bzw. rueckgaengig gemacht.
4. Protokoll wird beim Sync vollstaendig paginiert geladen (kein 500er Auswertungs-Cutoff mehr).

Wichtig:
- Ungespeicherte Eingaben im offenen Dialog bleiben bewusst nicht persistent.
- Destruktive Reset-/Import-Pfade sind explizit gewollt.

---

## 6. Frontend-Funktionsbereiche

- Login und Session
- Suche (OSRM-Gehzeit) und Adresskarten
- Meine Adressen
- Archiv mit Verlauf, Korrektur und Reaktivierung
- Karte (Map/List, Status- und PLZ-Filter)
- Admin:
  - Letzte Ereignisse
  - Teamverwaltung
  - Dokumentationen
  - REPORTS
  - Fehler und Wuensche

---

## 7. Reporting

Reports sind als statische, druckoptimierte Seiten verfuegbar:

- docs/report_executive_summary.md
- docs/report_business_kpi.md

KPI-Logik basiert auf:
- adressen Status
- protokoll Aktionen inkl. Reaktivierungs-/Korrekturlogik
- Bezirksmapping ueber PLZ

---

## 8. Sicherheit

- JWT (8h Ablauf)
- Rollenmodell admin / mitarbeiter
- passwort_hash nie in API-View exponiert
- CSP im Frontend gesetzt
- API nur ueber Nginx erreichbar
- PostgREST lokal gebunden (127.0.0.1)

---

## 9. Betrieb und Deployment

- Branch: main
- Push auf main deployed Frontend nach GitHub Pages
- Backend-Aenderungen via server-Skripte (Migrationen)
- DB-/Ops-Checks ueber server/*.sh und server/*.sql

---

## 10. Datenlebenszyklus

- Tagesbetrieb: dauerhafte Speicherung
- Audit-Log: jede relevante Aktion wird protokolliert
- Reset/Import: absichtlich destruktiv verfuegbar (Admin-Funktion)
- Projektende: geplante Datenloeschung gemaess Betriebsentscheidung

---

## 11. Source of Truth je Themenbereich

- UI/Workflow: index.html
- DB-Struktur: docs/db_model.md + server-Migrationsskripte
- Technik/Betrieb: docs/technik.md
- Features/Fachlogik: docs/features.md
- Importhistorie: docs/import_report.md
- Business-Case Tests: docs/tests_businesscases.md
- Abschlussreports: docs/report_executive_summary.md, docs/report_business_kpi.md

---

## 12. Dokumentationsprinzip

Diese SPEC ist bewusst kompakt als Systemreferenz gehalten.

Detailtiefe liegt in den Fachdokumenten, die vom Hub verlinkt sind.
Bei Abweichungen gelten:
1. produktiver Code
2. server-Migrationsskripte
3. docs/db_model.md
