# UI Test Matrix (NOVUM-ZIV)

Ziel: Alle aus User-Sicht ausfuehrbaren Funktionen abdecken und erwartetes Verhalten pruefbar machen.

## 1. Login und Session

| ID | Funktion | Schritte | Erwartetes Verhalten |
|---|---|---|---|
| UI-001 | Login mit gueltigen Daten | App oeffnen, E-Mail + Passwort eingeben, Login | Session wird erstellt, Hauptnavigation sichtbar, Name/Rolle korrekt |
| UI-002 | Login mit falschem Passwort | Falsches Passwort eingeben | Fehlermeldung, kein Session-Token, kein Zugriff auf Tabs |
| UI-003 | Auto-Session-Reuse | Seite neu laden bei gueltiger Session | User bleibt eingeloggt |
| UI-004 | Logout | Logout ausfuehren | Session wird geloescht, Login-Screen sichtbar |
| UI-005 | Force Password Change | User mit erzwungenem PW-Wechsel einloggen | Overlay erscheint, ohne Abschluss kein normaler App-Zugriff |

## 2. Suche und Ergebnisliste (Tab "Suchen")

| ID | Funktion | Schritte | Erwartetes Verhalten |
|---|---|---|---|
| UI-010 | Standort setzen (GPS) | Standortfreigabe geben | Treffer werden nach Gehzeit geladen |
| UI-011 | Standort setzen (manuell) | Adresse eingeben, suchen | Treffer werden geladen, Sortierung nach Gehzeit |
| UI-012 | Ergebnislimit aendern | Slider/Dropdown auf 5/10/15 | Sichtbare Ergebnisanzahl passt sich an |
| UI-013 | Sprachfilter | Sprachchips/Filter wechseln | Nur passende Adressen bleiben sichtbar |
| UI-014 | Adresse uebernehmen | In Ergebnisliste "Uebernehmen" klicken | Status wird "in_bearbeitung", Adresse in "Meine" sichtbar |
| UI-015 | Doppel-Claim verhindern | Dieselbe Adresse parallel von zwei Usern uebernehmen | Genau ein User bekommt die Adresse, zweiter sieht Ablehnung/kein Erfolg |

## 3. Meine Adressen (Tab "Meine")

| ID | Funktion | Schritte | Erwartetes Verhalten |
|---|---|---|---|
| UI-020 | Eigene reservierte Liste | Tab "Meine" oeffnen | Nur eigene "in_bearbeitung" Adressen sichtbar |
| UI-021 | Adresse zurueckgeben | "Zurueckgeben" klicken | Status wird "verfuegbar", Badge reduziert sich |
| UI-022 | Ergebnis eintragen | "Ergebnis eintragen" oeffnen, Aktion waehlen, speichern | Status wird "archiviert", Protokolleintrag erstellt |
| UI-023 | Notiz speichern | Ergebnis mit Notiz speichern | Notiz in Archivkarte/Verlauf sichtbar |

## 4. Archiv und Statistik (Tab "Archiv")

| ID | Funktion | Schritte | Erwartetes Verhalten |
|---|---|---|---|
| UI-030 | Statistik-Chips | Archiv oeffnen | Gesamt/Verfuegbar/Reserviert/Waehlt uns korrekt |
| UI-031 | Ergebnis-Chart | Archiv oeffnen | 5 Kategorien mit korrekter Anzahl + Prozentwert |
| UI-032 | Ergebnis korrigieren | Archivierte Adresse oeffnen, Aktion wechseln, speichern | Alte Kategorie -1, neue Kategorie +1; keine Doppelzaehlung |
| UI-033 | Archivsuche | Sucheingabe setzen | Kartenliste wird korrekt gefiltert |
| UI-034 | Teamfilter (Admin) | Teammitglied im Dropdown waehlen | Nur Archivkarten dieses Users sichtbar |
| UI-035 | Verlauf anzeigen | "Verlauf" oeffnen | Historie pro Adresse zeitlich sortiert, inkl. Reaktivierung |
| UI-036 | Reaktivieren (Admin/Owner) | Reaktivieren klicken | Status zurueck auf "verfuegbar", alte Ergebnisse nicht mehr in Statistik |

