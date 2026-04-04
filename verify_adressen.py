"""
NOVUM-ZIV — Adress-Verifizierung via DuckDuckGo
Sucht für jede unverifizierte Adresse die offizielle Praxis-Website.
Läuft täglich als systemd-Timer (max. 100 Adressen pro Lauf).
Stoppt sich selbst wenn alle Adressen verifiziert sind.
"""
import requests, time, sys, json, base64, os, subprocess
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# ── Konfiguration ─────────────────────────────────────────────────────────────
API          = os.getenv("NOVUMZIV_API", "https://204.168.217.211.nip.io/api")
EMAIL        = os.getenv("NOVUMZIV_EMAIL", "zahradnik@haselbach.art")
PASS         = os.getenv("NOVUMZIV_PASS", "novum2026!")
BATCH_SIZE   = 100   # Max. Adressen pro Lauf
SEARCH_DELAY = 2.5   # Sekunden zwischen Suchanfragen (DDG Rate-Limit vermeiden)

# Domains die NICHT als offizielle Website gelten
EXCLUDED_DOMAINS = {
    "docfinder.at", "jameda.de", "herold.at", "1200.at",
    "ordinationen.at", "medonline.at", "gelbeseiten.at",
    "google.com", "google.at", "facebook.com", "instagram.com",
    "wikipedia.org", "bing.com", "duckduckgo.com", "yahoo.com",
    "maps.google.com", "apple.com", "linkedin.com", "xing.com",
    "medizin-transparent.at", "arztsuche.at", "doctolib.com",
    "sanego.de", "yelp.com", "oesterreich.at",
    # Spam-Domains aus DDG-Ergebnissen
    "zhihu.com", "baidu.com", "dr.dk", "dominos.co.in", "dominos.com",
    "nintendo.com", "ppc.io", "completeera.com", "support.nintendo.com",
    "cylex.at", "revieweuro.com", "aerzte.de", "gesund-info.eu",
    "oegp.at", "med.sfu.ac.at", "at.revieweuro.com",
    "youtube.com", "twitter.com", "tiktok.com", "reddit.com",
    "amazon.com", "amazon.de", "ebay.at", "ebay.de",
    "pinterest.com", "tumblr.com", "wordpress.com", "blogspot.com",
}

# Erlaubte TLDs für Zahnarzt-Websites in Wien
ALLOWED_TLDS = {".at", ".wien", ".de", ".com", ".eu", ".net", ".org", ".info"}

def is_excluded(url: str) -> bool:
    try:
        from urllib.parse import urlparse
        host = urlparse(url).netloc.lower().lstrip("www.")
        # Domain auf Blocklist?
        if any(host == d or host.endswith("." + d) for d in EXCLUDED_DOMAINS):
            return True
        # TLD prüfen — nur .at/.de/.com/.eu etc. zulassen
        tld = "." + host.rsplit(".", 1)[-1] if "." in host else ""
        if tld not in ALLOWED_TLDS:
            return True
        return False
    except Exception:
        return True

def _name_in_url(name: str, url: str) -> bool:
    """Prüft ob zumindest ein Nachname-Fragment in der URL vorkommt."""
    if not name:
        return False
    url_l = url.lower()
    # Nachnamen-Teile durchprobieren (z.B. "Henn-Schmidgruber" -> ["henn","schmidgruber"])
    parts = name.lower().replace("-", " ").replace("_", " ").split()
    return any(p in url_l for p in parts if len(p) >= 4)

def search_ddg(query: str) -> str | None:
    """DuckDuckGo-Suche. Gibt erste gültige URL zurück."""
    try:
        from duckduckgo_search import DDGS
        with DDGS() as ddgs:
            results = ddgs.text(query, max_results=10)
            for r in results:
                url = r.get("href") or r.get("url") or ""
                if url and not is_excluded(url):
                    return url
    except Exception as e:
        print(f"  DDG-Fehler: {e}", file=sys.stderr)
    return None

def find_website(titel: str, name: str, strasse: str, hnr: str) -> str | None:
    """Sucht offizielle Website via DuckDuckGo. Bevorzugt URLs mit Namens-Match."""
    parts = [p for p in [titel, name] if p]
    query = " ".join(parts + ["Zahnarzt", strasse, hnr, "Wien"])
    try:
        from duckduckgo_search import DDGS
        with DDGS() as ddgs:
            results = list(ddgs.text(query, max_results=10))
    except Exception as e:
        print(f"  DDG-Fehler: {e}", file=sys.stderr)
        return None
    # Pass 1: URL die den Nachnamen enthält
    for r in results:
        url = r.get("href") or r.get("url") or ""
        if url and not is_excluded(url) and _name_in_url(name, url):
            return url
    # Pass 2: Erste .at-Domain
    for r in results:
        url = r.get("href") or r.get("url") or ""
        if url and not is_excluded(url):
            from urllib.parse import urlparse
            host = urlparse(url).netloc.lower()
            if host.endswith(".at") or host.endswith(".wien"):
                return url
    return None

