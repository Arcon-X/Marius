"""
NOVUM-ZIV — geo_name Massenaktualisierung via PostgREST API
Liest alle Adressen mit Koordinaten, reverse-geocodet via Nominatim,
filtert numerische Teile heraus → zeigt Viertel/Bezirk statt Straßenname.
"""
import requests, time, sys
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

API = "https://204.168.217.211.nip.io/api"
EMAIL = "zahradnik@haselbach.art"
PASS = "Artcecil1975"

# ── 1. Login ─────────────────────────────────────────────────────────────────
print("Logging in...")
r = requests.post(f"{API}/rpc/login",
    json={"email": EMAIL, "passwort": PASS},
    verify=False, timeout=15)
r.raise_for_status()
token = r.json()["token"]
headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json",
           "Prefer": "return=representation"}
print("Login OK")

# ── 2. Alle Adressen mit Koordinaten laden ────────────────────────────────────
print("Lade Adressen...")
r = requests.get(f"{API}/adressen?lat=not.is.null&select=id,lat,lon,strasse,hausnummer",
    headers=headers, verify=False, timeout=30)
r.raise_for_status()
adressen = r.json()
print(f"  {len(adressen)} Adressen mit Koordinaten gefunden")

# ── 3. Reverse Geocoding + Update ─────────────────────────────────────────────
updated = skipped = errors = 0

for i, a in enumerate(adressen):
    try:
        resp = requests.get(
            "https://nominatim.openstreetmap.org/reverse",
            params={"lat": a["lat"], "lon": a["lon"],
                    "format": "json", "accept-language": "de", "zoom": 18},
            headers={"User-Agent": "NOVUM-ZIV-GeoUpdate/1.0"},
            timeout=12)
        resp.raise_for_status()
        data = resp.json()
        dn = data.get("display_name", "")
        if not dn:
            skipped += 1
            time.sleep(1.1)
            continue

        parts = [p.strip() for p in dn.split(",")]
        # Rein-numerische Teile raus, dann Straße überspringen → Viertel/Bezirk
        meaningful = [p for p in parts if any(c.isalpha() for c in p)]
        geo_name = ", ".join(meaningful[0:3]) if meaningful else ""

        # Falls erstes Segment == Straßenname der Adresse → weglassen
        gn_parts = [p.strip() for p in geo_name.split(",")]
        if gn_parts and gn_parts[0].lower() == a.get("strasse", "").strip().lower():
            gn_parts = gn_parts[1:]
        geo_name = ", ".join(gn_parts).strip()

        if not geo_name:
            skipped += 1
            time.sleep(1.1)
            continue

        # PATCH via PostgREST
        pr = requests.patch(f"{API}/adressen?id=eq.{a['id']}",
            headers=headers, json={"geo_name": geo_name},
            verify=False, timeout=10)
        pr.raise_for_status()
        updated += 1

        if updated % 25 == 0 or i < 3:
            print(f"  [{i+1}/{len(adressen)}] {a['strasse']} {a.get('hausnummer','')} -> {geo_name}")

    except Exception as e:
        errors += 1
        print(f"  FEHLER {a['strasse']} {a.get('hausnummer','')}: {e}", file=sys.stderr)

    time.sleep(1.1)  # Nominatim rate limit

print(f"\nFertig! Aktualisiert: {updated}, Übersprungen: {skipped}, Fehler: {errors}")
