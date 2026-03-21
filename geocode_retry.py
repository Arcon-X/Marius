#!/usr/bin/env python3
"""
geocode_retry.py
================
Zweiter Versuch für die 341 nicht-geocodierten Adressen.

Strategie: Hausnummer wird auf die erste Ziffernfolge vereinfacht.
  Beispiele:
    31-33/2/7  → 31
    18-24/19   → 18
    47/2/13    → 47
    83/3-4     → 83
    sa/1/14    → kein Treffer (keine führende Zahl) → wird übersprungen

Erfolgreiche Einträge erhalten das Feld  notiz: "HNr. vereinfacht für Geocoding"
und werden in adressen_geocoded.json aktualisiert.

Ausführen (nach geocode_addresses.py):
    python geocode_retry.py

Danach nochmals generate_seed.py ausführen, um index.md+SQL zu aktualisieren.
"""

import json
import os
import re
import time
import urllib.request
import urllib.parse

BASE_DIR        = r'D:\GIT\Marius'
CHECKPOINT_PATH = os.path.join(BASE_DIR, 'adressen_geocoded.json')
NOMINATIM_URL   = 'https://nominatim.openstreetmap.org/search'
USER_AGENT      = 'NOVUM-ZIV-Import/1.0 (zahnaerztekammerwahl-wien-2026)'
DELAY_S         = 1.1
SAVE_EVERY      = 10


def first_number(hnr: str) -> str | None:
    """Extrahiert die erste Ziffernfolge aus einer Hausnummer."""
    m = re.match(r'(\d+)', hnr.strip())
    return m.group(1) if m else None


def geocode(plz: str, strasse: str, hnr: str, ort: str = 'Wien') -> tuple[float | None, float | None]:
    query = f'{strasse} {hnr}, {plz} {ort}, Österreich'
    params = urllib.parse.urlencode({
        'q':             query,
        'format':        'json',
        'limit':         1,
        'countrycodes':  'at',
        'addressdetails': 0,
    })
    url = f'{NOMINATIM_URL}?{params}'
    req = urllib.request.Request(url, headers={'User-Agent': USER_AGENT})
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = json.loads(resp.read().decode())
        if data:
            return float(data[0]['lat']), float(data[0]['lon'])
    except Exception as e:
        print(f'  ⚠ Fehler: {e}')
    return None, None


def main():
    if not os.path.exists(CHECKPOINT_PATH):
        print(f'FEHLER: {CHECKPOINT_PATH} nicht gefunden.')
        print('Bitte zuerst geocode_addresses.py ausführen.')
        return

    with open(CHECKPOINT_PATH, encoding='utf-8') as f:
        all_entries = json.load(f)

    # Index für schnellen Zugriff
    id_to_idx = {e['id']: i for i, e in enumerate(all_entries)}

    skipped = [e for e in all_entries if e['lat'] is None]
    print(f'▶ {len(skipped)} Einträge ohne Koordinaten — starte Retry mit vereinfachter HNr.\n')

    found_new  = 0
    still_none = 0
    no_digit   = 0
    already_tried = set()  # verhindert Doppelversuche bei gleicher Adresse
    changed    = 0

    for e in skipped:
        simplified = first_number(e['hnr'])

        if simplified is None:
            # z.B. "sa/1/14" — keine führende Ziffer
            no_digit += 1
            print(f'  [{e["id"]}] {e["strasse"]} {e["hnr"]} → keine Zahl, übersprungen')
            continue

        if simplified == e['hnr']:
            # HNr war bereits einfach (z.B. "155"), Nominatim hat es schon versucht
            # Trotzdem nochmal versuchen — vielleicht Tippfehler in der Straße
            pass

        key = f'{e["plz"]}|{e["strasse"]}|{simplified}'
        if key in already_tried:
            # Gleiche vereinfachte Adresse schon versucht (z.B. mehrere Ärzte, gleiche Praxis)
            # Ergebnis aus already_found übertragen falls vorhanden
            continue
        already_tried.add(key)

        print(f'  [{e["id"]}] {e["strasse"]} {e["hnr"]} → vereinfacht zu "{simplified}" ... ', end='', flush=True)
        lat, lon = geocode(e['plz'], e['strasse'], simplified)

        if lat is not None:
            print(f'✓ {lat:.5f}, {lon:.5f}')
            found_new += 1
            # Alle Einträge mit gleicher orig. Adresse + gleicher vereinfachter HNr updaten
            for e2 in skipped:
                if (e2['plz'] == e['plz'] and
                        e2['strasse'] == e['strasse'] and
                        first_number(e2['hnr']) == simplified and
                        e2['lat'] is None):
                    idx = id_to_idx[e2['id']]
                    all_entries[idx]['lat']   = lat
                    all_entries[idx]['lon']   = lon
                    all_entries[idx]['notiz'] = f'HNr. vereinfacht: {e2["hnr"]} → {simplified}'
                    changed += 1
        else:
            print('✗ immer noch nicht gefunden')
            still_none += 1

        if changed > 0 and changed % SAVE_EVERY == 0:
            with open(CHECKPOINT_PATH, 'w', encoding='utf-8') as f:
                json.dump(all_entries, f, ensure_ascii=False, indent=2)

        time.sleep(DELAY_S)

    # Finales Speichern
    with open(CHECKPOINT_PATH, 'w', encoding='utf-8') as f:
        json.dump(all_entries, f, ensure_ascii=False, indent=2)

    total_found = sum(1 for e in all_entries if e['lat'] is not None)
    print(f'\n{"─"*60}')
    print(f'Retry abgeschlossen!')
    print(f'  ✓ Neu geocodiert (Einträge):  {changed}')
    print(f'  ✗ Immer noch nicht gefunden:  {still_none}')
    print(f'  ⊘ Keine Ziffer in HNr:        {no_digit}')
    print(f'  Gesamt mit Koordinaten jetzt: {total_found} / {len(all_entries)}')
    print(f'\nNächster Schritt: python generate_seed.py')


if __name__ == '__main__':
    main()
