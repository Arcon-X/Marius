---
title: "NOVUM-ZIV — Domain konfigurieren"
---

<style>
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
</style>

# NOVUM-ZIV — Domain konfigurieren

> **Stand:** 29.03.2026 · **Ziel:** `https://www.bnz-wien.at/wahl2026` → NOVUM-ZIV Planungstool

---

## Ausgangslage

| Komponente | Aktuell | Ziel |
|---|---|---|
| **Frontend** (GitHub Pages) | `https://arcon-x.github.io/Marius/` | `https://www.bnz-wien.at/wahl2026` |
| **API** (Anexia-Server) | `https://204.168.217.211.nip.io/api` | bleibt oder eigene Subdomain |

---

## Variante A — Subdomain (empfohlen) ⭐

Die **sauberste und einfachste** Lösung: Eine eigene Subdomain wie `wahl2026.bnz-wien.at` direkt auf GitHub Pages zeigen lassen.

### Schritt 1: DNS-Record beim Domain-Provider setzen

Beim DNS-Provider von `bnz-wien.at` (z.B. World4You, Domaintechnik, All-Inkl, Cloudflare …) einen **CNAME-Record** anlegen:

| Typ | Name | Ziel | TTL |
|---|---|---|---|
| `CNAME` | `wahl2026` | `arcon-x.github.io` | 3600 |

<div class="info">
💡 Das ergibt die Adresse <code>wahl2026.bnz-wien.at</code>. Der CNAME zeigt auf den GitHub Pages Server, der dann unsere <code>index.html</code> ausliefert.
</div>

### Schritt 2: CNAME-Datei im Repository anlegen

Im Git-Repository `Arcon-X/Marius` eine Datei namens `CNAME` (ohne Endung!) im Root erstellen:

```
wahl2026.bnz-wien.at
```

### Schritt 3: GitHub Pages Custom Domain aktivieren

