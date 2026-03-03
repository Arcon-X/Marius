---
layout: null
---
<!DOCTYPE html>
<html lang="de">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="theme-color" content="#1A2E22">
<meta name="robots" content="noindex,nofollow">
<title>NOVUM-ZIV Unterschriften</title>
<style>
:root {
  --g:#2C6E49; --g-h:#4C9A6F; --g-l:#E8F5EE; --dark:#1A2E22;
  --txt:#1C1C1C; --sub:#5a5a5a; --bg:#F4F7F5; --card:#ffffff;
  --bdr:#D5E8DC; --warn:#FFF8E1; --wbdr:#F9A825; --red:#C0392B;
  --h-px:56px; --n-px:62px; --r:12px; --sha:0 2px 8px rgba(0,0,0,.10);
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html{font-size:16px;-webkit-text-size-adjust:100%}
body{
  font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;
  background:var(--bg);color:var(--txt);
  padding-top:calc(var(--h-px) + env(safe-area-inset-top));
  padding-bottom:calc(var(--n-px) + env(safe-area-inset-bottom));
  min-height:100dvh;
}
.app-bar{
  position:fixed;top:0;left:0;right:0;z-index:200;
  background:var(--dark);
  height:calc(var(--h-px) + env(safe-area-inset-top));
  display:flex;align-items:flex-end;padding:0 1rem .7rem;
  box-shadow:0 2px 6px rgba(0,0,0,.35);
}
.app-bar-inner{display:flex;align-items:baseline;gap:.6rem;flex:1}
.app-bar-logo{font-size:1.15rem;font-weight:800;color:#fff;letter-spacing:-.3px}
.app-bar-logo span{color:#4C9A6F}
.app-bar-badge{font-size:.68rem;font-weight:600;background:var(--g);color:#fff;border-radius:4px;padding:1px 6px}
.app-bar-right{font-size:.72rem;color:#a0b8a8;white-space:nowrap}
.bottom-nav{
  position:fixed;bottom:0;left:0;right:0;z-index:200;
  background:var(--card);border-top:1px solid #d0d0d0;
  height:calc(var(--n-px) + env(safe-area-inset-bottom));
  display:flex;padding-bottom:env(safe-area-inset-bottom);
}
.nav-btn{
  flex:1;display:flex;flex-direction:column;align-items:center;
  justify-content:center;gap:3px;background:none;border:none;cursor:pointer;
  padding:.4rem 0 .3rem;color:#888;font-size:.62rem;font-family:inherit;
  font-weight:500;-webkit-tap-highlight-color:transparent;transition:color .15s;position:relative;
}
.nav-btn .icon{font-size:1.35rem;line-height:1}
.nav-btn.active{color:var(--g)}
.nav-btn.active::before{
  content:'';position:absolute;top:0;left:20%;right:20%;
  height:3px;background:var(--g);border-radius:0 0 3px 3px;
}
.app-content{padding:.75rem .85rem;max-width:680px;margin:0 auto}
.panel{display:none}
.panel.active{display:block}
.card{background:var(--card);border-radius:var(--r);box-shadow:var(--sha);margin-bottom:.85rem;overflow:hidden}
.card-body{padding:.8rem 1rem}
.card-body p{font-size:.9rem;line-height:1.55}
.section-title{
  font-size:.7rem;font-weight:700;letter-spacing:1px;text-transform:uppercase;
  color:var(--g);margin:1.1rem 0 .45rem .1rem;
}
.section-title:first-child{margin-top:.1rem}
.status-grid{display:grid;grid-template-columns:1fr 1fr;gap:.55rem;margin-bottom:.85rem}
.stat-chip{background:var(--card);border-radius:10px;box-shadow:var(--sha);padding:.7rem .75rem;display:flex;flex-direction:column;gap:.15rem}
.stat-chip .chip-icon{font-size:1.2rem}
.stat-chip .chip-label{font-size:.7rem;color:var(--sub);font-weight:600}
.stat-chip .chip-val{font-size:.88rem;font-weight:700;color:var(--txt)}
.chip-ok{border-left:4px solid #2C6E49}
.chip-no{border-left:4px solid var(--red)}
.chip-warn{border-left:4px solid var(--wbdr)}
.chip-info{border-left:4px solid #3498db}
.warn-banner{
  background:var(--warn);border:1px solid var(--wbdr);border-radius:var(--r);
  padding:.75rem 1rem;margin-bottom:.85rem;font-size:.85rem;line-height:1.5;color:#7a5500;
}
.tbl-wrap{overflow-x:auto;-webkit-overflow-scrolling:touch}
table{width:100%;border-collapse:collapse;font-size:.82rem}
th{background:var(--g);color:#fff;padding:.5em .7em;text-align:left;white-space:nowrap}
td{padding:.42em .7em;border-bottom:1px solid #e4e4e4;vertical-align:top}
tr:nth-child(even) td{background:#f9fdfb}
tr:last-child td{border-bottom:none}
pre{
  background:#1e2a22;color:#c8e6c9;border-radius:8px;padding:.9rem 1rem;
  font-size:.75rem;overflow-x:auto;-webkit-overflow-scrolling:touch;line-height:1.55;margin:.5rem 0;
}
code{background:var(--g-l);color:var(--dark);border-radius:4px;padding:.12em .38em;font-size:.82em}
.team-item{display:flex;align-items:center;padding:.65rem 1rem;border-bottom:1px solid #eef3ef;gap:.75rem}
.team-item:last-child{border-bottom:none}
.team-num{
  width:28px;height:28px;background:var(--g-l);border-radius:50%;
  display:flex;align-items:center;justify-content:center;
  font-size:.75rem;font-weight:700;color:var(--g);flex-shrink:0;
}
.team-num.admin{background:var(--g);color:#fff}
.team-info{flex:1;min-width:0}
.team-name{font-size:.88rem;font-weight:600;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.team-role{font-size:.73rem;color:var(--sub)}
.badge-admin{background:var(--g);color:#fff;border-radius:4px;padding:1px 6px;font-size:.68rem;font-weight:700;margin-left:.4rem}
details{background:var(--card);border-radius:var(--r);box-shadow:var(--sha);margin-bottom:.7rem;overflow:hidden}
summary{
  padding:.85rem 1rem;cursor:pointer;font-weight:600;font-size:.9rem;color:var(--dark);
  display:flex;align-items:center;gap:.5rem;
  -webkit-tap-highlight-color:transparent;list-style:none;user-select:none;
}
summary::-webkit-details-marker{display:none}
summary::after{
  content:'\203A';margin-left:auto;font-size:1.2rem;color:var(--g);
  transform:rotate(90deg);transition:transform .2s;display:inline-block;
}
details[open]>summary::after{transform:rotate(-90deg)}
details[open]>summary{border-bottom:1px solid var(--bdr)}
.acc-body{padding:.75rem 1rem 1rem}
.acc-body p{font-size:.88rem;line-height:1.55;margin-bottom:.5rem}
.flow-list{list-style:none;padding:0;position:relative}
.flow-list::before{content:'';position:absolute;left:19px;top:0;bottom:0;width:2px;background:var(--bdr)}
.flow-step{display:flex;align-items:flex-start;gap:.75rem;padding:.55rem 0;position:relative}
.flow-dot{
  width:38px;height:38px;flex-shrink:0;background:var(--g);border-radius:50%;
  display:flex;align-items:center;justify-content:center;font-size:1.1rem;
  position:relative;z-index:1;box-shadow:0 0 0 3px var(--g-l);
}
.flow-text strong{font-size:.9rem;display:block;margin-bottom:.15rem}
.flow-text span{font-size:.8rem;color:var(--sub)}
.checklist{list-style:none;padding:0}
.checklist li{display:flex;align-items:flex-start;gap:.6rem;padding:.55rem .1rem;border-bottom:1px solid #eef3ef;font-size:.88rem;line-height:1.45}
.checklist li:last-child{border-bottom:none}
.check-icon{font-size:1rem;flex-shrink:0;margin-top:.05rem}
.cost-hero{text-align:center;padding:1.2rem .5rem .8rem}
.cost-hero .amount{font-size:2.5rem;font-weight:800;color:var(--g)}
.cost-hero .period{font-size:.85rem;color:var(--sub)}
.cost-hero .total{font-size:.9rem;color:var(--dark);font-weight:600;margin-top:.3rem}
.phase-list{list-style:none;padding:0}
.phase-item{display:flex;gap:.75rem;padding:.6rem .1rem;border-bottom:1px solid #eef3ef;align-items:flex-start}
.phase-item:last-child{border-bottom:none}
.phase-num{
  background:var(--g);color:#fff;border-radius:6px;width:26px;height:26px;
  display:flex;align-items:center;justify-content:center;
  font-size:.72rem;font-weight:800;flex-shrink:0;margin-top:.05rem;
}
.phase-info strong{font-size:.88rem;display:block}
.phase-info span{font-size:.78rem;color:var(--sub)}
.swatches{display:flex;gap:.5rem;flex-wrap:wrap}
.swatch{border-radius:8px;padding:.55rem .8rem;font-size:.75rem;font-weight:700;min-width:80px;display:flex;flex-direction:column;gap:.15rem;box-shadow:var(--sha)}
.swatch code{background:rgba(255,255,255,.3);color:inherit;font-size:.7rem}
@media(min-width:600px){
  .status-grid{grid-template-columns:repeat(4,1fr)}
  .app-content{padding:1rem 1.5rem}
  table{font-size:.9rem}
  .app-bar-logo{font-size:1.3rem}
}
</style>
</head>
<body>
<header class="app-bar">
  <div class="app-bar-inner">
    <div class="app-bar-logo">NOVUM<span>-ZIV</span></div>
    <div class="app-bar-badge">PLANUNG</div>
  </div>
  <div class="app-bar-right">3. März 2026</div>
</header>

<main class="app-content">

<section id="tab-home" class="panel active">
  <div class="warn-banner">
    ⚠️ <strong>Planungsdokument</strong> — noch kein Code, keine Live-Umgebung. Alle Angaben sind Entwürfe zur internen Abstimmung.
  </div>
  <div class="section-title">Projektstatus</div>
  <div class="status-grid">
    <div class="stat-chip chip-ok"><span class="chip-icon">🗺️</span><span class="chip-label">Distanz</span><span class="chip-val">Echte Gehzeit</span></div>
    <div class="stat-chip chip-ok"><span class="chip-icon">🖥️</span><span class="chip-label">Hosting</span><span class="chip-val">Anexia (AT)</span></div>
    <div class="stat-chip chip-ok"><span class="chip-icon">🔐</span><span class="chip-label">Login</span><span class="chip-val">19 Konten</span></div>
    <div class="stat-chip chip-no"><span class="chip-icon">🔄</span><span class="chip-label">Tages-Reset</span><span class="chip-val">Kein Reset</span></div>
    <div class="stat-chip chip-ok"><span class="chip-icon">🗺️</span><span class="chip-label">Karte</span><span class="chip-val">Leaflet.js</span></div>
    <div class="stat-chip chip-ok"><span class="chip-icon">📝</span><span class="chip-label">Protokoll</span><span class="chip-val">Audit-Log</span></div>
    <div class="stat-chip chip-warn"><span class="chip-icon">⚖️</span><span class="chip-label">DSGVO</span><span class="chip-val">Offen ⚠️</span></div>
    <div class="stat-chip chip-info"><span class="chip-icon">💶</span><span class="chip-label">Kosten</span><span class="chip-val">€ 3,79/Mt.</span></div>
  </div>
  <div class="section-title">Ziel</div>
  <div class="card"><div class="card-body">
    <p>Kandidat:innen finden mit einem Klick die <strong>N nächstgelegenen freien Adressen</strong> aus ~2.000 Wiener Wahlberechtigten — sortiert nach echter Gehzeit — und protokollieren Unterschriften dauerhaft. Doppelbesuche werden automatisch verhindert.</p>
  </div></div>
  <div class="section-title">Nächste Schritte</div>
  <div class="card"><div class="card-body">
    <ul class="checklist">
      <li><span class="check-icon">⚠️</span><div><strong>DSGVO</strong> — Option B (Anexia) oder Option C bestätigen</div></li>
      <li><span class="check-icon">📄</span><div><strong>Adressliste</strong> bereitstellen — Excel/CSV mit ~2.000 Wiener Adressen</div></li>
      <li><span class="check-icon">📧</span><div><strong>E-Mail-Adressen</strong> aller 19 Kandidat:innen bestätigen</div></li>
      <li><span class="check-icon">🖥️</span><div><strong>Anexia-Konto anlegen</strong> → <a href="https://www.anexia.com/de/" style="color:var(--g)">anexia.com</a></div></li>
      <li><span class="check-icon">🚀</span><div><strong>Entwicklung freigeben</strong> — Startschuss Phase 1</div></li>
    </ul>
  </div></div>
  <div class="section-title">Organisation</div>
  <div class="card"><div class="card-body">
    <p><strong>BNZ Bündnis NOVUM–ZIV</strong><br>Zahnärztekammerwahl Wien 2026<br>~2.000 Adressen · 19 Kandidat:innen · 1 Admin</p>
  </div></div>
</section>

<section id="tab-plan" class="panel">
  <div class="section-title">Bestätigte Entscheidungen</div>
  <div class="card"><div class="card-body" style="padding:.5rem;">
    <div class="tbl-wrap"><table>
      <thead><tr><th>Frage</th><th>Entscheidung</th></tr></thead>
      <tbody>
        <tr><td>Distanz-Art</td><td>✅ Echte Gehzeit (OSRM)</td></tr>
        <tr><td>Hosting</td><td>✅ Option B — Anexia (AT, Wien)</td></tr>
        <tr><td>Login</td><td>✅ Admin legt Konten an</td></tr>
        <tr><td>Tages-Reset</td><td>❌ Nein — dauerhafter Fortschritt</td></tr>
        <tr><td>Archivierung</td><td>✅ Permanent</td></tr>
        <tr><td>Notiz bei Erledigt</td><td>✅ Optionales Freitextfeld</td></tr>
        <tr><td>Karten-Ansicht</td><td>✅ Leaflet.js + OSM</td></tr>
        <tr><td>Protokollierung</td><td>✅ Audit-Log</td></tr>
      </tbody>
    </table></div>
  </div></div>
  <div class="section-title">Datenschutz &amp; Hosting</div>
  <div class="warn-banner">
    ⚠️ Die App verarbeitet personenbezogene Daten (Adressen, Logins, Besuchsprotokolle). Hosting-Entscheidung bitte vor Entwicklungsstart bestätigen.
  </div>
  <details open>
    <summary>✅ Option B — Anexia (AT, Wien) &nbsp;<span style="background:#E8F5EE;color:#2C6E49;border:1px solid #4C9A6F;border-radius:4px;padding:1px 6px;font-size:.72rem;font-weight:600;">geplant</span></summary>
    <div class="acc-body">
      <p>Datenbank auf selbst gemietem österreichischem Server — 100 % österreichisches Unternehmen, kein US-Dienst, kein Drittanbieter hat Datenzugriff.</p>
      <div class="tbl-wrap"><table><tbody>
        <tr><td><strong>Unternehmen</strong></td><td>Anexia Internetdienstleistungs GmbH (<strong>Österreich</strong>)</td></tr>
        <tr><td><strong>Standort</strong></td><td>Wien (Österreich) · EU</td></tr>
        <tr><td><strong>US-Bezug</strong></td><td>❌ Keiner</td></tr>
        <tr><td><strong>Preis</strong></td><td>ab <strong>~€ 20 / Monat</strong></td></tr>
        <tr><td><strong>PostgreSQL + PostGIS</strong></td><td>✅ Einfach installierbar</td></tr>
        <tr><td><strong>AVV (DSGVO)</strong></td><td>✅ Verfügbar</td></tr>
        <tr><td><strong>Kündigung</strong></td><td>Monatlich — nach Wahl löschen</td></tr>
      </tbody></table></div>
      <p style="margin-top:.6rem;font-size:.82rem;color:var(--sub);">Budgetäre Alternative: <strong>Hetzner (DE)</strong> ab € 3,79/Mt. — ebenfalls EU, aber deutsches Unternehmen.</p>
<pre>Anexia Server (Wien, AT)
  └── Ubuntu 24.04
        ├── PostgreSQL 16 + PostGIS 3
        └── PostgREST (REST-API)</pre>
    </div>
  </details>
  <details>
    <summary>❓ Option C — Keine personenbezogenen Daten in der Cloud</summary>
    <div class="acc-body">
      <p>Nur anonymisierte Adress-IDs in der Datenbank — keine Namen der Wahlberechtigten.</p>
      <div class="tbl-wrap"><table>
        <thead><tr><th>Vorteil</th><th>Nachteil</th></tr></thead>
        <tbody>
          <tr><td>Stark reduziertes DSGVO-Risiko</td><td>Weniger nützliche Auswertungen</td></tr>
          <tr><td>Auch mit Supabase (US) denkbar</td><td>Admin muss IDs manuell zuordnen</td></tr>
        </tbody>
      </table></div>
      <p style="margin-top:.6rem;font-size:.85rem;background:var(--g-l);border-radius:8px;padding:.6rem .8rem;">
        <strong>Zu klären:</strong> Enthält die Adressliste der Zahnärztekammer Namen, oder nur Adressen? Falls nur Adressen → Option C kaum nötig.
      </p>
    </div>
  </details>
</section>
<section id="tab-team" class="panel">
  <div class="section-title">19 Kandidat:innen — 1 Admin + 18 Mitarbeiter:innen</div>
  <div class="card" style="padding-bottom:.3rem;">
    <div class="team-item"><div class="team-num admin">1</div><div class="team-info"><div class="team-name">Dr. Marius Romanin <span class="badge-admin">ADMIN</span></div><div class="team-role">2. Vizepräsident:in · marius.romanin@bnz-wien.at</div></div></div>
    <div class="team-item"><div class="team-num">2</div><div class="team-info"><div class="team-name">OMR Dr. Franz Hastermann</div><div class="team-role">Präsident · franz.hastermann@bnz-wien.at</div></div></div>
    <div class="team-item"><div class="team-num">3</div><div class="team-info"><div class="team-name">Drin Petra Drabo</div><div class="team-role">Landesfinanzreferent:in · petra.drabo@bnz-wien.at</div></div></div>
    <div class="team-item"><div class="team-num">4</div><div class="team-info"><div class="team-name">DDr. Andreas Eder</div><div class="team-role">Landesfinanzreferent:in (Sukz.) · andreas.eder@bnz-wien.at</div></div></div>
    <div class="team-item"><div class="team-num">5</div><div class="team-info"><div class="team-name">MRin DDrin Barbara Thornton</div><div class="team-role">Betr. Auflagen &amp; Qualitätssicherung · barbara.thornton@bnz-wien.at</div></div></div>
    <div class="team-item"><div class="team-num">6</div><div class="team-info"><div class="team-name">Dr. Eren Eryilmaz</div><div class="team-role">Betr. Auflagen (Sukzessor) · eren.eryilmaz@bnz-wien.at</div></div></div>
    <div class="team-item"><div class="team-num">7</div><div class="team-info"><div class="team-name">Dr. Leon Golestani BSc BA MA</div><div class="team-role">Referat Fortbildung · leon.golestani@bnz-wien.at</div></div></div>
    <div class="team-item"><div class="team-num">8</div><div class="team-info"><div class="team-name">Drin Julia Stella Glatz</div><div class="team-role">Referat Fortbildung (Sukz.) · julia.glatz@bnz-wien.at</div></div></div>
    <div class="team-item"><div class="team-num">9</div><div class="team-info"><div class="team-name">Drin Andrietta Dossenbach</div><div class="team-role">Referat Hochschulangelegenheiten · andrietta.dossenbach@bnz-wien.at</div></div></div>
    <div class="team-item"><div class="team-num">10</div><div class="team-info"><div class="team-name">Drin Andrea Gamper</div><div class="team-role">Referat Hochschul. (Sukz.) · andrea.gamper@bnz-wien.at</div></div></div>
    <div class="team-item"><div class="team-num">11</div><div class="team-info"><div class="team-name">Dr. Dino Imsirovic</div><div class="team-role">Referat Kassenangelegenheiten · dino.imsirovic@bnz-wien.at</div></div></div>
    <div class="team-item"><div class="team-num">12</div><div class="team-info"><div class="team-name">MR Dr. Gerhard Schager</div><div class="team-role">Referat Kassen. (Sukzessor) · gerhard.schager@bnz-wien.at</div></div></div>
    <div class="team-item"><div class="team-num">13</div><div class="team-info"><div class="team-name">Dr. Paul Inkofer</div><div class="team-role">Referat Niederlassung &amp; Wahlzahnärzt:innen · paul.inkofer@bnz-wien.at</div></div></div>
    <div class="team-item"><div class="team-num">14</div><div class="team-info"><div class="team-name">Drin Andrea Bednar-Brandt</div><div class="team-role">Referat Niederlassung (Sukz.) · andrea.bednar-brandt@bnz-wien.at</div></div></div>
    <div class="team-item"><div class="team-num">15</div><div class="team-info"><div class="team-name">Drin Anita Elmauthaler</div><div class="team-role">Referat Soziales &amp; Jungzahnärzt:innen · anita.elmauthaler@bnz-wien.at</div></div></div>
    <div class="team-item"><div class="team-num">16</div><div class="team-info"><div class="team-name">Drin Petra Stühlinger</div><div class="team-role">Referat Soziales (Sukzessorin) · petra.stuehlinger@bnz-wien.at</div></div></div>
    <div class="team-item"><div class="team-num">17</div><div class="team-info"><div class="team-name">Drin Lama Hamisch MSc</div><div class="team-role">Referat Vergemeinschaftungsformen · lama.hamisch@bnz-wien.at</div></div></div>
    <div class="team-item"><div class="team-num">18</div><div class="team-info"><div class="team-name">Dr. Otis Rezegh</div><div class="team-role">Referat Vergemeins. (Sukzessor) · otis.rezegh@bnz-wien.at</div></div></div>
    <div class="team-item"><div class="team-num">19</div><div class="team-info"><div class="team-name">Drin Selma Husejnovic</div><div class="team-role">Kommunikation / Öffentlichkeit · selma.husejnovic@bnz-wien.at</div></div></div>
  </div>
  <p style="font-size:.78rem;color:var(--sub);text-align:center;margin-top:-.3rem;margin-bottom:.8rem;">⚠️ E-Mail-Adressen sind Platzhalter — vor Setup bestätigen.</p>
</section>

<section id="tab-tech" class="panel">
  <div class="section-title">Systemarchitektur</div>
  <details open>
    <summary>🏗️ Architekturdiagramm</summary>
    <div class="acc-body">
<pre>┌──────────────────────────────────────┐
│  FRONTEND — GitHub Pages (kostenlos) │
│  HTML / JS / BNZ-CSS                 │
│  Login · Suche · Liste · Karte       │
└──────────┬───────────────────────────┘
           │ HTTPS+JWT       │ OSRM
           ▼                 ▼
┌─────────────────┐  ┌──────────────────┐
│  Anexia (Wien)  │  │ project-osrm.org   │
│  ~€ 20/Monat    │  │ Fußgänger-Routing  │
│  PostgreSQL 16  │  │ → Gehmin + Meter   │
│  PostGIS 3      │  └──────────────────┘
│  PostgREST      │
└─────────────────┘
EU · DSGVO-konform · kein US-Dienst</pre>
    </div>
  </details>
  <div class="section-title">Datenbank</div>
  <details>
    <summary>🗄️ Tabelle: adressen</summary>
    <div class="acc-body">
      <div class="tbl-wrap"><table>
        <thead><tr><th>Spalte</th><th>Typ</th><th>Beschreibung</th></tr></thead>
        <tbody>
          <tr><td><code>id</code></td><td>UUID</td><td>Eindeutige ID</td></tr>
          <tr><td><code>plz</code>, <code>strasse</code></td><td>TEXT</td><td>Adresse</td></tr>
          <tr><td><code>lat</code>, <code>lon</code></td><td>FLOAT</td><td>GPS-Koordinaten</td></tr>
          <tr><td><code>standort</code></td><td>GEOMETRY</td><td>PostGIS-Punkt</td></tr>
          <tr><td><code>status</code></td><td>TEXT</td><td>verfuegbar / in_bearbeitung / archiviert</td></tr>
          <tr><td><code>benutzer_id</code></td><td>UUID</td><td>Zuständige Person</td></tr>
          <tr><td><code>erledigt_am</code></td><td>TIMESTAMP</td><td>Zeitpunkt</td></tr>
        </tbody>
      </table></div>
    </div>
  </details>
  <details>
    <summary>🗄️ Tabelle: protokoll</summary>
    <div class="acc-body">
      <div class="tbl-wrap"><table>
        <thead><tr><th>Spalte</th><th>Typ</th><th>Beschreibung</th></tr></thead>
        <tbody>
          <tr><td><code>adressen_id</code></td><td>UUID</td><td>Verknüpfte Adresse</td></tr>
          <tr><td><code>benutzer_id</code></td><td>UUID</td><td>Wer</td></tr>
          <tr><td><code>aktion</code></td><td>TEXT</td><td>unterschrift / nicht_angetroffen / …</td></tr>
          <tr><td><code>zeitpunkt</code></td><td>TIMESTAMP</td><td>Wann</td></tr>
          <tr><td><code>notiz</code></td><td>TEXT</td><td>Optionale Bemerkung</td></tr>
        </tbody>
      </table></div>
    </div>
  </details>
  <div class="section-title">Routing &amp; SQL</div>
  <details>
    <summary>📐 Vorfilter SQL (PostGIS)</summary>
    <div class="acc-body">
<pre>SELECT id, strasse, plz, lat, lon
FROM adressen
WHERE status = 'verfuegbar'
ORDER BY standort
  &lt;-&gt; ST_MakePoint(:lon, :lat)
LIMIT 50;</pre>
    </div>
  </details>
  <details>
    <summary>📐 OSRM-Abfrage (JavaScript)</summary>
    <div class="acc-body">
<pre>const r = await fetch(
  `https://router.project-osrm.org/route/v1/foot/
   ${'{'}meinLon{'}'},{'{'}meinLat{'}'};${'{'}a.lon{'}'},{'{'}a.lat{'}'}
   ?overview=false`
);
const {{ duration, distance }} =
  (await r.json()).routes[0];
// Top N nach duration (Sekunden) sortieren</pre>
    </div>
  </details>
  <div class="section-title">Kosten</div>
  <div class="card">
    <div class="cost-hero">
      <div class="amount">~€ 20</div>
      <div class="period">pro Monat (Anexia, Wien)</div>
      <div class="total">2 Monate gesamt: ~€ 40</div>
    </div>
    <div class="card-body" style="padding-top:0;">
      <div class="tbl-wrap"><table><tbody>
        <tr><td>Anexia Server (Wien, Server + DB)</td><td><strong>~€ 20</strong></td></tr>
        <tr><td>GitHub Pages (Frontend)</td><td>€ 0</td></tr>
        <tr><td>OSRM (Routing)</td><td>€ 0</td></tr>
        <tr><td>Leaflet.js + OSM (Karte)</td><td>€ 0</td></tr>
        <tr><td>Nominatim (Geokodierung)</td><td>€ 0</td></tr>
      </tbody></table></div>
    </div>
  </div>
  <div class="section-title">BNZ Farbpalette</div>
  <div class="card"><div class="card-body">
    <div class="swatches">
      <div class="swatch" style="background:#2C6E49;color:#fff;">BNZ Grün<code>#2C6E49</code></div>
      <div class="swatch" style="background:#4C9A6F;color:#fff;">Grün Hell<code>#4C9A6F</code></div>
      <div class="swatch" style="background:#E8F5EE;color:#1A2E22;border:1px solid #b8d8c8;">Grün Blass<code>#E8F5EE</code></div>
      <div class="swatch" style="background:#1A2E22;color:#fff;">BNZ Dunkel<code>#1A2E22</code></div>
    </div>
  </div></div>
</section>
<section id="tab-flow" class="panel">
  <div class="section-title">Benutzerablauf</div>
  <div class="card"><div class="card-body">
    <ul class="flow-list">
      <li class="flow-step"><div class="flow-dot">🔐</div><div class="flow-text"><strong>Login</strong><span>E-Mail + Passwort (vom Admin vergeben)</span></div></li>
      <li class="flow-step"><div class="flow-dot">📍</div><div class="flow-text"><strong>Standort ermitteln</strong><span>GPS oder Adresse manuell eingeben</span></div></li>
      <li class="flow-step"><div class="flow-dot">🔢</div><div class="flow-text"><strong>Anzahl wählen</strong><span>5 · 10 · 15 Adressen</span></div></li>
      <li class="flow-step"><div class="flow-dot">⚙️</div><div class="flow-text"><strong>Routing (automatisch)</strong><span>50 Adressen vorfiltern → OSRM → Gehminuten → Top N</span></div></li>
      <li class="flow-step"><div class="flow-dot">📋</div><div class="flow-text"><strong>Liste / Karte</strong><span>z. B. Grünentorgasse 12 — 3 min (220 m)</span></div></li>
      <li class="flow-step"><div class="flow-dot">💬</div><div class="flow-text"><strong>Reservieren</strong><span>Status → IN BEARBEITUNG · Adresse besuchen</span></div></li>
      <li class="flow-step"><div class="flow-dot">✅</div><div class="flow-text"><strong>Erledigt</strong><span>Unterschrift / Nicht angetroffen / Kein Interesse + Notiz → ARCHIVIERT</span></div></li>
    </ul>
  </div></div>
  <div class="section-title">Status-Lebenszyklus</div>
  <div class="card"><div class="card-body">
<pre>VERFÜGBAR
  →[übernommen]→ IN BEARBEITUNG
                  →[erledigt]→ ARCHIVIERT
                    ↑ Admin reaktiviert (Ausnahme)</pre>
  </div></div>
  <div class="section-title">Projektplan — ~3 Arbeitstage</div>
  <div class="card"><div class="card-body">
    <ul class="phase-list">
      <li class="phase-item"><div class="phase-num">0</div><div class="phase-info"><strong>DSGVO finalisieren</strong><span>Option B / C bestätigen</span></div></li>
      <li class="phase-item"><div class="phase-num">1</div><div class="phase-info"><strong>Anexia-Server (Wien)</strong><span>PostgreSQL + PostGIS · 2–3 Std.</span></div></li>
      <li class="phase-item"><div class="phase-num">2</div><div class="phase-info"><strong>Auth-System</strong><span>19 Konten anlegen · 2 Std.</span></div></li>
      <li class="phase-item"><div class="phase-num">3</div><div class="phase-info"><strong>Geokodierung + Import</strong><span>Python · ~2.000 Adressen · 2–3 Std.</span></div></li>
      <li class="phase-item"><div class="phase-num">4</div><div class="phase-info"><strong>Frontend: Kernfunktionen</strong><span>Login · Routing · Erledigt-Dialog · 8–10 Std.</span></div></li>
      <li class="phase-item"><div class="phase-num">5</div><div class="phase-info"><strong>Frontend: Karte</strong><span>Leaflet.js · 3–4 Std.</span></div></li>
      <li class="phase-item"><div class="phase-num">6</div><div class="phase-info"><strong>Archiv + Admin</strong><span>Auswertung, Reports · 2–3 Std.</span></div></li>
      <li class="phase-item"><div class="phase-num">7</div><div class="phase-info"><strong>Test + Go-Live</strong><span>2 Std.</span></div></li>
      <li class="phase-item"><div class="phase-num">8</div><div class="phase-info"><strong>Nach Wahl: Daten vernichten</strong><span>Server löschen · 30 Min.</span></div></li>
    </ul>
  </div></div>
  <div class="section-title">Screen-Mockups</div>
  <details>
    <summary>📱 Login · Hauptseite · Erledigt-Dialog</summary>
    <div class="acc-body">
<pre>LOGIN           HAUPTSEITE        ERLEDIGT
┌───────────┐  ┌─────────────┐  ┌───────────┐
│ NOVUM-ZIV │  │NOVUM-ZIV[▶]│  │✓ Erledigt?│
│───────────│  ├─────────────┤  │───────────│
│E-Mail:    │  │GPS○ Adr.○  │  │Grüntorg.12│
│[_________]│  │Anzahl:[10▼]│  │───────────│
│Passwort:  │  │[Liste][Karte]│ │[✅Untersch.]│
│[_________]│  │[🔍 Suchen]  │  │[❌Nicht ang]│
│           │  ├─────────────┤  │[⏭Kein Int.]│
│[Anmelden] │  │1.Grüntorg 3m│  │           │
│ #2C6E49   │  │2.Wallens. 5m│  │Notiz:[___]│
└───────────┘  │[✅ Übernehm.] │  └───────────┘
                └─────────────┘</pre>
    </div>
  </details>
</section>

</main>

<nav class="bottom-nav">
  <button class="nav-btn active" data-tab="home"><span class="icon">🏠</span>Home</button>
  <button class="nav-btn" data-tab="plan"><span class="icon">📋</span>Beschlüsse</button>
  <button class="nav-btn" data-tab="team"><span class="icon">👥</span>Team</button>
  <button class="nav-btn" data-tab="tech"><span class="icon">⚙️</span>Technik</button>
  <button class="nav-btn" data-tab="flow"><span class="icon">🔄</span>Ablauf</button>
</nav>

<script>
(function(){
  var btns   = document.querySelectorAll('.nav-btn');
  var panels = document.querySelectorAll('.panel');
  function activate(id){
    btns.forEach(function(b){b.classList.toggle('active',b.dataset.tab===id);});
    panels.forEach(function(p){p.classList.toggle('active',p.id==='tab-'+id);});
    window.scrollTo({top:0,behavior:'instant'});
    if(history.replaceState)history.replaceState(null,'','#'+id);
  }
  btns.forEach(function(b){b.addEventListener('click',function(){activate(b.dataset.tab);});});
  var hash=location.hash.replace('#','');
  var valid=['home','plan','team','tech','flow'];
  if(valid.indexOf(hash)!==-1)activate(hash);
})();
</script>
</body>
</html>
