#!/usr/bin/env python3
import subprocess, sys

DB = "novumziv"
PG = ["sudo", "-u", "postgres", "psql", "-d", DB, "-c"]

def psql(sql):
    r = subprocess.run(PG + [sql], capture_output=True, text=True)
    print(r.stdout, r.stderr)
    return r.returncode

import bcrypt

# 1) Email des bestehenden Admins ändern
print("=== 1) Email update ===")
psql("UPDATE public.benutzer SET email='marius.romanin@aon.at' WHERE email='marius.romanin@bnz-wien.at';")

# 2) Neuen Admin erstellen
print("=== 2) Neuer Admin ===")
pw = "novum2026!"
h = bcrypt.hashpw(pw.encode(), bcrypt.gensalt(12)).decode()
sql = f"INSERT INTO public.benutzer (name, email, passwort_hash, rolle) VALUES ('Zahradnik', 'zahradnik@haselbach.art', '{h}', 'admin') ON CONFLICT (email) DO NOTHING;"
psql(sql)

# 3) Verifizieren
print("=== 3) Alle Admins ===")
psql("SELECT id, name, email, rolle FROM public.benutzer WHERE rolle='admin';")
