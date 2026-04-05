---
title: "NOVUM-ZIV — Domain konfigurieren"
---

<style>
.site-header { display: none !important; }
.neu {
  border-left: 4px solid #2da44e;
  background: #dafbe1;
  padding: .6rem 1rem;
  margin: .8rem 0;
  border-radius: 4px;
}
.warn {
  border-left: 4px solid #d1242f;
  background: #ffebe9;
  padding: .6rem 1rem;
  margin: .8rem 0;
  border-radius: 4px;
}
.info {
  border-left: 4px solid #0969da;
  background: #ddf4ff;
  padding: .6rem 1rem;
  margin: .8rem 0;
  border-radius: 4px;
}
code { background: #f6f8fa; padding: 2px 6px; border-radius: 3px; font-size: .9em; }
pre code { background: none; padding: 0; }
table { border-collapse: collapse; width: 100%; margin: 1rem 0; }
th, td { border: 1px solid #d0d7de; padding: .5rem .8rem; text-align: left; }
th { background: #f6f8fa; }
.doc-nav { position: sticky; top: .5rem; z-index: 20; background: #fff; border: 1px solid #d0d7de; border-radius: 10px; padding: .7rem; margin: .2rem 0 1rem 0; box-shadow: 0 2px 8px rgba(0,0,0,.05); }
.doc-nav-title { font-size: .8rem; color: #57606a; font-weight: 700; margin-bottom: .45rem; }
.doc-nav-links { display: flex; gap: .4rem; overflow-x: auto; padding-bottom: .15rem; }
.doc-nav-links a { text-decoration: none; border: 1px solid #d0d7de; background: #f6f8fa; color: #24292f; border-radius: 999px; padding: .32rem .72rem; white-space: nowrap; font-size: .82rem; font-weight: 600; }
.doc-nav-links a.active { background: #1f6feb; border-color: #1f6feb; color: #fff; }
.doc-nav-links a:focus-visible { outline: 2px solid #1f6feb; outline-offset: 2px; }
</style>

# NOVUM-ZIV — Domain konfigurieren

<div class="doc-nav" role="navigation" aria-label="Dokumentationsnavigation">
  <div class="doc-nav-title">Dokumentation</div>
  <div class="doc-nav-links">
    <a href="/docs/index.html" title="Startseite mit gefuehrtem Lesefluss">Hub</a>
    <a href="/SPEC.html" title="Gesamtspezifikation fuer End-to-End Details">SPEC</a>
    <a href="/docs/technik.html" title="Technische Architektur, Betrieb und Sicherheit">Technik</a>
    <a href="/docs/db_model.html" title="Datenmodell, Views, RPCs und Constraints">DB</a>
    <a href="/docs/features.html" title="Produktfunktionen und User-Flow">Features</a>
    <a href="/docs/import_report.html" title="Datenherkunft, Geocoding und Qualitaet">Import</a>
    <a href="/docs/domain.html" class="active" aria-current="page" title="Domain, TLS und Migrationsbetrieb">Domain</a>
    <a href="/docs/report_executive_summary.html" title="Management-Zusammenfassung fuer Abschluss">Exec</a>
    <a href="/docs/report_business_kpi.html" title="KPI-Vertiefung mit Bezirks- und Teamwerten">KPI</a>
  </div>
</div>

> **Stand:** 05.04.2026 · **Ziel:** `https://wahl2026.bnz-wien.at` → NOVUM-ZIV Planungstool

<div class="changelog">
<details open>
<summary>📋 Letzte Änderungen</summary>

| Datum | Bereich | Änderung |
|---|---|---|
| 05.04.2026 | Lesefluss | ✏️ Rolle im Gesamt-Lesepfad ergänzt, Verweise mit Hover-Kurztexten erweitert |
| 04.04.2026 | Migration | ✏️ Neuer Abschnitt für Hetzner-Serverwechsel (kurzes Wartungsfenster, nip.io-Phase) |

</details>
</div>

<div class="neu">

## Lesefluss-Einordnung

- Diese Seite ist die **Betriebsebene**: Domain, TLS, Migration und Cutover.
- Vorher: [Import Report](/docs/import_report.html "Datenherkunft und Geocoding-Qualitaet als Input")
- Danach: [Executive Summary](/docs/report_executive_summary.html "Abschlusssicht fuer Steering und Entscheidungen")
- Kennzahlen danach: [Business KPI](/docs/report_business_kpi.html "Detailmetriken fuer Bezirke und Team")

</div>

---

## Aktuelle Architektur

Frontend und API laufen auf **demselben Hetzner-Server** (Self-Hosting). Es gibt kein CORS-Problem, da alles Same-Origin ist.

| Komponente | Aktuell | Ziel |
|---|---|---|
| **Frontend** (Hetzner) | `https://204.168.217.211.nip.io/` | `https://wahl2026.bnz-wien.at` |
| **API** (gleicher Server) | `https://204.168.217.211.nip.io/api` | `https://wahl2026.bnz-wien.at/api` |

<div class="info">
💡 Seit v1.6.0 werden Frontend und API gemeinsam auf dem Hetzner-Server gehostet. Die API wird intern über den relativen Pfad <code>/api</code> angesprochen — kein CORS nötig.
</div>

| Komponente | Details |
|---|---|
| **Server** | Hetzner VPS · `204.168.217.211` · Ubuntu 24.04 LTS |
| **Webserver** | Nginx (statische Dateien + Reverse Proxy → PostgREST) |
| **TLS** | Let's Encrypt via Certbot (aktuell für `204.168.217.211.nip.io`) |
| **Deploy** | GitHub Actions → Jekyll Build → rsync via SSH |

## Migration auf neuen Hetzner-Server (nip.io zuerst)

<div class="neu">
Empfohlener Ablauf: zuerst auf neue <code>&lt;NEW_IP&gt;.nip.io</code> migrieren, danach optional auf endgültige Domain (z.B. <code>wahl2026.bnz-wien.at</code>) umstellen.
</div>

### 1. Neuen Server vorbereiten

```bash
SERVER_IP=<NEW_IP> SERVER_DOMAIN=<NEW_IP>.nip.io bash server/setup_server.sh
```

### 2. Datenbank migrieren

```bash
OLD_HOST=204.168.217.211 NEW_HOST=<NEW_IP> bash server/migrate_db_to_new_hetzner.sh
```

### 3. Frontend-Nginx auf neuem Host aktivieren

```bash
SERVER_DOMAIN=<NEW_IP>.nip.io bash server/migrate_selfhost.sh
```

### 4. Smoke Tests gegen neuen Host

```bash
BASE_URL=https://<NEW_IP>.nip.io bash server/test_login_full.sh
BASE_URL=http://127.0.0.1:3000 bash server/test_login.sh
BASE_URL=http://127.0.0.1:3000 bash server/test_patch.sh
```

### 5. Verifier-Job auf neuen Host deployen

```powershell
$env:NOVUMZIV_SERVER_IP = "<NEW_IP>"
$env:NOVUMZIV_SERVER_DOMAIN = "<NEW_IP>.nip.io"
.\server\deploy_verify.ps1
```

### 6. Kurzfristiger Rollback

- Alter Host bleibt 24h online.
- Bei Fehlern im Login/PATCH sofort auf alten Host zurückschalten.
- Erst danach optional finale Domain umstellen.

---

## Domain-Konfiguration — Schritte

### Schritt 1: DNS-Record beim Domain-Provider setzen

Beim DNS-Provider von `bnz-wien.at` (z.B. World4You, Domaintechnik, All-Inkl, Cloudflare …) einen **A-Record** anlegen:

| Typ | Name | Ziel | TTL |
|---|---|---|---|
| `A` | `wahl2026` | `204.168.217.211` | 3600 |

<div class="info">
💡 Das ergibt die Adresse <code>wahl2026.bnz-wien.at</code>, die direkt auf unseren Hetzner-Server zeigt.
</div>

### Schritt 2: TLS-Zertifikat auf dem Server holen

SSH auf den Hetzner-Server:

```bash
ssh -i ~/.ssh/id_ed25519_novumziv2 root@204.168.217.211
```

Certbot für die neue Domain ausführen:

```bash
sudo certbot --nginx -d wahl2026.bnz-wien.at
```

Certbot passt die Nginx-Konfiguration automatisch an und richtet die HTTPS-Weiterleitung ein.

### Schritt 3: Nginx `server_name` anpassen

Falls Certbot den `server_name` nicht automatisch gesetzt hat, manuell in `/etc/nginx/sites-available/novumziv` ändern:

```nginx
server_name wahl2026.bnz-wien.at;
```

Dann Nginx neu laden:

```bash
sudo nginx -t && sudo systemctl reload nginx
```

### Schritt 4: `_config.yml` anpassen

Im Repository die Jekyll-Konfiguration aktualisieren:

```yaml
url: "https://wahl2026.bnz-wien.at"
baseurl: ""
```

Commit & Push löst automatisch einen Deploy auf den Server aus.

### Schritt 5 (Optional): Redirect von www.bnz-wien.at/wahl2026

Falls Besucher auch über `www.bnz-wien.at/wahl2026` zur App gelangen sollen, muss auf dem **www-Server** eine Weiterleitung eingerichtet werden:

**Falls Apache (.htaccess):**
```apache
Redirect 301 /wahl2026 https://wahl2026.bnz-wien.at
```

**Falls Nginx:**
```nginx
location = /wahl2026 {
    return 301 https://wahl2026.bnz-wien.at;
}
```

**Falls WordPress:**
Plugin "Redirection" installieren, dann:
- Quell-URL: `/wahl2026`
- Ziel-URL: `https://wahl2026.bnz-wien.at`
- Typ: 301 (permanent)

<div class="info">
💡 Dieser Schritt erfordert Zugriff auf den Webserver von <code>www.bnz-wien.at</code>.
</div>

---

## Ergebnis

| Was | URL |
|---|---|
| **App** | `https://wahl2026.bnz-wien.at` |
| **API** | `https://wahl2026.bnz-wien.at/api` (Same-Origin) |
| **Redirect** (optional) | `www.bnz-wien.at/wahl2026` → Subdomain |

<div class="neu">
✅ <strong>Vorteile der aktuellen Architektur:</strong><br>
• Frontend + API auf demselben Server → kein CORS nötig<br>
• Volle Kontrolle über TLS (Let's Encrypt/Certbot)<br>
• Automatischer Deploy via GitHub Actions (Push → Jekyll Build → rsync)<br>
• Kein Eingriff in die bestehende www.bnz-wien.at Website nötig
</div>

---

## Checkliste

- [ ] DNS A-Record `wahl2026` → `204.168.217.211` gesetzt
- [ ] TLS-Zertifikat via Certbot für `wahl2026.bnz-wien.at` geholt
- [ ] Nginx `server_name` auf neue Domain aktualisiert
- [ ] `_config.yml` URL angepasst + gepusht
- [ ] (Optional) Redirect von `www.bnz-wien.at/wahl2026` eingerichtet
- [ ] Funktionstest: App lädt, Login funktioniert, API-Calls erfolgreich

---

*Fragen? → Marius Romanin (marius.romanin@bnz-wien.at)*
