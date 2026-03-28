#!/usr/bin/env python3
"""
generate_seed.py
================
Phase 2+3: Liest adressen_geocoded.json und

  A) ersetzt SEED_ADRESSEN in index.md mit allen echten Adressen
  B) erzeugt import.sql für den PostgreSQL-Import (Anexia-Server)

Nur Adressen MIT gültigen Koordinaten werden übernommen.
Adressen ohne Koordinaten werden in 'adressen_ohne_koordinaten.txt' gelistet.

Ausführen (nach geocode_addresses.py):
    python generate_seed.py
"""

import json
import os
import re
from datetime import datetime

BASE_DIR          = r'D:\GIT\Marius'
CHECKPOINT_PATH   = os.path.join(BASE_DIR, 'adressen_geocoded.json')
INDEX_PATH        = os.path.join(BASE_DIR, 'index.md')
SQL_EXPORT_PATH   = os.path.join(BASE_DIR, 'import.sql')
SKIPPED_LOG_PATH  = os.path.join(BASE_DIR, 'adressen_ohne_koordinaten.txt')

# Regex-Marker im index.md für den SEED_ADRESSEN-Block
SEED_START = 'const SEED_ADRESSEN = ['
SEED_END   = '];'


def js_str(s: str) -> str:
    """Escaped einen String für JavaScript-Einsatz (einfache Anführungszeichen)."""
    return s.replace('\\', '\\\\').replace("'", "\\'")


def build_js_array(entries: list[dict]) -> str:
    """Baut den JS-Array-String für SEED_ADRESSEN."""
    lines = ['const SEED_ADRESSEN = [']
    for e in entries:
        lat = f"{e['lat']:.5f}"
        lon = f"{e['lon']:.5f}"
        line = (
            f"  {{id:'{js_str(e['id'])}'"
            f",plz:'{js_str(e['plz'])}'"
            f",strasse:'{js_str(e['strasse'])}'"
            f",hnr:'{js_str(e['hnr'])}'"
            f",titel:'{js_str(e['titel'])}'"
            f",name:'{js_str(e['name'])}'"
            f",lat:{lat},lon:{lon}}},"
        )
        lines.append(line)
    lines.append('];')
    return '\n'.join(lines)


def build_sql(entries: list[dict]) -> str:
    """Baut die PostgreSQL-INSERT-Statements."""
    now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    lines = [
        f"-- NOVUM-ZIV Adress-Import — generiert am {now}",
        f"-- {len(entries)} Adressen aus 'Zahnärzteliste NUR Adressen - Stand April 2021.xlsx'",
        "",
        "BEGIN;",
        "",
        "-- Bestehende Demo-Daten löschen",
        "TRUNCATE TABLE protokoll;",
        "TRUNCATE TABLE adressen CASCADE;",
        "",
        "-- Neue Adressen einfügen",
        "INSERT INTO adressen (id, plz, ort, strasse, hausnummer, zusatz, lat, lon, titel, arzt_name, geo_name, import_batch) VALUES",
    ]

    value_lines = []
    for e in entries:
        def q(s): return s.replace("'", "''") if s else ''
        # Zusatz: alles nach "/" in der Hausnummer (z.B. "23/4" → Tür "4")
        hnr_parts = e['hnr'].split('/', 1)
        hnr_clean = hnr_parts[0].strip()
        zusatz    = hnr_parts[1].strip() if len(hnr_parts) > 1 else ''

        geo_name = e.get('geo_name') or ''
        val = (
            f"  (uuid_generate_v4(), "
            f"'{q(e['plz'])}', 'Wien', "
            f"'{q(e['strasse'])}', "
            f"'{q(hnr_clean)}', "
            f"{'NULL' if not zusatz else chr(39) + q(zusatz) + chr(39)}, "
            f"{e['lat']}, {e['lon']}, "
            f"{'NULL' if not e['titel'] else chr(39) + q(e['titel']) + chr(39)}, "
            f"'{q(e['name'])}', "
            f"{'NULL' if not geo_name else chr(39) + q(geo_name) + chr(39)}, "
            f"'import_april_2021')"
        )
        value_lines.append(val)

    lines.append(',\n'.join(value_lines) + ';')
    lines.append('')
    lines.append('COMMIT;')
    lines.append('')
    lines.append(f'-- Ergebnis prüfen:')
    lines.append(f"SELECT COUNT(*) FROM adressen;  -- Soll: {len(entries)}")
    return '\n'.join(lines)


