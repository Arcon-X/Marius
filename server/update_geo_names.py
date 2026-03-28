"""
Runs on the server via SSH. Connects locally to PostgreSQL, reverse-geocodes,
updates geo_name column. Uses only stdlib + requests (installed via pip).
"""
import json, sys, time
import subprocess

DB = "novumziv"

def psql(query, silent=False):
    r = subprocess.run(
        ["sudo", "-u", "postgres", "psql", "-t", "-A", "-d", DB, "-c", query],
        capture_output=True, text=True)
    if r.returncode != 0 and not silent:
        print(f"  DB-Fehler: {r.stderr.strip()}", file=sys.stderr)
    return r.stdout.strip()

# Load addresses
rows_raw = psql("SELECT id, lat, lon, strasse, hausnummer FROM adressen WHERE lat IS NOT NULL AND lon IS NOT NULL ORDER BY id;")
rows = [line.split("|") for line in rows_raw.splitlines() if "|" in line]
print(f"Adressen mit Koordinaten: {len(rows)}")

import urllib.request
updated = skipped = errors = 0

for i, parts in enumerate(rows):
    if len(parts) < 3:
        continue
    id_, lat, lon = parts[0], parts[1], parts[2]
    strasse = parts[3] if len(parts) > 3 else ""
    hnr = parts[4] if len(parts) > 4 else ""

    url = (f"https://nominatim.openstreetmap.org/reverse"
           f"?lat={lat}&lon={lon}&format=json&accept-language=de&zoom=18")
    req = urllib.request.Request(url, headers={"User-Agent": "NOVUM-ZIV-GeoUpdate/1.0"})
    try:
        with urllib.request.urlopen(req, timeout=12) as resp:
            data = json.loads(resp.read())
    except Exception as e:
        errors += 1
        if errors <= 5:
            print(f"  FEHLER curl: {strasse} {hnr}: {e}", file=sys.stderr)
        time.sleep(1.2)
        continue

    dn = data.get("display_name", "")
    if not dn:
        skipped += 1
        time.sleep(1.1)
        continue

    # Filter numeric-only parts, skip street name → show suburb/district
    dp = [p.strip() for p in dn.split(",")]
    meaningful = [p for p in dp if any(c.isalpha() for c in p)]
    geo_name = ", ".join(meaningful[1:3]) if len(meaningful) > 1 else (meaningful[0] if meaningful else "")

    if not geo_name:
        skipped += 1
        time.sleep(1.1)
        continue

    safe = geo_name.replace("'", "''")
    psql(f"UPDATE adressen SET geo_name = '{safe}' WHERE id = '{id_}';", silent=True)
    updated += 1

    if updated % 50 == 0 or i < 3:
        sys.stdout.flush()
        print(f"  [{i+1}/{len(rows)}] {strasse} {hnr} → {geo_name}")

    time.sleep(1.1)

print(f"\nFertig! Aktualisiert: {updated}, Übersprungen: {skipped}, Fehler: {errors}")
sys.stdout.flush()
