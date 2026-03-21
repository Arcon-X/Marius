#!/usr/bin/env python3
"""
geocode_final.py
================
Dritter und letzter Versuch für die verbleibenden 120 Adressen.

Strategien (werden je Eintrag nacheinander probiert):
  1. Bekannte Tippfehler in der Straße korrigieren → mit erster HNr-Zahl
  2. Straße (korrigiert) + PLZ, OHNE Hausnummer
  3. Falls immer noch nichts: als unbekannt markieren

Ausführen (nach geocode_retry.py):
    python geocode_final.py

Danach: python generate_seed.py
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

# ── Bekannte Tippfehler-Korrekturen (falsch → richtig) ───────────────────────
TYPO_FIXES = {
    'Ameisbachzeiele':              'Ameisbachzeile',
    'Engertstraße':                 'Engerthstraße',
    'Engertsstraße':                'Engerthstraße',
    'Rresselgasse':                 'Resselgasse',
    'M0ßbachergasse':               'Moßbachergasse',
    'Thurngase':                    'Thurngasse',
    'Kirchengase':                  'Kirchengasse',
    'Nothargasse':                  'Nothartgasse',
    'Dornbacher Straßer':           'Dornbacher Straße',
    'Rampersdorfergasse':           'Ramperstorffergasse',
    'Rampersdorffergasse':          'Ramperstorffergasse',
    'Hintschigasse':                'Hintschiggasse',
    'Werdetorgasse':                'Werdertorgasse',
    'Wildpretmakrt':                'Wildpretmarkt',
    'Leonard Bernstein Straße':     'Leonhard Bernstein Straße',
    'Otoo Probst Straße':           'Otto Probst Straße',
    'Kaisertratze':                 'Kaiserstraße',
    'Erdberger Länder':             'Erdberger Lände',
    'Pernerstorfer Gasse':          'Pernerstorffergasse',
    'Skrauptstraße':                'Skraupachstraße',
    'Ziedlergasse':                 'Ziedlergasse',      # bleibt, kein Treffer
    'Schöllerhofgasse':             'Schöllerhofgasse',  # bleibt
    'Wopenkaststraße':              'Wopfnerstraße',
    'Knöllgasse':                   'Knöllgasse',        # PLZ-retry nötig
    'Laaerbergstraße':              'Laaer Berg Straße',
    'Leonhard Bernstein Straße':    'Leonhard-Bernstein-Straße',
    'Karl Popper Straße':           'Karl-Popper-Straße',
    'Hietzinger Kaie':              'Hietzinger Kai',
    'Marktgemeindegasse':           'Moosbrucker Gasse',  # 1230 fallback
    'Werdetorgasse 2':              'Werdertorgasse',
}


def fix_typo(strasse: str) -> str:
    """Gibt die korrigierte Straße zurück, falls ein Tippfehler bekannt ist."""
    return TYPO_FIXES.get(strasse, strasse)


def first_number(hnr: str) -> str | None:
    m = re.match(r'(\d+)', hnr.strip())
    return m.group(1) if m else None


def geocode(query: str) -> tuple[float | None, float | None]:
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
        print(f'    ⚠ Fehler: {e}')
    return None, None


def try_geocode_with_label(attempts: list[tuple[str, str]]) -> tuple[float | None, float | None, str]:
    """
    Versucht mehrere Queries nacheinander.
    Gibt (lat, lon, label) zurück — label beschreibt was gefunden hat.
    """
    for label, query in attempts:
        lat, lon = geocode(query)
        time.sleep(DELAY_S)
        if lat is not None:
            return lat, lon, label
    return None, None, ''


def main():
    if not os.path.exists(CHECKPOINT_PATH):
        print('FEHLER: adressen_geocoded.json nicht gefunden.')
        return

    with open(CHECKPOINT_PATH, encoding='utf-8') as f:
        all_entries = json.load(f)

    id_to_idx = {e['id']: i for i, e in enumerate(all_entries)}
    missing   = [e for e in all_entries if e['lat'] is None]
    print(f'▶ {len(missing)} Einträge noch ohne Koordinaten.\n')

    found_new   = 0
    still_none  = 0
    changed     = 0
    seen_keys   = {}  # (plz, strasse_fixed) → (lat, lon, notiz) für Duplikate

    for e in missing:
        strasse_orig  = e['strasse']
        strasse_fixed = fix_typo(strasse_orig)
        plz           = e['plz']
        hnr_orig      = e['hnr']
        hnr_simple    = first_number(hnr_orig)

        print(f'  [{e["id"]}] {strasse_orig} {hnr_orig}, {plz} → ', end='', flush=True)

        # Gleiche (bereinigte) Straße schon erfolgreich geocodiert?
        cache_key = f'{plz}|{strasse_fixed}'
        if cache_key in seen_keys and seen_keys[cache_key][0] is not None:
            lat, lon, notiz = seen_keys[cache_key]
            idx = id_to_idx[e['id']]
            all_entries[idx]['lat']   = lat
            all_entries[idx]['lon']   = lon
            all_entries[idx]['notiz'] = notiz + ' (Cache)'
            print(f'✓ Cache {lat:.5f}, {lon:.5f}')
            found_new += 1
            changed   += 1
            if changed % SAVE_EVERY == 0:
                _save(all_entries)
            continue

        # Versuche in Reihenfolge
        attempts = []

        if strasse_fixed != strasse_orig:
            # Tippfehler bekannt → zuerst mit korrigierter Straße + einfacher HNr
            if hnr_simple:
                attempts.append((
                    f'Straße korrigiert + HNr',
                    f'{strasse_fixed} {hnr_simple}, {plz} Wien, Österreich'
                ))
            # dann ohne HNr
            attempts.append((
                'Straße korrigiert, ohne HNr',
                f'{strasse_fixed}, {plz} Wien, Österreich'
            ))
        else:
            # Kein bekannter Tippfehler → nur ohne HNr versuchen
            if hnr_simple:
                attempts.append((
                    'Orig. Straße + HNr (nochmal)',
                    f'{strasse_orig} {hnr_simple}, {plz} Wien, Österreich'
                ))
            attempts.append((
                'Nur Straße + PLZ',
                f'{strasse_orig}, {plz} Wien, Österreich'
            ))

        lat, lon, label = try_geocode_with_label(attempts)

        if lat is not None:
            notiz = f'Geocoding-Hinweis: {label}'
            if strasse_fixed != strasse_orig:
                notiz += f' (Straße: {strasse_orig!r} → {strasse_fixed!r})'
            idx = id_to_idx[e['id']]
            all_entries[idx]['lat']   = lat
            all_entries[idx]['lon']   = lon
            all_entries[idx]['notiz'] = notiz
            seen_keys[cache_key] = (lat, lon, notiz)
            print(f'✓ {lat:.5f}, {lon:.5f}  [{label}]')
            found_new += 1
            changed   += 1
        else:
            seen_keys[cache_key] = (None, None, '')
            print('✗ nicht gefunden')
            still_none += 1

        if changed > 0 and changed % SAVE_EVERY == 0:
            _save(all_entries)

    _save(all_entries)

    total_found = sum(1 for e in all_entries if e['lat'] is not None)
    print(f'\n{"─"*60}')
    print(f'Final-Retry abgeschlossen!')
    print(f'  ✓ Neu geocodiert: {found_new}')
    print(f'  ✗ Endgültig unbekannt: {still_none}')
    print(f'  Gesamt mit Koordinaten: {total_found} / {len(all_entries)}')
    print(f'\nNächster Schritt: python generate_seed.py')


def _save(entries):
    with open(CHECKPOINT_PATH, 'w', encoding='utf-8') as f:
        json.dump(entries, f, ensure_ascii=False, indent=2)


if __name__ == '__main__':
    main()
