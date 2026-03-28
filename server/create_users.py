#!/usr/bin/env python3
"""
NOVUM-ZIV — Benutzerkonten anlegen
Direkt auf dem Server ausführen: python3 create_users.py

Voraussetzung: psycopg2  →  pip install psycopg2-binary
Zugangsdaten aus /root/novumziv_credentials.txt lesen oder unten eintragen.
"""
import sys
import getpass
import psycopg2
from psycopg2.extras import execute_values

# ── Konfiguration ─────────────────────────────────────────────
# Mit Zugangsdaten aus /root/novumziv_credentials.txt befüllen:
DB_HOST = "localhost"
DB_NAME = "novumziv"
DB_USER = "novumziv_user"
DB_PASS = "8dN8W83i8bH09zsjSaTU7reitw5NKvvk"

# ── Team (19 Kandidat:innen) ──────────────────────────────────
# Passwörter: Initial-Passwort, muss beim ersten Login geändert werden
# FORMAT: (email, name, rolle, initial_passwort)
TEAM = [
    ("marius.romanin@bnz-wien.at",       "Dr. Marius Romanin",           "admin",        "novum2026!"),
    ("franz.hastermann@bnz-wien.at",     "OMR Dr. Franz Hastermann",      "mitarbeiter",  "novum2026!"),
    ("petra.drabo@bnz-wien.at",          "Drin Petra Drabo",              "mitarbeiter",  "novum2026!"),
    ("andreas.eder@bnz-wien.at",         "DDr. Andreas Eder",             "mitarbeiter",  "novum2026!"),
    ("barbara.thornton@bnz-wien.at",     "MRin DDrin Barbara Thornton",   "mitarbeiter",  "novum2026!"),
    ("eren.eryilmaz@bnz-wien.at",        "Dr. Eren Eryilmaz",             "mitarbeiter",  "novum2026!"),
    ("leon.golestani@bnz-wien.at",       "Dr. Leon Golestani BSc BA MA",  "mitarbeiter",  "novum2026!"),
    ("julia.glatz@bnz-wien.at",          "Drin Julia Stella Glatz",       "mitarbeiter",  "novum2026!"),
    ("andrietta.dossenbach@bnz-wien.at", "Drin Andrietta Dossenbach",     "mitarbeiter",  "novum2026!"),
    ("andrea.gamper@bnz-wien.at",        "Drin Andrea Gamper",            "mitarbeiter",  "novum2026!"),
    ("dino.imsirovic@bnz-wien.at",       "Dr. Dino Imsirovic",            "mitarbeiter",  "novum2026!"),
    ("gerhard.schager@bnz-wien.at",      "MR Dr. Gerhard Schager",        "mitarbeiter",  "novum2026!"),
    ("paul.inkofer@bnz-wien.at",         "Dr. Paul Inkofer",              "mitarbeiter",  "novum2026!"),
    ("andrea.bednar-brandt@bnz-wien.at", "Drin Andrea Bednar-Brandt",     "mitarbeiter",  "novum2026!"),
    ("anita.elmauthaler@bnz-wien.at",    "Drin Anita Elmauthaler",        "mitarbeiter",  "novum2026!"),
    ("petra.stuehlinger@bnz-wien.at",    "Drin Petra Stühlinger",         "mitarbeiter",  "novum2026!"),
    ("lama.hamisch@bnz-wien.at",         "Drin Lama Hamisch MSc",         "mitarbeiter",  "novum2026!"),
    ("otis.rezegh@bnz-wien.at",          "Dr. Otis Rezegh",               "mitarbeiter",  "novum2026!"),
    ("selma.husejnovic@bnz-wien.at",     "Drin Selma Husejnovic",         "mitarbeiter",  "novum2026!"),
]

# ─────────────────────────────────────────────────────────────

def main():
    if not DB_PASS:
        print("FEHLER: DB_PASS nicht gesetzt. Bitte in create_users.py eintragen.")
        print("Zugangsdaten: /root/novumziv_credentials.txt")
        sys.exit(1)

    print(f"Verbinde mit {DB_NAME}@{DB_HOST}...")
    try:
        conn = psycopg2.connect(
            host=DB_HOST, dbname=DB_NAME,
            user=DB_USER, password=DB_PASS
        )
    except Exception as e:
        print(f"Verbindungsfehler: {e}")
        sys.exit(1)

    cur = conn.cursor()

    print(f"\n{len(TEAM)} Benutzer anlegen...\n")
    created = 0
    skipped = 0

    for email, name, rolle, pw in TEAM:
        # Prüfen ob bereits vorhanden
        cur.execute("SELECT id FROM benutzer WHERE email = %s", (email,))
        if cur.fetchone():
            print(f"  SKIP  {email} (bereits vorhanden)")
            skipped += 1
            continue

        # Passwort-Hash mit pgcrypto (bcrypt)
        cur.execute(
            "INSERT INTO benutzer (email, name, rolle, passwort_hash) "
            "VALUES (%s, %s, %s, crypt(%s, gen_salt('bf', 10)))",
            (email, name, rolle, pw)
        )
        print(f"  ✓  {name:40s}  {email}")
        created += 1

    conn.commit()
    cur.close()
    conn.close()

    print(f"\n{'─'*60}")
    print(f"  Erstellt: {created}")
    print(f"  Übersprungen (bereits vorhanden): {skipped}")
    print(f"\n  Initial-Passwort für alle: novum2026!")
    print(f"  ⚠️  Bitte Passwörter nach dem ersten Login ändern!")
    print(f"{'─'*60}\n")

if __name__ == "__main__":
    main()