1. Auf GitHub → Repository `Arcon-X/Marius` → **Settings** → **Pages**
2. Unter **Custom domain** eingeben: `wahl2026.bnz-wien.at`
3. **Save** klicken
4. Warten bis der DNS-Check grün wird (kann bis zu 24h dauern, meist 5-30 Min.)
5. Checkbox **Enforce HTTPS** aktivieren (GitHub stellt automatisch ein Let's Encrypt Zertifikat aus)

### Schritt 4: `_config.yml` anpassen

```yaml
url: "https://wahl2026.bnz-wien.at"
baseurl: ""    # leer, weil kein Unterverzeichnis mehr
```

### Schritt 5: CORS auf dem API-Server anpassen

SSH auf den Anexia-Server und Nginx-Config aktualisieren:

```bash
sudo nano /etc/nginx/sites-available/novumziv
```

Die `Access-Control-Allow-Origin` Zeile ändern:

```nginx
# Vorher:
add_header Access-Control-Allow-Origin "https://arcon-x.github.io" always;

# Nachher:
add_header Access-Control-Allow-Origin "https://wahl2026.bnz-wien.at" always;
```

Dann Nginx neu laden:

```bash
sudo nginx -t && sudo systemctl reload nginx
```

### Schritt 6: API-URL im Frontend anpassen (optional)

Wenn der API-Server auch eine eigene Subdomain bekommen soll (z.B. `api.bnz-wien.at`):

1. Beim DNS-Provider einen **A-Record** setzen:

| Typ | Name | Ziel | TTL |
|---|---|---|---|
| `A` | `api` | `204.168.217.211` | 3600 |

2. Auf dem Server TLS-Zertifikat holen:

```bash
sudo certbot --nginx -d api.bnz-wien.at
```

3. Nginx `server_name` anpassen:

```nginx
server_name api.bnz-wien.at;
```

4. Im Frontend (`index.html`) die API-URL ändern:

```javascript
// Vorher:
const SB_URL='https://204.168.217.211.nip.io/api';
// Nachher:
const SB_URL='https://api.bnz-wien.at/api';
```

### Ergebnis Variante A

| Was | URL |
|---|---|
| **App** | `https://wahl2026.bnz-wien.at` |
| **API** | `https://api.bnz-wien.at/api` (optional) |

<div class="neu">
✅ <strong>Vorteile:</strong> Kein Eingriff in die bestehende www.bnz-wien.at Website nötig. Eigenes TLS-Zertifikat (automatisch via GitHub/Let's Encrypt). Vollständig unabhängig.
</div>

---

## Variante B — Weiterleitung von /wahl2026

Falls es zwingend `www.bnz-wien.at/wahl2026` sein muss, braucht man **Zugriff auf den Webserver** von `www.bnz-wien.at`.

<div class="warn">
⚠️ <strong>Wichtig:</strong> GitHub Pages kann NICHT unter einem Unterpfad einer fremden Domain betrieben werden. Ein Pfad wie <code>/wahl2026</code> auf einer bestehenden Website erfordert Zugriff auf deren Server-Konfiguration.
</div>

### Option B1: Redirect (einfach)

Auf dem Server von `www.bnz-wien.at` eine Weiterleitung einrichten:

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

→ Besucher von `www.bnz-wien.at/wahl2026` landen automatisch auf der Subdomain.

### Option B2: Reverse Proxy (komplex)

Den Pfad `/wahl2026` direkt an GitHub Pages durchreichen. **Nur wenn ein Nginx/Apache-Server unter voller Kontrolle steht:**

```nginx
location /wahl2026/ {
    proxy_pass https://arcon-x.github.io/Marius/;
    proxy_set_header Host arcon-x.github.io;
    proxy_ssl_server_name on;
    sub_filter 'href="/' 'href="/wahl2026/';
    sub_filter_once off;
}
```

<div class="warn">
⚠️ Reverse Proxy ist <strong>nicht empfohlen</strong> — komplex, fehleranfällig, und erfordert Anpassungen an allen relativen Pfaden im Frontend.
</div>

---

## Empfehlung & Zusammenfassung

| | Variante A: Subdomain ⭐ | Variante B1: Redirect | Variante B2: Reverse Proxy |
|---|---|---|---|
| **DNS-Aufwand** | 1 CNAME-Record | 1 CNAME + Server-Config | 1 CNAME + Server-Config |
| **Server-Zugriff nötig?** | Nein | Ja (www-Server) | Ja (www-Server) |
| **TLS-Zertifikat** | Automatisch (GitHub) | — | Manuell |
| **Komplexität** | ⭐ Niedrig | ⭐ Niedrig | 🔴 Hoch |
| **Ergebnis-URL** | `wahl2026.bnz-wien.at` | `www.bnz-wien.at/wahl2026` → Redirect | `www.bnz-wien.at/wahl2026` |

<div class="neu">
🎯 <strong>Empfehlung: Variante A (Subdomain) + optional B1 (Redirect)</strong><br>
1. Subdomain <code>wahl2026.bnz-wien.at</code> einrichten (Schritte 1–6 oben)<br>
2. Optional: Auf <code>www.bnz-wien.at/wahl2026</code> einen Redirect zur Subdomain setzen<br>
→ Beide URLs funktionieren, die eigentliche App läuft sauber auf der Subdomain.
</div>

---

## Checkliste

- [ ] DNS CNAME-Record `wahl2026` → `arcon-x.github.io` gesetzt
- [ ] `CNAME`-Datei im Repository angelegt
- [ ] GitHub Pages Custom Domain konfiguriert + HTTPS erzwungen
- [ ] `_config.yml` URL + baseurl angepasst
- [ ] CORS auf Anexia-Server auf neue Domain aktualisiert
- [ ] (Optional) API-Subdomain `api.bnz-wien.at` eingerichtet
- [ ] (Optional) Redirect von `www.bnz-wien.at/wahl2026` eingerichtet
- [ ] Funktionstest: App lädt, Login funktioniert, API-Calls erfolgreich

---

*Fragen? → Marius Romanin (marius.romanin@bnz-wien.at)*