# ── Login ─────────────────────────────────────────────────────────────────────
print("Logging in...")
r = requests.post(f"{API}/rpc/login",
    json={"email": EMAIL, "passwort": PASS},
    verify=False, timeout=15)
r.raise_for_status()
token = r.json()["token"]

# User-ID aus JWT extrahieren
payload_b64 = token.split(".")[1]
payload_b64 += "=" * (4 - len(payload_b64) % 4)
user_id = json.loads(base64.b64decode(payload_b64)).get("user_id")

headers = {
    "Authorization": f"Bearer {token}",
    "Content-Type": "application/json",
    "Prefer": "return=minimal",
}
print(f"Login OK (user_id: {user_id})")

# ── Adressen laden ─────────────────────────────────────────────────────────────
print(f"Lade bis zu {BATCH_SIZE} unverifizierte Adressen...")
r = requests.get(
    f"{API}/adressen?verifiziert=is.false&arzt_name=not.is.null"
    f"&select=id,titel,arzt_name,strasse,hausnummer,plz,sprache,website,verifiziert"
    f"&order=id.asc&limit={BATCH_SIZE}",
    headers=headers, verify=False, timeout=30)
r.raise_for_status()
adressen = r.json()
print(f"  {len(adressen)} Adressen geladen")

if not adressen:
    print("Keine unverifizierte Adressen mehr — Timer wird deaktiviert.")
    subprocess.run(["systemctl", "disable", "--now", "verify-adressen.timer"],
                   capture_output=True)
    sys.exit(0)

# ── Verifizierung ──────────────────────────────────────────────────────────────
updated = skipped = errors = 0

for i, a in enumerate(adressen):
    titel     = a.get("titel") or ""
    name      = a.get("arzt_name") or ""
    strasse   = a.get("strasse") or ""
    hnr       = a.get("hausnummer") or ""
    addr_id   = a["id"]

    print(f"  [{i+1}/{len(adressen)}] {strasse} {hnr} — {titel} {name}".strip())

    try:
        website_url = find_website(titel, name, strasse, hnr)

        if not website_url:
            print(f"    -> Keine Website gefunden")
            skipped += 1
            time.sleep(SEARCH_DELAY)
            continue

        print(f"    -> {website_url}")

        # Snapshot der aktuellen Werte vor dem Überschreiben
        old_snap = {
            "titel":      a.get("titel"),
            "arzt_name":  a.get("arzt_name"),
            "strasse":    a.get("strasse"),
            "hausnummer": a.get("hausnummer"),
            "plz":        a.get("plz"),
            "website":    a.get("website"),
            "verifiziert": a.get("verifiziert", False),
        }
        snap_ok = requests.post(
            f"{API}/protokoll",
            headers=headers,
            json={
                "adressen_id": addr_id,
                "benutzer_id": user_id,
                "aktion":      "bearbeitet",
                "notiz":       json.dumps({"old": old_snap, "source": "verify",
                                           "website_found": website_url}),
            },
            verify=False, timeout=10)
        if not snap_ok.ok:
            print(f"    Snapshot-Warnung: {snap_ok.status_code}", file=sys.stderr)

        # PATCH: website + verifiziert=true
        pr = requests.patch(
            f"{API}/adressen?id=eq.{addr_id}",
            headers=headers,
            json={"website": website_url, "verifiziert": True},
            verify=False, timeout=10)
        pr.raise_for_status()
        updated += 1

    except Exception as e:
        errors += 1
        print(f"    FEHLER: {e}", file=sys.stderr)

    time.sleep(SEARCH_DELAY)

# ── Verbleibende zählen ────────────────────────────────────────────────────────
r2 = requests.get(
    f"{API}/adressen?verifiziert=is.false&arzt_name=not.is.null&select=id&limit=1",
    headers=headers, verify=False, timeout=15)
remaining_any = len(r2.json()) if r2.ok else "?"

print(f"\nFertig! Aktualisiert: {updated}, Nicht gefunden: {skipped}, Fehler: {errors}")

if remaining_any == 0:
    print("Alle Adressen verifiziert! Timer wird deaktiviert.")
    subprocess.run(["systemctl", "disable", "--now", "verify-adressen.timer"],
                   capture_output=True)
else:
    print(f"Noch unverifizierte Adressen vorhanden — weiter morgen um 03:00 Uhr.")