## 5. Karte / Listenansicht (Tab "Karte")

| ID | Funktion | Schritte | Erwartetes Verhalten |
|---|---|---|---|
| UI-040 | Kartenanzeige | Karte oeffnen | Marker sichtbar, Farb-/Statuslogik korrekt |
| UI-041 | Listenansicht | Kartenmodus wechseln | Liste zeigt identische Datengrundlage wie Karte |
| UI-042 | Statusfilter | Filterchips nutzen | Nur passende Status-Eintraege sichtbar |
| UI-043 | PLZ-Filter | PLZ-Filter setzen | Nur Eintraege aus gewaehlter PLZ |

## 6. Adresse bearbeiten (Edit-Dialog)

| ID | Funktion | Schritte | Erwartetes Verhalten |
|---|---|---|---|
| UI-050 | Feldbearbeitung speichern | Titel/Name/Adresse etc. aendern, speichern | Daten lokal + Backend aktualisiert |
| UI-051 | Geocoding Erfolg | Gueltige Adresse speichern | lat/lon + geo_name aktualisiert, Erfolgshinweis sichtbar |
| UI-052 | Geocoding Misserfolg | Ungueltige Adresse speichern | Warnhinweis, alte Koordinaten bleiben bestehen |
| UI-053 | Snapshot-Historie | Adresse aendern, Historie pruefen | "bearbeitet" Snapshot mit alten Werten vorhanden |
| UI-054 | Snapshot wiederherstellen | Historie-Restore klicken und speichern | Alte Werte werden erneut gesetzt |

## 7. Adminbereich

| ID | Funktion | Schritte | Erwartetes Verhalten |
|---|---|---|---|
| UI-060 | Teamsektion anzeigen | Team aufklappen | Teamkarten + Kennzahlen korrekt |
| UI-061 | Letzte Ereignisse | Log-Sektion oeffnen | Juengste Protokolle in korrekter Reihenfolge |
| UI-062 | JSON-Export | Export klicken | JSON-Download startet |
| UI-063 | JSON-Import | Gueltige JSON importieren | Daten werden geladen und UI aktualisiert |
| UI-064 | JSON-Import invalid | Ungueltige JSON importieren | Valider Fehlerhinweis, kein Datenverlust |
| UI-065 | Voll-Reset (Admin) | Voll-Reset bestaetigen | Status/Reservierungen/Archiv werden erwartungsgemaess zurueckgesetzt |
| UI-066 | Doku-Links (Neu) | Admin > Dokumentationen > Oeffnen | Link oeffnet in neuem Tab und laedt .html Seite |
| UI-067 | Issues anlegen | Bug/Feature melden | Neuer Eintrag sichtbar in Liste |
| UI-068 | Issue status aendern | Issue auf erledigt setzen | Status gespeichert und korrekt dargestellt |

## 8. Rollen und Berechtigungen

| ID | Funktion | Schritte | Erwartetes Verhalten |
|---|---|---|---|
| UI-070 | Mitarbeiter-Rechte | Als mitarbeiter anmelden | Kein Admin-Tab, keine Admin-only Aktionen |
| UI-071 | Admin-Rechte | Als admin anmelden | Admin-Tab sichtbar, Admin-Aktionen verfuegbar |
| UI-072 | Reaktivieren Rechte | Als Fremd-Mitarbeiter reaktivieren versuchen | Aktion gesperrt, klare Rueckmeldung |

## 9. Smoke-Set (schnell pro Release)

- UI-001 Login ok
- UI-014 Uebernehmen
- UI-022 Ergebnis speichern
- UI-032 Ergebnis korrigieren (keine Doppelzaehlung)
- UI-036 Reaktivieren
- UI-066 Doku-Link oeffnet .html in neuem Tab

## 10. Optional: Automatisierung

Empfohlenes Tooling fuer spaetere Automatisierung:
- Playwright fuer End-to-End User-Flows
- Testdaten-Seed mit festen Demo-Usern
- Isolierte Testinstanz der API fuer reproduzierbare Resultate