def update_index_md(js_array: str) -> None:
    """Ersetzt den SEED_ADRESSEN-Block in index.md."""
    with open(INDEX_PATH, encoding='utf-8') as f:
        content = f.read()

    # Finde Start und Ende des SEED_ADRESSEN-Blocks
    start_pos = content.find(SEED_START)
    if start_pos == -1:
        raise ValueError(f'"{SEED_START}" nicht in index.md gefunden!')

    # Finde das schließende ]; nach dem Start
    # Suche nach "];" am Anfang einer Zeile (nach dem Block)
    end_search_start = start_pos + len(SEED_START)
    end_pattern = re.compile(r'\n\];', re.MULTILINE)
    m = end_pattern.search(content, end_search_start)
    if not m:
        raise ValueError('Kein schließendes "];" für SEED_ADRESSEN gefunden!')

    end_pos = m.end()  # Position nach dem schließenden ];

    new_content = content[:start_pos] + js_array + content[end_pos:]

    with open(INDEX_PATH, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print(f'  ✓ index.md aktualisiert.')


def main():
    # Checkpoint laden
    if not os.path.exists(CHECKPOINT_PATH):
        print(f'FEHLER: {CHECKPOINT_PATH} nicht gefunden.')
        print('Bitte zuerst geocode_addresses.py ausführen.')
        return

    with open(CHECKPOINT_PATH, encoding='utf-8') as f:
        all_entries = json.load(f)

    print(f'▶ {len(all_entries)} Einträge geladen.')

    # Aufteilen: mit/ohne Koordinaten
    valid   = [e for e in all_entries if e['lat'] is not None and e['lon'] is not None]
    skipped = [e for e in all_entries if e['lat'] is None or e['lon'] is None]

    print(f'  ✓ Mit Koordinaten:    {len(valid)}')
    print(f'  ✗ Ohne Koordinaten:   {len(skipped)}')

    if not valid:
        print('FEHLER: Keine Einträge mit Koordinaten. Bitte geocode_addresses.py zuerst vollständig ausführen.')
        return

    # ── Phase 2: index.md aktualisieren ─────────────────────────────────────
    print(f'\n▶ Phase 2: index.md aktualisieren ...')
    js_array = build_js_array(valid)
    update_index_md(js_array)
    print(f'  {len(valid)} Adressen in SEED_ADRESSEN geschrieben.')

    # ── Phase 3: SQL-Export ──────────────────────────────────────────────────
    print(f'\n▶ Phase 3: SQL-Export generieren ...')
    sql = build_sql(valid)
    with open(SQL_EXPORT_PATH, 'w', encoding='utf-8') as f:
        f.write(sql)
    print(f'  ✓ {SQL_EXPORT_PATH}')

    # ── Nicht-gefundene Adressen loggen ─────────────────────────────────────
    if skipped:
        with open(SKIPPED_LOG_PATH, 'w', encoding='utf-8') as f:
            f.write(f'Adressen ohne Koordinaten ({len(skipped)} Stück)\n')
            f.write('=' * 60 + '\n\n')
            for e in skipped:
                f.write(f"[{e['id']}] {e.get('titel','')} {e.get('name','')} | "
                        f"{e.get('strasse','')} {e.get('hnr','')} {e.get('plz','')} Wien\n")
        print(f'\n  ⚠ {len(skipped)} Adressen ohne Koordinaten → {SKIPPED_LOG_PATH}')

    print(f'\n{"─"*60}')
    print(f'Fertig! Nächster Schritt:')
    print(f'  git add index.md import.sql')
    print(f'  git commit -m "Echte Adressen: {len(valid)} Zahnärzte importiert"')
    print(f'  git push')


if __name__ == '__main__':
    main()
