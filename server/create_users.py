#!/usr/bin/env python3
"""
NOVUM-ZIV — Benutzerkonten anlegen
Direkt auf dem Server ausführen: python3 create_users.py

Voraussetzung: psycopg2  →  pip install psycopg2-binary
Zugangsdaten aus /root/novumziv_credentials.txt lesen oder unten eintragen.
"""
import sys
import os
import getpass
import psycopg2
from psycopg2.extras import execute_values

# ── Konfiguration ─────────────────────────────────────────────
# Mit Zugangsdaten aus /root/novumziv_credentials.txt befüllen:
DB_HOST = "localhost"
DB_NAME = "novumziv"
DB_USER = "novumziv_user"
DB_PASS = os.getenv("NOVUMZIV_DB_PASS", "")
INITIAL_PASSWORD = os.getenv("NOVUMZIV_INITIAL_PASSWORD", "")

# ── Team (19 Kandidat:innen) ──────────────────────────────────
# Passwörter: Initial-Passwort, muss beim ersten Login geändert werden
# FORMAT: (email, name, rolle)
TEAM = [
    ("marius.romanin@bnz-wien.at",       "Dr. Marius Romanin",           "admin"),
    ("franz.hastermann@bnz-wien.at",     "OMR Dr. Franz Hastermann",      "mitarbeiter"),
    ("petra.drabo@bnz-wien.at",          "Drin Petra Drabo",              "mitarbeiter"),
    ("andreas.eder@bnz-wien.at",         "DDr. Andreas Eder",             "mitarbeiter"),
    ("barbara.thornton@bnz-wien.at",     "MRin DDrin Barbara Thornton",   "mitarbeiter"),
    ("eren.eryilmaz@bnz-wien.at",        "Dr. Eren Eryilmaz",             "mitarbeiter"),
    ("leon.golestani@bnz-wien.at",       "Dr. Leon Golestani BSc BA MA",  "mitarbeiter"),
    ("julia.glatz@bnz-wien.at",          "Drin Julia Stella Glatz",       "mitarbeiter"),
    ("andrietta.dossenbach@bnz-wien.at", "Drin Andrietta Dossenbach",     "mitarbeiter"),
    ("andrea.gamper@bnz-wien.at",        "Drin Andrea Gamper",            "mitarbeiter"),
    ("dino.imsirovic@bnz-wien.at",       "Dr. Dino Imsirovic",            "mitarbeiter"),
    ("gerhard.schager@bnz-wien.at",      "MR Dr. Gerhard Schager",        "mitarbeiter"),
    ("paul.inkofer@bnz-wien.at",         "Dr. Paul Inkofer",              "mitarbeiter"),
    ("andrea.bednar-brandt@bnz-wien.at", "Drin Andrea Bednar-Brandt",     "mitarbeiter"),
    ("anita.elmauthaler@bnz-wien.at",    "Drin Anita Elmauthaler",        "mitarbeiter"),
    ("petra.stuehlinger@bnz-wien.at",    "Drin Petra Stühlinger",         "mitarbeiter"),
    ("lama.hamisch@bnz-wien.at",         "Drin Lama Hamisch MSc",         "mitarbeiter"),
    ("otis.rezegh@bnz-wien.at",          "Dr. Otis Rezegh",               "mitarbeiter"),
    ("selma.husejnovic@bnz-wien.at",     "Drin Selma Husejnovic",         "mitarbeiter"),
]

# ─────────────────────────────────────────────────────────────

def main():
    if not DB_PASS:
        print("FEHLER: NOVUMZIV_DB_PASS nicht gesetzt.")
        print("Zugangsdaten aus /root/novumziv_credentials.txt als Env setzen.")
        sys.exit(1)

    if not INITIAL_PASSWORD:
        print("FEHLER: NOVUMZIV_INITIAL_PASSWORD nicht gesetzt.")
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

    for email, name, rolle in TEAM:
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
            (email, name, rolle, INITIAL_PASSWORD)
        )
        print(f"  ✓  {name:40s}  {email}")
        created += 1

    conn.commit()
    cur.close()
    conn.close()

    print(f"\n{'─'*60}")
    print(f"  Erstellt: {created}")
    print(f"  Übersprungen (bereits vorhanden): {skipped}")
    print(f"\n  Initial-Passwort fuer alle wurde aus NOVUMZIV_INITIAL_PASSWORD uebernommen.")
    print(f"  ⚠️  Bitte Passwörter nach dem ersten Login ändern!")
    print(f"{'─'*60}\n")

if __name__ == "__main__":
    main()
