---
title: "NOVUM-ZIV — Feature-Dokumentation"
---

<style>
.site-header { display: none !important; }
.neu {
  border-left: 4px solid #2da44e;
  background: #dafbe1;
  padding: .6rem 1rem;
  margin: .8rem 0;
  border-radius: 4px;
}
.doc-nav { position: sticky; top: .5rem; z-index: 20; background: #fff; border: 1px solid #d0d7de; border-radius: 10px; padding: .7rem; margin: .2rem 0 1rem 0; box-shadow: 0 2px 8px rgba(0,0,0,.05); }
.doc-nav-title { font-size: .8rem; color: #57606a; font-weight: 700; margin-bottom: .45rem; }
.doc-nav-links { display: flex; gap: .4rem; overflow-x: auto; padding-bottom: .15rem; }
.doc-nav-links a { text-decoration: none; border: 1px solid #d0d7de; background: #f6f8fa; color: #24292f; border-radius: 999px; padding: .32rem .72rem; white-space: nowrap; font-size: .82rem; font-weight: 600; }
.doc-nav-links a.active { background: #1f6feb; border-color: #1f6feb; color: #fff; }
.doc-nav-links a:focus-visible { outline: 2px solid #1f6feb; outline-offset: 2px; }
</style>

# NOVUM-ZIV Unterschriften — Feature-Dokumentation

<div class="doc-nav" role="navigation" aria-label="Dokumentationsnavigation">
  <div class="doc-nav-title">Dokumentation</div>
  <div class="doc-nav-links">
    <a href="/docs/features.html" class="active" aria-current="page" title="Produktfunktionen und User-Flow">Features</a>
    <a href="/docs/technik.html" title="Technische Architektur, Betrieb und Sicherheit">Technik</a>
    <a href="/docs/db_model.html" title="Datenmodell, Views, RPCs und Constraints">DB Model</a>
    <a href="/docs/import_report.html" title="Datenherkunft, Geocoding und Qualitaet">Import Report</a>
    <a href="/docs/domain.html" title="Domain, TLS und Migrationsbetrieb">Domain</a>
    <a href="/docs/report_executive_summary.html" title="Management-Zusammenfassung fuer Abschluss">Executive Summary</a>
    <a href="/docs/report_business_kpi.html" title="KPI-Vertiefung mit Bezirks- und Teamwerten">Business KPI</a>
  </div>
</div>

> **Stand:** 05.04.2026 · **Projekt:** BNZ Bündnis NOVUM–ZIV · Zahnärztekammerwahl Wien 2026

---

<div class="neu">

## Lesefluss-Einordnung

- **Du bist hier richtig, wenn** du den Produktablauf von vorne nach hinten verstehen willst.
- **Vorher:** [Hub](/docs/index.html "Startpunkt mit kompletter Lesereihenfolge")
- **Danach:** [Technik](/docs/technik.html "Architektur, Sicherheit und Rechtemodell")
- **Tiefe Details danach:** [DB Model](/docs/db_model.html "Datenstrukturen und API-Projektionen im Detail")

</div>

---

## Überblick

Die App unterstützt 19 Kandidat:innen dabei, rund 1.500 Wiener Zahnarztpraxen per Hausbesuch zu erreichen. Kernprinzip: **Nächste freie Adresse finden → übernehmen → besuchen → Ergebnis eintragen.**

---

## 1. Standortbasierte Suche

- **GPS-Ortung:** Per Klick wird der aktuelle Standort ermittelt.
- **Manuelle Adresssuche:** Straße/PLZ eintippen → Nominatim-Geocoding → Treffer als Ausgangspunkt.
- **Nächste Adressen:** Die N nächstgelegenen *freien* Adressen werden per PostGIS-KNN (Luftlinie) ermittelt und anschließend mit echten **Fußgänger-Gehzeiten** (OSRM) sortiert angezeigt.
- **Entfernungsanzeige:** Jede Karte zeigt 🚶 Gehminuten und Meter zum aktuellen Standort.

---

## 2. Adress-Karten

Jede Adresse wird als kompakte Karte dargestellt mit:

| Element | Beschreibung |
|---|---|
| **Straße + Hausnummer** | Fettgedruckte Überschrift |
| **Arztname + Titel** | z. B. „Dr. Antonia Fartushna" |
| **Geo-Info** | 🏛️ Gebäude, Viertel, Bezirksteil (via Nominatim) |
| **Verifiziert-Badge** | ✔️ wenn die Praxis verifiziert wurde |
| **Website-Link** | 🌐 klickbar, öffnet Praxis-Website in neuem Tab |
| **PLZ + Stadt** | z. B. „1010 Wien" |
| **Gehzeit** | 🚶 3 min / 245 m |
| **Sprach-Hinweis** | 🗣️ bei nicht-deutschsprachigen Praxen (pa = Persisch) |

Die Karten erscheinen in 5 verschiedenen Ansichten einheitlich:
Suche, Meine, Archiv, Karte (Liste), Admin-Adressliste.

---

## 3. Adress-Übernahme & Doppelbuchungsschutz

- **Atomischer Claim:** PATCH nur wenn `status = verfuegbar` → verhindert Doppelübernahme bei gleichzeitigem Zugriff.
- **Status-Workflow:** `verfuegbar` → `in_bearbeitung` → `archiviert` (→ optional `reaktiviert` → `verfuegbar`).
- Übernahme-Zeitpunkt wird gespeichert (`reserviert_am`).
- Protokoll-Eintrag „übernommen" wird automatisch erstellt.

---

## 4. Ergebnis eintragen

Nach dem Besuch wählt der/die Kandidat:in eines von fünf Ergebnissen:

| Ergebnis | Icon | Beschreibung |
|---|---|---|
| **Wählt uns** | 🗳️ | Unterschrift erhalten |
| **Wählt uns nicht** | ❌ | Abgelehnt |
| **Überlegt noch** | 🤔 | Noch unentschieden |
| **Kein Interesse an der Wahl** | 🚫 | Will nicht wählen |
| **Sonstige** | 💬 | Freitextnotiz möglich |

Adresse wird archiviert und im Ergebnis-Chart gezählt.

---

## 5. Bearbeiten-Dialog

Jede Adresse kann über ⚙️ bearbeitet werden:

- **Felder:** Titel, Arztname, Straße, Hausnummer, PLZ, Sprache, Website-URL, Verifiziert-Checkbox.
- **Auto-Geocoding:** Beim Speichern wird die Adresse automatisch über Nominatim neu geocodiert. Koordinaten und Geo-Name werden aktualisiert, Ergebnis wird im Dialog angezeigt.
- **Versions-History:** Jede Änderung erzeugt einen Snapshot (alter → neuer Zustand) im Protokoll. Im Dialog werden vergangene Versionen mit „Wiederherstellen"-Button angezeigt.
- **3-Sekunden-Verzögerung:** Dialog bleibt nach dem Speichern 3 Sekunden offen, damit Geocoding-Ergebnis gelesen werden kann.

---

## 6. Reaktivieren (Zurücksetzen)

- Admins und Owner können archivierte Adressen **reaktivieren**.
- Status wird auf `verfuegbar` zurückgesetzt, Zuweisung gelöscht.
- Alte Ergebnisse werden automatisch aus der Gesamtstatistik herausgerechnet (nur Einträge *nach* der letzten Reaktivierung zählen).
- Protokoll-Eintrag „reaktiviert" wird erstellt.

---

## 7. Meine Adressen

- Eigener Tab zeigt alle aktuell zugewiesenen Adressen (Status `in_bearbeitung`).
- Badge in der Navigation zeigt Anzahl offener Adressen.
- Direkt-Aktionen: Ergebnis eintragen, Bearbeiten.

---

## 8. Archiv & Gesamtstatistik

### Statistik-Chips
| Chip | Beschreibung |
|---|---|
| 🏠 Gesamt | Gesamtzahl aller Adressen |
| ✅ Verfügbar | Noch freie Adressen |
| 📌 Reserviert | Aktuell in Bearbeitung |
| 🗳️ Wählt uns | Unterschriften gesammelt |

### Ergebnis-Chart
- Horizontales Balkendiagramm mit allen 5 Ergebnis-Kategorien.
- Prozentangaben und absolute Zahlen.
- Reaktivierte Adressen werden korrekt herausgerechnet.

### Archiv-Karten
- Alle abgeschlossenen Adressen mit Ergebnis-Icon, Zeitstempel, Notiz.
- **Verlauf-Button** 📋 zeigt komplette Chronik (alle Aktionen über die Lebensdauer).
- Bearbeiten und Ergebnis korrigieren direkt möglich.

---

## 9. Karte (Leaflet)

- **Kartenansicht:** Interaktive OpenStreetMap-Karte mit farbigen Markern je Status.
- **Listenansicht:** Umschaltbar zwischen Karte und kompakter Liste.
- **Filter:** Nach Status (verfügbar, reserviert, archiviert, eigene, Probleme) und PLZ.
- **Eigener Standort:** Blauer Kreis zeigt aktuelle Position.
- **Marker-Cluster:** Gruppierung bei vielen Markern in der Nähe.

---

## 10. Admin-Bereich

### Letzte Ereignisse
- Chronologisches Log der letzten 15 Aktionen (zusammenklappbar, initial geschlossen).
- Zeigt: Aktion, Adresse, Benutzer, Zeitstempel, Notizen.

### Team-Management
- **Anzeige:** Name, E-Mail, Telefon (mit `tel:` Link → direkt anrufen auf Handy), Rolle, Statistiken.
- **Bearbeiten:** ✏️ Inline-Formular für Name, E-Mail, Telefon, Rolle.
- **Hinzufügen:** ➕ Neues Mitglied anlegen (initiales Passwort = E-Mail).
- **Entfernen:** 🗑️ mit Bestätigung (blockiert bei zugewiesenen Adressen).
- Admin-Schutz: Nur Admins können Team verwalten (serverseitige Prüfung via Trigger).

### Adressliste
- Vollständige Adressliste aller 1.485 Adressen mit Filtern nach Status und PLZ.
- **JSON-Export:** Alle Adressen mit allen Feldern als JSON herunterladen.
- **JSON-Import:** Adressen aus JSON-Datei wiederherstellen (mit Bestätigung).

### Dokumentationen
- Zusammenklappbarer Bereich mit Links zu Projektdokumenten.

---

## 11. Verifizierung

- **Verifiziert-Badge:** ✔️ neben dem Straßennamen bei verifizierten Praxen.
- **Website-Feld:** Im Bearbeiten-Dialog kann eine offizielle Website hinterlegt werden.
- **Verifiziert-Checkbox:** Manuelles Setzen des Verifiziert-Status.
- **Versions-Tracking:** Änderungen an Website/Verifiziert werden im Protokoll gesnapshoted.

---

## 12. Geo-Name (Ortsbezeichnung)

- Bei jedem Geocoding wird aus Nominatim ein lesbarer `geo_name` extrahiert.
- Enthält bis zu 3 Teile: Gebäudename, Straße, Viertel/Bezirksteil.
- **Deduplizierung auf der Karte:** Straßenname wird beim Anzeigen herausgefiltert, da er bereits in der Überschrift steht.
- Batch-Update über Server-Script möglich (`update_geo_names.py`).

---

## 13. Sprach-Unterstützung

- Praxen können als nicht-deutschsprachig markiert werden.
- Aktuell unterstützt: `de` (Standard), `pa` (Persisch).
- Visueller Hinweis 🗣️ auf der Karte.
- Filterbar in der Admin-Adressliste.

---

## 14. Login & Sicherheit

- **JWT-Authentifizierung:** Login über PostgREST RPC-Funktion, 8h Token-Gültigkeit.
- **Brute-Force-Schutz:** Client-seitige Sperre nach 5 Fehlversuchen (60 Sekunden Cooldown).
- **Passwort-Sichtbarkeit:** Toggle-Button im Login-Formular.
- **Rollen:** Admin (voller Zugriff) und Mitarbeiter (eigene Adressen + Suche).
- **Content Security Policy:** Whitelist für Skripte, Bilder, API-Zugriffe.

### 14.1 Rechtemodell (kompakt)

| Funktion | Admin | Mitarbeiter |
|---|---|---|
| Suche / Karte / eigene Arbeit | Ja | Ja |
| Archiv ansehen | Alle Einträge | Nur eigene Einträge |
| Admin-Tab | Ja | Nein |
| Team verwalten (Benutzer anlegen/ändern/löschen) | Ja | Nein |
| Passwort für andere zurücksetzen | Ja | Nein |

Hinweis zur Sicherheit:
- UI blendet Admin-Funktionen für Mitarbeitende aus.
- Kritische Team-Aktionen sind zusätzlich serverseitig geschützt (Rollenprüfung in SQL-Funktionen/Triggern).

---

## 15. Performance & Sync

- **Server-Sync:** Alle 30 Sekunden werden Daten vom Server nachgeladen.
- **Lokaler Cache:** Adressen und Protokoll werden in `localStorage` gecacht für schnelle Darstellung.
- **Paginierung:** Adressen werden seitenweise (1.000 pro Seite) geladen.
- **OSRM-Calls:** Serialisiert ausgeführt (max. 50 pro Suche) um Rate-Limits zu respektieren.

---

## 16. Mobile-First Design

- **Responsive:** Optimiert für Smartphone-Nutzung im Außendienst.
- **Bottom-Navigation:** 5 Tabs (Suchen, Meine, Archiv, Karte, Admin).
- **Touch-optimiert:** Große Touch-Targets, keine Hover-Abhängigkeiten.
- **PWA-artig:** Vollbild-Nutzung auf iOS/Android (kein App-Store nötig).
- **Telefon-Links:** `tel:` Links für direkte Anrufe auf mobilen Geräten.

---

## 17. Einstellungen & Account-Sicherheit

- **Einstellungen-Dialog:** Klick auf den Benutzernamen im Header öffnet Account-Einstellungen.
- **E-Mail ändern:** Eigene Login-E-Mail kann über RPC serverseitig geändert werden.
- **Passphrase ändern:** Änderung mit Prüfung des aktuellen Passworts und Mindestlänge (12 Zeichen).
- **Passwort ein-/ausblenden:** Augen-Button in Login, Zwangswechsel und Settings.
- **Erstlogin-Zwang:** Nutzer mit Standard-Passwort müssen vor App-Nutzung eine neue Passphrase setzen.
- **"Passwort vergessen":** Hinweis-Flow über Admin-Kontakt für Reset.

---

## 18. Admin-Reports, Issues & Voll-Reset

### Reports im Admin
- Eigener Bereich **REPORTS** im Admin mit Direkt-Links zu Executive Summary und Business KPI.
- Öffnen der Reports mit kurzlebiger Token-Übergabe für geschützte Inhalte.

### Fehler- & Wünsche-Board
- Admin-Bereich **Fehler & Wünsche** mit Typwahl (`bug`/`feature`) und Beschreibung.
- Funktionen: erstellen, Status offen/erledigt umschalten, löschen.
- Zeitstempel- und Benutzerbezug je Eintrag.

### Voll-Reset (Admin)
- Geführter Sicherheits-Reset mit expliziter Bestätigung (`RESET`).
- Löscht Protokoll und setzt alle Adressen auf Initialzustand zurück.
- Setzt zusätzlich Verifizierungs-/Website-Felder zurück und synchronisiert lokalen Cache.

---

## 19. Vollständigkeits-Check (Code vs. Doku)

Geprüft gegen [index.html](../index.html "Single-File App mit gesamter UI- und Feature-Logik") am 05.04.2026.

| Capability-Gruppe | In dieser Doku enthalten | Hinweis |
|---|---|---|
| Suche, Übernahme, Archiv, Karte | Ja | Kapitel 1-9 |
| Admin-Teamverwaltung & Rollenmodell | Ja | Kapitel 10, 14.1 |
| Verifizierung, Geo-Name, Sprache | Ja | Kapitel 11-13 |
| Performance, Sync, Mobile | Ja | Kapitel 15-16 |
| Einstellungen, E-Mail/Passphrase, Zwangswechsel | Ja | Kapitel 17 |
| Reports, Issues, Voll-Reset | Ja | Kapitel 18 |

Damit sind die aktuell produktiv sichtbaren Kernfunktionen der App in der Feature-Dokumentation abgedeckt.
