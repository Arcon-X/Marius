#!/usr/bin/env python3
"""
geocode_addresses.py
====================
Phase 1: Liest die Zahnärzteliste (Excel), geocodiert jede Adresse via
Nominatim (openstreetmap.org) und speichert das Ergebnis als JSON.

Kann jederzeit unterbrochen und ohne Datenverlust fortgesetzt werden —
Checkpoint wird nach jeweils 10 Einträgen gespeichert.

Laufzeit: ~45 Minuten (2.692 Adressen × 1 Sekunde Rate-Limit)

Ausführen:
    python geocode_addresses.py

Ausgabe:
    adressen_geocoded.json   — Zwischenspeicher / finales Ergebnis
"""

import json
import os
import re
import time
import openpyxl
import urllib.request
import urllib.parse

# ── Konfiguration ─────────────────────────────────────────────────────────────
BASE_DIR        = r'D:\GIT\Marius'
CHECKPOINT_PATH = os.path.join(BASE_DIR, 'adressen_geocoded.json')
NOMINATIM_URL   = 'https://nominatim.openstreetmap.org/search'
USER_AGENT      = 'NOVUM-ZIV-Import/1.0 (zahnaerztekammerwahl-wien-2026)'
DELAY_S         = 1.1   # Nominatim Policy: max 1 req/s — etwas mehr für Sicherheit
SAVE_EVERY      = 10    # Checkpoint-Intervall


# ── Hilfsfunktionen ───────────────────────────────────────────────────────────
def split_strasse_hnr(full_addr: str) -> tuple[str, str]:
    """
    Trennt kombinierte Adresse ("Jägerstraße 23/4") in
    Straße ("Jägerstraße") und Hausnummer ("23/4").

    Österreichisches Format: Hausnummer beginnt immer mit einer Ziffer.
    Fallback: letztes Leerzeichen-getrennte Token als Hausnummer.
    """
    addr = str(full_addr).strip()
    # Hausnummer: letztes Token, das mit einer Ziffer beginnt
    m = re.match(r'^(.+?)\s+(\d\S*)$', addr)
    if m:
        return m.group(1).strip(), m.group(2).strip()
    # Fallback (z.B. "sa/1/14" ohne führende Ziffer) → rsplit
    parts = addr.rsplit(' ', 1)
    if len(parts) == 2:
        return parts[0].strip(), parts[1].strip()
    return addr, ''


def geocode(plz: str, full_addr: str, ort: str = 'Wien') -> tuple[float | None, float | None]:
    """
    Geocodiert eine Adresse via Nominatim.
    Gibt (lat, lon) zurück oder (None, None) bei Fehler.
    """
    query = f'{full_addr}, {plz} {ort}, Österreich'
    params = urllib.parse.urlencode({
        'q':            query,
        'format':       'json',
        'limit':        1,
        'countrycodes': 'at',
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


def safe_str(val) -> str:
    """Konvertiert None-Werte sicher in leeren String."""
    if val is None:
        return ''
    s = str(val).strip()
    return '' if s.lower() == 'none' else s


# ── Hauptprogramm ─────────────────────────────────────────────────────────────
def main():
    # Checkpoint laden (falls vorhanden → Fortsetzung)
    if os.path.exists(CHECKPOINT_PATH):
        with open(CHECKPOINT_PATH, encoding='utf-8') as f:
            results = json.load(f)
        done_ids = {r['id'] for r in results}
        found_so_far = sum(1 for r in results if r['lat'] is not None)
        print(f'▶ Checkpoint gefunden: {len(results)} bereits verarbeitet '
              f'({found_so_far} geocodiert, '
              f'{len(results) - found_so_far} nicht gefunden).')
    else:
        results  = []
        done_ids = set()
        print('▶ Kein Checkpoint — starte von vorne.')

    # Excel laden
    fnames = [f for f in os.listdir(BASE_DIR)
              if f.endswith('.xlsx') and not f.startswith('~')]
    if not fnames:
        raise FileNotFoundError('Keine .xlsx-Datei in D:\\GIT\\Marius gefunden.')
    fpath = os.path.join(BASE_DIR, fnames[0])
    print(f'▶ Lade Excel: {fnames[0]}')

    wb = openpyxl.load_workbook(fpath, read_only=True, data_only=True)
    ws = wb['Auswertung']

    # Alle Datenzeilen (ohne Header), nur wo PLZ vorhanden
    all_rows = list(ws.iter_rows(values_only=True))
    data_rows = [r for r in all_rows[1:] if r[3] is not None]
    total = len(data_rows)
    print(f'▶ {total} Datenzeilen gefunden.\n')

    new_this_run = 0

    for idx, row in enumerate(data_rows):
        entry_id = f'a{idx + 1:04d}'

        if entry_id in done_ids:
            continue  # bereits verarbeitet → überspringen

        titel     = safe_str(row[0])
        nachname  = safe_str(row[1])
        vorname   = safe_str(row[2])
        plz_raw   = row[3]
        ort       = safe_str(row[4]) or 'Wien'
        full_addr = safe_str(row[5])

        # PLZ als 4-stelligen String (Excel speichert als int)
        try:
            plz = str(int(plz_raw))
        except (ValueError, TypeError):
            plz = safe_str(plz_raw)

        strasse, hnr = split_strasse_hnr(full_addr)
        name = f'{vorname} {nachname}'.strip()
        display = f'{titel} {name}'.strip() if titel else name

        print(f'[{idx + 1:4d}/{total}] {display:40s} | {full_addr}, {plz} {ort} ... ',
              end='', flush=True)

        lat, lon = geocode(plz, full_addr, ort)

        entry = {
            'id':      entry_id,
            'plz':     plz,
            'strasse': strasse,
            'hnr':     hnr,
            'titel':   titel,
            'name':    name,
            'lat':     lat,
            'lon':     lon,
        }

        if lat is not None:
            print(f'✓ {lat:.5f}, {lon:.5f}')
        else:
            print('✗ nicht gefunden')

        results.append(entry)
        done_ids.add(entry_id)
        new_this_run += 1

        # Checkpoint speichern
        if new_this_run % SAVE_EVERY == 0:
            with open(CHECKPOINT_PATH, 'w', encoding='utf-8') as f:
                json.dump(results, f, ensure_ascii=False, indent=2)

        time.sleep(DELAY_S)

    # Finales Speichern
    with open(CHECKPOINT_PATH, 'w', encoding='utf-8') as f:
        json.dump(results, f, ensure_ascii=False, indent=2)

    found    = sum(1 for r in results if r['lat'] is not None)
    not_found = len(results) - found
    print(f'\n{"─"*60}')
    print(f'Fertig! Gesamt: {len(results)}')
    print(f'  ✓ Geocodiert:    {found}')
    print(f'  ✗ Nicht gefunden: {not_found}')
    print(f'  Gespeichert in:  {CHECKPOINT_PATH}')
    print(f'\nNächster Schritt: python generate_seed.py')


if __name__ == '__main__':
    main()
