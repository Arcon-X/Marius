#!/usr/bin/env python3
"""
geocode_addresses.py
====================
Phase 1: Liest die Zahnärzteliste (Excel), geocodiert jede Adresse via
Nominatim (openstreetmap.org) und speichert das Ergebnis als JSON.

Kann jederzeit unterbrochen und ohne Datenverlust fortgesetzt werden —
Checkpoint wird nach jeweils 10 Einträgen gespeichert.

Excel-Format (Zahnarztekammer_260223_211026.xlsx):
  Sheet: 'Table 1', Zeile 1 = Header, Daten ab Zeile 2
  Spalte A: Name  — "Nachname Vorname (Titel.)"
  Spalte B: Kontaktdaten — "Straße HNr,  PLZ Wien [Telefon]"

Laufzeit: ~28 Minuten (1.491 Adressen × 1,1 Sekunden Rate-Limit)

Ausführen:
    python geocode_addresses.py

Ausgabe:
    adressen_geocoded.json   — Zwischenspeicher / finales Ergebnis
"""

import json
import os
import re
import sys
import time
import openpyxl
import urllib.request
import urllib.parse

# UTF-8 Ausgabe erzwingen (Windows-Terminal gibt sonst cp1252)
sys.stdout.reconfigure(encoding='utf-8')

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


def geocode(plz: str, full_addr: str, ort: str = 'Wien') -> tuple[float | None, float | None, str | None]:
    """
    Geocodiert eine Adresse via Nominatim.
    Gibt (lat, lon, geo_name) zurück oder (None, None, None) bei Fehler.
    geo_name: erster Teil des display_name (z.B. Gebäudename "Palais Equitable").
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
            raw_name = data[0].get('display_name', '').split(',')[0].strip()
            geo_name = raw_name if raw_name else None
            return float(data[0]['lat']), float(data[0]['lon']), geo_name
    except Exception as e:
        print(f'  ⚠ Fehler: {e}')
    return None, None, None


def safe_str(val) -> str:
    """Konvertiert None-Werte sicher in leeren String."""
    if val is None:
        return ''
    s = str(val).strip()
    return '' if s.lower() == 'none' else s


def parse_name(raw: str) -> tuple[str, str]:
    """
    Parst "Nachname Vorname (Titel.)" → (titel, "Vorname Nachname").
    Titel werden aus den Klammern extrahiert und dedupliziert.
    """
    raw = safe_str(raw)
    m = re.match(r'^(.+?)\s*\((.+?)\)\s*$', raw)
    if m:
        name_part = m.group(1).strip()
        title_raw = m.group(2).strip()
        # Titel: Komma-getrennt, dedupliziert
        seen: list[str] = []
        for t in title_raw.split(','):
            t = t.strip()
            if t and t not in seen:
                seen.append(t)
        titel = ' '.join(seen)
        # Name umdrehen: letztes Wort = Vorname, Rest = Nachname
        words = name_part.split()
        if len(words) >= 2:
            name = words[-1] + ' ' + ' '.join(words[:-1])
        else:
            name = name_part
    else:
        titel = ''
        name = raw
    return titel, name


def parse_address(raw: str) -> tuple[str, str, str]:
    """
    Parst "Straße HNr,  PLZ Wien [Telefon]" → (strasse, hnr, plz).
    Zeilenumbrüche (Telefonnummer kann umbrechen) werden normalisiert.
    """
    raw = safe_str(raw).replace('\n', ' ').replace('\r', ' ')
    if ',' in raw:
        addr_part, right_part = raw.split(',', 1)
    else:
        addr_part, right_part = raw, ''
    addr_part  = addr_part.strip()
    right_part = right_part.strip()
    # PLZ: vierstellige Wiener PLZ (10xx–12xx)
    plz_m = re.search(r'\b(1[0-9]{3})\b', right_part)
    plz   = plz_m.group(1) if plz_m else ''
    strasse, hnr = split_strasse_hnr(addr_part)
    return strasse, hnr, plz


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
    ws = wb['Table 1']

    # Alle Datenzeilen (ohne Header-Zeile 1), nur wo Name+Kontaktdaten vorhanden
    all_rows  = list(ws.iter_rows(values_only=True))
    data_rows = [r for r in all_rows[1:] if r[0] is not None and r[1] is not None]
    total = len(data_rows)
    print(f'▶ {total} Datenzeilen gefunden.\n')

    new_this_run = 0

    for idx, row in enumerate(data_rows):
        entry_id = f'a{idx + 1:04d}'

        if entry_id in done_ids:
            continue  # bereits verarbeitet → überspringen

        titel, name = parse_name(safe_str(row[0]))
        strasse, hnr, plz = parse_address(safe_str(row[1]))
        display = f'{titel} {name}'.strip() if titel else name

        print(f'[{idx + 1:4d}/{total}] {display:40s} | {strasse} {hnr}, {plz} Wien ... ',
              end='', flush=True)

        lat, lon, geo_name = geocode(plz, f'{strasse} {hnr}'.strip())

        entry = {
            'id':      entry_id,
            'plz':     plz,
            'strasse': strasse,
            'hnr':     hnr,
            'titel':   titel,
            'name':    name,
            'lat':     lat,
            'lon':     lon,
            'geo_name': geo_name,
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
