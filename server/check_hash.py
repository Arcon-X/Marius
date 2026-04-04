#!/usr/bin/env python3
import os
import subprocess, bcrypt

DB = "novumziv"

r = subprocess.run(
    ["sudo", "-u", "postgres", "psql", "-d", DB, "-t", "-c",
     "SELECT email, passwort_hash FROM public.benutzer WHERE rolle='admin';"],
    capture_output=True, text=True
)
print(r.stdout)

# Passwort gegen beide Hashes prüfen
pw = os.getenv("CHECK_PASSWORD")
if not pw:
    raise SystemExit("CHECK_PASSWORD muss als Umgebungsvariable gesetzt sein.")
for line in r.stdout.strip().splitlines():
    parts = [p.strip() for p in line.split("|")]
    if len(parts) == 2:
        email, h = parts
        ok = bcrypt.checkpw(pw.encode(), h.encode())
        print(f"{email}: hash_len={len(h)}, starts={h[:7]}, pw_ok={ok}")
