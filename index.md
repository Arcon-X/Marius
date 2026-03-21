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
<meta name="theme-color" content="#2D2060">
<meta name="robots" content="noindex,nofollow">
<title>NOVUM-ZIV Unterschriften</title>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">
<style>
:root{
  --g:#7B6BC4;--g-h:#9A8BE0;--g-l:#EEEAF9;--dark:#2D2060;
  --txt:#1C1C1C;--sub:#6b7280;--bg:#F2F0FA;--card:#fff;
  --bdr:#D4CEF0;--red:#C0392B;--warn:#FFFDE0;--wbdr:#D4C800;
  --h-px:56px;--n-px:60px;--r:12px;--sha:0 2px 8px rgba(0,0,0,.10);
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html,body{height:100%;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;font-size:16px;background:var(--bg);color:var(--txt)}
.hidden{display:none!important}

/* LOGIN */
#scr-login{
  min-height:100dvh;display:flex;align-items:center;justify-content:center;
  background:linear-gradient(160deg,var(--dark) 0%,#7B6BC4 100%);padding:1.5rem;
}
.login-card{
  background:#fff;border-radius:18px;padding:2rem 1.75rem;width:100%;max-width:370px;
  box-shadow:0 8px 32px rgba(0,0,0,.25);
}
.login-logo{font-size:1.9rem;font-weight:800;color:var(--dark);letter-spacing:-.5px;text-align:center;margin-bottom:.15rem}
.login-logo span{color:var(--g)}
.login-sub{font-size:.78rem;color:var(--sub);text-align:center;margin-bottom:1.4rem}
.demo-note{
  background:var(--warn);border:1px solid var(--wbdr);border-radius:8px;
  font-size:.76rem;padding:.55rem .75rem;color:#7a5500;margin-bottom:1rem;line-height:1.45;
}
.login-card label{font-size:.78rem;font-weight:600;color:var(--sub);display:block;margin-bottom:.3rem;margin-top:.8rem}
.login-card input{
  width:100%;padding:.7rem .9rem;border:1.5px solid #ddd;border-radius:8px;
  font-size:.95rem;font-family:inherit;outline:none;transition:border .15s;
}
.login-card input:focus{border-color:var(--g)}
.btn-primary{
  width:100%;margin-top:1.2rem;padding:.82rem;background:var(--g);color:#fff;
  border:none;border-radius:10px;font-size:1rem;font-weight:700;cursor:pointer;
  font-family:inherit;transition:background .15s;
}
.btn-primary:hover{background:var(--g-h)}
.login-err{margin-top:.65rem;font-size:.82rem;color:var(--red);text-align:center;min-height:1.2em}

/* APP SHELL */
#scr-app{
  height:100dvh;display:flex;flex-direction:column;
  padding-top:calc(var(--h-px) + env(safe-area-inset-top));
  padding-bottom:calc(var(--n-px) + env(safe-area-inset-bottom));
}
.app-bar{
  position:fixed;top:0;left:0;right:0;z-index:300;
  background:var(--dark);
  height:calc(var(--h-px) + env(safe-area-inset-top));
  display:flex;align-items:flex-end;padding:0 1rem .65rem;gap:.5rem;
  box-shadow:0 2px 8px rgba(0,0,0,.35);
}
.ab-logo{font-size:1.1rem;font-weight:800;color:#fff;letter-spacing:-.3px}
.ab-logo span{color:#9A8BE0}
.ab-badge{font-size:.64rem;font-weight:700;background:var(--g);color:#fff;border-radius:4px;padding:1px 5px}
.ab-user{flex:1;font-size:.72rem;color:#B8B0D8;text-align:right;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.ab-logout{background:none;border:none;color:#8A7AC8;cursor:pointer;font-size:.78rem;padding:2px 6px;border-radius:4px;white-space:nowrap}
.ab-logout:hover{color:#fff}
.app-main{flex:1;overflow-y:auto;-webkit-overflow-scrolling:touch}
.panel{display:none;padding:.75rem .85rem;max-width:680px;margin:0 auto}
.panel.active{display:block}
.bottom-nav{
  position:fixed;bottom:0;left:0;right:0;z-index:300;
  background:var(--card);border-top:1.5px solid #e0e0e0;
  height:calc(var(--n-px) + env(safe-area-inset-bottom));
  display:flex;padding-bottom:env(safe-area-inset-bottom);
}
.nav-btn{
  flex:1;display:flex;flex-direction:column;align-items:center;justify-content:center;
  gap:3px;background:none;border:none;cursor:pointer;padding:.35rem 0 .25rem;
  color:#9ca3af;font-size:.58rem;font-weight:600;font-family:inherit;
  -webkit-tap-highlight-color:transparent;transition:color .15s;position:relative;letter-spacing:.2px;
}
.nav-btn .icon{font-size:1.25rem;line-height:1}
.nav-btn.active{color:var(--g)}
.nav-btn.active::before{
  content:'';position:absolute;top:0;left:15%;right:15%;
  height:3px;background:var(--g);border-radius:0 0 3px 3px;
}
.nav-badge{
  position:absolute;top:4px;right:calc(50% - 18px);
  background:var(--red);color:#fff;border-radius:9px;font-size:.6rem;font-weight:700;
  padding:1px 5px;min-width:16px;text-align:center;
}

/* SHARED */
.section-title{
  font-size:.68rem;font-weight:700;letter-spacing:1px;text-transform:uppercase;
  color:var(--g);margin:1rem 0 .45rem .1rem;
}
.section-title:first-child{margin-top:.1rem}
.card{background:var(--card);border-radius:var(--r);box-shadow:var(--sha);margin-bottom:.75rem;overflow:hidden}
.empty-state{text-align:center;padding:2.5rem 1rem;color:var(--sub);font-size:.88rem}
.empty-state .big{font-size:2rem;margin-bottom:.5rem}

/* SEARCH */
.loc-row{display:flex;gap:.5rem;align-items:stretch;margin-bottom:.55rem}
.loc-input{
  flex:1;padding:.7rem .9rem;border:1.5px solid #ddd;border-radius:8px;
  font-size:.9rem;font-family:inherit;outline:none;transition:border .15s;
}
.loc-input:focus{border-color:var(--g)}
.gps-btn{
  background:var(--g-l);border:1.5px solid var(--g);color:var(--g);
  border-radius:8px;padding:0 .85rem;cursor:pointer;
  display:flex;align-items:center;gap:.3rem;
  font-family:inherit;font-weight:700;font-size:.78rem;white-space:nowrap;
}
.gps-btn:active{background:var(--g);color:#fff}
.loc-display{
  background:var(--g-l);border-radius:8px;padding:.5rem .85rem;
  font-size:.8rem;color:#7B6BC4;font-weight:600;margin-bottom:.55rem;
  display:flex;align-items:center;gap:.4rem;
}
.num-selector{display:flex;gap:.5rem;margin-bottom:.75rem}
.num-btn{
  flex:1;padding:.65rem .3rem;border:1.5px solid #ddd;border-radius:8px;
  font-size:.9rem;font-weight:700;background:var(--card);cursor:pointer;
  font-family:inherit;transition:all .15s;text-align:center;
}
.num-btn.sel{background:var(--g);color:#fff;border-color:var(--g)}
.search-btn{
  width:100%;padding:.85rem;background:var(--g);color:#fff;border:none;
  border-radius:10px;font-size:1rem;font-weight:700;cursor:pointer;
  font-family:inherit;display:flex;align-items:center;justify-content:center;gap:.5rem;
}
.search-btn:hover{background:var(--g-h)}
.search-btn:disabled{background:#9ca3af;cursor:not-allowed}

/* RESULT CARDS */
.addr-card{
  background:var(--card);border-radius:var(--r);box-shadow:var(--sha);
  margin-bottom:.65rem;overflow:hidden;
}
.addr-header{display:flex;align-items:center;padding:.75rem 1rem;gap:.6rem}
.addr-num{
  width:28px;height:28px;background:var(--g-l);border-radius:50%;
  display:flex;align-items:center;justify-content:center;
  font-size:.72rem;font-weight:800;color:var(--g);flex-shrink:0;
}
.addr-main{flex:1;min-width:0}
.addr-street{font-size:.92rem;font-weight:700;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.addr-arzt{font-size:.75rem;color:var(--g);font-weight:600;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.addr-plz{font-size:.75rem;color:var(--sub)}
.addr-time{text-align:right;flex-shrink:0}
.addr-min{font-size:1rem;font-weight:800;color:var(--g)}
.addr-dist{font-size:.68rem;color:var(--sub)}
.addr-actions{padding:.1rem 1rem .75rem;display:flex;gap:.5rem}
.btn-take{
  flex:1;padding:.6rem;background:var(--g);color:#fff;border:none;
  border-radius:8px;font-size:.84rem;font-weight:700;cursor:pointer;font-family:inherit;
}
.btn-take:hover{background:var(--g-h)}
.btn-done{
  flex:1;padding:.6rem;background:#fff;color:var(--g);border:2px solid var(--g);
  border-radius:8px;font-size:.84rem;font-weight:700;cursor:pointer;font-family:inherit;
}
.btn-done:hover{background:var(--g-l)}
.mine-pill{
  display:inline-block;font-size:.65rem;font-weight:700;border-radius:4px;
  padding:2px 6px;background:#FFFDE0;color:#5A5000;
}

/* MEINE */
.mine-card{
  background:var(--card);border-radius:var(--r);box-shadow:var(--sha);
  margin-bottom:.65rem;border-left:4px solid var(--wbdr);
}
.mine-header{padding:.75rem 1rem .4rem;display:flex;align-items:flex-start;gap:.65rem}
.mine-icon{font-size:1.3rem;flex-shrink:0;margin-top:.05rem}
.mine-info{flex:1;min-width:0}
.mine-street{font-size:.9rem;font-weight:700}
.mine-plz{font-size:.73rem;color:var(--sub);margin-bottom:.2rem}
.mine-since{font-size:.7rem;color:var(--sub)}
.mine-actions{padding:.2rem 1rem .75rem}

/* DIALOG */
.dlg-overlay{
  position:fixed;inset:0;z-index:500;background:rgba(0,0,0,.5);
  display:flex;align-items:flex-end;justify-content:center;
  padding-bottom:env(safe-area-inset-bottom);
}
.dlg-card{
  background:#fff;border-radius:18px 18px 0 0;padding:1.5rem 1.25rem 1.25rem;
  width:100%;max-width:480px;animation:slideUp .2s ease-out;
}
@keyframes slideUp{from{transform:translateY(60px);opacity:0}to{transform:none;opacity:1}}
.dlg-title{font-size:1rem;font-weight:800;color:var(--dark);margin-bottom:.2rem}
.dlg-addr{font-size:.82rem;color:var(--sub);margin-bottom:1.1rem}
.dlg-options{display:flex;flex-direction:column;gap:.5rem;margin-bottom:1rem}
.dlg-opt{
  padding:.75rem 1rem;border:2px solid #e5e7eb;border-radius:10px;
  text-align:left;background:#fff;cursor:pointer;font-family:inherit;
  font-size:.88rem;font-weight:600;display:flex;align-items:center;gap:.65rem;
  transition:all .15s;
}
.dlg-opt:hover{border-color:var(--g);background:var(--g-l)}
.dlg-opt.selected{border-color:var(--g);background:var(--g);color:#fff}
.dlg-note{
  width:100%;padding:.65rem .9rem;border:1.5px solid #ddd;border-radius:8px;
  font-size:.88rem;font-family:inherit;resize:none;outline:none;margin-bottom:.85rem;
  transition:border .15s;
}
.dlg-note:focus{border-color:var(--g)}
.dlg-footer{display:flex;gap:.5rem}
.btn-cancel{
  flex:0 0 auto;padding:.72rem 1.1rem;background:#f3f4f6;border:none;
  border-radius:8px;font-size:.88rem;font-weight:600;cursor:pointer;font-family:inherit;
}
.btn-save{
  flex:1;padding:.72rem;background:var(--g);color:#fff;border:none;
  border-radius:8px;font-size:.9rem;font-weight:700;cursor:pointer;font-family:inherit;
}
.btn-save:disabled{background:#9ca3af;cursor:not-allowed}

/* MAP */
#p-karte{padding:0!important}
#map{height:calc(100dvh - var(--h-px) - var(--n-px) - env(safe-area-inset-top) - env(safe-area-inset-bottom))}

/* ADMIN */
.stats-grid{display:grid;grid-template-columns:1fr 1fr;gap:.55rem;margin-bottom:.85rem}
.stat-chip{
  background:var(--card);border-radius:10px;box-shadow:var(--sha);
  padding:.75rem .8rem;display:flex;flex-direction:column;gap:.1rem;
}
.sc-icon{font-size:1.3rem}
.sc-label{font-size:.66rem;color:var(--sub);font-weight:700;text-transform:uppercase;letter-spacing:.5px}
.sc-val{font-size:1.35rem;font-weight:800;color:var(--txt)}
.chip-g{border-left:4px solid var(--g)}
.chip-y{border-left:4px solid var(--wbdr)}
.chip-r{border-left:4px solid var(--red)}
.chip-b{border-left:4px solid #3b82f6}
.log-item{
  padding:.6rem 1rem;border-bottom:1px solid #f0f0f0;
  display:flex;align-items:flex-start;gap:.75rem;font-size:.82rem;
}
.log-item:last-child{border-bottom:none}
.log-dot{width:8px;height:8px;border-radius:50%;flex-shrink:0;margin-top:.35rem}
.ld-waehlt_uns{background:#7B6BC4}
.ld-waehlt_nicht{background:var(--red)}
.ld-ueberlegt{background:#D4C800}
.ld-kein_interesse_wahl{background:#9ca3af}
.ld-sonstige{background:#3b82f6}
.ld-uebernommen{background:var(--wbdr)}
.ld-reaktiviert{background:#3b82f6}
.log-main{flex:1}
.log-aktion{font-weight:700}
.log-detail{color:var(--sub);font-size:.75rem}

/* ARCHIVE */
.arch-card{
  background:var(--card);border-radius:var(--r);box-shadow:var(--sha);
  margin-bottom:.6rem;border-left:4px solid #e5e7eb;
}
.arch-header{padding:.7rem 1rem;display:flex;align-items:center;gap:.65rem}
.arch-icon{font-size:1.2rem;flex-shrink:0}
.arch-street{font-size:.88rem;font-weight:700}
.arch-meta{font-size:.72rem;color:var(--sub)}

/* TOAST */
.toast{
  position:fixed;bottom:calc(var(--n-px) + env(safe-area-inset-bottom) + .75rem);
  left:50%;transform:translateX(-50%);
  background:var(--dark);color:#fff;border-radius:24px;
  padding:.55rem 1.25rem;font-size:.85rem;font-weight:600;
  z-index:600;pointer-events:none;opacity:0;transition:opacity .25s;
  white-space:nowrap;max-width:90vw;
}
.toast.show{opacity:1}
.btn-reset{
  width:100%;margin-top:.5rem;padding:.65rem;background:#fff;color:var(--red);
  border:2px solid var(--red);border-radius:8px;font-size:.85rem;font-weight:700;
  cursor:pointer;font-family:inherit;
}
.btn-reset:hover{background:var(--red);color:#fff}

@media(min-width:600px){
  .stats-grid{grid-template-columns:repeat(4,1fr)}
  .panel{padding:1rem 1.5rem}
}
</style>
</head>
<body>

<!-- LOGIN -->
<div id="scr-login">
  <div class="login-card">
    <div class="login-logo">NOVUM<span>-ZIV</span></div>
    <div class="login-sub">Unterschriften &middot; Zahnaerztekammerwahl Wien 2026</div>
    <div class="demo-note">
      &#128296; <strong>Demo-Modus</strong> &mdash; lokale Testdaten, kein Server.<br>
      Admin: <strong>admin@demo.at</strong> / <strong>novum26</strong><br>
      Mitarbeiter: <strong>demo@demo.at</strong> / <strong>demo</strong>
    </div>
    <label for="inp-email">E-Mail</label>
    <input id="inp-email" type="email" autocomplete="email" placeholder="name@bnz-wien.at">
    <label for="inp-pw">Passwort</label>
    <input id="inp-pw" type="password" autocomplete="current-password" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;">
    <button class="btn-primary" onclick="auth.login()">Anmelden</button>
    <div id="login-err" class="login-err"></div>
  </div>
</div>

<!-- APP -->
<div id="scr-app" class="hidden">

  <header class="app-bar">
    <div class="ab-logo">NOVUM<span>-ZIV</span></div>
    <div class="ab-badge">DEMO</div>
    <div class="ab-user" id="ab-user"></div>
    <button class="ab-logout" onclick="auth.logout()">Abmelden</button>
  </header>

  <main class="app-main">

    <!-- SUCHEN -->
    <div id="p-home" class="panel active">
      <div class="section-title">Mein Standort</div>
      <div class="loc-row">
        <input id="loc-input" class="loc-input" type="text"
               placeholder="Adresse eingeben &hellip;"
               onkeydown="if(event.key==='Enter')loc.geocode()">
        <button class="gps-btn" onclick="loc.getGPS()">&#128205; GPS</button>
      </div>
      <div id="loc-display" class="loc-display hidden">
        &#128205; <span id="loc-text"></span>
      </div>
      <div class="section-title">Anzahl Adressen</div>
      <div class="num-selector" id="num-selector">
        <button class="num-btn" onclick="setNum(5)">5</button>
        <button class="num-btn sel" onclick="setNum(10)">10</button>
        <button class="num-btn" onclick="setNum(15)">15</button>
        <button class="num-btn" onclick="setNum(20)">20</button>
      </div>
      <button class="search-btn" id="search-btn" onclick="doSearch()">
        <span id="search-icon">&#128269;</span>
        <span id="search-label">N&auml;chste Adressen suchen</span>
      </button>
      <div id="results-wrap" style="margin-top:.85rem"></div>
    </div>

    <!-- MEINE -->
    <div id="p-meine" class="panel">
      <div id="meine-wrap"></div>
    </div>

    <!-- KARTE -->
    <div id="p-karte" class="panel">
      <div id="map"></div>
    </div>

    <!-- ARCHIV -->
    <div id="p-archive" class="panel">
      <div id="archive-wrap"></div>
    </div>

    <!-- ADMIN -->
    <div id="p-admin" class="panel">
      <div class="section-title">Gesamtstatistik</div>
      <div class="stats-grid" id="admin-stats"></div>
      <div class="section-title">Letzte Ereignisse</div>
      <div class="card" id="admin-log"></div>
      <div class="section-title">Team (19 Kandidat:innen)</div>
      <div class="card" id="admin-users"></div>
      <div class="section-title">Demo-Daten</div>
      <button class="btn-reset" onclick="S.reset()">&#128465; Alle Demo-Daten zur&uuml;cksetzen</button>
    </div>

  </main>

  <nav class="bottom-nav">
    <button class="nav-btn active" data-tab="home" onclick="showTab('home')">
      <span class="icon">&#128269;</span>Suchen
    </button>
    <button class="nav-btn" data-tab="meine" onclick="showTab('meine')">
      <span class="icon">&#128204;</span>Meine
      <span class="nav-badge hidden" id="badge-meine">0</span>
    </button>
    <button class="nav-btn" data-tab="karte" onclick="showTab('karte')">
      <span class="icon">&#128506;</span>Karte
    </button>
    <button class="nav-btn" data-tab="archive" onclick="showTab('archive')">
      <span class="icon">&#9989;</span>Archiv
    </button>
    <button class="nav-btn hidden" data-tab="admin" id="nav-admin" onclick="showTab('admin')">
      <span class="icon">&#9881;</span>Admin
    </button>
  </nav>

</div>

<!-- DIALOG -->
<div id="dlg-overlay" class="dlg-overlay hidden"
     onclick="if(event.target===this)dlg.close()">
  <div class="dlg-card">
    <div class="dlg-title">Ergebnis eintragen</div>
    <div class="dlg-addr" id="dlg-addr-text"></div>
    <div class="dlg-options">
      <button class="dlg-opt" data-action="waehlt_uns" onclick="dlg.select(this)">
        &#128314; Wählt uns
      </button>
      <button class="dlg-opt" data-action="waehlt_nicht" onclick="dlg.select(this)">
        &#10060; Wählt uns nicht
      </button>
      <button class="dlg-opt" data-action="ueberlegt" onclick="dlg.select(this)">
        &#129300; Überlegt noch
      </button>
      <button class="dlg-opt" data-action="kein_interesse_wahl" onclick="dlg.select(this)">
        &#128683; Kein Interesse an der Wahl
      </button>
      <button class="dlg-opt" data-action="sonstige" onclick="dlg.select(this)">
        &#128172; Sonstige Angaben
      </button>
    </div>
    <textarea id="dlg-note" class="dlg-note" rows="2"
              placeholder="Notiz (optional) &hellip;"></textarea>
    <div class="dlg-footer">
      <button class="btn-cancel" onclick="dlg.close()">Abbrechen</button>
      <button class="btn-save" id="dlg-save" onclick="dlg.save()" disabled>Speichern</button>
    </div>
  </div>
</div>

<!-- TOAST -->
<div class="toast" id="toast"></div>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
'use strict';

/* ── DEMO DATA ───────────────────────────────────────── */
const DEMO_USERS = [
  {id:'u01',email:'admin@demo.at',                   pw:'novum26',name:'Dr. Marius Romanin',          rolle:'admin'},
  {id:'u02',email:'demo@demo.at',                    pw:'demo',   name:'Demo Mitarbeiter:in',          rolle:'mitarbeiter'},
  {id:'u03',email:'marius.romanin@bnz-wien.at',      pw:'novum26',name:'Dr. Marius Romanin (BNZ)',     rolle:'admin'},
  {id:'u04',email:'franz.hastermann@bnz-wien.at',    pw:'novum26',name:'OMR Dr. Franz Hastermann',     rolle:'mitarbeiter'},
  {id:'u05',email:'petra.drabo@bnz-wien.at',         pw:'novum26',name:'Drin Petra Drabo',             rolle:'mitarbeiter'},
  {id:'u06',email:'andreas.eder@bnz-wien.at',        pw:'novum26',name:'DDr. Andreas Eder',            rolle:'mitarbeiter'},
  {id:'u07',email:'barbara.thornton@bnz-wien.at',    pw:'novum26',name:'MRin DDrin Barbara Thornton',  rolle:'mitarbeiter'},
  {id:'u08',email:'eren.eryilmaz@bnz-wien.at',       pw:'novum26',name:'Dr. Eren Eryilmaz',            rolle:'mitarbeiter'},
  {id:'u09',email:'leon.golestani@bnz-wien.at',      pw:'novum26',name:'Dr. Leon Golestani BSc',       rolle:'mitarbeiter'},
  {id:'u10',email:'julia.glatz@bnz-wien.at',         pw:'novum26',name:'Drin Julia Stella Glatz',      rolle:'mitarbeiter'},
  {id:'u11',email:'andrietta.dossenbach@bnz-wien.at',pw:'novum26',name:'Drin Andrietta Dossenbach',    rolle:'mitarbeiter'},
  {id:'u12',email:'andrea.gamper@bnz-wien.at',       pw:'novum26',name:'Drin Andrea Gamper',           rolle:'mitarbeiter'},
  {id:'u13',email:'dino.imsirovic@bnz-wien.at',      pw:'novum26',name:'Dr. Dino Imsirovic',           rolle:'mitarbeiter'},
  {id:'u14',email:'gerhard.schager@bnz-wien.at',     pw:'novum26',name:'MR Dr. Gerhard Schager',       rolle:'mitarbeiter'},
  {id:'u15',email:'paul.inkofer@bnz-wien.at',        pw:'novum26',name:'Dr. Paul Inkofer',             rolle:'mitarbeiter'},
  {id:'u16',email:'andrea.bednar-brandt@bnz-wien.at',pw:'novum26',name:'Drin Andrea Bednar-Brandt',    rolle:'mitarbeiter'},
  {id:'u17',email:'anita.elmauthaler@bnz-wien.at',   pw:'novum26',name:'Drin Anita Elmauthaler',       rolle:'mitarbeiter'},
  {id:'u18',email:'petra.stuehlinger@bnz-wien.at',   pw:'novum26',name:'Drin Petra Stühlinger',        rolle:'mitarbeiter'},
  {id:'u19',email:'lama.hamisch@bnz-wien.at',        pw:'novum26',name:'Drin Lama Hamisch MSc',        rolle:'mitarbeiter'},
  {id:'u20',email:'otis.rezegh@bnz-wien.at',         pw:'novum26',name:'Dr. Otis Rezegh',              rolle:'mitarbeiter'},
  {id:'u21',email:'selma.husejnovic@bnz-wien.at',    pw:'novum26',name:'Drin Selma Husejnovic',        rolle:'mitarbeiter'},
];

const SEED_ADRESSEN = [
  {id:'a0001',plz:'1190',strasse:'Heiligenstädter Straße',hnr:'69/10',titel:'PhDr.',name:'Ahmad Aburomiah',lat:48.25638,lon:16.36618},
  {id:'a0002',plz:'1200',strasse:'Jägerstraße',hnr:'23/4',titel:'Dr.',name:'Faten Abo Khachabe',lat:48.23853,lon:16.37088},
  {id:'a0007',plz:'1200',strasse:'Innstraße',hnr:'3',titel:'DDr.',name:'Dajana Miriam Achunow',lat:48.23082,lon:16.38705},
  {id:'a0008',plz:'1020',strasse:'Große Mohrengasse',hnr:'9',titel:'DDr.',name:'Sorin-Rado Adam',lat:48.21489,lon:16.38172},
  {id:'a0009',plz:'1050',strasse:'Ramperstorffergasse',hnr:'68',titel:'',name:'David Adler',lat:48.19027,lon:16.35519},
  {id:'a0010',plz:'1170',strasse:'Rhigasgasse',hnr:'8',titel:'Dr.',name:'Sepand Aeenechi',lat:48.22301,lon:16.32311},
  {id:'a0011',plz:'1130',strasse:'Altgasse',hnr:'11',titel:'Dr.',name:'Neda Afsharzadeh-Erstic',lat:48.18515,lon:16.29941},
  {id:'a0012',plz:'1190',strasse:'Billrothstraße',hnr:'58/11',titel:'Dr.',name:'Claudia Aichinger-Pfandl',lat:48.24303,lon:16.34738},
  {id:'a0015',plz:'1060',strasse:'Schadekgasse',hnr:'8/8',titel:'Dr.',name:'Heidelinde Aigner-Schmid',lat:48.19803,lon:16.35268},
  {id:'a0016',plz:'1220',strasse:'Ennemosergasse',hnr:'4/1',titel:'Dr.',name:'Samar Ajouri',lat:48.22159,lon:16.53185},
  {id:'a0017',plz:'1180',strasse:'Hans-Sachs-Gasse',hnr:'29',titel:'Dr.',name:'Muhlis Akarsu',lat:48.22551,lon:16.34578},
  {id:'a0018',plz:'1130',strasse:'Speisinger Straße',hnr:'214/1',titel:'Dr.',name:'Jangi Akhondi',lat:48.16318,lon:16.27943},
  {id:'a0020',plz:'1040',strasse:'Wiedner Hauptstraße',hnr:'64/2#',titel:'Dr.',name:'Ghazwan Aktaa',lat:48.19610,lon:16.36709},
  {id:'a0023',plz:'1120',strasse:'Ratschkygasse',hnr:'5/6',titel:'Dr.',name:'Ghazwan Al Janabi',lat:48.17717,lon:16.32773},
  {id:'a0024',plz:'1040',strasse:'Goldeggasse',hnr:'2/4',titel:'Dr. med. dent.',name:'Ali Al Samarrae',lat:48.18978,lon:16.37718},
  {id:'a0026',plz:'1060',strasse:'Stumpergasse',hnr:'57/5',titel:'Dr.',name:'Mohammed Amer Majeed Al Dabbagh',lat:48.19538,lon:16.34288},
  {id:'a0028',plz:'1140',strasse:'Spallartgasse',hnr:'6/218',titel:'Dr.',name:'Abdullah Alabdullah',lat:48.20077,lon:16.30607},
  {id:'a0029',plz:'1230',strasse:'Breitenfurter Straße',hnr:'360-368/1/1',titel:'Dr.',name:'Amina Alam El Din',lat:48.13593,lon:16.28220},
  {id:'a0030',plz:'1140',strasse:'Hochsatzengasse',hnr:'32/18',titel:'Dr.',name:'Mohammad Albarazi',lat:48.19581,lon:16.27609},
  {id:'a0031',plz:'1090',strasse:'Boltzmanngasse',hnr:'20/8',titel:'Dr.',name:'Andrea Albert',lat:48.22416,lon:16.35652},
  {id:'a0032',plz:'1120',strasse:'Schönbrunner Straße',hnr:'236/17',titel:'Dr. med. dent.',name:'Melania Albert',lat:48.18378,lon:16.32007},
  {id:'a0034',plz:'1070',strasse:'Neustiftgasse',hnr:'104/6',titel:'Dr.',name:'Horia Dan Albu',lat:48.20608,lon:16.33904},
  {id:'a0035',plz:'1040',strasse:'Heumühlgasse',hnr:'18/13',titel:'Dr.',name:'Gabriele Alexandru',lat:48.19654,lon:16.36136},
  {id:'a0036',plz:'1120',strasse:'Breitenfurterstraße',hnr:'107-109/1',titel:'Dr.',name:'Monika Alf',lat:48.17095,lon:16.32378},
  {id:'a0037',plz:'1200',strasse:'Spaungasse',hnr:'17/19',titel:'Dr.',name:'Umar Alhujazy',lat:48.23457,lon:16.36507},
  {id:'a0038',plz:'1040',strasse:'Mommsengasse',hnr:'28',titel:'Dr.',name:'Maitham Ali',lat:48.18858,lon:16.37861},
  {id:'a0039',plz:'1030',strasse:'Beatrixgasse',hnr:'3/5',titel:'Dr.',name:'Nadya Ali',lat:48.20157,lon:16.38047},
  {id:'a0040',plz:'1030',strasse:'Salesianergasse',hnr:'4',titel:'Dr. med. dent.',name:'Siamak Alizadeh',lat:48.20065,lon:16.38075},
  {id:'a0042',plz:'1020',strasse:'Freudplatz',hnr:'1',titel:'Dr.',name:'Marwa Alsafar',lat:48.21514,lon:16.40528},
  {id:'a0043',plz:'1230',strasse:'Dr. Neumann Gasse',hnr:'9',titel:'Dr.',name:'Alaa Eddin Alshahel',lat:48.13831,lon:16.28642},
  {id:'a0044',plz:'1050',strasse:'Margaretengürtel',hnr:'18/4/B/7',titel:'Dr.',name:'Omer Altemimy',lat:48.18376,lon:16.34644},
  {id:'a0046',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Gülümser Altinkaynak',lat:48.21955,lon:16.35453},
  {id:'a0047',plz:'1200',strasse:'Klosterneuburger Straße',hnr:'40/7',titel:'Dr.',name:'Alexander Altmann',lat:48.22826,lon:16.36863},
  {id:'a0048',plz:'1130',strasse:'Bergheidengasse',hnr:'8',titel:'DDr.',name:'Dagmar Altrichter',lat:48.16933,lon:16.28831},
  {id:'a0049',plz:'1220',strasse:'Zschokkegasse',hnr:'140',titel:'Dr.',name:'Lilian Altziebler',lat:48.22002,lon:16.46409},
  {id:'a0050',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'Dr.',name:'Alwand Amir-Asgari',lat:48.19748,lon:16.34833},
  {id:'a0052',plz:'1140',strasse:'Linzer Straße',hnr:'403/8',titel:'Dr.',name:'Daniela-Isabelle Ancutici',lat:48.19426,lon:16.29267},
  {id:'a0053',plz:'1220',strasse:'Wagramer Straße',hnr:'127',titel:'Dr.',name:'Abir Anderawes',lat:48.24805,lon:16.44142},
  {id:'a0054',plz:'1230',strasse:'Othellogasse',hnr:'1/3/1',titel:'Dr.',name:'Christoph Andersson',lat:48.13768,lon:16.34985},
  {id:'a0057',plz:'1010',strasse:'Getreidemarkt',hnr:'11/23',titel:'DDr.',name:'Michael Angerer',lat:48.20180,lon:16.36244},
  {id:'a0058',plz:'1220',strasse:'Langobardenstraße',hnr:'122',titel:'Dr.',name:'Ghassan Anjem',lat:48.21931,lon:16.46448},
  {id:'a0059',plz:'1100',strasse:'Burgenlandgasse',hnr:'74',titel:'Dr.',name:'Robert Annau',lat:48.15301,lon:16.40276},
  {id:'a0061',plz:'1010',strasse:'Nibelungengasse',hnr:'1-3',titel:'DDr.',name:'Ulrich Jörg Arhold',lat:48.20148,lon:16.36627},
  {id:'a0062',plz:'1030',strasse:'Hintzerstraße',hnr:'10',titel:'Dr.',name:'Christoph Arnhart',lat:48.20030,lon:16.39065},
  {id:'a0064',plz:'1020',strasse:'Praterstraße',hnr:'40/4',titel:'Dr.',name:'Silvie Aschauer',lat:48.21551,lon:16.38578},
  {id:'a0067',plz:'1100',strasse:'Pernerstorfergasse',hnr:'38/8',titel:'medic stom.',name:'Elena Ataman',lat:48.17722,lon:16.36526},
  {id:'a0068',plz:'1060',strasse:'Webgasse',hnr:'29/15',titel:'Dr.',name:'Fahim Atamni',lat:48.19585,lon:16.34482},
  {id:'a0069',plz:'1090',strasse:'Währinger Straße',hnr:'70/6',titel:'Dr.',name:'Diana Atassi',lat:48.22168,lon:16.35404},
  {id:'a0070',plz:'1140',strasse:'Hütteldorfer Straße',hnr:'88/2/9',titel:'Dr.',name:'Karin Auer',lat:48.19761,lon:16.29867},
  {id:'a0072',plz:'1070',strasse:'Mariahilfer Straße',hnr:'114',titel:'Ddr.',name:'Levente Aved',lat:48.19689,lon:16.34278},
  {id:'a0073',plz:'1080',strasse:'Blindengasse',hnr:'53/4',titel:'Dott. mag.',name:'Tommaso Avventi',lat:48.21414,lon:16.34156},
  {id:'a0075',plz:'1040',strasse:'Karlsgasse',hnr:'3/16',titel:'Dr.',name:'Roni Babadostov',lat:48.19724,lon:16.36996},
  {id:'a0077',plz:'1220',strasse:'Doeltergasse',hnr:'3/1/1',titel:'Dr. med. univ.',name:'Martin Baczynski',lat:48.25718,lon:16.43736},
  {id:'a0078',plz:'1190',strasse:'Gallmeyergasse',hnr:'6/1/3',titel:'Prim. Dr.',name:'Mihai-Adrian Badulescu',lat:48.24591,lon:16.35702},
  {id:'a0079',plz:'1090',strasse:'Liechtensteinstraße',hnr:'97/201',titel:'Dr.',name:'Krisztina Bagi',lat:48.21766,lon:16.36203},
  {id:'a0080',plz:'1130',strasse:'Eduard Klein Gasse',hnr:'11',titel:'DDr.',name:'Christine Baier',lat:48.18764,lon:16.30138},
  {id:'a0081',plz:'1160',strasse:'Baumeistergasse',hnr:'1/14/1',titel:'Dr.',name:'Brigitte Balduin-Stark',lat:48.22161,lon:16.29930},
  {id:'a0084',plz:'1050',strasse:'Schloßgasse',hnr:'16/37',titel:'Dr.',name:'Daniel Jozsef Bank',lat:48.19009,lon:16.36003},
  {id:'a0085',plz:'1010',strasse:'Börseplatz',hnr:'6/1/8',titel:'Dr',name:'Hans-Peter Bantleon',lat:48.21491,lon:16.36778},
  {id:'a0086',plz:'1010',strasse:'Dorotheergasse',hnr:'12',titel:'Dr.',name:'Johannes Bantleon',lat:48.20738,lon:16.36907},
  {id:'a0087',plz:'1220',strasse:'Janis Joplin Promenade',hnr:'14/1',titel:'Dr.',name:'Artur Baraev',lat:48.22695,lon:16.50394},
  {id:'a0089',plz:'1050',strasse:'Ramperstorffergasse',hnr:'68',titel:'Dr.',name:'Mate Barany',lat:48.19027,lon:16.35519},
  {id:'a0090',plz:'1090',strasse:'Spitalgasse',hnr:'17/a',titel:'Dr.',name:'Nora Barrak',lat:48.21750,lon:16.35114},
  {id:'a0091',plz:'1180',strasse:'Schulgasse',hnr:'22/3',titel:'Dr.',name:'Barbara Barth',lat:48.22570,lon:16.33857},
  {id:'a0092',plz:'1150',strasse:'Hütteldorfer Straße',hnr:'26',titel:'Dr.',name:'Behfar Basharat',lat:48.19960,lon:16.32775},
  {id:'a0093',plz:'1020',strasse:'Taborstraße',hnr:'5/4',titel:'Dr.',name:'Marielle Bauer',lat:48.21861,lon:16.38090},
  {id:'a0094',plz:'1150',strasse:'Grenzgasse',hnr:'5',titel:'Dr.',name:'Marion Bauer',lat:48.19204,lon:16.32986},
  {id:'a0095',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Peter Maximilian Bauer',lat:48.21955,lon:16.35453},
  {id:'a0096',plz:'1100',strasse:'Stockholmer Platz',hnr:'2',titel:'Dr.',name:'Walter Bauer',lat:48.14963,lon:16.38170},
  {id:'a0097',plz:'1090',strasse:'Borschkegasse',hnr:'7/9',titel:'Dr.',name:'Christiane Baumann',lat:48.21790,lon:16.34556},
  {id:'a0098',plz:'1230',strasse:'Speisinger Straße',hnr:'149a',titel:'Dr.',name:'Heinz Baumer',lat:48.15910,lon:16.27631},
  {id:'a0099',plz:'1110',strasse:'Brehmstraße',hnr:'2/11',titel:'Dr.',name:'Franz Baumgärtner',lat:48.17534,lon:16.40612},
  {id:'a0100',plz:'1080',strasse:'Florianigasse',hnr:'50/2/3',titel:'Dr.',name:'Florian Beck',lat:48.21191,lon:16.35179},
  {id:'a0101',plz:'1230',strasse:'Maurer Hauptplatz',hnr:'8a',titel:'Dr.',name:'Melita Becker',lat:48.15123,lon:16.26769},
  {id:'a0102',plz:'1190',strasse:'Döblinger Hauptstraße',hnr:'41',titel:'Dr.',name:'Hannelore Beckh-Widmanstetter',lat:48.23821,lon:16.35412},
  {id:'a0103',plz:'1130',strasse:'Firmiangasse',hnr:'28',titel:'DDr.',name:'Franziska Beer',lat:48.19175,lon:16.26942},
  {id:'a0104',plz:'1090',strasse:'Bindergasse',hnr:'5-9/7',titel:'Dr.',name:'Susanne Maria Monika Beer',lat:48.22623,lon:16.35639},
  {id:'a0105',plz:'1120',strasse:'Schönbrunner Straße',hnr:'244/1/5',titel:'Dr.',name:'Peter Beiwl',lat:48.18724,lon:16.34302},
  {id:'a0106',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Katrin Bekes',lat:48.21955,lon:16.35453},
  {id:'a0107',plz:'1040',strasse:'Gußhausstraße',hnr:'21/13',titel:'',name:'Sami Serdar Beklen',lat:48.19680,lon:16.37034},
  {id:'a0108',plz:'1150',strasse:'Mariahilfer Straße',hnr:'139/5-6',titel:'Dr.',name:'Otto Belk',lat:48.19590,lon:16.33946},
  {id:'a0109',plz:'1190',strasse:'Billrothstraße',hnr:'12',titel:'DDr.',name:'Jaroslav Belsky',lat:48.23601,lon:16.35028},
  {id:'a0110',plz:'1030',strasse:'Erdbergstraße',hnr:'202/E7a',titel:'Dr.',name:'Igor Benda',lat:48.19027,lon:16.41417},
  {id:'a0111',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'Dr.',name:'Natascha Benke',lat:48.19748,lon:16.34833},
  {id:'a0112',plz:'1210',strasse:'Wannemachergasse',hnr:'4',titel:'Dr.',name:'Grzegorz Berecki',lat:48.27990,lon:16.40986},
  {id:'a0113',plz:'1100',strasse:'Wienerbergstraße',hnr:'15-19',titel:'Dr.',name:'Barbara Lisbeth Berger',lat:48.16956,lon:16.34391},
  {id:'a0114',plz:'1170',strasse:'Lobenhauerngasse',hnr:'38/8',titel:'Dr.',name:'Julia Teresa Berger',lat:48.21785,lon:16.32414},
  {id:'a0115',plz:'1190',strasse:'Formanekgasse',hnr:'20/2',titel:'Dr.',name:'Stellan Bergert',lat:48.24582,lon:16.35171},
  {id:'a0116',plz:'1170',strasse:'Palffygasse',hnr:'25',titel:'Dr.',name:'Boguslaw Berlinski',lat:48.21731,lon:16.33693},
  {id:'a0117',plz:'1200',strasse:'Höchstädtplatz',hnr:'4/182',titel:'',name:'Irene Luise Bernhard',lat:48.23980,lon:16.37760},
  {id:'a0118',plz:'1220',strasse:'Gunertweg',hnr:'2/2',titel:'Univ.-Prof. Dr.',name:'Thomas Bernhart',lat:48.24970,lon:16.47915},
  {id:'a0119',plz:'1220',strasse:'Gunertweg',hnr:'2/2',titel:'Dr.',name:'Danila Bernhart',lat:48.24970,lon:16.47915},
  {id:'a0120',plz:'1220',strasse:'Langobardenstraße',hnr:'122',titel:'Dr.',name:'Lukas Berr',lat:48.21931,lon:16.46448},
  {id:'a0121',plz:'1190',strasse:'Obkirchergasse',hnr:'38/2',titel:'Dr.',name:'Markus Bernsteiner',lat:48.24451,lon:16.34217},
  {id:'a0122',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Kristina Bertl',lat:48.21955,lon:16.35453},
  {id:'a0124',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Magdalena Beshir',lat:48.21955,lon:16.35453},
  {id:'a0125',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Ferida Besirevic-Bulic',lat:48.21955,lon:16.35453},
  {id:'a0126',plz:'1090',strasse:'Nußdorfer Straße',hnr:'68/17',titel:'Dr.',name:'Katharina Anja-Maria Besser-Kizilyamac',lat:48.22538,lon:16.35485},
  {id:'a0127',plz:'1170',strasse:'Teichgasse',hnr:'1/1/12',titel:'Dr.',name:'Andrea Bias',lat:48.21430,lon:16.32740},
  {id:'a0128',plz:'1030',strasse:'Landstraßer Hauptstraße',hnr:'12/3',titel:'Dr.',name:'Günther Bierbaumer',lat:48.20476,lon:16.38763},
  {id:'a0129',plz:'1230',strasse:'Breitenfurter Straße',hnr:'360-368/1/1',titel:'',name:'Raphaela Bigaj',lat:48.13593,lon:16.28220},
  {id:'a0130',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'Dr.',name:'Hanna Bilinska',lat:48.19748,lon:16.34833},
  {id:'a0131',plz:'1070',strasse:'Neubaugasse',hnr:'37/15',titel:'DDr.',name:'Peter Binder',lat:48.20082,lon:16.34911},
  {id:'a0132',plz:'1130',strasse:'Rohrbacher Straße',hnr:'17/1',titel:'Dr.',name:'Romana Binder-Illichmann',lat:48.18917,lon:16.27192},
  {id:'a0133',plz:'1080',strasse:'Lange Gasse',hnr:'63/12',titel:'Dr.',name:'Florian Biowski',lat:48.21123,lon:16.35162},
  {id:'a0136',plz:'1010',strasse:'Kohlmarkt',hnr:'5',titel:'Dr.',name:'Martin Kurt Bischetsrieder',lat:48.20900,lon:16.36816},
  {id:'a0137',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Clara Bischof',lat:48.21955,lon:16.35453},
  {id:'a0138',plz:'1210',strasse:'Mengergasse',hnr:'29/1',titel:'Dr.',name:'Barbara Bitriol',lat:48.25611,lon:16.40973},
  {id:'a0139',plz:'1030',strasse:'Reisnerstraße',hnr:'14',titel:'Dr.',name:'Klaus-Dieter Bliemegger',lat:48.20142,lon:16.38312},
  {id:'a0142',plz:'1030',strasse:'Untere Weißgerberstraße',hnr:'47/4',titel:'Dr.',name:'Martina Bögl',lat:48.21048,lon:16.39360},
  {id:'a0143',plz:'1030',strasse:'Jacquingasse',hnr:'41',titel:'DDr.',name:'Alexander Bogner',lat:48.19061,lon:16.38491},
  {id:'a0144',plz:'1180',strasse:'Währinger Straße',hnr:'108',titel:'Ddr.',name:'Stefan Bollschweiler',lat:48.22614,lon:16.34525},
  {id:'a0146',plz:'1050',strasse:'Wiedner Hauptstraße',hnr:'156',titel:'Dr. med. dent.',name:'Andrea Borbely',lat:48.18200,lon:16.35856},
  {id:'a0147',plz:'1230',strasse:'Breitenfurter Straße',hnr:'360-368/1/1',titel:'',name:'Sarra Boukhobza',lat:48.13593,lon:16.28220},
  {id:'a0149',plz:'1010',strasse:'Seilergasse',hnr:'9/5',titel:'MR Dr. med. univ.',name:'Peter Brandstätter',lat:48.20665,lon:16.37036},
  {id:'a0150',plz:'1190',strasse:'Koschatgasse',hnr:'5',titel:'Dr.',name:'Sabine Brandstätter',lat:48.24048,lon:16.32814},
  {id:'a0151',plz:'1110',strasse:'Simmeringer Hauptstraße',hnr:'118',titel:'MR Dr.',name:'Claus Robert Braun',lat:48.17104,lon:16.41922},
  {id:'a0153',plz:'1140',strasse:'Hadikgasse',hnr:'154/4',titel:'Ddr.',name:'Siegfried Breithuber',lat:48.19045,lon:16.29270},
  {id:'a0154',plz:'1050',strasse:'Franzensgasse',hnr:'22/1-2',titel:'Dr. med. dent.',name:'Marie-Therese Brenner',lat:48.19539,lon:16.35917},
  {id:'a0156',plz:'1180',strasse:'Thimiggasse',hnr:'64/6',titel:'Dr.',name:'Matthäus Breu',lat:48.23081,lon:16.32565},
  {id:'a0157',plz:'1110',strasse:'Gottschalkgasse',hnr:'15/6',titel:'Dr.',name:'Gabriele Brim',lat:48.17379,lon:16.41230},
  {id:'a0159',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Margit Bristela',lat:48.21955,lon:16.35453},
  {id:'a0160',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Corinna Bruckmann',lat:48.21955,lon:16.35453},
  {id:'a0161',plz:'1180',strasse:'Weinhauser Gasse',hnr:'5/11',titel:'Dr.',name:'Kaya Buchegger',lat:48.22979,lon:16.33091},
  {id:'a0162',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Ivana Buchmayer',lat:48.21955,lon:16.35453},
  {id:'a0163',plz:'1020',strasse:'Nestroyplatz',hnr:'1/10',titel:'Dr. med. dent.',name:'Nikolaus Otto Budas',lat:48.21488,lon:16.38436},
  {id:'a0164',plz:'1010',strasse:'Johannesgasse',hnr:'14/42a',titel:'Dr.',name:'Lena Sophie Bügler',lat:48.20336,lon:16.37648},
  {id:'a0166',plz:'1080',strasse:'Breitenfelder Gasse',hnr:'2/13',titel:'DDr.',name:'Alexander Burger',lat:48.21416,lon:16.34355},
  {id:'a0167',plz:'1030',strasse:'Landstraßer Hauptstraße',hnr:'102/7',titel:'Dr',name:'Martin Burian',lat:48.18941,lon:16.40004},
  {id:'a0168',plz:'1040',strasse:'Schleifmühlgasse',hnr:'7/12',titel:'Dr.',name:'Irene Burian-Böhm',lat:48.19837,lon:16.36394},
  {id:'a0169',plz:'1230',strasse:'Hochstraße',hnr:'13',titel:'Dr.',name:'Alexander Burker',lat:48.13204,lon:16.25875},
  {id:'a0170',plz:'1110',strasse:'Simmeringer Platz',hnr:'1/2/6',titel:'Dr.',name:'Maria Burt',lat:48.16934,lon:16.41965},
  {id:'a0171',plz:'1010',strasse:'Bergheidengasse',hnr:'8/1/5',titel:'Dr.',name:'Werner Buschbeck',lat:48.17067,lon:16.28937},
  {id:'a0172',plz:'1010',strasse:'Dorotheergasse',hnr:'7/5',titel:'Dr.',name:'Denise Elizabeth Busche',lat:48.20651,lon:16.36860},
  {id:'a0173',plz:'1230',strasse:'Breitenfurter Straße',hnr:'360-368/1/1',titel:'Dr.',name:'Dieter Busenlechner',lat:48.13593,lon:16.28220},
  {id:'a0174',plz:'1090',strasse:'Lazarettgasse',hnr:'33/32',titel:'Dr.',name:'Jens Busk',lat:48.21715,lon:16.34281},
  {id:'a0175',plz:'1190',strasse:'Kaasgrabengasse 89A',hnr:'2',titel:'Dr',name:'Zoltàn Kàroly Buzogàny',lat:48.25048,lon:16.33887},
  {id:'a0176',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Marija Cakarevic',lat:48.21955,lon:16.35453},
  {id:'a0177',plz:'1100',strasse:'Keplergasse',hnr:'16/4',titel:'Dr. med. dent.',name:'Kosta Carcev',lat:48.17916,lon:16.37601},
  {id:'a0178',plz:'1060',strasse:'Strohmayergasse',hnr:'7/8',titel:'Dr. med. dent.',name:'Emese Enikö Caspary',lat:48.19220,lon:16.34106},
  {id:'a0179',plz:'1090',strasse:'Währinger Gürtel',hnr:'130/12',titel:'Dr.',name:'Mattia Castegnaro',lat:48.22298,lon:16.34874},
  {id:'a0180',plz:'1010',strasse:'Bösendorferstraße',hnr:'6/3/17',titel:'Dr. med. dent.',name:'Mario Castro-Hurtarte',lat:48.20105,lon:16.37183},
  {id:'a0181',plz:'1010',strasse:'Getreidemarkt',hnr:'18/1/10',titel:'Dr.',name:'Thomas Cede',lat:48.20091,lon:16.36544},
  {id:'a0182',plz:'1090',strasse:'Pelikangasse',hnr:'14/27',titel:'DDr.',name:'Julia Cede',lat:48.21701,lon:16.34815},
  {id:'a0183',plz:'1230',strasse:'Dr. Neumann Gasse',hnr:'9',titel:'Dr.',name:'Fiona Cejnek',lat:48.13831,lon:16.28642},
  {id:'a0185',plz:'1100',strasse:'Sonnwendgasse',hnr:'16/1/2',titel:'ao. Univ.-Prof. Dr.',name:'Ales Celar',lat:48.17885,lon:16.37982},
  {id:'a0186',plz:'1100',strasse:'Landgutgasse',hnr:'2/1/2',titel:'Dr.',name:'Robert Celar',lat:48.18152,lon:16.37857},
  {id:'a0189',plz:'1100',strasse:'Davidgasse',hnr:'9/1',titel:'Dr.',name:'Peter Cernuska',lat:48.17318,lon:16.37652},
  {id:'a0190',plz:'1100',strasse:'Trambauerstraße',hnr:'5/38',titel:'MR Dr.',name:'Kurt Cerny',lat:48.16772,lon:16.37189},
  {id:'a0191',plz:'1030',strasse:'Parkgasse',hnr:'15',titel:'Dr.',name:'Julia Cerny',lat:48.20322,lon:16.39466},
  {id:'a0192',plz:'1090',strasse:'Roßauer Lände',hnr:'45/8',titel:'Dr.',name:'Wolfgang Cerny',lat:48.22371,lon:16.36713},
  {id:'a0193',plz:'1050',strasse:'Ramperstorffergasse',hnr:'68',titel:'Dr.',name:'Miriam Charfi',lat:48.19027,lon:16.35519},
  {id:'a0195',plz:'1190',strasse:'Himmelstraße',hnr:'18',titel:'DDr.',name:'Susanne Chiari-Töpker',lat:48.25740,lon:16.33755},
  {id:'a0196',plz:'1010',strasse:'Krugerstraße',hnr:'8/10',titel:'DDr.',name:'Ludmilla Chyplyk',lat:48.20400,lon:16.37119},
  {id:'a0197',plz:'1180',strasse:'Canongasse',hnr:'6/12',titel:'Dr.',name:'Iuliu-Petru Cionca',lat:48.22335,lon:16.34705},
  {id:'a0199',plz:'1040',strasse:'Trappelgasse',hnr:'11/10',titel:'Dr.',name:'Ibolya Crepaz',lat:48.18837,lon:16.36588},
  {id:'a0200',plz:'1090',strasse:'Glasergasse',hnr:'16/12',titel:'Dr.',name:'Iris Crepaz',lat:48.22433,lon:16.36278},
  {id:'a0201',plz:'1040',strasse:'Trappelgasse',hnr:'11/10',titel:'Dr.',name:'Lukas Crepaz',lat:48.18837,lon:16.36588},
  {id:'a0203',plz:'1060',strasse:'Getreidemarkt',hnr:'1/7a',titel:'Dr.',name:'Cornelius Crupinschi',lat:48.20148,lon:16.36351},
  {id:'a0204',plz:'1060',strasse:'Gumpendorfer Straße',hnr:'87/1/1',titel:'Dr.',name:'Daniela Crupinschi',lat:48.19747,lon:16.35354},
  {id:'a0205',plz:'1190',strasse:'Heiligenstädter Straße',hnr:'9',titel:'dr. med. dent.',name:'Imre Csapo',lat:48.23260,lon:16.35534},
  {id:'a0207',plz:'1020',strasse:'Freudplatz',hnr:'1',titel:'Dr.',name:'Barbara Cvikl',lat:48.21514,lon:16.40528},
  {id:'a0208',plz:'1230',strasse:'Eduard Kittenberger Gasse 34 Haus',hnr:'1',titel:'DDr.',name:'Cornelia Czembirek',lat:48.14641,lon:16.30407},
  {id:'a0209',plz:'1090',strasse:'Berggasse',hnr:'15/6a',titel:'Dr. med. univ.',name:'Wolfgang Czernicky',lat:48.21907,lon:16.36519},
  {id:'a0210',plz:'1100',strasse:'Hardtmuthgasse',hnr:'42',titel:'',name:'Lilya Dakhkilgova',lat:48.16996,lon:16.37266},
  {id:'a0211',plz:'1210',strasse:'Karl Aschenbrenner Gasse',hnr:'3',titel:'Dr.',name:'Harald Danek',lat:48.25351,lon:16.39736},
  {id:'a0212',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Bojan Danilovic',lat:48.21955,lon:16.35453},
  {id:'a0213',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Ivan Danilovic',lat:48.21955,lon:16.35453},
  {id:'a0215',plz:'1160',strasse:'Yppenplatz',hnr:'7/9+10',titel:'Dr.',name:'Manuel Maria Danner',lat:48.21310,lon:16.33539},
  {id:'a0216',plz:'1210',strasse:'Hufgasse',hnr:'30',titel:'DDr.',name:'Diana Dawoud',lat:48.26163,lon:16.41870},
  {id:'a0217',plz:'1150',strasse:'Schwendergasse',hnr:'19/13',titel:'Dr. med. univ.',name:'Anna Daxer',lat:48.19092,lon:16.32665},
  {id:'a0219',plz:'1040',strasse:'Argentinier Straße',hnr:'69',titel:'DDr.',name:'Irina Dechtyar',lat:48.18773,lon:16.37728},
  {id:'a0220',plz:'1140',strasse:'Sebastian Kelch Gasse',hnr:'16/12',titel:'Dr.',name:'Saskia Deciu',lat:48.19822,lon:16.30895},
  {id:'a0221',plz:'1100',strasse:'Wienerbergstraße',hnr:'15-19',titel:'Dr.',name:'Daniela Degendorfer',lat:48.16956,lon:16.34391},
  {id:'a0222',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'Dr.',name:'Shiva Dehghani Firouz Abadi',lat:48.19748,lon:16.34833},
  {id:'a0223',plz:'1070',strasse:'Kaiserstraße',hnr:'5/17',titel:'Ddr.',name:'Edith Deinhofer',lat:48.19826,lon:16.34120},
  {id:'a0224',plz:'1190',strasse:'Billrothstraße',hnr:'12',titel:'Dr.-medic stom.',name:'Ioana-Ruxandra Dejeu',lat:48.23601,lon:16.35028},
  {id:'a0225',plz:'1220',strasse:'Meissauergasse',hnr:'15/5/1',titel:'Dr.',name:'Erika Devenyi',lat:48.24849,lon:16.43978},
  {id:'a0226',plz:'1020',strasse:'Freudplatz',hnr:'1',titel:'Dr.',name:'Benjamin Di Bora',lat:48.21514,lon:16.40528},
  {id:'a0227',plz:'1210',strasse:'Karl Aschenbrenner Gasse',hnr:'3',titel:'Dr.',name:'Daniela Dimova-Schanda',lat:48.25351,lon:16.39736},
  {id:'a0228',plz:'1120',strasse:'Bischoffgasse',hnr:'23',titel:'DDr.',name:'Sabine Dirry',lat:48.18120,lon:16.32182},
  {id:'a0229',plz:'1010',strasse:'Renngasse',hnr:'15',titel:'DDr.',name:'Anna Maria Johanna Josepha Dißauer',lat:48.21372,lon:16.36825},
  {id:'a0230',plz:'1150',strasse:'Johnstraße',hnr:'24/13',titel:'Dr.',name:'Ulrike Dittert',lat:48.19874,lon:16.31895},
  {id:'a0231',plz:'1060',strasse:'Hofmühlgasse',hnr:'1)13',titel:'Dr.',name:'Alijana Dizdaric',lat:48.19335,lon:16.35248},
  {id:'a0233',plz:'1120',strasse:'Gierstergasse',hnr:'11',titel:'DDr.',name:'Leyla Djafari',lat:48.18326,lon:16.33491},
  {id:'a0234',plz:'1170',strasse:'Neuwaldegger Straße',hnr:'39/1/3',titel:'Dr.',name:'Jelena Djordjevic',lat:48.24052,lon:16.27940},
  {id:'a0235',plz:'1160',strasse:'Thaliastraße',hnr:'1/12',titel:'Dr.',name:'Marina Dodig Pernar',lat:48.20855,lon:16.33779},
  {id:'a0236',plz:'1090',strasse:'Währinger Straße',hnr:'16/23',titel:'Univ.-Prof. Dr.',name:'Orhun Dörtbudak',lat:48.22168,lon:16.35404},
  {id:'a0237',plz:'1080',strasse:'Schlesingerplatz',hnr:'5',titel:'Dr.',name:'Aneta Dolezal',lat:48.21270,lon:16.34711},
  {id:'a0238',plz:'1030',strasse:'Seidlgasse',hnr:'12',titel:'Dr.',name:'Vit Dolezal',lat:48.20742,lon:16.39041},
  {id:'a0239',plz:'1200',strasse:'Pielachgasse',hnr:'1',titel:'Dr.',name:'Gabriele Domanovits',lat:48.23399,lon:16.39074},
  {id:'a0240',plz:'1090',strasse:'Boltzmanngasse',hnr:'17/2/59',titel:'',name:'Katharina Maria Domanovits',lat:48.22416,lon:16.35652},
  {id:'a0241',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Danijel Domic',lat:48.21955,lon:16.35453},
  {id:'a0243',plz:'1220',strasse:'Langobardenstraße',hnr:'122',titel:'Dr.',name:'Sahar Dorri',lat:48.21931,lon:16.46448},
  {id:'a0244',plz:'1220',strasse:'Langobardenstraße',hnr:'122',titel:'Dr.',name:'Kimia Dorri-Haller',lat:48.21931,lon:16.46448},
  {id:'a0245',plz:'1030',strasse:'Jauresgasse',hnr:'1/10',titel:'',name:'Andrietta Dossenbach',lat:48.19726,lon:16.38395},
  {id:'a0248',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Amer Dragic',lat:48.21955,lon:16.35453},
  {id:'a0249',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Mirza Dragic',lat:48.21955,lon:16.35453},
  {id:'a0252',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Nicoletta Dumitrescu',lat:48.21955,lon:16.35453},
  {id:'a0253',plz:'1060',strasse:'Gumpendorfer Straße',hnr:'115',titel:'Dr.',name:'Doina Dumitru',lat:48.19081,lon:16.34640},
  {id:'a0255',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'DDr.',name:'Gerlinde Durstberger',lat:48.21955,lon:16.35453},
  {id:'a0256',plz:'1010',strasse:'Renngasse',hnr:'15',titel:'Dr.',name:'Ivana Dzidic',lat:48.21372,lon:16.36825},
  {id:'a0257',plz:'1130',strasse:'Speisinger Straße',hnr:'46-48/4/1',titel:'Dr.',name:'Anton Ebner',lat:48.16963,lon:16.28514},
  {id:'a0258',plz:'1170',strasse:'Dornerplatz',hnr:'6',titel:'Dr.',name:'Doris Maria Eckel',lat:48.22147,lon:16.33402},
  {id:'a0260',plz:'1180',strasse:'Schulgasse',hnr:'79/5',titel:'Mag. Dr.',name:'Christine Eckersberger',lat:48.22570,lon:16.33857},
  {id:'a0261',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'',name:'Magdalena Eckersberger',lat:48.22664,lon:16.35181},
  {id:'a0262',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Ing. DDr.',name:'Michael Edelmayer',lat:48.21955,lon:16.35453},
  {id:'a0264',plz:'1010',strasse:'Lichtenfelsgasse',hnr:'1',titel:'DDr.',name:'Andreas Eder',lat:48.20978,lon:16.35765},
  {id:'a0265',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Jaryna Eder',lat:48.21955,lon:16.35453},
  {id:'a0266',plz:'1020',strasse:'Karmelitergasse',hnr:'11/3',titel:'Dr.',name:'Michael Eder',lat:48.21647,lon:16.37944},
  {id:'a0267',plz:'1230',strasse:'Eduard Kittenberger Gasse 34 Haus',hnr:'1',titel:'DDr.',name:'Christina Eder-Czembirek',lat:48.14641,lon:16.30407},
  {id:'a0269',plz:'1010',strasse:'Renngasse',hnr:'15',titel:'Dr.',name:'Jelena Egelja',lat:48.21372,lon:16.36825},
  {id:'a0270',plz:'1210',strasse:'Karl Aschenbrenner Gasse',hnr:'3',titel:'Dr.',name:'Mane Egelja',lat:48.25351,lon:16.39736},
  {id:'a0271',plz:'1130',strasse:'Hietzinger Hauptstraße',hnr:'3',titel:'Dr.',name:'Alfons Ehrenzweig',lat:48.18607,lon:16.30068},
  {id:'a0272',plz:'1220',strasse:'Stralehnergasse',hnr:'15/1',titel:'Dr.',name:'Paul Ehrlich',lat:48.22191,lon:16.45261},
  {id:'a0274',plz:'1120',strasse:'Bendlgasse',hnr:'10-12',titel:'Dr.',name:'Mohamad El Nazzal',lat:48.18069,lon:16.33489},
  {id:'a0275',plz:'1130',strasse:'Hofwiesengasse 36/A',hnr:'10',titel:'Dr.',name:'Bara Elhout',lat:48.17379,lon:16.28646},
  {id:'a0276',plz:'1200',strasse:'Othmargasse',hnr:'25/57',titel:'Dr.',name:'Michael-Fuad Elias',lat:48.23131,lon:16.36977},
  {id:'a0278',plz:'1160',strasse:'Speckbachergasse',hnr:'42/8',titel:'Dr.',name:'Ramy Elsohagy',lat:48.21715,lon:16.31685},
  {id:'a0279',plz:'1010',strasse:'Dorotheergasse',hnr:'7/3c',titel:'Dr. med. univ.',name:'Maija Monique Eltz',lat:48.20801,lon:16.37005},
  {id:'a0280',plz:'1070',strasse:'Burggasse',hnr:'105/2',titel:'Dr.',name:'Alireza Emami Nouri',lat:48.20413,lon:16.35451},
  {id:'a0281',plz:'1170',strasse:'Geblergasse',hnr:'67/3',titel:'Dr.',name:'Gad Emara',lat:48.21610,lon:16.33773},
  {id:'a0282',plz:'1130',strasse:'Münichreiterstraße',hnr:'21/!',titel:'DDr.',name:'Veronika Emesz-Pantelic',lat:48.18269,lon:16.28362},
  {id:'a0285',plz:'1090',strasse:'Währinger Straße',hnr:'46/24',titel:'DDr.',name:'Johannes Engelmann',lat:48.22168,lon:16.35404},
  {id:'a0286',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'Dr.',name:'Sophie Engin-Deniz',lat:48.22664,lon:16.35181},
  {id:'a0287',plz:'1160',strasse:'Neulerchenfelder Straße',hnr:'34',titel:'Doz. DDr.',name:'Georg Enislidis',lat:48.21131,lon:16.33487},
  {id:'a0288',plz:'1160',strasse:'Neulerchenfelder Straße',hnr:'36',titel:'Dr.',name:'Sabine Enislidis',lat:48.21134,lon:16.33467},
  {id:'a0289',plz:'1010',strasse:'Mölker Bastei',hnr:'3/12',titel:'Dr.',name:'Konrad Eppacher',lat:48.21263,lon:16.36188},
  {id:'a0290',plz:'1100',strasse:'Wienerbergstraße',hnr:'15-19',titel:'Dr.',name:'Sera Eren',lat:48.16956,lon:16.34391},
  {id:'a0292',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'',name:'Michael Eschrich',lat:48.19748,lon:16.34833},
  {id:'a0293',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Azadeh Esfandeyari',lat:48.21955,lon:16.35453},
  {id:'a0294',plz:'1090',strasse:'Währinger Straße',hnr:'18-20',titel:'Prof. DDr.',name:'Rolf Ewers',lat:48.22426,lon:16.35017},
  {id:'a0295',plz:'1130',strasse:'St. Veit Gasse',hnr:'51/2',titel:'Dr.',name:'Otto Exenberger',lat:48.18783,lon:16.28515},
  {id:'a0296',plz:'1060',strasse:'Mariahilfer Straße',hnr:'117/4',titel:'Dr.',name:'Pia Faber-Miklautz',lat:48.19889,lon:16.35152},
  {id:'a0297',plz:'1030',strasse:'Landstraßer Hauptstraße',hnr:'9/19',titel:'Ddr.',name:'Ursula Fälbl-Fuchs',lat:48.18706,lon:16.39798},
  {id:'a0299',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'Dr.',name:'Andreas Faith',lat:48.19748,lon:16.34833},
  {id:'a0301',plz:'1130',strasse:'Tolstojgasse',hnr:'15',titel:'Dr.',name:'Georg Faltl',lat:48.18106,lon:16.27863},
  {id:'a0303',plz:'1060',strasse:'Liniengasse',hnr:'50-52/2/2',titel:'Dr.',name:'Erik Farago',lat:48.19132,lon:16.33973},
  {id:'a0304',plz:'1060',strasse:'Liniengasse',hnr:'50-52/2/2',titel:'Dr.',name:'Lajos Farago',lat:48.19132,lon:16.33973},
  {id:'a0305',plz:'1060',strasse:'Liniengasse',hnr:'50-52/2/2',titel:'Dr.',name:'Sylvia Farago',lat:48.19132,lon:16.33973},
  {id:'a0307',plz:'1210',strasse:'Karl Aschenbrenner Gasse',hnr:'3',titel:'Dr.',name:'Arghavan Farrokhian',lat:48.25351,lon:16.39736},
  {id:'a0309',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Laura Fautschek',lat:48.21955,lon:16.35453},
  {id:'a0311',plz:'1020',strasse:'Max Winter Platz',hnr:'21/8',titel:'Dr.',name:'Meliha Felic',lat:48.22077,lon:16.40052},
  {id:'a0312',plz:'1070',strasse:'Schottenfeldgasse',hnr:'3/18',titel:'Dr.',name:'Iris Felmerer-Schaffranek',lat:48.20507,lon:16.34312},
  {id:'a0313',plz:'1060',strasse:'Schmalzhofgasse',hnr:'24/6',titel:'Dr.',name:'Christoph Fenninger',lat:48.19542,lon:16.34676},
  {id:'a0314',plz:'1010',strasse:'Schottengasse',hnr:'3a',titel:'Dr.',name:'Eva Ferstl-Sziberth',lat:48.21265,lon:16.36359},
  {id:'a0315',plz:'1220',strasse:'Kagraner Platz',hnr:'1',titel:'Dr.',name:'Waldemar Festenburg',lat:48.25033,lon:16.44433},
  {id:'a0317',plz:'1140',strasse:'Hauptstraße',hnr:'60',titel:'DDr.',name:'Carmen Fischer',lat:48.20880,lon:16.22530},
  {id:'a0318',plz:'1010',strasse:'Nibelungengasse',hnr:'1-3',titel:'Dr.',name:'Zsolt Fischer',lat:48.20148,lon:16.36627},
  {id:'a0319',plz:'1210',strasse:'Karl Aschenbrenner Gasse',hnr:'3',titel:'Dr.',name:'Amelia Lisa Flandorfer',lat:48.25351,lon:16.39736},
  {id:'a0320',plz:'1210',strasse:'Leopoldauer Platz',hnr:'68',titel:'Dr. med. dent.',name:'Leonardo Fleischmann',lat:48.26308,lon:16.44309},
  {id:'a0321',plz:'1020',strasse:'Untere Donaustraße',hnr:'27/8a',titel:'Ddr.',name:'Dionisie Florescu',lat:48.21291,lon:16.38507},
  {id:'a0323',plz:'1050',strasse:'Schönbrunner Straße',hnr:'149/2',titel:'Dr.',name:'Andrea Foltin',lat:48.19122,lon:16.35573},
  {id:'a0325',plz:'1210',strasse:'Brünner Straße',hnr:'1/8',titel:'Dr.',name:'Vivian Forster',lat:48.26863,lon:16.40400},
  {id:'a0326',plz:'1160',strasse:'Erdbrustgasse',hnr:'11',titel:'Dr.',name:'Renate Forsthuber',lat:48.21504,lon:16.30319},
  {id:'a0327',plz:'1210',strasse:'Freiheitsplatz',hnr:'10',titel:'MR Dr. med. univ.',name:'Thomas Francan',lat:48.30090,lon:16.41686},
  {id:'a0328',plz:'1210',strasse:'Stammersdorfer Straße',hnr:'96a',titel:'Dr.',name:'Angelika Francan-Putz',lat:48.30090,lon:16.41695},
  {id:'a0329',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'',name:'Aleksandra Oktawia Franczak',lat:48.19748,lon:16.34833},
  {id:'a0330',plz:'1220',strasse:'Langobardenstraße',hnr:'122',titel:'Dr.',name:'Elisabeth Frank',lat:48.21931,lon:16.46448},
  {id:'a0331',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'Dr.',name:'Monika Frank',lat:48.19748,lon:16.34833},
  {id:'a0332',plz:'1140',strasse:'Waidhausenstraße',hnr:'13/8',titel:'DDr.',name:'Jimmy Frank',lat:48.19659,lon:16.28077},
  {id:'a0333',plz:'1030',strasse:'Invalidenstraße',hnr:'13/1/3',titel:'DDr.',name:'Thomas Freiding',lat:48.20710,lon:16.38653},
  {id:'a0334',plz:'1110',strasse:'Mailergasse',hnr:'21',titel:'Dr.',name:'Karoline Koralie Fremerey',lat:48.15694,lon:16.46739},
  {id:'a0335',plz:'1010',strasse:'Reichsratsstraße',hnr:'7/11',titel:'DDr.',name:'Christina Freudenthaler',lat:48.21290,lon:16.35892},
  {id:'a0336',plz:'1010',strasse:'Reichsratsstraße',hnr:'7/11',titel:'ao. Univ.-Prof. Dr.',name:'Josef Freudenthaler',lat:48.21290,lon:16.35892},
  {id:'a0337',plz:'1230',strasse:'Breitenfurter Straße',hnr:'256/4',titel:'Dr.',name:'Barbara Frey',lat:48.13755,lon:16.27631},
  {id:'a0338',plz:'1120',strasse:'Niederhofstraße',hnr:'6',titel:'Dr.',name:'Günther Freysinger',lat:48.18111,lon:16.33603},
  {id:'a0339',plz:'1190',strasse:'Gymnasiumstraße',hnr:'62',titel:'Dr.',name:'Ingrid Friede-Lindner',lat:48.23562,lon:16.34893},
  {id:'a0340',plz:'1010',strasse:'Singerstraße',hnr:'4',titel:'Dr.',name:'Karoly Friedrich',lat:48.20767,lon:16.37234},
  {id:'a0341',plz:'1180',strasse:'Währinger Gürtel',hnr:'33/5',titel:'Dr.',name:'Heimo Frimmel',lat:48.22323,lon:16.34815},
  {id:'a0342',plz:'1190',strasse:'Billrothstraße',hnr:'31/11',titel:'Dr.',name:'Thomas Frühwirth',lat:48.23970,lon:16.34910},
  {id:'a0343',plz:'1030',strasse:'Klimschgasse',hnr:'14/3',titel:'Dr. med. dent.',name:'Nikolaus Fuchs',lat:48.19326,lon:16.39525},
  {id:'a0344',plz:'1090',strasse:'Berggasse',hnr:'7/6',titel:'Dr.',name:'Nicole Fuchs',lat:48.21744,lon:16.35991},
  {id:'a0345',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'DDr.',name:'Alexander Fügl',lat:48.21955,lon:16.35453},
  {id:'a0347',plz:'1130',strasse:'Würzburggasse',hnr:'35',titel:'Dr.',name:'Ilse Fürst-Fetka',lat:48.17415,lon:16.29463},
  {id:'a0348',plz:'1050',strasse:'Arbeitergasse',hnr:'14/12',titel:'Dr.',name:'Gert Fuhrmann',lat:48.18496,lon:16.34858},
  {id:'a0349',plz:'1150',strasse:'Ullmannstraße',hnr:'14/12',titel:'Dr.',name:'Anton Fuhrmann',lat:48.18851,lon:16.33557},
  {id:'a0350',plz:'1210',strasse:'Schuchardtstraße',hnr:'9/10',titel:'Dr.',name:'Markus Fuhry',lat:48.29870,lon:16.42504},
  {id:'a0351',plz:'1010',strasse:'Führichgasse',hnr:'2/4',titel:'Dr.',name:'Matthias Futter',lat:48.20504,lon:16.36898},
  {id:'a0352',plz:'1220',strasse:'Langobardenstraße',hnr:'189',titel:'Dr.',name:'Alex Gahleitner',lat:48.21829,lon:16.47582},
  {id:'a0353',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Andre Gahleitner',lat:48.21955,lon:16.35453},
  {id:'a0354',plz:'1100',strasse:'Hertha Firnberg Straße',hnr:'10/2/1',titel:'Dr.',name:'Jelena Gajic',lat:48.16606,lon:16.34649},
  {id:'a0356',plz:'1100',strasse:'Humboldtgasse',hnr:'40/17',titel:'Dr.',name:'Zsolt Galambos',lat:48.17847,lon:16.37792},
  {id:'a0357',plz:'1100',strasse:'Humboldtgasse',hnr:'40/17',titel:'Dr.',name:'Bence Galambos',lat:48.17847,lon:16.37792},
  {id:'a0358',plz:'1100',strasse:'Humboldtgasse',hnr:'40/17',titel:'Dr.',name:'Erika Galambosne Hacker',lat:48.17847,lon:16.37792},
  {id:'a0359',plz:'1070',strasse:'Neustiftgasse',hnr:'16',titel:'DDr.',name:'Koco Galev',lat:48.20546,lon:16.35324},
  {id:'a0360',plz:'1100',strasse:'Buchengasse',hnr:'70',titel:'Dr.',name:'Birgit Gallé',lat:48.17481,lon:16.37682},
  {id:'a0362',plz:'1200',strasse:'Ospelgasse',hnr:'29/21',titel:'Dr.',name:'Tanja Galleider',lat:48.23277,lon:16.38817},
  {id:'a0365',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Andrea Gamper',lat:48.21955,lon:16.35453},
  {id:'a0366',plz:'1140',strasse:'Linzer Straße',hnr:'296',titel:'Dr.',name:'Ursula Ganger',lat:48.19767,lon:16.27533},
  {id:'a0367',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Clemens Ganger',lat:48.21955,lon:16.35453},
  {id:'a0368',plz:'1210',strasse:'Leopoldauer Platz',hnr:'68',titel:'Dr.',name:'Gabriela Carolina Garcia de Fleischmann',lat:48.26308,lon:16.44309},
  {id:'a0369',plz:'1100',strasse:'Senefeldergasse',hnr:'32/1',titel:'Dr.',name:'Eva-Mirela Gardner',lat:48.17396,lon:16.37534},
  {id:'a0370',plz:'1030',strasse:'Trubelgasse',hnr:'24/9',titel:'Dr. MDSc',name:'Deepti Garg',lat:48.18894,lon:16.38864},
  {id:'a0371',plz:'1010',strasse:'Wipplingerstraße',hnr:'29/7',titel:'Dr.',name:'Armando Garini',lat:48.21360,lon:16.36732},
  {id:'a0376',plz:'1130',strasse:'Mühlbachergasse',hnr:'9',titel:'Dr.',name:'Helma Gauert',lat:48.18301,lon:16.28516},
  {id:'a0380',plz:'1030',strasse:'Neulinggasse',hnr:'14/4',titel:'Dr.',name:'Daniel Geml',lat:48.19908,lon:16.38634},
  {id:'a0382',plz:'1100',strasse:'Wienerbergstraße',hnr:'13',titel:'DDr.',name:'Birgit Genser-Strobl',lat:48.16919,lon:16.34527},
  {id:'a0383',plz:'1020',strasse:'Freudplatz',hnr:'1',titel:'',name:'Katharina Georg',lat:48.21514,lon:16.40528},
  {id:'a0385',plz:'1100',strasse:'Wienerbergstraße',hnr:'13',titel:'Dr.',name:'Philipp Gerhardt',lat:48.16919,lon:16.34527},
  {id:'a0386',plz:'1200',strasse:'Allerheiligenplatz',hnr:'11/51',titel:'Dr.',name:'Hermann Germ',lat:48.23797,lon:16.38434},
  {id:'a0388',plz:'1030',strasse:'Landstraßer Hauptstraße',hnr:'13',titel:'Dr.',name:'Nicoletta Gerstner-Mensdorff-Pouilly',lat:48.20526,lon:16.38729},
  {id:'a0389',plz:'1120',strasse:'Bischoffgasse',hnr:'23',titel:'Priv.-Doz. Dr. med. univ. Dr. med. dent.',name:'Lucia Gerzanic',lat:48.18120,lon:16.32182},
  {id:'a0390',plz:'1130',strasse:'Costenoblegasse',hnr:'7',titel:'MR Dr. med. univ.',name:'Walter Geyer',lat:48.18742,lon:16.27128},
  {id:'a0392',plz:'1160',strasse:'Neulerchenfelder Straße',hnr:'75-77',titel:'DDr.',name:'Ursula Geyerhofer',lat:48.21204,lon:16.32907},
  {id:'a0393',plz:'1210',strasse:'Gerichtsgasse',hnr:'1e/4/4',titel:'Dr.',name:'Susanne Geyerhofer',lat:48.26092,lon:16.39693},
  {id:'a0394',plz:'1170',strasse:'Hernalser Hauptstraße',hnr:'148',titel:'Dr.',name:'Cennet Gezer',lat:48.22217,lon:16.32032},
  {id:'a0395',plz:'1230',strasse:'Breitenfurter Straße',hnr:'360-368/1/1',titel:'Dr.',name:'Mohamad Nour Ghazal',lat:48.13593,lon:16.28220},
  {id:'a0396',plz:'1160',strasse:'Zöchbauerstraße',hnr:'9/11',titel:'Dr.',name:'Mohammad Medhi Gheini',lat:48.20692,lon:16.30811},
  {id:'a0397',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Katharina Giannis',lat:48.21955,lon:16.35453},
  {id:'a0398',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Carolina Anja Giefing',lat:48.21955,lon:16.35453},
  {id:'a0399',plz:'1070',strasse:'Westbahnstraße',hnr:'1b/2/3',titel:'Dr.',name:'Gerold Gierszewski',lat:48.20180,lon:16.34646},
  {id:'a0400',plz:'1230',strasse:'Breitenfurter Straße',hnr:'360-368/1/1',titel:'Dr.',name:'Ewa Gierszewski',lat:48.13593,lon:16.28220},
  {id:'a0401',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'',name:'Prabhjot Kaur Gill',lat:48.22664,lon:16.35181},
  {id:'a0403',plz:'1060',strasse:'Rahlgasse',hnr:'1/19',titel:'Dr. med. univ.',name:'Christoph Glaser',lat:48.20146,lon:16.36171},
  {id:'a0405',plz:'1210',strasse:'Am Bruckhaufen',hnr:'21',titel:'Dr.',name:'Julia Stella Glatz',lat:48.24251,lon:16.40005},
  {id:'a0407',plz:'1060',strasse:'Stiegengasse',hnr:'7/2/7',titel:'Dr.',name:'Manfred Glössel',lat:48.19790,lon:16.35796},
  {id:'a0409',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'Dr.',name:'Nevena Godeva',lat:48.22664,lon:16.35181},
  {id:'a0410',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'',name:'Jana Göhring',lat:48.19748,lon:16.34833},
  {id:'a0411',plz:'1190',strasse:'Sieveringer Straße',hnr:'17',titel:'Dr.',name:'Matthias Göstel',lat:48.24595,lon:16.33965},
  {id:'a0412',plz:'1120',strasse:'Hervicusgasse',hnr:'2/5',titel:'Dr.',name:'Sima Sylvia Golestani',lat:48.16147,lon:16.30356},
  {id:'a0413',plz:'1100',strasse:'Hertha Firnberg Straße',hnr:'10/2/1',titel:'Dr.',name:'Leon Golestani',lat:48.16606,lon:16.34649},
  {id:'a0415',plz:'1200',strasse:'Hartlgasse',hnr:'17/1',titel:'Dr.',name:'Karol Gonda',lat:48.23806,lon:16.37296},
  {id:'a0418',plz:'1090',strasse:'Nußdorfer Straße',hnr:'18/8',titel:'Dr.',name:'Andreas Claudius Gossler',lat:48.22770,lon:16.35505},
  {id:'a0419',plz:'1090',strasse:'Nußdorfer Straße',hnr:'18/8',titel:'Dr.',name:'Claudius Gossler',lat:48.22770,lon:16.35505},
  {id:'a0420',plz:'1090',strasse:'Spitalgasse',hnr:'17/a',titel:'Dr.',name:'Laura Gotai',lat:48.21750,lon:16.35114},
  {id:'a0421',plz:'1100',strasse:'Hertha Firnberg Straße',hnr:'10/2/1',titel:'Dr.',name:'Viktoria Gottfried',lat:48.16606,lon:16.34649},
  {id:'a0423',plz:'1030',strasse:'Erdbergstraße',hnr:'202/E7a',titel:'Dr.',name:'Hannah Grafl',lat:48.19027,lon:16.41417},
  {id:'a0425',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Thomas Gravogl',lat:48.21955,lon:16.35453},
  {id:'a0427',plz:'1030',strasse:'Bayerngasse',hnr:'3/11',titel:'Dr. med. univ.',name:'Rene Gregor',lat:48.20104,lon:16.38213},
  {id:'a0429',plz:'1210',strasse:'Brünner Straße',hnr:'108/1/2',titel:'Dr.',name:'Marion Grieß',lat:48.26863,lon:16.40400},
  {id:'a0430',plz:'1140',strasse:'Hütteldorfer Straße',hnr:'291-293',titel:'Dr. med. dent.',name:'Sebastian Gritsch',lat:48.19761,lon:16.29867},
  {id:'a0431',plz:'1100',strasse:'Wienerbergstraße',hnr:'13',titel:'Dr.',name:'Katalin Gróf',lat:48.16919,lon:16.34527},
  {id:'a0432',plz:'1060',strasse:'Mariahilfer Straße 1',hnr:'A/1/28',titel:'Dr.',name:'Peter Gross',lat:48.20130,lon:16.35978},
  {id:'a0433',plz:'1220',strasse:'Donaustadtstraße',hnr:'30/13/3/7',titel:'Dr.',name:'Ulrike Groß',lat:48.23682,lon:16.44072},
  {id:'a0434',plz:'1080',strasse:'Sanettystraße',hnr:'4/7',titel:'Dr.',name:'Monika Gruber',lat:48.21021,lon:16.33977},
  {id:'a0436',plz:'1220',strasse:'Rennbahnweg',hnr:'27/12/3',titel:'Dr.',name:'Marlene Gruber-Fürschuss',lat:48.25461,lon:16.45762},
  {id:'a0437',plz:'1030',strasse:'Salesianergasse',hnr:'4/3',titel:'Dr.',name:'Amadeus Grzadziel',lat:48.20072,lon:16.38073},
  {id:'a0438',plz:'1080',strasse:'Wickenburggasse',hnr:'14/3',titel:'Univ. Prof. Dr.',name:'Barbara Gsellmann',lat:48.21348,lon:16.35398},
  {id:'a0439',plz:'1100',strasse:'Heimkehrergasse',hnr:'9',titel:'OMR DDr.',name:'Herbert Güntner',lat:48.15866,lon:16.40357},
  {id:'a0440',plz:'1090',strasse:'Borschkegasse',hnr:'14/12',titel:'Dr.',name:'Alexander Gugenberger',lat:48.21790,lon:16.34556},
  {id:'a0441',plz:'1050',strasse:'Ramperstorffergasse',hnr:'68',titel:'',name:'Maria Antonieta Guillaumet Claure',lat:48.19027,lon:16.35519},
  {id:'a0442',plz:'1230',strasse:'Dirmhirngasse',hnr:'25/2/4',titel:'Ddr.',name:'Istvan Gyanti',lat:48.13675,lon:16.28376},
  {id:'a0444',plz:'1030',strasse:'Pfefferhofgasse 1A',hnr:'8',titel:'Dr.',name:'Sandra Haas',lat:48.21200,lon:16.38796},
  {id:'a0445',plz:'1230',strasse:'Breitenfurter Straße',hnr:'360-368/1/1',titel:'Dr.',name:'Verena Haas',lat:48.13593,lon:16.28220},
  {id:'a0446',plz:'1230',strasse:'Perfektastraße',hnr:'40/4',titel:'Dr.',name:'Barbara Babette Habitzl',lat:48.13732,lon:16.31570},
  {id:'a0447',plz:'1090',strasse:'Kolingasse',hnr:'20/3',titel:'Ddr.',name:'Alexander Hadwig',lat:48.21574,lon:16.36235},
  {id:'a0448',plz:'1090',strasse:'Kolingasse',hnr:'20/3',titel:'Ddr.',name:'Kristina Hadwig',lat:48.21574,lon:16.36235},
  {id:'a0449',plz:'1020',strasse:'Freudplatz',hnr:'3',titel:'Dr.',name:'Hady Haririan',lat:48.21539,lon:16.40464},
  {id:'a0450',plz:'1050',strasse:'Ramperstorffergasse',hnr:'68',titel:'Dr.',name:'Dzana Hadzihasanovic',lat:48.19027,lon:16.35519},
  {id:'a0452',plz:'1170',strasse:'Klopstockgasse',hnr:'60/13',titel:'Dr.',name:'Viktoria Martina Härtl',lat:48.21840,lon:16.32339},
  {id:'a0453',plz:'1220',strasse:'Anton Sattler Gasse',hnr:'115/9/1',titel:'Mag. Dr.',name:'Amilia Haider',lat:48.25193,lon:16.44097},
  {id:'a0454',plz:'1150',strasse:'Preysinggasse',hnr:'44/5',titel:'Ddr.',name:'Emir Haider',lat:48.19717,lon:16.32675},
  {id:'a0455',plz:'1190',strasse:'Pokornygasse',hnr:'1a',titel:'Dr.',name:'Robert Haider',lat:48.24113,lon:16.35613},
  {id:'a0456',plz:'1160',strasse:'Thaliastraße',hnr:'11/11',titel:'Dr. dent.',name:'Leonore Haimböck',lat:48.21265,lon:16.31184},
  {id:'a0457',plz:'1160',strasse:'Thaliastraße',hnr:'11/11',titel:'Dr.',name:'Werner Haimböck',lat:48.21265,lon:16.31184},
  {id:'a0458',plz:'1220',strasse:'Schüttaustraße',hnr:'4/1/1',titel:'Dr.',name:'Markiel Haimov',lat:48.22720,lon:16.42204},
  {id:'a0459',plz:'1210',strasse:'Schwaigergasse',hnr:'10/12',titel:'Dr.',name:'Michael Haindl',lat:48.25767,lon:16.39533},
  {id:'a0460',plz:'1170',strasse:'Hernalser Hauptstraße',hnr:'97',titel:'Dr.',name:'Sibylle Hainich',lat:48.21920,lon:16.32660},
  {id:'a0461',plz:'1090',strasse:'Schwarzspanierstraße',hnr:'11',titel:'Dr.',name:'Lajos Halasz',lat:48.21641,lon:16.35640},
  {id:'a0462',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'Dr.',name:'Barbara Halasz',lat:48.22664,lon:16.35181},
  {id:'a0463',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'Dr.',name:'Andreas Halla',lat:48.19748,lon:16.34833},
  {id:'a0464',plz:'1180',strasse:'Kutschkergasse',hnr:'12/21',titel:'Dr.',name:'Cora Haller-Waschak',lat:48.22257,lon:16.34374},
  {id:'a0465',plz:'1220',strasse:'Julius Payer Gasse',hnr:'18-20/2',titel:'Dr.',name:'Lukas Hallmann',lat:48.23322,lon:16.42237},
  {id:'a0466',plz:'1210',strasse:'Jerusalemgasse',hnr:'30',titel:'Dr.',name:'Omar Hamid',lat:48.26924,lon:16.44118},
  {id:'a0467',plz:'1010',strasse:'Passauer Platz',hnr:'5/1/4',titel:'Dr.',name:'Lama Hamisch',lat:48.21299,lon:16.37052},
  {id:'a0468',plz:'1080',strasse:'Laudongasse',hnr:'38',titel:'DDr.',name:'Christian Hammerer',lat:48.21319,lon:16.34573},
  {id:'a0469',plz:'1170',strasse:'Jörgerstraße',hnr:'32',titel:'Dr.',name:'Margit Brigitte Handl',lat:48.21780,lon:16.33689},
  {id:'a0470',plz:'1220',strasse:'Gemeindeaugasse',hnr:'3/5',titel:'Dr. med. dent.',name:'Matthias Hangl',lat:48.22298,lon:16.45207},
  {id:'a0471',plz:'1170',strasse:'Hernalser Hauptstraße',hnr:'16/5',titel:'Dr.',name:'Ingrid Hanna',lat:48.21840,lon:16.32929},
  {id:'a0472',plz:'1030',strasse:'Rennweg',hnr:'22/1',titel:'Dr.',name:'Brigitte Hantschk-Schaffarz',lat:48.18719,lon:16.40163},
  {id:'a0474',plz:'1090',strasse:'Wasagasse',hnr:'24',titel:'Dr.',name:'Mikosh Harajda',lat:48.21850,lon:16.35991},
  {id:'a0475',plz:'1060',strasse:'Kurzgasse',hnr:'1/1',titel:'Dr.',name:'Petra Harik-Jesch',lat:48.19353,lon:16.34028},
  {id:'a0478',plz:'1090',strasse:'Schlagergasse',hnr:'3/10',titel:'Dr.',name:'Peter Ferdinand Haselmajer',lat:48.22347,lon:16.35012},
  {id:'a0481',plz:'1060',strasse:'Mariahilfer Straße',hnr:'61/4',titel:'DDr.',name:'Veronika Hauke-Walek',lat:48.19598,lon:16.34024},
  {id:'a0482',plz:'1060',strasse:'Mariahilfer Straße',hnr:'61/4',titel:'Dr.',name:'Wolf Maximilian Hauke',lat:48.19598,lon:16.34024},
  {id:'a0484',plz:'1070',strasse:'Hermanngasse',hnr:'6/3/1',titel:'Dr.',name:'Hainrich Hechenblaickner',lat:48.20336,lon:16.34732},
  {id:'a0485',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Annika Hecht',lat:48.21955,lon:16.35453},
  {id:'a0487',plz:'1220',strasse:'Eibengasse',hnr:'3',titel:'Dr.',name:'Erwin Heigl',lat:48.22196,lon:16.46961},
  {id:'a0488',plz:'1210',strasse:'Karl Aschenbrenner Gasse',hnr:'3',titel:'Dr.',name:'Elisabeth Katharina Heindel',lat:48.25351,lon:16.39736},
  {id:'a0490',plz:'1050',strasse:'Hamburgerstraße',hnr:'7/14',titel:'Dr.',name:'Marie Paul Heintel',lat:48.19530,lon:16.35533},
  {id:'a0491',plz:'1050',strasse:'Bräuhausgasse',hnr:'6/10',titel:'Dr.',name:'Verena Heinzle',lat:48.18700,lon:16.34640},
  {id:'a0492',plz:'1120',strasse:'Helene Potetz Weg 3 / 1 /',hnr:'12',titel:'Dr.',name:'Gerda Heissenberger',lat:48.16491,lon:16.32518},
  {id:'a0493',plz:'1210',strasse:'Karl Aschenbrenner Gasse',hnr:'3',titel:'Dr.',name:'Paul Heissenberger',lat:48.25351,lon:16.39736},
  {id:'a0494',plz:'1080',strasse:'Josefstädter Straße',hnr:'80',titel:'Dr.',name:'Bettina Heller-Hajdu',lat:48.21134,lon:16.34074},
  {id:'a0496',plz:'1090',strasse:'Spitalgasse',hnr:'19',titel:'Ddr.',name:'Stefan Hengl',lat:48.21774,lon:16.35115},
  {id:'a0497',plz:'1090',strasse:'Roßauer Lände 33 /',hnr:'6a',titel:'Dr.',name:'Birgit Henn-Schmidgruber',lat:48.22638,lon:16.36547},
  {id:'a0498',plz:'1020',strasse:'Böcklinstraße',hnr:'12/6',titel:'Dr.',name:'Christine Sylvie Hermann',lat:48.20625,lon:16.39893},
  {id:'a0499',plz:'1090',strasse:'Lazarettgasse',hnr:'19',titel:'Dr.',name:'Verena Herrmann',lat:48.21728,lon:16.34836},
  {id:'a0500',plz:'1030',strasse:'Radetzkystraße',hnr:'19/8-9',titel:'Dr. med. dent.',name:'Ursula Hersch',lat:48.21249,lon:16.39101},
  {id:'a0502',plz:'1210',strasse:'Jedlersdorfer Straße',hnr:'182/1/21a',titel:'Dr.',name:'Janina Heschl',lat:48.28939,lon:16.41105},
  {id:'a0503',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Simone Heuberer',lat:48.21955,lon:16.35453},
  {id:'a0505',plz:'1180',strasse:'Pötzleinsdorfer Straße',hnr:'76/2',titel:'Dr.',name:'Kathrin Hienert',lat:48.23994,lon:16.31452},
  {id:'a0506',plz:'1050',strasse:'Bräuhausgasse',hnr:'55/23',titel:'Dr.',name:'Ina Ricarda Hingsammer',lat:48.18645,lon:16.34574},
  {id:'a0508',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'DDr.',name:'Julia Hinrichs-Priller',lat:48.21955,lon:16.35453},
  {id:'a0509',plz:'1230',strasse:'Jesuitensteig',hnr:'5',titel:'Dr.',name:'Peter Hirk',lat:48.14923,lon:16.26970},
  {id:'a0511',plz:'1190',strasse:'Hartäckerstraße',hnr:'126',titel:'Dr.',name:'Thomas Hirschberg',lat:48.24008,lon:16.32383},
  {id:'a0513',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Barbora Hlavajová',lat:48.21955,lon:16.35453},
  {id:'a0515',plz:'1100',strasse:'Hertha Firnberg Straße',hnr:'10/2/1',titel:'Dr.',name:'Jon Nikolaus Hoberg',lat:48.16606,lon:16.34649},
  {id:'a0516',plz:'1120',strasse:'Wilhelmstraße',hnr:'44/1/3',titel:'Dr.',name:'Thomas Hocevar',lat:48.17659,lon:16.33422},
  {id:'a0517',plz:'1040',strasse:'Schikanedergasse',hnr:'1/2',titel:'DDr.',name:'Christina Höchtl-Nell',lat:48.19682,lon:16.36444},
  {id:'a0518',plz:'1050',strasse:'Ramperstorffergasse',hnr:'68',titel:'Dr.',name:'Fatema Hoda',lat:48.19027,lon:16.35519},
  {id:'a0519',plz:'1230',strasse:'Schwarzenhaidestraße',hnr:'28',titel:'Dr.',name:'Doris Ursula Höhsl',lat:48.15064,lon:16.32716},
  {id:'a0520',plz:'1230',strasse:'Schwarzenhaidestraße',hnr:'15',titel:'Dr.',name:'Stephan Höhsl',lat:48.15087,lon:16.32772},
  {id:'a0521',plz:'1230',strasse:'Schwarzenhaidestraße',hnr:'28',titel:'Dr.',name:'Wolfgang Höhsl',lat:48.15064,lon:16.32716},
  {id:'a0523',plz:'1080',strasse:'Lange Gasse',hnr:'14/37',titel:'Dr.',name:'Christine Höllwart',lat:48.21123,lon:16.35162},
  {id:'a0524',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Lorenz Hölzl',lat:48.21955,lon:16.35453},
  {id:'a0525',plz:'1210',strasse:'Karl Aschenbrenner Gasse',hnr:'3',titel:'Dr.',name:'Gernot Paul Hönigl',lat:48.25351,lon:16.39736},
  {id:'a0526',plz:'1020',strasse:'Freudplatz',hnr:'1',titel:'Dr.',name:'Markus Hof',lat:48.21514,lon:16.40528},
  {id:'a0527',plz:'1170',strasse:'Geblergasse',hnr:'62/11',titel:'Dr.',name:'Julia Hofbauer',lat:48.21704,lon:16.32312},
  {id:'a0528',plz:'1220',strasse:'An der oberen Alten Donau',hnr:'189',titel:'Dr.',name:'Valentina Mattea Hofbauer',lat:48.24108,lon:16.42671},
  {id:'a0530',plz:'1180',strasse:'Gymnasiumstraße',hnr:'25/7',titel:'Dr.',name:'Stephan Alexander Hofer',lat:48.22864,lon:16.34345},
  {id:'a0533',plz:'1130',strasse:'Hietzinger Hauptstraße',hnr:'112',titel:'Dr.',name:'Isabella Hoffmann',lat:48.18762,lon:16.27809},
  {id:'a0534',plz:'1020',strasse:'Förstergasse',hnr:'4/4',titel:'DDr.',name:'Patricia Hoffmann',lat:48.22104,lon:16.37205},
  {id:'a0535',plz:'1010',strasse:'Getreidemarkt',hnr:'17/3',titel:'DDr.',name:'Richard Hofmann',lat:48.20091,lon:16.36544},
  {id:'a0536',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'Dr.',name:'Stefanie Hofner',lat:48.22664,lon:16.35181},
  {id:'a0537',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'Dr.',name:'Elzbieta Hofstätter',lat:48.22664,lon:16.35181},
  {id:'a0538',plz:'1180',strasse:'Hockegasse',hnr:'19/24',titel:'DDr.',name:'Simone Christina Holawe',lat:48.23669,lon:16.32112},
  {id:'a0539',plz:'1010',strasse:'Dorotheergasse',hnr:'12/13a',titel:'Dr. med. dent.',name:'Matthias Holly',lat:48.20801,lon:16.37005},
  {id:'a0540',plz:'1090',strasse:'Höfergasse',hnr:'18/11',titel:'Dr.',name:'Angelika Holy-Schein',lat:48.21752,lon:16.34996},
  {id:'a0541',plz:'1180',strasse:'Antonigasse',hnr:'13/!0',titel:'DDr.',name:'Daniel Holzinger',lat:48.22597,lon:16.32985},
  {id:'a0542',plz:'1100',strasse:'Wienerbergstraße',hnr:'13',titel:'Dr.',name:'Eva Holzweber',lat:48.16919,lon:16.34527},
  {id:'a0543',plz:'1080',strasse:'Josefstädter Straße',hnr:'80',titel:'Dr.',name:'Marion Hommer',lat:48.21134,lon:16.34074},
  {id:'a0545',plz:'1060',strasse:'Getreidemarkt',hnr:'11/23',titel:'Dr.',name:'Yasdan Honarwasch',lat:48.20180,lon:16.36244},
  {id:'a0546',plz:'1110',strasse:'Simmeringer Hauptstraße',hnr:'69/11',titel:'Vizepräs. MR Dr.',name:'Thomas Horejs',lat:48.16352,lon:16.42740},
  {id:'a0547',plz:'1010',strasse:'Kärntner Ring',hnr:'10/6',titel:'Dr.',name:'Armand-Romeo Hortolomei',lat:48.20209,lon:16.37074},
  {id:'a0549',plz:'1220',strasse:'Zschokkegasse',hnr:'140',titel:'Dr.',name:'Julia Hosmann',lat:48.22002,lon:16.46409},
  {id:'a0550',plz:'1160',strasse:'Maroltingergasse',hnr:'102/2',titel:'Dr.',name:'Christina Hotico',lat:48.21421,lon:16.30695},
  {id:'a0551',plz:'1180',strasse:'Gentzgasse',hnr:'132',titel:'Dr.',name:'Peter Hotz',lat:48.22995,lon:16.33280},
  {id:'a0552',plz:'1100',strasse:'Grundäckergasse',hnr:'36/9',titel:'Dr. med. dent.',name:'Thomas Huber',lat:48.13904,lon:16.39939},
  {id:'a0553',plz:'1130',strasse:'Münichreiterstraße',hnr:'53',titel:'Dr.',name:'Claudia Huber-Sander',lat:48.18657,lon:16.28579},
  {id:'a0554',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Azra Huremovic',lat:48.21955,lon:16.35453},
  {id:'a0556',plz:'1050',strasse:'Schußwallgasse',hnr:'5/9',titel:'Dr.',name:'Muaiad Abdul-Rahim Hussein',lat:48.18173,lon:16.35947},
  {id:'a0557',plz:'1010',strasse:'Singerstraße',hnr:'27/38',titel:'Dr.',name:'Aurora Huza',lat:48.20626,lon:16.37628},
  {id:'a0558',plz:'1200',strasse:'Raffaelgasse',hnr:'1/9',titel:'Dr.',name:'Ovidiu Iacob',lat:48.23346,lon:16.37166},
  {id:'a0560',plz:'1030',strasse:'Untere Viaduktgasse',hnr:'55/12',titel:'DDr.',name:'Emina Ibrahimi',lat:48.20581,lon:16.38654},
  {id:'a0561',plz:'1030',strasse:'Strohgasse',hnr:'28',titel:'Dr.',name:'David Id',lat:48.19845,lon:16.37864},
  {id:'a0562',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Damir Imamovic',lat:48.21955,lon:16.35453},
  {id:'a0563',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Dino Imsirovic',lat:48.21955,lon:16.35453},
  {id:'a0564',plz:'1230',strasse:'Dr. Neumann Gasse',hnr:'9',titel:'Dr.',name:'Elisabeth Ingerle',lat:48.13831,lon:16.28642},
  {id:'a0565',plz:'1080',strasse:'Lerchenfelder Straße',hnr:'36/5',titel:'Dr.',name:'Paul Inkofer',lat:48.20652,lon:16.34860},
  {id:'a0566',plz:'1210',strasse:'Seyringer Straße',hnr:'1/3/18',titel:'',name:'Andreea-Maria Ioo',lat:48.26390,lon:16.45392},
  {id:'a0567',plz:'1110',strasse:'Herbortgasse',hnr:'22',titel:'Dr.',name:'Sabina Islamovic',lat:48.17140,lon:16.41095},
  {id:'a0568',plz:'1090',strasse:'Währinger Straße',hnr:'50/15',titel:'Dr.',name:'Beatrix Ittner',lat:48.22426,lon:16.35017},
  {id:'a0569',plz:'1010',strasse:'Kärntner Straße',hnr:'10',titel:'Dr. med. dent.',name:'Konrad Jacobs',lat:48.20716,lon:16.37120},
  {id:'a0570',plz:'1060',strasse:'Mariahilfer Straße',hnr:'93/22',titel:'Dr',name:'Konrad Jahn',lat:48.19889,lon:16.35152},
  {id:'a0571',plz:'1060',strasse:'Mariahilfer Straße',hnr:'93/22',titel:'Dr.',name:'Philipp Jahn',lat:48.19889,lon:16.35152},
  {id:'a0572',plz:'1190',strasse:'Hohenauergasse',hnr:'8',titel:'Dr.',name:'Johann Jaklitsch',lat:48.24515,lon:16.34669},
  {id:'a0573',plz:'1070',strasse:'Lerchenfelder Straße',hnr:'139',titel:'Dr.',name:'Monika Jaklitsch',lat:48.20804,lon:16.34007},
  {id:'a0574',plz:'1200',strasse:'Kluckygasse',hnr:'6/5',titel:'Dr.',name:'Slawik Jakubow',lat:48.22990,lon:16.36849},
  {id:'a0576',plz:'1080',strasse:'Lange Gasse',hnr:'9/4',titel:'Dr. med. univ. Dr. med. dent.',name:'Oliver Jandrasits',lat:48.21123,lon:16.35162},
  {id:'a0577',plz:'1160',strasse:'Hasnerstraße',hnr:'69',titel:'Dr.',name:'Gertrude Janisch',lat:48.20919,lon:16.32500},
  {id:'a0578',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Anja Jankovic-Pejicic',lat:48.21955,lon:16.35453},
  {id:'a0579',plz:'1120',strasse:'Längenfeldgasse',hnr:'28/8/1',titel:'Dr.',name:'Sasa Janzekovic',lat:48.17585,lon:16.34185},
  {id:'a0581',plz:'1110',strasse:'Simmeringer Hauptstraße',hnr:'120',titel:'Dr.',name:'Siri Jebens',lat:48.17070,lon:16.41957},
  {id:'a0582',plz:'1140',strasse:'Leystraße',hnr:'2a/14',titel:'Dr.',name:'Susanne Jeckl-Lio',lat:48.24690,lon:16.37495},
  {id:'a0583',plz:'1110',strasse:'Herbortgasse',hnr:'22',titel:'DDr.',name:'Niko Matija Jelen',lat:48.17140,lon:16.41095},
  {id:'a0584',plz:'1190',strasse:'Silbergasse',hnr:'9/1/5',titel:'Dr.',name:'Arabella Jelinek Gaugusch',lat:48.24300,lon:16.34885},
  {id:'a0585',plz:'1080',strasse:'Lange Gasse',hnr:'11/19',titel:'Dr.',name:'Julian Jender',lat:48.21123,lon:16.35162},
  {id:'a0588',plz:'1150',strasse:'Wurmsergasse',hnr:'39/15',titel:'Dr.',name:'Fang Jia',lat:48.19491,lon:16.32120},
  {id:'a0589',plz:'1090',strasse:'Währinger Straße',hnr:'72/4',titel:'Ddr.',name:'Elisabeth Jiru',lat:48.22168,lon:16.35404},
  {id:'a0590',plz:'1090',strasse:'Bleichergasse',hnr:'7/5',titel:'Dr.',name:'Andrea Jöstl',lat:48.22408,lon:16.35194},
  {id:'a0592',plz:'1070',strasse:'Mariahilfer Straße',hnr:'32/3',titel:'Priv.-Doz. Dr. med. univ. Dr. med. dent.',name:'Erwin Odo Jonke',lat:48.19671,lon:16.34416},
  {id:'a0593',plz:'1030',strasse:'Hainburger Straße',hnr:'17/11',titel:'Dr.',name:'Nicolas Jordan',lat:48.19749,lon:16.40003},
  {id:'a0595',plz:'1130',strasse:'Hietzinger Hauptstraße',hnr:'24',titel:'Dr.',name:'Emmerich-Alexander Josipovich',lat:48.18642,lon:16.29980},
  {id:'a0596',plz:'1220',strasse:'Donau City Straße',hnr:'1',titel:'Dr.',name:'Miona Jovanovic',lat:48.23265,lon:16.41361},
  {id:'a0598',plz:'1120',strasse:'Schönbrunner Allee',hnr:'46/5',titel:'DDr.',name:'Anna Jung',lat:48.17451,lon:16.31324},
  {id:'a0599',plz:'1040',strasse:'Prinz Eugen Straße',hnr:'16/8',titel:'Dr.',name:'Elke Jungkamp-Glaeser',lat:48.19336,lon:16.37811},
  {id:'a0600',plz:'1210',strasse:'Pastorstraße',hnr:'2a',titel:'DDr.',name:'Karl Jungwirth',lat:48.27456,lon:16.44325},
  {id:'a0602',plz:'1020',strasse:'Engerthstraße',hnr:'209/10',titel:'Dr.',name:'Aron Kaikow',lat:48.22694,lon:16.40030},
  {id:'a0603',plz:'1140',strasse:'Zyklamengasse',hnr:'63',titel:'Dr.',name:'Erich Kainz',lat:48.21598,lon:16.25468},
  {id:'a0604',plz:'1230',strasse:'Schimekgasse',hnr:'4',titel:'Dr.',name:'Petra Kainz',lat:48.14036,lon:16.32928},
  {id:'a0605',plz:'1090',strasse:'Seegasse',hnr:'25/22',titel:'Dr.',name:'Daniel Kalla',lat:48.22332,lon:16.36666},
  {id:'a0606',plz:'1040',strasse:'Gußhausstraße',hnr:'23/22',titel:'Dr.',name:'Hermine Kainz-Toifl',lat:48.19680,lon:16.37034},
  {id:'a0607',plz:'1060',strasse:'Garbergasse',hnr:'9/4',titel:'Dr.',name:'Alexandra Kalmar',lat:48.19319,lon:16.34401},
  {id:'a0608',plz:'1020',strasse:'Ausstellungsstraße',hnr:'7/4',titel:'Dr.',name:'Amra Kamenica',lat:48.21797,lon:16.39611},
  {id:'a0611',plz:'1120',strasse:'Otto Bondy Platz',hnr:'3',titel:'DDr.',name:'Markus Kantor',lat:48.16546,lon:16.32604},
  {id:'a0612',plz:'1110',strasse:'Wopenkastraße',hnr:'2/3/2',titel:'Dr.',name:'Thomas Kanzler',lat:48.15158,lon:16.46268},
  {id:'a0613',plz:'1140',strasse:'Hütteldorfer Straße',hnr:'124/2',titel:'Dr.',name:'Thomas Kapounek',lat:48.19761,lon:16.29867},
  {id:'a0614',plz:'1160',strasse:'Steinmüllergasse',hnr:'66/4',titel:'Dr.',name:'Athinodoros Karathanasis',lat:48.22277,lon:16.29870},
  {id:'a0615',plz:'1040',strasse:'Favoritenstraße',hnr:'48',titel:'Dr.',name:'Ferenc Kardos',lat:48.18972,lon:16.37196},
  {id:'a0616',plz:'1090',strasse:'Beethovengasse',hnr:'1/1/1',titel:'Dr.',name:'Florian Karg',lat:48.21763,lon:16.35686},
  {id:'a0617',plz:'1170',strasse:'Waldzeile',hnr:'8',titel:'Dr.',name:'Stefanie Karlsböck',lat:48.25186,lon:16.27458},
  {id:'a0619',plz:'1020',strasse:'Taborstraße',hnr:'52/19',titel:'DDr.',name:'Gawriel Karschigijew',lat:48.21861,lon:16.38090},
  {id:'a0620',plz:'1030',strasse:'Strohgasse',hnr:'28',titel:'Dr.',name:'Julia Kastner',lat:48.19845,lon:16.37864},
  {id:'a0621',plz:'1090',strasse:'Müllnergasse',hnr:'4/15',titel:'Ddr.',name:'Florian Katauczek',lat:48.22015,lon:16.36297},
  {id:'a0625',plz:'1100',strasse:'Wienerbergstraße',hnr:'13',titel:'Dr.',name:'Nikolai Keilmann',lat:48.16919,lon:16.34527},
  {id:'a0626',plz:'1030',strasse:'Strohgasse',hnr:'28',titel:'Dr.',name:'Vinzenz Kellerer',lat:48.19845,lon:16.37864},
  {id:'a0627',plz:'1190',strasse:'Sieveringer Straße',hnr:'18/5',titel:'Dr.',name:'Ulrich Kempkes',lat:48.25696,lon:16.31129},
  {id:'a0629',plz:'1020',strasse:'Sebastian Kneipp Gasse',hnr:'9/28',titel:'Dr.',name:'Lilla Kertesz',lat:48.21866,lon:16.40717},
  {id:'a0630',plz:'1080',strasse:'Laudongasse',hnr:'38',titel:'DDr.',name:'David Keszthelyi',lat:48.21319,lon:16.34573},
  {id:'a0631',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Sarah Khater',lat:48.21955,lon:16.35453},
  {id:'a0632',plz:'1040',strasse:'Mittersteig',hnr:'7/2',titel:'Dr.',name:'Alfred Herbert Kielburg',lat:48.19240,lon:16.36443},
  {id:'a0634',plz:'1010',strasse:'Sterngasse 6A /',hnr:'1',titel:'Dr.',name:'Zihi Kim',lat:48.21172,lon:16.37365},
  {id:'a0635',plz:'1170',strasse:'Dornbacher Straße',hnr:'43/1/6',titel:'Dr.',name:'Bernd Kinast',lat:48.22811,lon:16.30052},
  {id:'a0636',plz:'1120',strasse:'Aßmayergasse',hnr:'54',titel:'dr. med. dent.',name:'Zoltan Kincses',lat:48.17837,lon:16.33771},
  {id:'a0637',plz:'1170',strasse:'Ottakringer Straße',hnr:'64/11',titel:'MR DDr.',name:'Johannes Kirchner',lat:48.21515,lon:16.33955},
  {id:'a0638',plz:'1090',strasse:'Lazarettgasse',hnr:'3',titel:'Dr.',name:'Maria Theresia Kirschner',lat:48.21824,lon:16.35095},
  {id:'a0640',plz:'1190',strasse:'Grinzinger Straße',hnr:'149A',titel:'Ddr.',name:'Andrea Kiss',lat:48.25483,lon:16.36727},
  {id:'a0641',plz:'1080',strasse:'Josefstädter Straße',hnr:'66',titel:'Dr.',name:'Ingomar Kittl',lat:48.21074,lon:16.34378},
  {id:'a0643',plz:'1100',strasse:'Wienerbergstraße',hnr:'13',titel:'Dr.',name:'Tibor Kladek',lat:48.16919,lon:16.34527},
  {id:'a0644',plz:'1060',strasse:'Mariahilfer Straße',hnr:'127',titel:'MR Dr.',name:'Rainer Klaus',lat:48.19531,lon:16.34030},
  {id:'a0645',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'Dr.',name:'Clemens Kleinberger',lat:48.22664,lon:16.35181},
  {id:'a0646',plz:'1210',strasse:'Berlagasse',hnr:'45/1/3',titel:'Dr.',name:'Philipp Kleinrath',lat:48.28965,lon:16.38216},
  {id:'a0647',plz:'1190',strasse:'Grinzinger Straße',hnr:'149a',titel:'Dr.',name:'Robert Klier',lat:48.25483,lon:16.36727},
  {id:'a0651',plz:'1050',strasse:'Schönbrunner Straße',hnr:'39',titel:'DDDr.',name:'Alfred Klotz',lat:48.19269,lon:16.35772},
  {id:'a0652',plz:'1190',strasse:'Billrothstraße',hnr:'20/15',titel:'Priv.-Doz. DDr.',name:'Clemens Klug',lat:48.23970,lon:16.34910},
  {id:'a0653',plz:'1180',strasse:'Pötzleinsdorfer Straße',hnr:'83',titel:'Dr.',name:'Birgit Kluger',lat:48.24259,lon:16.30851},
  {id:'a0654',plz:'1180',strasse:'Pötzleinsdorfer Straße',hnr:'83',titel:'DDr.',name:'Wolf-Dietrich Kluger',lat:48.24259,lon:16.30851},
  {id:'a0655',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Anna Knaus',lat:48.21955,lon:16.35453},
  {id:'a0656',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Marianne Knibbe',lat:48.21955,lon:16.35453},
  {id:'a0657',plz:'1180',strasse:'Gymnasiumstraße',hnr:'28',titel:'Dr.',name:'Wolfgang Kniewasser',lat:48.22964,lon:16.34473},
  {id:'a0658',plz:'1070',strasse:'Neubaugasse',hnr:'88',titel:'Ddr.',name:'Julia Knötig',lat:48.20630,lon:16.34950},
  {id:'a0659',plz:'1100',strasse:'Buchengasse',hnr:'133/1',titel:'Dr.',name:'Daria Knyrim-Mager',lat:48.17425,lon:16.38202},
  {id:'a0660',plz:'1090',strasse:'Grundlgasse',hnr:'1',titel:'Dr.',name:'Gert Koban',lat:48.22683,lon:16.36320},
  {id:'a0662',plz:'1150',strasse:'Schwendergasse',hnr:'35-37',titel:'Dr.',name:'Zsófia Kóbor',lat:48.19061,lon:16.32582},
  {id:'a0663',plz:'1140',strasse:'Linzer Straße',hnr:'57/4',titel:'Dr.',name:'Christine Koczi',lat:48.19426,lon:16.29267},
  {id:'a0665',plz:'1060',strasse:'Schadekgasse',hnr:'16/16',titel:'Dr.',name:'Elke Kögl',lat:48.19803,lon:16.35268},
  {id:'a0666',plz:'1020',strasse:'Taborstraße',hnr:'18/24',titel:'Dr.',name:'Christiane Köhler-Mayerhofer',lat:48.21861,lon:16.38090},
  {id:'a0667',plz:'1190',strasse:'Billrothstraße',hnr:'20/15',titel:'Dr. med. dent.',name:'Katrin Köllensperger',lat:48.23970,lon:16.34910},
  {id:'a0668',plz:'1090',strasse:'Liechtensteinstraße',hnr:'104',titel:'Dr.',name:'Walter Reinhard Köppl',lat:48.22983,lon:16.35650},
  {id:'a0669',plz:'1100',strasse:'Berthold Viertel Gasse',hnr:'11/3',titel:'Dr.',name:'Gregor Kösters',lat:48.15376,lon:16.36181},
  {id:'a0670',plz:'1070',strasse:'Kaiserstraße',hnr:'6',titel:'Dr.',name:'Philipp Kohlberger',lat:48.19712,lon:16.34169},
  {id:'a0671',plz:'1090',strasse:'Hörlgasse',hnr:'6/12',titel:'Dr.',name:'Marcus Kolbeck',lat:48.21606,lon:16.36111},
  {id:'a0672',plz:'1140',strasse:'Leyserstraße 2A /',hnr:'20',titel:'Mag.',name:'Rosica Koleva',lat:48.20208,lon:16.30276},
  {id:'a0673',plz:'1040',strasse:'Schelleingasse',hnr:'21/14',titel:'Dr.',name:'Markus Koller',lat:48.18633,lon:16.37170},
  {id:'a0674',plz:'1040',strasse:'Waltergasse',hnr:'5/6',titel:'Dr.',name:'Brisilda Kondi',lat:48.19096,lon:16.36862},
  {id:'a0675',plz:'1190',strasse:'Weimarer Straße',hnr:'102',titel:'Dr. dent. med.',name:'Gottfried Konnerth',lat:48.23662,lon:16.34548},
  {id:'a0676',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Josip Kopic',lat:48.21955,lon:16.35453},
  {id:'a0677',plz:'1160',strasse:'Friedrich Kaiser Gasse',hnr:'25/15',titel:'Dr.',name:'Maria Stefanie Kornfeind',lat:48.21104,lon:16.32977},
  {id:'a0679',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'DDr.',name:'Polina Kotlarenko',lat:48.21955,lon:16.35453},
  {id:'a0680',plz:'1110',strasse:'Guglgasse',hnr:'6/3/6/6',titel:'Dr.',name:'Martin Kova',lat:48.18508,lon:16.41873},
  {id:'a0681',plz:'1050',strasse:'Hollgasse',hnr:'8/3',titel:'DDr.',name:'Martin Kovac',lat:48.18252,lon:16.36016},
  {id:'a0682',plz:'1030',strasse:'Rochusgasse',hnr:'23',titel:'Dr.',name:'Martin Kozak',lat:48.20089,lon:16.38801},
  {id:'a0683',plz:'1150',strasse:'Mariahilfer Straße',hnr:'133',titel:'Dr.',name:'Rudolf Krachsberger',lat:48.19538,lon:16.33825},
  {id:'a0685',plz:'1180',strasse:'Cottagegasse',hnr:'19/1',titel:'Dr.',name:'Mathias Kränzl',lat:48.23153,lon:16.34131},
  {id:'a0686',plz:'1140',strasse:'Penzinger Straße',hnr:'81',titel:'Dr.',name:'Werner Kraihammer',lat:48.18967,lon:16.30091},
  {id:'a0687',plz:'1130',strasse:'Lainzer Straße',hnr:'141',titel:'',name:'Stefanie Krainhöfner',lat:48.17682,lon:16.28403},
  {id:'a0688',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Martin Krainhöfner',lat:48.21955,lon:16.35453},
  {id:'a0690',plz:'1030',strasse:'Strohgasse',hnr:'28',titel:'Dr.',name:'Hane Krasniqi',lat:48.19845,lon:16.37864},
  {id:'a0691',plz:'1030',strasse:'Kleistgasse',hnr:'3/6',titel:'Dr.',name:'Peter Kratochwil',lat:48.19203,lon:16.38987},
  {id:'a0692',plz:'1150',strasse:'Meiselstraße',hnr:'7',titel:'Dr.',name:'Isabella Kratzik',lat:48.19742,lon:16.32149},
  {id:'a0693',plz:'1130',strasse:'Lainzer Straße',hnr:'31',titel:'Dr.',name:'Heinz-Peter Krebs',lat:48.18470,lon:16.29532},
  {id:'a0694',plz:'1200',strasse:'Wallensteinplatz 3-4 /',hnr:'I',titel:'Dr.',name:'Matthias Kreminger',lat:48.22971,lon:16.37150},
  {id:'a0695',plz:'1090',strasse:'Alserbachstraße',hnr:'31',titel:'Dr.',name:'Evelyn Krenn',lat:48.22539,lon:16.36025},
  {id:'a0696',plz:'1010',strasse:'Werdertorgasse',hnr:'12/8',titel:'Dr.',name:'Sabine Kresse',lat:48.21542,lon:16.37099},
  {id:'a0698',plz:'1060',strasse:'Meravigliagasse',hnr:'1/15',titel:'Dr.',name:'Jakob Kreuzer',lat:48.19011,lon:16.33958},
  {id:'a0699',plz:'1030',strasse:'Eslarngasse',hnr:'2/17',titel:'Dr.',name:'Elisabeth Kritscher',lat:48.19478,lon:16.39399},
  {id:'a0700',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Mathias Krobath',lat:48.21955,lon:16.35453},
  {id:'a0701',plz:'1170',strasse:'Ortliebgasse',hnr:'1',titel:'Dr.',name:'Johannes Kronberger',lat:48.21413,lon:16.32996},
  {id:'a0702',plz:'1090',strasse:'Nußdorfer Straße',hnr:'4/5',titel:'Dr.',name:'Allan Krupka',lat:48.22538,lon:16.35485},
  {id:'a0703',plz:'1160',strasse:'Thaliastraße',hnr:'88/1/16',titel:'Dr.',name:'Waltraud Kubalek',lat:48.21137,lon:16.32119},
  {id:'a0705',plz:'1210',strasse:'Schleifgasse',hnr:'6/4',titel:'Dr.',name:'Pawel Kubitzky',lat:48.26019,lon:16.40142},
  {id:'a0706',plz:'1090',strasse:'Währinger Straße',hnr:'23/1',titel:'DDr.',name:'Ulrike Kuchler',lat:48.22168,lon:16.35404},
  {id:'a0707',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'Dr.',name:'Verena Kuchler',lat:48.19748,lon:16.34833},
  {id:'a0710',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Nejra Kulovic Redzic',lat:48.21955,lon:16.35453},
  {id:'a0711',plz:'1180',strasse:'Gersthofer Straße',hnr:'119/2/2',titel:'Dr.',name:'Ronald Kunisch',lat:48.23729,lon:16.32115},
  {id:'a0712',plz:'1120',strasse:'Dörfelstraße',hnr:'12',titel:'Dr.',name:'Jeanette Kunkal',lat:48.17579,lon:16.33541},
  {id:'a0713',plz:'1050',strasse:'Reinprechtsdorfer Straße',hnr:'53',titel:'Ddr.',name:'Georg Kuntzl',lat:48.18771,lon:16.35200},
  {id:'a0714',plz:'1080',strasse:'Lange Gasse',hnr:'63',titel:'Dr.',name:'Florian Kunz',lat:48.21401,lon:16.35086},
  {id:'a0715',plz:'1130',strasse:'Küniglberggasse',hnr:'65',titel:'Dr.',name:'Victoria Kunz',lat:48.17660,lon:16.28897},
  {id:'a0716',plz:'1170',strasse:'Hernalser Gürtel',hnr:'43',titel:'Ddr.',name:'Michael Kurtisch',lat:48.21676,lon:16.34117},
  {id:'a0717',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Christoph Kurzmann',lat:48.21955,lon:16.35453},
  {id:'a0719',plz:'1220',strasse:'Zachgasse',hnr:'2/1',titel:'Dr.',name:'Gerhard Kveder',lat:48.21623,lon:16.48953},
  {id:'a0720',plz:'1230',strasse:'Erlaaer Platz',hnr:'2',titel:'Ddr.',name:'Claudius Kwapinski',lat:48.14804,lon:16.31015},
  {id:'a0724',plz:'1090',strasse:'Spitalgasse',hnr:'23',titel:'Dr.',name:'Agnes Katalin Lackner',lat:48.21941,lon:16.35083},
  {id:'a0725',plz:'1130',strasse:'Lainzer Straße',hnr:'132/3',titel:'Dr.',name:'Maximilian Ladenbauer',lat:48.18072,lon:16.28489},
  {id:'a0726',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Ddr.',name:'Markus Franz Laky',lat:48.21955,lon:16.35453},
  {id:'a0727',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Tobias Lang',lat:48.21955,lon:16.35453},
  {id:'a0728',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'Dr.',name:'Friedrich Lantzberg',lat:48.22664,lon:16.35181},
  {id:'a0729',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85/87',titel:'Dr.',name:'Bettina Lantzberg-Kunze',lat:48.19748,lon:16.34833},
  {id:'a0730',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Florian Lanza',lat:48.21955,lon:16.35453},
  {id:'a0731',plz:'1090',strasse:'Nußdorfer Straße',hnr:'4/5',titel:'Dr. med. dent.',name:'Annette Latscher-Lauendorf',lat:48.22538,lon:16.35485},
  {id:'a0733',plz:'1020',strasse:'Praterstraße',hnr:'58',titel:'Dr.',name:'Gerda Launsky-Ludvik',lat:48.21607,lon:16.38806},
  {id:'a0734',plz:'1060',strasse:'Webgasse',hnr:'7/6',titel:'Ddr.',name:'Verena Lechner',lat:48.19585,lon:16.34482},
  {id:'a0735',plz:'1130',strasse:'Nästlbergergasse',hnr:'6',titel:'Dr.',name:'Johann Lederer',lat:48.16063,lon:16.26065},
  {id:'a0736',plz:'1110',strasse:'Rosa Jochmann Ring',hnr:'1/1/3',titel:'Dr.',name:'Beata Ledwon',lat:48.15421,lon:16.46420},
  {id:'a0737',plz:'1030',strasse:'Kegelgasse',hnr:'35/21',titel:'Dr.',name:'Jakob Piotr Ledwon',lat:48.20739,lon:16.39273},
  {id:'a0739',plz:'1020',strasse:'Hillerstraße',hnr:'14/12-13',titel:'Dr.',name:'Anastasia Leikina',lat:48.22065,lon:16.40694},
  {id:'a0741',plz:'1010',strasse:'Stubenring',hnr:'20/8',titel:'Dr.',name:'Doris Leitner',lat:48.20879,lon:16.38214},
  {id:'a0742',plz:'1010',strasse:'Rotenturmstraße',hnr:'27/15',titel:'Prim. Dr.',name:'Johannes Lembacher',lat:48.21172,lon:16.37611},
  {id:'a0743',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'',name:'Sophie Lembacher',lat:48.21955,lon:16.35453},
  {id:'a0744',plz:'1010',strasse:'Rotenturmstraße',hnr:'27/15',titel:'Dr.',name:'Sylvia Lembacher-Schmoiger',lat:48.21172,lon:16.37611},
  {id:'a0745',plz:'1180',strasse:'Gersthofer Straße',hnr:'8/1/9',titel:'Dr.',name:'Natalie Lemberg',lat:48.23427,lon:16.32757},
  {id:'a0746',plz:'1020',strasse:'Taborstraße',hnr:'48/15',titel:'Dr.',name:'Elke Lenotti',lat:48.21861,lon:16.38090},
  {id:'a0747',plz:'1190',strasse:'Saileräckergasse',hnr:'17/1',titel:'Dr.',name:'Maria Andreyna Leon Manrique',lat:48.24125,lon:16.33653},
  {id:'a0748',plz:'1070',strasse:'Zieglergasse',hnr:'5',titel:'DDr.',name:'Vera Leonhard',lat:48.19784,lon:16.34513},
  {id:'a0750',plz:'1010',strasse:'Judenplatz',hnr:'10',titel:'Dr.',name:'Sven C. Leopold',lat:48.21178,lon:16.36969},
  {id:'a0752',plz:'1100',strasse:'Hertha Firnberg Straße',hnr:'10/2/1',titel:'Dr.',name:'Daniela Lettner',lat:48.16606,lon:16.34649},
  {id:'a0753',plz:'1010',strasse:'Wollzeile',hnr:'17/9',titel:'Dr.',name:'Michael Lettner',lat:48.20902,lon:16.37473},
  {id:'a0754',plz:'1010',strasse:'Am Graben',hnr:'12',titel:'Dr.',name:'Michael Peter Leu',lat:48.13400,lon:16.13159},
  {id:'a0755',plz:'1190',strasse:'Peter Altenberg Gasse',hnr:'13',titel:'Dr.',name:'Maximilian Leukauf',lat:48.25037,lon:16.29403},
  {id:'a0756',plz:'1190',strasse:'Rodlergasse',hnr:'8',titel:'Dr. med. univ.',name:'Michael M. Leukauf',lat:48.24153,lon:16.33444},
  {id:'a0757',plz:'1190',strasse:'Rodlergasse',hnr:'8',titel:'Dr.',name:'Doris Leukauf',lat:48.24153,lon:16.33444},
  {id:'a0759',plz:'1170',strasse:'Clemens Hofbauer Platz',hnr:'10/21',titel:'Dr.',name:'Marie-Luise Leyh',lat:48.21863,lon:16.32162},
  {id:'a0760',plz:'1010',strasse:'Köllnerhofgasse',hnr:'6',titel:'Dr.',name:'Roberto Lhotka',lat:48.21058,lon:16.37605},
  {id:'a0761',plz:'1130',strasse:'Vitusgasse',hnr:'9',titel:'Dr.',name:'Wenning Li',lat:48.18713,lon:16.26642},
  {id:'a0762',plz:'1020',strasse:'Freudplatz',hnr:'1',titel:'DDr.',name:'Bledar Lilaj',lat:48.21514,lon:16.40528},
  {id:'a0763',plz:'1190',strasse:'Nottebohmstraße',hnr:'63',titel:'Dr.',name:'Elisabeth Lill',lat:48.24966,lon:16.31985},
  {id:'a0764',plz:'1180',strasse:'Währinger Straße',hnr:'151',titel:'Univ. Doz. Dr.',name:'Werner Lill',lat:48.22829,lon:16.33481},
  {id:'a0765',plz:'1020',strasse:'Rueppgasse',hnr:'17/1',titel:'Dr.',name:'Katharina Lin-Pilz',lat:48.22363,lon:16.38754},
  {id:'a0766',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'Dr.',name:'Stefan Lindemann',lat:48.19748,lon:16.34833},
  {id:'a0767',plz:'1010',strasse:'Friedrichstraße',hnr:'6/13',titel:'Dr.',name:'Roman Lindenberger',lat:48.20084,lon:16.36696},
  {id:'a0768',plz:'1150',strasse:'Schmutzergasse',hnr:'2',titel:'DDr.',name:'Andreas Lindner',lat:48.19960,lon:16.31826},
  {id:'a0769',plz:'1060',strasse:'Dreihausgasse',hnr:'11/25',titel:'Dr.',name:'Laura Elisabeth Lingg',lat:48.19052,lon:16.32552},
  {id:'a0773',plz:'1130',strasse:'Wolkersbergenstraße',hnr:'1',titel:'DDr.',name:'Corina List',lat:48.17251,lon:16.27389},
  {id:'a0774',plz:'1090',strasse:'Währinger Straße',hnr:'23/1',titel:'Dr.',name:'Emanuela Thuy-Tien Liu',lat:48.22168,lon:16.35404},
  {id:'a0775',plz:'1210',strasse:'O\'Brien Gasse',hnr:'29/13',titel:'DDr.',name:'Maximilian Lochner',lat:48.26530,lon:16.39111},
  {id:'a0776',plz:'1090',strasse:'Sensengasse',hnr:'2',titel:'Dr.',name:'Nina Lochner',lat:48.21909,lon:16.35272},
  {id:'a0777',plz:'1120',strasse:'Meidlinger Hauptstraße',hnr:'42-44',titel:'Dr.',name:'Peter Löwy',lat:48.17853,lon:16.32963},
  {id:'a0778',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'Dr.',name:'Bettina Lohmann-Lehner',lat:48.19748,lon:16.34833},
  {id:'a0780',plz:'1190',strasse:'Zehenthofgasse',hnr:'28',titel:'Dr.',name:'Maria Anna Lothaller-Watzak',lat:48.24780,lon:16.34612},
  {id:'a0781',plz:'1210',strasse:'Fritz Kandl Gasse',hnr:'1/2/10',titel:'Dr.',name:'Shadi Loutfi',lat:48.28845,lon:16.39155},
  {id:'a0782',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'ZÄ',name:'Karla Lowasz',lat:48.19748,lon:16.34833},
  {id:'a0783',plz:'1110',strasse:'Simmeringer Hauptstraße',hnr:'40/4/1',titel:'Dr.',name:'Josef Ludvik',lat:48.17483,lon:16.41588},
  {id:'a0784',plz:'1200',strasse:'Innstraße',hnr:'3',titel:'Dr.',name:'Savo Lukac',lat:48.23082,lon:16.38705},
  {id:'a0789',plz:'1020',strasse:'Johannes von Gott Platz',hnr:'1',titel:'DDr.',name:'Aleksandra Lux',lat:48.21512,lon:16.38182},
  {id:'a0790',plz:'1100',strasse:'Hertha Firnberg Straße',hnr:'10/2/1',titel:'Dr.',name:'Andrea Verena Lux',lat:48.16606,lon:16.34649},
  {id:'a0791',plz:'1150',strasse:'Grenzgasse',hnr:'5',titel:'Dr.',name:'Stefan Ion Mac-Bretschneider',lat:48.19204,lon:16.32986},
  {id:'a0792',plz:'1190',strasse:'Sieveringer Straße',hnr:'18/5',titel:'Dr.',name:'Peter Macek',lat:48.25696,lon:16.31129},
  {id:'a0793',plz:'1020',strasse:'Johannes von Gott Platz',hnr:'1',titel:'Dr.',name:'Stefan Machalik',lat:48.21512,lon:16.38182},
  {id:'a0794',plz:'1020',strasse:'Förstergasse',hnr:'7/23',titel:'Dr.',name:'Herbert Macik',lat:48.22104,lon:16.37205},
  {id:'a0795',plz:'1010',strasse:'Zelinkagasse',hnr:'10/12',titel:'Dr.',name:'Evelyn Marietta Maculan-Lanschützer',lat:48.21646,lon:16.36997},
  {id:'a0797',plz:'1230',strasse:'Rudolf Zeller Gasse',hnr:'51-61/9/4',titel:'DDr.',name:'Stefanie Mader',lat:48.14635,lon:16.28349},
  {id:'a0798',plz:'1230',strasse:'Breitenfurter Straße 360-368 / 1 /',hnr:'1',titel:'Dr.',name:'Bettina Männer',lat:48.13593,lon:16.28220},
  {id:'a0799',plz:'1010',strasse:'Renngasse',hnr:'15',titel:'Dr.',name:'Magdalena Magdalenko',lat:48.21372,lon:16.36825},
  {id:'a0800',plz:'1040',strasse:'Margaretenstraße',hnr:'44',titel:'Dr.',name:'Azzam Mahmoud',lat:48.19517,lon:16.36306},
  {id:'a0802',plz:'1210',strasse:'Anton Störck Gasse',hnr:'71',titel:'DDr.',name:'Georg Mailath-Pokorny',lat:48.26605,lon:16.39049},
  {id:'a0803',plz:'1210',strasse:'Anton Störck Gasse',hnr:'71',titel:'Dr.',name:'Georg Mailath-Pokorny',lat:48.26605,lon:16.39049},
  {id:'a0804',plz:'1020',strasse:'Freudplatz',hnr:'1',titel:'Dr.',name:'Rebecca Mair',lat:48.21514,lon:16.40528},
  {id:'a0806',plz:'1060',strasse:'Mariahilfer Straße',hnr:'111/1/2',titel:'Dr. med. dent.',name:'Kremena Malinova',lat:48.19598,lon:16.34024},
  {id:'a0807',plz:'1150',strasse:'Mariahilfer Straße',hnr:'140/11',titel:'Dr.',name:'Robert Mallinger',lat:48.19538,lon:16.33825},
  {id:'a0808',plz:'1230',strasse:'Lindgrabengasse',hnr:'36',titel:'Dr.',name:'Achim E. Mamut',lat:48.15408,lon:16.25580},
  {id:'a0810',plz:'1120',strasse:'Meidlinger Hauptstraße 12-14 /',hnr:'9',titel:'Dr.',name:'Raluca-Iulia Mamut-Zahradnik',lat:48.18169,lon:16.32916},
  {id:'a0812',plz:'1070',strasse:'Kaiserstraße',hnr:'6/19',titel:'Dr.',name:'Peter Marada',lat:48.20561,lon:16.33980},
  {id:'a0813',plz:'1060',strasse:'Mariahilfer Straße 105 / 1 / 14 +',hnr:'15',titel:'Dr.',name:'Arthur Marczell',lat:48.19013,lon:16.31994},
  {id:'a0815',plz:'1210',strasse:'Leopoldauer Straße',hnr:'68',titel:'Dr.',name:'Peter Markotanyos',lat:48.26025,lon:16.41614},
  {id:'a0816',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'',name:'Silvia Markova',lat:48.21955,lon:16.35453},
  {id:'a0818',plz:'1070',strasse:'Westbahnstraße',hnr:'60/9',titel:'Dr.',name:'Noémi-Katalin Markovic',lat:48.20187,lon:16.33929},
  {id:'a0821',plz:'1070',strasse:'Breite Gasse 4 Top',hnr:'3',titel:'Dr.',name:'Leila Marvastian',lat:48.20373,lon:16.35677},
  {id:'a0822',plz:'1180',strasse:'Kutschkergasse',hnr:'1',titel:'Ddr.',name:'Vera Masic-Cabak',lat:48.22230,lon:16.34350},
  {id:'a0823',plz:'1090',strasse:'Spitalgasse',hnr:'17/6',titel:'Dr.',name:'Fedja Masic-Redinger',lat:48.21916,lon:16.35192},
  {id:'a0825',plz:'1060',strasse:'Mariahilfer Straße',hnr:'47/5/7',titel:'DDr.',name:'Michael Herbert Mateika',lat:48.20130,lon:16.35978},
  {id:'a0826',plz:'1070',strasse:'Kirchengasse',hnr:'12/2',titel:'Dr.',name:'Barbara Susanne Matejka',lat:48.20168,lon:16.35198},
  {id:'a0827',plz:'1060',strasse:'Mariahilfer Straße',hnr:'47/5/7',titel:'Dr.',name:'Renate Matejka',lat:48.20130,lon:16.35978},
  {id:'a0828',plz:'1170',strasse:'Rhigasgasse',hnr:'8',titel:'Dr.',name:'Mirjana Matic',lat:48.22301,lon:16.32311},
  {id:'a0829',plz:'1090',strasse:'Lazarettgasse',hnr:'19',titel:'Dr.',name:'Marc Julian Matula',lat:48.21728,lon:16.34836},
  {id:'a0831',plz:'1010',strasse:'Wipplingerstraße',hnr:'18/5a',titel:'DDr.',name:'Karl Maurer',lat:48.21469,lon:16.36623},
  {id:'a0833',plz:'1010',strasse:'Judenplatz',hnr:'10',titel:'Dr.',name:'Claudia Mautner Markhof',lat:48.21178,lon:16.36969},
  {id:'a0835',plz:'1100',strasse:'Wienerbergstraße',hnr:'15-19',titel:'Dr.',name:'Anna Elisabeth Mayr',lat:48.16956,lon:16.34391},
  {id:'a0836',plz:'1080',strasse:'Josefstädter Straße',hnr:'80',titel:'Dr.',name:'Maria Mayr',lat:48.21134,lon:16.34074},
  {id:'a0837',plz:'1060',strasse:'Stumpergasse',hnr:'4ß',titel:'MR Dr.',name:'Frederick Mayrhofer-Krammel',lat:48.19367,lon:16.34479},
  {id:'a0840',plz:'1080',strasse:'Josefstädter Straße',hnr:'80',titel:'Dr.',name:'Mandana Mazi',lat:48.21134,lon:16.34074},
  {id:'a0841',plz:'1220',strasse:'Zschokkegasse',hnr:'140',titel:'Dr.',name:'Alexandra Mc Kay',lat:48.22002,lon:16.46409},
  {id:'a0842',plz:'1030',strasse:'Sechskrügelgasse',hnr:'8/7',titel:'Dr. med. univ. et med. dent.',name:'Michael Meissl',lat:48.20163,lon:16.38915},
  {id:'a0843',plz:'1060',strasse:'Mollardgasse',hnr:'2/4',titel:'Dr.',name:'Martina Meister',lat:48.19008,lon:16.34979},
  {id:'a0844',plz:'1210',strasse:'Schlosshofer Straße',hnr:'20/1/5',titel:'Dr.',name:'Ulrike Melber',lat:48.25803,lon:16.39903},
  {id:'a0846',plz:'1070',strasse:'Schottenfeldgasse',hnr:'45',titel:'Dr. med. dent.',name:'Annika Meller',lat:48.20143,lon:16.34257},
  {id:'a0848',plz:'1010',strasse:'Weihburggasse',hnr:'11/5',titel:'Dr.',name:'Agnes Szilvia Meszaros',lat:48.20705,lon:16.37231},
  {id:'a0851',plz:'1010',strasse:'Opernring 8 Stg. 2 /',hnr:'9',titel:'Dr.',name:'Agnes Mezei',lat:48.20239,lon:16.36949},
  {id:'a0853',plz:'1040',strasse:'Schleifmühlgasse',hnr:'7/9',titel:'Dr.',name:'Michael Mick',lat:48.19837,lon:16.36394},
  {id:'a0854',plz:'1030',strasse:'Seidlgasse',hnr:'36/11',titel:'Dr.',name:'René Bernard Mick',lat:48.20771,lon:16.39083},
  {id:'a0855',plz:'1040',strasse:'Schleifmühlgasse',hnr:'7/8',titel:'Dr.',name:'Simona Ionela Mick',lat:48.19729,lon:16.36526},
  {id:'a0856',plz:'1220',strasse:'Langobardenstraße',hnr:'122',titel:'DDr..',name:'Kathrin Mika',lat:48.21931,lon:16.46448},
  {id:'a0857',plz:'1130',strasse:'Wolkersbergenstraße',hnr:'1',titel:'DDr',name:'Werner Millesi',lat:48.17251,lon:16.27389},
  {id:'a0858',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'Dr.',name:'Ingrid Millesi-Strobl',lat:48.22664,lon:16.35181},
  {id:'a0859',plz:'1190',strasse:'Würthgasse',hnr:'10',titel:'Dr.',name:'Maximilian Marcus Millonig',lat:48.24032,lon:16.35422},
  {id:'a0861',plz:'1090',strasse:'Schwarzspanierstraße',hnr:'16/3',titel:'DDr.',name:'Armando Minassian',lat:48.21703,lon:16.35869},
  {id:'a0862',plz:'1140',strasse:'Striagasse',hnr:'22',titel:'Dr.',name:'Emanuel Mirea',lat:48.20189,lon:16.28995},
  {id:'a0863',plz:'1110',strasse:'Herbortgasse',hnr:'22',titel:'Dr.',name:'Ilnaz Miri Soleiman',lat:48.17140,lon:16.41095},
  {id:'a0866',plz:'1170',strasse:'Rhigasgasse',hnr:'8',titel:'Dr.',name:'Vanessa Mitterdorfer',lat:48.22301,lon:16.32311},
  {id:'a0867',plz:'1080',strasse:'Fuhrmannsgasse 7 /',hnr:'12',titel:'Dr.',name:'Elisabeth Mitterlechner',lat:48.21088,lon:16.34806},
  {id:'a0868',plz:'1190',strasse:'Gustav Pick Gasse',hnr:'15/1/6',titel:'Dr.',name:'Peter Mladek',lat:48.24359,lon:16.32675},
  {id:'a0870',plz:'1050',strasse:'Schönbrunner Straße',hnr:'38/10',titel:'Dr. med. dent.',name:'Konstanze Mock',lat:48.19122,lon:16.35573},
  {id:'a0871',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Jan Möstl',lat:48.21955,lon:16.35453},
  {id:'a0872',plz:'1100',strasse:'Absberggasse',hnr:'21/1/9',titel:'Dr.',name:'Moustafa Mohamad',lat:48.17350,lon:16.38986},
  {id:'a0874',plz:'1050',strasse:'Ramperstorffergasse',hnr:'68',titel:'Dr.',name:'Tatiana Molodova',lat:48.19027,lon:16.35519},
  {id:'a0875',plz:'1040',strasse:'Schlüsselgasse',hnr:'8/17',titel:'Dr.',name:'Nosratollah Momeni Hosseini',lat:48.19325,lon:16.36794},
  {id:'a0876',plz:'1080',strasse:'Josefstädter Straße',hnr:'80',titel:'DDr..',name:'Michaela Mondl',lat:48.21134,lon:16.34074},
  {id:'a0877',plz:'1180',strasse:'Weimarer Straße',hnr:'15',titel:'DDr.',name:'Gabriel Monov',lat:48.22759,lon:16.34094},
  {id:'a0880',plz:'1140',strasse:'Kienmayergasse',hnr:'31/11',titel:'Dr.',name:'Georg Morgenstern',lat:48.20188,lon:16.31131},
  {id:'a0881',plz:'1100',strasse:'Wienerbergstraße',hnr:'13',titel:'Dr.',name:'Adelina Morina',lat:48.16919,lon:16.34527},
  {id:'a0882',plz:'1080',strasse:'Josefstädter Straße',hnr:'43/1/8',titel:'Dr.',name:'Ulrike Moritz',lat:48.20952,lon:16.34967},
  {id:'a0883',plz:'1080',strasse:'Josefstädter Straße',hnr:'43/1/8',titel:'DDr.',name:'Andreas Moritz',lat:48.20952,lon:16.34967},
  {id:'a0884',plz:'1180',strasse:'Bastiengasse',hnr:'85',titel:'Dr.',name:'Emilia Mory',lat:48.23468,lon:16.31754},
  {id:'a0885',plz:'1180',strasse:'Gersthofer Straße',hnr:'63/11',titel:'Dr.',name:'Axel Christian Mory',lat:48.23427,lon:16.32757},
  {id:'a0886',plz:'1090',strasse:'Bleichergasse',hnr:'13/11',titel:'Dr.',name:'Reinhard Moser',lat:48.22408,lon:16.35194},
  {id:'a0887',plz:'1100',strasse:'Hertha Firnberg Straße',hnr:'10/2/1',titel:'Dr.',name:'Florian Mostbeck',lat:48.16606,lon:16.34649},
  {id:'a0888',plz:'1140',strasse:'Hütteldorfer Straße',hnr:'102',titel:'Dr.',name:'Wolfgang Mostbeck',lat:48.19913,lon:16.31227},
  {id:'a0889',plz:'1190',strasse:'Krottenbachstraße',hnr:'307/1/2',titel:'Dr.',name:'Albert Movssissian',lat:48.24048,lon:16.34048},
  {id:'a0890',plz:'1030',strasse:'Radetzkyplatz',hnr:'2',titel:'Dr.',name:'Laszlo Mozsolits',lat:48.21081,lon:16.38974},
  {id:'a0891',plz:'1010',strasse:'Renngasse',hnr:'15',titel:'DDr..',name:'Svätopluk Mraz',lat:48.21372,lon:16.36825},
  {id:'a0892',plz:'1110',strasse:'Herbortgasse',hnr:'22',titel:'Dr.',name:'Marlene Mühlbachler',lat:48.17140,lon:16.41095},
  {id:'a0894',plz:'1050',strasse:'Pilgramgasse',hnr:'1/2/8',titel:'Dr.',name:'Norbert Müller',lat:48.19176,lon:16.35731},
  {id:'a0896',plz:'1050',strasse:'Pilgramgasse',hnr:'1/2/8',titel:'Dr.',name:'Mona Amelie Mercedes Müller',lat:48.19176,lon:16.35731},
  {id:'a0897',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Franziska-Sabine Müller',lat:48.21955,lon:16.35453},
  {id:'a0899',plz:'1080',strasse:'Laudongasse',hnr:'38',titel:'Dr.',name:'Michael Müller',lat:48.21319,lon:16.34573},
  {id:'a0900',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Moritz Müller-Hartburg',lat:48.21955,lon:16.35453},
  {id:'a0901',plz:'1150',strasse:'Arnsteingasse',hnr:'29/26',titel:'Dr.',name:'Christiane Müller-Hartburg',lat:48.18960,lon:16.33136},
  {id:'a0902',plz:'1220',strasse:'An der Oberen Alten Donau',hnr:'187',titel:'Dr.',name:'Ulrike Müller-Hofbauer',lat:48.24113,lon:16.42664},
  {id:'a0903',plz:'1190',strasse:'Heiligenstädter Straße',hnr:'51/53',titel:'Dr.',name:'Susanne Müller-Tyl',lat:48.25267,lon:16.36413},
  {id:'a0904',plz:'1100',strasse:'Hertha Firnberg Straße',hnr:'10/2/1',titel:'Dr.',name:'Stefanie Müllner-Salzl',lat:48.16606,lon:16.34649},
  {id:'a0905',plz:'1100',strasse:'Malborghetgasse',hnr:'33/4',titel:'Dr.',name:'Wolf Dieter Müllschitzky',lat:48.17016,lon:16.35901},
  {id:'a0907',plz:'1220',strasse:'Wurmbrandgasse',hnr:'19/3',titel:'Dr.',name:'Anna Mulik-Kargol',lat:48.22627,lon:16.45486},
  {id:'a0908',plz:'1020',strasse:'Adambergergasse',hnr:'12/26a',titel:'Dr.',name:'Alexa Muth',lat:48.22040,lon:16.37461},
  {id:'a0909',plz:'1230',strasse:'Breitenfurterstraße 360-368 / 1 /',hnr:'1',titel:'Dr.',name:'Maximilian Nadlinger',lat:48.13593,lon:16.28220},
  {id:'a0910',plz:'1020',strasse:'Engerthstraße',hnr:'230/19/9',titel:'Dr.',name:'Karl Nagy-Babiak',lat:48.21588,lon:16.41443},
  {id:'a0911',plz:'1010',strasse:'Wipplingerstraße',hnr:'29/3',titel:'Dr.',name:'Sabine Nahler',lat:48.21201,lon:16.37038},
  {id:'a0913',plz:'1140',strasse:'Einwanggasse',hnr:'4/9',titel:'Dr.',name:'Philipp Luciano Necsea',lat:48.19083,lon:16.30178},
  {id:'a0914',plz:'1210',strasse:'Brünner Straße',hnr:'80/11',titel:'Dr.',name:'Christian Negrin',lat:48.30433,lon:16.42458},
  {id:'a0915',plz:'1210',strasse:'Bahnsteggasse',hnr:'22/16',titel:'Dr.',name:'Wolfgang Negrin',lat:48.26470,lon:16.39910},
  {id:'a0916',plz:'1030',strasse:'Hegergasse',hnr:'2/12',titel:'Dr.',name:'Reiner Neidenbach',lat:48.19164,lon:16.38844},
  {id:'a0917',plz:'1040',strasse:'Schikanedergasse',hnr:'1/2',titel:'Dr.',name:'Thomas Nell',lat:48.19682,lon:16.36444},
  {id:'a0918',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'DDr..',name:'Andrea Lotte Nell',lat:48.21955,lon:16.35453},
  {id:'a0921',plz:'1030',strasse:'Barichgasse',hnr:'2',titel:'Dr.',name:'Barbara Nemetz',lat:48.19787,lon:16.39465},
  {id:'a0922',plz:'1190',strasse:'Iglaseegasse',hnr:'69/6',titel:'Dr.',name:'Regina Nenadovic-Selischkar',lat:48.24714,lon:16.34880},
  {id:'a0923',plz:'1040',strasse:'Theresianumgasse',hnr:'17/4',titel:'DDr.',name:'Johanna Netzer',lat:48.19214,lon:16.37568},
  {id:'a0924',plz:'1030',strasse:'Ungargasse',hnr:'4/3',titel:'Dr.',name:'Kathrin Elisabeth Neugschwandtner',lat:48.19788,lon:16.38726},
  {id:'a0925',plz:'1170',strasse:'Rötzergasse',hnr:'7/14',titel:'Dr.',name:'Thuy-Y Nguyen',lat:48.22008,lon:16.32912},
  {id:'a0926',plz:'1210',strasse:'Schloßhofer Straße',hnr:'13-15/',titel:'Dr.',name:'Raluca - Elena Nicolae',lat:48.25763,lon:16.40071},
  {id:'a0927',plz:'1090',strasse:'Schwarzspanierstraße',hnr:'15/1/5',titel:'Dr.',name:'Alexander Nidetzky',lat:48.21703,lon:16.35869},
  {id:'a0928',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Anuscha Nidetzky',lat:48.21955,lon:16.35453},
  {id:'a0929',plz:'1100',strasse:'Eisenstadtplatz',hnr:'4/1/5',titel:'Dr.',name:'Gustav Niebauer',lat:48.16753,lon:16.38249},
  {id:'a0930',plz:'1100',strasse:'Eisenstadtplatz',hnr:'4/1/5',titel:'Dr.',name:'Michaela Niebauer',lat:48.16753,lon:16.38249},
  {id:'a0932',plz:'1010',strasse:'Renngasse',hnr:'15',titel:'Dr.',name:'Ewald Niefergall',lat:48.21372,lon:16.36825},
  {id:'a0934',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Carina-Maria Nikodem',lat:48.21955,lon:16.35453},
  {id:'a0935',plz:'1040',strasse:'Prinz Eugen Straße',hnr:'56/11',titel:'Dr.',name:'Oksana Nirk',lat:48.19336,lon:16.37811},
  {id:'a0936',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'DDr.',name:'Ruhi Niyazi',lat:48.19748,lon:16.34833},
  {id:'a0937',plz:'1220',strasse:'Zschokkegasse',hnr:'140',titel:'Dr.',name:'Nazanin Noroozkhan',lat:48.22002,lon:16.46409},
  {id:'a0938',plz:'1030',strasse:'Fasangasse',hnr:'7/22',titel:'Dr.',name:'Ursula Novacek-Plachetzky',lat:48.19430,lon:16.38638},
  {id:'a0939',plz:'1120',strasse:'Vivenotgasse',hnr:'17/12',titel:'Dr.',name:'Mladen Novak',lat:48.17898,lon:16.33127},
  {id:'a0941',plz:'1100',strasse:'Gußriegelstraße 51 / 1 /',hnr:'2',titel:'Dr.',name:'Michael Nussbaumer',lat:48.17576,lon:16.35959},
  {id:'a0942',plz:'1120',strasse:'Spittelbreitengasse',hnr:'23/12',titel:'Dr.',name:'Imma Oberhuber',lat:48.17675,lon:16.32203},
  {id:'a0943',plz:'1010',strasse:'Freyung 4 / 1 /',hnr:'3',titel:'Dr.',name:'Julia Magdalena Oberleitner',lat:48.21162,lon:16.36519},
  {id:'a0944',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Simon Öppinger',lat:48.21955,lon:16.35453},
  {id:'a0945',plz:'1100',strasse:'Hertha Firnberg Straße 10 / 2 /',hnr:'1',titel:'Dr.',name:'Maximilian Ogris',lat:48.16606,lon:16.34649},
  {id:'a0946',plz:'1020',strasse:'Karmeliterplatz 1 /',hnr:'7',titel:'Dr.',name:'Walter Ogris',lat:48.21582,lon:16.37979},
  {id:'a0947',plz:'1120',strasse:'Singrienergasse',hnr:'29',titel:'Dr.',name:'Ina Olsson',lat:48.17839,lon:16.32514},
  {id:'a0948',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'Dr.',name:'Andreea-Julia Oniga',lat:48.19748,lon:16.34833},
  {id:'a0949',plz:'1100',strasse:'Hasengasse',hnr:'32/4',titel:'Dr.',name:'Noemi Opitz',lat:48.17945,lon:16.36990},
  {id:'a0950',plz:'1080',strasse:'Josefstädter Straße',hnr:'13/25',titel:'Dr.',name:'Eva Oppolzer',lat:48.20941,lon:16.35138},
  {id:'a0951',plz:'1110',strasse:'Grillgasse 14a /',hnr:'12',titel:'Dr.',name:'Alexandra Orgler',lat:48.16999,lon:16.41025},
  {id:'a0952',plz:'1010',strasse:'Goldschmiedgasse',hnr:'10/3/1',titel:'Dr.',name:'Evren Orun',lat:48.20869,lon:16.37130},
  {id:'a0953',plz:'1090',strasse:'Liechtensteinstraße',hnr:'60/8',titel:'Dr. med. univ.',name:'Werner Ossmann',lat:48.21766,lon:16.36203},
  {id:'a0954',plz:'1030',strasse:'Landstraßer Gürtel',hnr:'89',titel:'Dr.',name:'Alireza Oveisi',lat:48.18520,lon:16.39767},
  {id:'a0955',plz:'1130',strasse:'Joseph Lister Gasse 31a /',hnr:'8',titel:'Dr.',name:'Leyla Oveysi',lat:48.17506,lon:16.26841},
  {id:'a0956',plz:'1030',strasse:'Neulinggasse',hnr:'28/3',titel:'Dr.',name:'Alfred Pabisch',lat:48.19908,lon:16.38634},
  {id:'a0957',plz:'1090',strasse:'Garnisongasse',hnr:'6/6',titel:'Dr.',name:'Martin Pac',lat:48.21655,lon:16.35663},
  {id:'a0958',plz:'1190',strasse:'Glanzinggasse',hnr:'23/2',titel:'Dr.',name:'Kiana Pak Seresht',lat:48.24244,lon:16.31672},
  {id:'a0960',plz:'1170',strasse:'Thelemangasse',hnr:'5/3',titel:'DDr.',name:'Philipp Martin Paluch',lat:48.21408,lon:16.33923},
  {id:'a0961',plz:'1140',strasse:'Spallartgasse',hnr:'11/34',titel:'DDr.',name:'Slobodan Pantelic',lat:48.20077,lon:16.30607},
  {id:'a0964',plz:'1010',strasse:'Stubenring',hnr:'14',titel:'Dr.',name:'Alfred Partik',lat:48.20892,lon:16.38170},
  {id:'a0966',plz:'1130',strasse:'Rohrbacher Straße',hnr:'25',titel:'Dr.',name:'Bettina Patay-Kremliczka',lat:48.18993,lon:16.27087},
  {id:'a0967',plz:'1060',strasse:'Esterhazygasse 30a /',hnr:'6',titel:'Dr.',name:'Sanda-Ileana Patruta',lat:48.19707,lon:16.34916},
  {id:'a0968',plz:'1160',strasse:'Kirchstetterngasse',hnr:'49',titel:'Dr.',name:'Melanie Traute Paulmayer',lat:48.20994,lon:16.33306},
  {id:'a0969',plz:'1080',strasse:'Schlesingerplatz',hnr:'5',titel:'Dr.',name:'Andrea Pavili',lat:48.21270,lon:16.34711},
  {id:'a0970',plz:'1100',strasse:'Laxenburgerstraße',hnr:'24/2/10',titel:'Dr.',name:'Vojislav Pavlovic',lat:48.17977,lon:16.37383},
  {id:'a0971',plz:'1120',strasse:'Schönbrunnerstraße',hnr:'219/10',titel:'Dr.',name:'Joanna Pawlik',lat:48.18337,lon:16.33015},
  {id:'a0972',plz:'1010',strasse:'Tuchlauben',hnr:'7',titel:'Dr. med. dent.',name:'Tomasz Pawlowski',lat:48.21008,lon:16.36951},
  {id:'a0973',plz:'1010',strasse:'Herrengasse',hnr:'6/8/3',titel:'DDr.',name:'Alkuin Anton Pecher',lat:48.20912,lon:16.36609},
  {id:'a0974',plz:'1220',strasse:'Langobardenstraße',hnr:'122',titel:'Dr.',name:'Margarita Pecina',lat:48.21931,lon:16.46448},
  {id:'a0975',plz:'1110',strasse:'Simmeringer Platz',hnr:'1/2/5-6',titel:'DDr.',name:'Sandra Peck',lat:48.16935,lon:16.41985},
  {id:'a0976',plz:'1010',strasse:'Getreidemarkt',hnr:'18/14',titel:'Dr. med. dent.',name:'Axel Peez',lat:48.20091,lon:16.36544},
  {id:'a0977',plz:'1140',strasse:'Linzer Straße',hnr:'48/6',titel:'Dr.',name:'Ingrid Peka',lat:48.20347,lon:16.24275},
  {id:'a0978',plz:'1010',strasse:'Renngasse',hnr:'15',titel:'Dr.',name:'Tania Pekez',lat:48.21372,lon:16.36825},
  {id:'a0979',plz:'1090',strasse:'Pramergasse',hnr:'28/3',titel:'Dr. med. univ.',name:'Renate Pellech',lat:48.22225,lon:16.36276},
  {id:'a0980',plz:'1170',strasse:'Heuberggasse',hnr:'11',titel:'Dr.',name:'Thomas Pellech',lat:48.22841,lon:16.29280},
  {id:'a0981',plz:'1040',strasse:'Schleifmühlgasse',hnr:'1/16',titel:'DDr.',name:'Maria Peloschek',lat:48.19729,lon:16.36526},
  {id:'a0982',plz:'1190',strasse:'Hackenberggasse',hnr:'42',titel:'Dr.',name:'Brigitte Penkner',lat:48.24717,lon:16.32375},
  {id:'a0983',plz:'1210',strasse:'Jedlersdorfer Straße',hnr:'99/21/2',titel:'Dr.',name:'Sonja Penkner',lat:48.27781,lon:16.40033},
  {id:'a0984',plz:'1170',strasse:'Jörgerstraße',hnr:'50',titel:'DDr.',name:'Evamarie Perger-Eggarter',lat:48.21828,lon:16.33388},
  {id:'a0985',plz:'1180',strasse:'Anton Frank Gasse',hnr:'4/11',titel:'Dr.',name:'Ekaterina Perkovic',lat:48.22935,lon:16.34307},
  {id:'a0986',plz:'1180',strasse:'Leitermayergasse',hnr:'40/10',titel:'Dr',name:'Nora Perlaky',lat:48.22420,lon:16.33802},
  {id:'a0987',plz:'1040',strasse:'Schäffergasse',hnr:'20',titel:'Dr. med. univ.',name:'Michael Pernatsch',lat:48.19394,lon:16.36373},
  {id:'a0990',plz:'1180',strasse:'Weimarer Straße',hnr:'5/21',titel:'Dr. med. dent.',name:'Hajo Peters',lat:48.22655,lon:16.34051},
  {id:'a0991',plz:'1180',strasse:'Weimarer Straße',hnr:'5/21',titel:'Dr.',name:'Ariane Peters',lat:48.22655,lon:16.34051},
  {id:'a0992',plz:'1180',strasse:'Staudgasse 20 /',hnr:'3-4',titel:'Dr.',name:'Reinhard Paul Kurt Pfändner',lat:48.22523,lon:16.33620},
  {id:'a0993',plz:'1050',strasse:'Ramperstorffergasse',hnr:'68',titel:'Dr.',name:'Julia Pfanner',lat:48.19027,lon:16.35519},
  {id:'a0995',plz:'1010',strasse:'Schellinggasse',hnr:'5/4',titel:'Dr.',name:'Bruno Pfeiffer',lat:48.20348,lon:16.37422},
  {id:'a0996',plz:'1120',strasse:'Meidlinger Hauptstraße 7-9 / 1 /',hnr:'1',titel:'Dr.',name:'Georg Pfeiffer',lat:48.17891,lon:16.32996},
  {id:'a0997',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'Dr.',name:'Theresa Pfisterer',lat:48.22664,lon:16.35181},
  {id:'a0998',plz:'1130',strasse:'Fichtnergasse',hnr:'6',titel:'Dr.',name:'Jutta Pflüger',lat:48.18531,lon:16.28819},
  {id:'a0999',plz:'1180',strasse:'Gertrudplatz',hnr:'7/14',titel:'Dr.',name:'Joachim Pfusterschmied',lat:48.22591,lon:16.34486},
  {id:'a1001',plz:'1010',strasse:'Bösendorferstraße',hnr:'4/3/15',titel:'Dr.',name:'Georg Piehslinger',lat:48.20105,lon:16.37183},
  {id:'a1002',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'DDr.',name:'Eva Piehslinger',lat:48.21955,lon:16.35453},
  {id:'a1003',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr..',name:'Markus Edwin Pifl',lat:48.21955,lon:16.35453},
  {id:'a1005',plz:'1030',strasse:'Kolonitzgasse',hnr:'6/5',titel:'Dr.',name:'Tomasz Pilus',lat:48.21040,lon:16.38756},
  {id:'a1006',plz:'1140',strasse:'Linzer Straße 408 /',hnr:'I',titel:'Dr.',name:'Wjaczeslaw Pinchasov',lat:48.20347,lon:16.24275},
  {id:'a1007',plz:'1230',strasse:'Breitenfurter Straße 360-368 / 1 /',hnr:'1',titel:'Dr.',name:'Kristina Pinkel',lat:48.13593,lon:16.28220},
  {id:'a1009',plz:'1180',strasse:'Währinger Straße 138 /',hnr:'14',titel:'DDr.',name:'Andreas Pinter',lat:48.22525,lon:16.34845},
  {id:'a1010',plz:'1060',strasse:'Stiegengasse 7 / 2 /',hnr:'7',titel:'Dr.',name:'Claudia Mercedes Pinter',lat:48.19870,lon:16.35700},
  {id:'a1011',plz:'1030',strasse:'Kolonitzgasse',hnr:'6/5',titel:'DDr.',name:'Anna Piotrowski',lat:48.21040,lon:16.38756},
  {id:'a1012',plz:'1120',strasse:'Gierstergasse',hnr:'11',titel:'Prim. Dr.',name:'Josef Piribauer',lat:48.18326,lon:16.33491},
  {id:'a1015',plz:'1040',strasse:'Mommsengasse',hnr:'28',titel:'Dr.',name:'Bogdana Pirker-Lutsyuk',lat:48.18858,lon:16.37861},
  {id:'a1016',plz:'1050',strasse:'Wiedner Hauptstraße',hnr:'81',titel:'Dr.',name:'Wolfgang Pirko',lat:48.18769,lon:16.36461},
  {id:'a1017',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'Dr.',name:'Bahar Pishan',lat:48.22664,lon:16.35181},
  {id:'a1019',plz:'1220',strasse:'Arakawastraße',hnr:'6/2/4',titel:'Dr.',name:'Tobias Pletz',lat:48.24839,lon:16.42885},
  {id:'a1020',plz:'1030',strasse:'Strohgasse',hnr:'28',titel:'Dr.',name:'Claudia Plössnig-Oberleitner',lat:48.19845,lon:16.37864},
  {id:'a1021',plz:'1130',strasse:'Hietzinger Hauptstraße',hnr:'147',titel:'Dr.',name:'Ulrike Pöll',lat:48.18779,lon:16.26779},
  {id:'a1022',plz:'1120',strasse:'Bischoffgasse',hnr:'23',titel:'Dr. med. univ. Dr. med. dent.',name:'Birgit Podesser',lat:48.18120,lon:16.32182},
  {id:'a1023',plz:'1130',strasse:'Novalisgasse',hnr:'7',titel:'Dr.',name:'Wolfgang Paul Pöschl',lat:48.17771,lon:16.26578},
  {id:'a1025',plz:'1090',strasse:'Rögergasse',hnr:'32/1-3',titel:'Dr.',name:'Svitlana Pokornik',lat:48.22491,lon:16.36532},
  {id:'a1028',plz:'1200',strasse:'Jägerstraße',hnr:'30/10',titel:'Priv.-Doz. Dr.',name:'Bernhard Pommer',lat:48.23141,lon:16.37061},
  {id:'a1029',plz:'1090',strasse:'Augasse',hnr:'13/7',titel:'Dr.',name:'Madalina Ioana Popa-Tuns',lat:48.23129,lon:16.35698},
  {id:'a1030',plz:'1220',strasse:'Ilse Arlt Straße',hnr:'6/27',titel:'Dr.',name:'Adriana Popescu',lat:48.22672,lon:16.50102},
  {id:'a1031',plz:'1060',strasse:'Mariahilferstraße',hnr:'81/1/9',titel:'Dr.',name:'Diana Nicoleta Popescu',lat:48.19889,lon:16.35152},
  {id:'a1032',plz:'1100',strasse:'Favoritenstraße',hnr:'106/6',titel:'Dr.',name:'Dragana Popovic',lat:48.14943,lon:16.38236},
  {id:'a1033',plz:'1100',strasse:'Neilreichgasse',hnr:'47/1',titel:'Dr.',name:'Aida Popovic-Knezevic',lat:48.16901,lon:16.36423},
  {id:'a1034',plz:'1060',strasse:'Linke Wienzeile',hnr:'48-52',titel:'Dr.',name:'Alexander Popp',lat:48.19729,lon:16.35759},
  {id:'a1036',plz:'1090',strasse:'Alser Straße',hnr:'8/5',titel:'Prim. Univ.-Prof. MR DDr.',name:'Hubert Porteder',lat:48.21525,lon:16.34862},
  {id:'a1037',plz:'1090',strasse:'Alser Straße',hnr:'8',titel:'Dr.',name:'Harald Porteder',lat:48.21516,lon:16.35043},
  {id:'a1039',plz:'1090',strasse:'Widerhofergasse',hnr:'5/7',titel:'Dr.',name:'Ingrid Postl-Winkler',lat:48.22322,lon:16.35456},
  {id:'a1041',plz:'1210',strasse:'Achengasse',hnr:'1/14',titel:'DDr.',name:'Andreas Potyka',lat:48.28391,lon:16.45381},
  {id:'a1042',plz:'1220',strasse:'Zschokkegasse',hnr:'140',titel:'Dr.',name:'Niloufar Pour Sadeghian',lat:48.22002,lon:16.46409},
  {id:'a1043',plz:'1140',strasse:'Hütteldorfer Straße',hnr:'135/48',titel:'DDr.',name:'Marion Pourebrahim',lat:48.19761,lon:16.29867},
  {id:'a1045',plz:'1230',strasse:'Breitenfurter Straße 360-368 / 2 /',hnr:'3',titel:'Dr. med. dent.',name:'Birgit Praschniker',lat:48.13600,lon:16.28201},
  {id:'a1046',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Maria Preissnecker',lat:48.21955,lon:16.35453},
  {id:'a1049',plz:'1020',strasse:'Praterstraße',hnr:'66',titel:'Dr.',name:'Friedrich Prodinger',lat:48.21646,lon:16.38853},
  {id:'a1050',plz:'1080',strasse:'Josefstädter Straße',hnr:'66',titel:'ZA',name:'Aristotelis Prountzos',lat:48.21074,lon:16.34378},
  {id:'a1051',plz:'1100',strasse:'Laxenburger Straße',hnr:'12',titel:'Dr.',name:'Ewa Ptaszynska',lat:48.18052,lon:16.37356},
  {id:'a1052',plz:'1100',strasse:'Knöllgasse',hnr:'49/51',titel:'Dr.',name:'Lucja Ptaszynska',lat:48.17201,lon:16.35360},
  {id:'a1054',plz:'1160',strasse:'Neulerchenfelder Straße',hnr:'21/4',titel:'Dr.',name:'Ursula Puchstein',lat:48.21096,lon:16.33700},
  {id:'a1055',plz:'1130',strasse:'Schweizertalstraße',hnr:'6/3',titel:'Dr.',name:'Ehrentraud Püribauer',lat:48.18733,lon:16.26506},
  {id:'a1056',plz:'1140',strasse:'Nisselgasse',hnr:'1-3/3',titel:'Dr.',name:'Werner Püringer',lat:48.18849,lon:16.30386},
  {id:'a1057',plz:'1040',strasse:'Mayerhofgasse',hnr:'12',titel:'Dr.',name:'Susanne Pultar',lat:48.19273,lon:16.36890},
  {id:'a1058',plz:'1150',strasse:'Goldschlagstraße',hnr:'110/9',titel:'Dr.',name:'Punzenberger Lena',lat:48.19449,lon:16.31687},
  {id:'a1059',plz:'1090',strasse:'Kinderspitalgasse',hnr:'1/6',titel:'Dr.',name:'Sophie-Beatrix Pur',lat:48.21574,lon:16.34469},
  {id:'a1060',plz:'1180',strasse:'Währinger Straße',hnr:'120',titel:'DDr.',name:'Michael Puschmann',lat:48.22661,lon:16.34332},
  {id:'a1061',plz:'1180',strasse:'Währinger Straße',hnr:'120',titel:'DDr.',name:'Susanne Puschmann',lat:48.22661,lon:16.34332},
  {id:'a1062',plz:'1050',strasse:'Ramperstorffergasse',hnr:'68',titel:'Dr.',name:'Maximilian Putz',lat:48.19027,lon:16.35519},
  {id:'a1063',plz:'1010',strasse:'Werdertorgasse',hnr:'15',titel:'Dr. med. dent.',name:'Andreas Quidenus',lat:48.21554,lon:16.37095},
  {id:'a1066',plz:'1100',strasse:'Senefeldergasse',hnr:'49/7',titel:'Dr.',name:'Gerd Raabe',lat:48.17396,lon:16.37534},
  {id:'a1067',plz:'1080',strasse:'Lerchenfelder Straße',hnr:'36/5',titel:'Dr.',name:'Victoria Anna Rachle',lat:48.20652,lon:16.34860},
  {id:'a1069',plz:'1120',strasse:'Malfattigasse',hnr:'1/1/8',titel:'Dr.',name:'Jasna Radiskovic',lat:48.18096,lon:16.34135},
  {id:'a1070',plz:'1090',strasse:'Kinderspitalgasse',hnr:'1/6',titel:'DDDr.',name:'Rainer Raimann',lat:48.21574,lon:16.34469},
  {id:'a1071',plz:'1040',strasse:'Viktorgasse',hnr:'25/8',titel:'MR Dr.',name:'Klaus Rainer',lat:48.18916,lon:16.37433},
  {id:'a1072',plz:'1060',strasse:'Stumpergasse',hnr:'61/13',titel:'Dr.',name:'Emira Ramadani',lat:48.19367,lon:16.34479},
  {id:'a1073',plz:'1160',strasse:'Thaliastraße',hnr:'42/9',titel:'Dr.',name:'Katharina Rambousek-Sperl',lat:48.21265,lon:16.31184},
  {id:'a1074',plz:'1050',strasse:'Franzensgasse',hnr:'22/8',titel:'Dr.',name:'Gabriele Rameis',lat:48.19539,lon:16.35917},
  {id:'a1075',plz:'1170',strasse:'Oberwiedenstraße',hnr:'15',titel:'Dr.',name:'Andrea Ramisch-Breinössl',lat:48.22626,lon:16.29905},
  {id:'a1076',plz:'1080',strasse:'Josefstädter Straße',hnr:'66/17',titel:'Dr.',name:'Lorenz Michael Ramsauer',lat:48.21039,lon:16.34501},
  {id:'a1078',plz:'1130',strasse:'Speisinger Straße',hnr:'46-48',titel:'Dr.',name:'Azadeh Raouf',lat:48.16949,lon:16.28489},
  {id:'a1080',plz:'1120',strasse:'Altmannsdorfer Straße',hnr:'76/12/12',titel:'Dr.',name:'Daniela Ratschew',lat:48.16616,lon:16.31605},
  {id:'a1081',plz:'1120',strasse:'Schönbrunner Allee',hnr:'11/7',titel:'DDr.',name:'Claudius Ratschew',lat:48.17451,lon:16.31324},
  {id:'a1082',plz:'1010',strasse:'Singerstraße',hnr:'11/9',titel:'Dr.',name:'Gerhard Ratzenberger',lat:48.20626,lon:16.37628},
  {id:'a1083',plz:'1090',strasse:'Liechtensteinstraße',hnr:'90/27',titel:'Dr.',name:'Marco Aoqi Rausch',lat:48.22711,lon:16.35640},
  {id:'a1086',plz:'1090',strasse:'Liechtensteinstraße',hnr:'46/3',titel:'Mag.',name:'Dimitar Raynov',lat:48.22860,lon:16.35612},
  {id:'a1087',plz:'1230',strasse:'Breitenfurter Straße 360-368 / 1 /',hnr:'1',titel:'Dr.',name:'Kerstin Beate Rech',lat:48.13593,lon:16.28220},
  {id:'a1088',plz:'1210',strasse:'Brünner Straße',hnr:'238',titel:'Dr.',name:'Sascha Rechinger',lat:48.29372,lon:16.41967},
  {id:'a1089',plz:'1140',strasse:'Seckendorfstraße',hnr:'1',titel:'Dr.',name:'Sanimeda Redzepovic',lat:48.19733,lon:16.28700},
  {id:'a1090',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Mladen Regoda',lat:48.21955,lon:16.35453},
  {id:'a1093',plz:'1160',strasse:'Schuhmeierplatz',hnr:'14',titel:'Dr. med. dent.',name:'Barbara Reichelt',lat:48.21166,lon:16.31913},
  {id:'a1094',plz:'1030',strasse:'Zaunergasse',hnr:'16',titel:'Dr.',name:'Peter Hans Reichenbach',lat:48.19890,lon:16.38007},
  {id:'a1095',plz:'1090',strasse:'Liechtensteinstraße',hnr:'21/8',titel:'Dr.',name:'Peter Reichenbach',lat:48.22711,lon:16.35640},
  {id:'a1096',plz:'1090',strasse:'Nußdorfer Straße',hnr:'14/12a',titel:'Dr. med. dent.',name:'Georg Reichenberg',lat:48.22538,lon:16.35485},
  {id:'a1097',plz:'1140',strasse:'Breitenseer Straße',hnr:'13',titel:'Dr.',name:'Johann Max Reichsthaler',lat:48.20264,lon:16.29433},
  {id:'a1098',plz:'1140',strasse:'Breitenseer Straße',hnr:'13',titel:'Dr.',name:'Cordula Reichsthaler',lat:48.20264,lon:16.29433},
  {id:'a1100',plz:'1050',strasse:'Ramperstorffergasse',hnr:'66',titel:'Dr.',name:'Barbara Reimer',lat:48.18999,lon:16.35540},
  {id:'a1101',plz:'1050',strasse:'Ramperstorffergasse',hnr:'68',titel:'',name:'Linda Reimers',lat:48.19027,lon:16.35519},
  {id:'a1102',plz:'1230',strasse:'Liesinger Platz',hnr:'1/52',titel:'Dr.',name:'Walter Reisinger',lat:48.13483,lon:16.28326},
  {id:'a1103',plz:'1090',strasse:'Rooseveltplatz',hnr:'12/3',titel:'Dr.',name:'Bärbl Reistenhofer',lat:48.21589,lon:16.35810},
  {id:'a1104',plz:'1090',strasse:'Rooseveltplatz',hnr:'12/3',titel:'Dr. med. univ.',name:'Oliver Reistenhofer',lat:48.21589,lon:16.35810},
  {id:'a1105',plz:'1060',strasse:'Getreidemarkt',hnr:'17/3',titel:'DDr',name:'Alexandra Reiterer',lat:48.20213,lon:16.36210},
  {id:'a1106',plz:'1220',strasse:'Bellegardegasse',hnr:'24',titel:'Dr.',name:'Marija Reiter-Vasilcin',lat:48.22755,lon:16.42255},
  {id:'a1107',plz:'1100',strasse:'Wienerbergstraße',hnr:'13',titel:'Dr.',name:'Hannah Reitter',lat:48.16919,lon:16.34527},
  {id:'a1108',plz:'1040',strasse:'Südtiroler Platz',hnr:'5',titel:'',name:'Sheyla Marcia Repolusk',lat:48.18707,lon:16.37311},
  {id:'a1109',plz:'1050',strasse:'Ramperstorffergasse',hnr:'68',titel:'Dr.',name:'Claudia-Luminita Revnic',lat:48.19027,lon:16.35519},
  {id:'a1110',plz:'1130',strasse:'Lainzer Straße',hnr:'164',titel:'Dr.',name:'Lundrim Rexhepi',lat:48.17473,lon:16.28405},
  {id:'a1111',plz:'1050',strasse:'Grüngasse',hnr:'26/4-5',titel:'Dr.',name:'Amin Rezakhani',lat:48.19473,lon:16.35763},
  {id:'a1113',plz:'1030',strasse:'Erdbergstraße 202',hnr:'E7a',titel:'Dr.',name:'Kerim Ribic',lat:48.19027,lon:16.41417},
  {id:'a1114',plz:'1020',strasse:'Josefinengasse',hnr:'5/14',titel:'Dr.',name:'Serge Ricart',lat:48.22102,lon:16.38280},
  {id:'a1116',plz:'1120',strasse:'Theresienbadgasse',hnr:'4/3',titel:'Dr.',name:'Lucia Rieder',lat:48.18260,lon:16.32834},
  {id:'a1117',plz:'1170',strasse:'Alszeile',hnr:'34/2/3',titel:'Dr.',name:'Günther Riefler',lat:48.22902,lon:16.30360},
  {id:'a1120',plz:'1030',strasse:'Lorbeergasse',hnr:'15',titel:'Dr.',name:'Ronald Ringl',lat:48.20907,lon:16.39039},
  {id:'a1121',plz:'1050',strasse:'Reinprechtsdorfer Straße',hnr:'53/4',titel:'Dr.',name:'Sibylle Rodlauer-Kuntzl',lat:48.18419,lon:16.35552},
  {id:'a1122',plz:'1120',strasse:'Koppreitergasse',hnr:'4/17',titel:'Dr.',name:'Snezhina Rodríguez - Mustelier',lat:48.17453,lon:16.32763},
  {id:'a1123',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Katharina Sabine Röggla',lat:48.21955,lon:16.35453},
  {id:'a1125',plz:'1170',strasse:'Rhigasgasse',hnr:'8',titel:'Dr.',name:'Caroline Rollé',lat:48.22301,lon:16.32311},
  {id:'a1127',plz:'1180',strasse:'Herbeckstraße',hnr:'67/5',titel:'Dr.',name:'Marius Joahnnes Romanin',lat:48.23136,lon:16.32668},
  {id:'a1129',plz:'1030',strasse:'Salesianergasse',hnr:'4/3',titel:'Dr.',name:'Roxana-Otilia Rominu',lat:48.20072,lon:16.38073},
  {id:'a1130',plz:'1010',strasse:'Rudolfsplatz',hnr:'14',titel:'DDr',name:'Franz Ronay',lat:48.21442,lon:16.37092},
  {id:'a1131',plz:'1010',strasse:'Rudolfsplatz',hnr:'14',titel:'Dr.',name:'Caroline Ronay-Reisetbauer',lat:48.21442,lon:16.37092},
  {id:'a1132',plz:'1100',strasse:'Ada Christen Gasse',hnr:'2a/10',titel:'DDr.',name:'Christian Ronge',lat:48.14636,lon:16.38633},
  {id:'a1133',plz:'1110',strasse:'Simmeringer Platz',hnr:'1/5+6',titel:'Dr. med. dent.',name:'Robert Rosa',lat:48.16935,lon:16.41985},
  {id:'a1134',plz:'1190',strasse:'Grinzinger Straße',hnr:'70',titel:'DDr.',name:'Christine Roser-Podlesak',lat:48.25360,lon:16.35371},
  {id:'a1136',plz:'1130',strasse:'Joseph Lister Gasse 31a',hnr:'8',titel:'Dr.',name:'Amir Naser Rostamzadeh',lat:48.17506,lon:16.26841},
  {id:'a1137',plz:'1010',strasse:'Seilergasse',hnr:'4',titel:'Dr.',name:'Charlotte Rothensteiner-Richter',lat:48.20761,lon:16.37090},
  {id:'a1138',plz:'1010',strasse:'Rudolfsplatz',hnr:'10/11',titel:'Dr.',name:'Rebekka Rifka Rubin',lat:48.21441,lon:16.37228},
  {id:'a1139',plz:'1230',strasse:'Anton Baumgartner Straße',hnr:'44',titel:'Dr.',name:'Ingo Ruckelshausen',lat:48.15123,lon:16.31220},
  {id:'a1140',plz:'1140',strasse:'Waidhausenstraße',hnr:'11',titel:'Dr.',name:'Alwina Ruckelshausen',lat:48.19678,lon:16.28055},
  {id:'a1141',plz:'1020',strasse:'Taborstraße',hnr:'62',titel:'Dr. med. dent.',name:'Lukas Rudolf',lat:48.22251,lon:16.38269},
  {id:'a1142',plz:'1020',strasse:'Taborstraße',hnr:'62',titel:'Dr.',name:'Christine Rudolf',lat:48.22251,lon:16.38269},
  {id:'a1143',plz:'1010',strasse:'Schwedenplatz',hnr:'2/2/17',titel:'Dr. med. dent.',name:'Britta Elisabeth Rüscher',lat:48.21136,lon:16.37900},
  {id:'a1144',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'Dr.',name:'Julija Rul',lat:48.19748,lon:16.34833},
  {id:'a1145',plz:'1040',strasse:'Favoritenstraße',hnr:'44/6',titel:'Dr. med. dent.',name:'Florian Rummer',lat:48.19599,lon:16.36867},
  {id:'a1149',plz:'1080',strasse:'Piaristengasse',hnr:'56/58',titel:'DDr.',name:'Abdul Salam Safar',lat:48.21115,lon:16.35036},
  {id:'a1151',plz:'1100',strasse:'Keplergasse',hnr:'7/4',titel:'Dr.',name:'Agnes Gabriella Salamon',lat:48.17916,lon:16.37601},
  {id:'a1155',plz:'1090',strasse:'Boltzmanngasse',hnr:'12/2',titel:'DDr.',name:'Alexander Saletu',lat:48.22416,lon:16.35652},
  {id:'a1156',plz:'1090',strasse:'Boltzmanngasse',hnr:'12/2',titel:'DDr.',name:'Franziska Saletu',lat:48.22416,lon:16.35652},
  {id:'a1157',plz:'1220',strasse:'Karl Bednarik Gasse',hnr:'49',titel:'Dr.',name:'Fatin Salmen',lat:48.24407,lon:16.48745},
  {id:'a1158',plz:'1230',strasse:'Perchtoldsdorfer Straße',hnr:'19',titel:'DDr.',name:'Ulrike Salmen',lat:48.13266,lon:16.28173},
  {id:'a1159',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'Dr.',name:'Tammam Salti',lat:48.19748,lon:16.34833},
  {id:'a1160',plz:'1080',strasse:'Laudongasse',hnr:'38',titel:'Dr. med. dent.',name:'Tania Samouh',lat:48.21319,lon:16.34573},
  {id:'a1162',plz:'1070',strasse:'Burggasse',hnr:'115/16',titel:'Dr.',name:'Olga San Nicolo',lat:48.20433,lon:16.34143},
  {id:'a1163',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'Dr.',name:'Saied Sanaei',lat:48.19748,lon:16.34833},
  {id:'a1164',plz:'1130',strasse:'Auhofstraße',hnr:'31',titel:'Dr.',name:'Eugen Sander',lat:48.18900,lon:16.28756},
  {id:'a1165',plz:'1180',strasse:'Währinger Straße',hnr:'140/5',titel:'Dr.',name:'Robert Daniel Santi',lat:48.23025,lon:16.32913},
  {id:'a1168',plz:'1010',strasse:'Schottengasse',hnr:'4/34',titel:'DDr.',name:'Oliwer Sas',lat:48.21352,lon:16.36295},
  {id:'a1169',plz:'1120',strasse:'Steinbauergasse',hnr:'15',titel:'Dr.',name:'Katharina Sas',lat:48.18296,lon:16.34309},
  {id:'a1170',plz:'1190',strasse:'Nußdorfer Lände',hnr:'43/79',titel:'Dr.',name:'Damjan Savic',lat:48.24720,lon:16.36917},
  {id:'a1171',plz:'1030',strasse:'Neulinggasse',hnr:'23/4',titel:'Dr.',name:'Alexander Sawaljanow',lat:48.19908,lon:16.38634},
  {id:'a1172',plz:'1180',strasse:'Gertrudplatz',hnr:'5/37',titel:'Dr.',name:'Sophia Maria Schaar',lat:48.22591,lon:16.34486},
  {id:'a1173',plz:'1030',strasse:'Strohgasse',hnr:'28',titel:'Dr.',name:'Moritz Schachermayr',lat:48.19845,lon:16.37864},
  {id:'a1175',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Hans-Peter Alexander Schäfer',lat:48.21955,lon:16.35453},
  {id:'a1176',plz:'1140',strasse:'Einwanggasse',hnr:'25/5',titel:'MR Dr. med. univ.',name:'Gerhard Schager',lat:48.19083,lon:16.30178},
  {id:'a1177',plz:'1140',strasse:'Einwanggasse',hnr:'25/5',titel:'Dr.',name:'Verena Schager',lat:48.19083,lon:16.30178},
  {id:'a1178',plz:'1220',strasse:'Steigenteschgasse',hnr:'2/5/2',titel:'Dr.',name:'Lydia Schalberger',lat:48.24628,lon:16.43741},
  {id:'a1179',plz:'1220',strasse:'Wagramer Straße',hnr:'25/1/9',titel:'Ddr.',name:'Sabine Schanzer',lat:48.24614,lon:16.43976},
  {id:'a1180',plz:'1190',strasse:'Heiligenstädter Straße',hnr:'9',titel:'Dr.',name:'Michaela Scharnagl-Lesnik',lat:48.23260,lon:16.35534},
  {id:'a1181',plz:'1190',strasse:'Friedlgasse',hnr:'49/5',titel:'Dr.',name:'Johann Schatz',lat:48.24383,lon:16.34064},
  {id:'a1182',plz:'1190',strasse:'Rudolfinergasse',hnr:'1/1',titel:'DDr.',name:'Katharina Schatz',lat:48.24424,lon:16.34729},
  {id:'a1184',plz:'1020',strasse:'Tempelgasse',hnr:'5/1+2',titel:'Univ.-Prof. DDr.',name:'Andreas Schedle',lat:48.21457,lon:16.38452},
  {id:'a1187',plz:'1140',strasse:'Einwanggasse',hnr:'21/1/4',titel:'Mag. Dr.',name:'Andrea Schiebel-Gassner',lat:48.19416,lon:16.30202},
  {id:'a1190',plz:'1030',strasse:'Reisnerstraße',hnr:'28/3',titel:'Dr.',name:'Cornelia Schintlmeister',lat:48.19641,lon:16.38370},
  {id:'a1193',plz:'1120',strasse:'Wienerbergstraße',hnr:'34/5',titel:'Dr.',name:'Peter Schlinke',lat:48.17157,lon:16.33159},
  {id:'a1194',plz:'1120',strasse:'Wienerbergstraße',hnr:'34/5',titel:'Dr.',name:'Ingeborg Schlinke',lat:48.17157,lon:16.33159},
  {id:'a1195',plz:'1220',strasse:'Langobardenstraße',hnr:'122',titel:'Dr.',name:'Katrin Schlögl-Klebermass',lat:48.21931,lon:16.46448},
  {id:'a1196',plz:'1010',strasse:'Johannesgasse',hnr:'15',titel:'Dr.',name:'Wolfgang Schlossarek',lat:48.20473,lon:16.37348},
  {id:'a1197',plz:'1090',strasse:'Fuchsthallergasse',hnr:'2/11',titel:'Dr.',name:'Gabriele Schmidbauer-Schuster',lat:48.22473,lon:16.35197},
  {id:'a1198',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'DDr.',name:'Martina Schmid-Schwap',lat:48.21955,lon:16.35453},
  {id:'a1199',plz:'1110',strasse:'Herbortgasse',hnr:'22',titel:'DDr.',name:'Birgit Schmidt',lat:48.17140,lon:16.41095},
  {id:'a1200',plz:'1210',strasse:'Am Spitz',hnr:'3/2',titel:'DDr.',name:'Thomas Schmidt',lat:48.25820,lon:16.39791},
  {id:'a1201',plz:'1210',strasse:'Am Spitz',hnr:'3/2',titel:'Mag. DDr.',name:'Sylvia Schmidt-Lueger',lat:48.25820,lon:16.39791},
  {id:'a1202',plz:'1190',strasse:'Kreindlgasse',hnr:'13/2a',titel:'Dr.',name:'Wolfgang Schmied',lat:48.23798,lon:16.35163},
  {id:'a1203',plz:'1160',strasse:'Maroltingergasse',hnr:'52/2/3',titel:'Univ. Ass. DDr.',name:'Christoph Schmölzer',lat:48.20939,lon:16.30527},
  {id:'a1204',plz:'1220',strasse:'Schenk Danzinger Gasse',hnr:'3/1',titel:'Dr. med. univ. Dr. med. dent.',name:'Thomas Schmuth',lat:48.22465,lon:16.50099},
  {id:'a1206',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'Dr.',name:'Martina Schnabl',lat:48.22664,lon:16.35181},
  {id:'a1207',plz:'1030',strasse:'Schlachthausgasse',hnr:'20',titel:'Dr. med. dent.',name:'Christian Schneider',lat:48.19504,lon:16.40730},
  {id:'a1211',plz:'1080',strasse:'Josefstädter Straße',hnr:'80',titel:'Dr.',name:'Katharina Schneider-Trost',lat:48.21134,lon:16.34074},
  {id:'a1212',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'Dr.',name:'Benedikt Schober',lat:48.19748,lon:16.34833},
  {id:'a1213',plz:'1010',strasse:'Mahlerstraße',hnr:'11/9',titel:'Dr.',name:'Christian Schober',lat:48.20240,lon:16.37294},
  {id:'a1214',plz:'1010',strasse:'Mahlerstraße',hnr:'11/9',titel:'Dr.',name:'Gabriele Schober',lat:48.20240,lon:16.37294},
  {id:'a1215',plz:'1080',strasse:'Josefstädter Straße',hnr:'80',titel:'Dr.',name:'Theresa Schober',lat:48.21134,lon:16.34074},
  {id:'a1217',plz:'1090',strasse:'Liechtensteinstraße',hnr:'22/4/2',titel:'Dr.',name:'Melanie Schöller',lat:48.21904,lon:16.36234},
  {id:'a1220',plz:'1180',strasse:'Schumanngasse',hnr:'46/3',titel:'Dr.',name:'Lena Schönberger',lat:48.22118,lon:16.33811},
  {id:'a1221',plz:'1190',strasse:'Döblinger Hauptstraße',hnr:'7/11',titel:'DDr.',name:'Roland Scholz',lat:48.23387,lon:16.35271},
  {id:'a1222',plz:'1010',strasse:'Renngasse',hnr:'15',titel:'Dr.',name:'Klaus Scholz',lat:48.21372,lon:16.36825},
  {id:'a1223',plz:'1100',strasse:'Wienerbergstraße',hnr:'13',titel:'Dr.',name:'Bernhard Schopper',lat:48.16919,lon:16.34527},
  {id:'a1224',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'DDr.',name:'Christian Schopper',lat:48.22664,lon:16.35181},
  {id:'a1225',plz:'1140',strasse:'Hütteldorfer Straße',hnr:'247/',titel:'Dr.',name:'Ronald Christian Schors',lat:48.19672,lon:16.28891},
  {id:'a1227',plz:'1180',strasse:'Aumannplatz',hnr:'2',titel:'DDr.',name:'Christian Schraml',lat:48.22867,lon:16.33484},
  {id:'a1228',plz:'1060',strasse:'Stumpergasse',hnr:'40',titel:'Dr.',name:'Bettina Schreder',lat:48.19417,lon:16.34436},
  {id:'a1231',plz:'1160',strasse:'Gallitzinstraße',hnr:'78a',titel:'Dr.',name:'Barbara Schreiner-Tiefenbacher',lat:48.21576,lon:16.29010},
  {id:'a1232',plz:'1100',strasse:'Wienerbergstraße',hnr:'13',titel:'Dr.',name:'Kurt Schreitmüller',lat:48.16919,lon:16.34527},
  {id:'a1235',plz:'1120',strasse:'Wilhelmstraße',hnr:'1c/2/5',titel:'Dr. dent.',name:'Annamaria Schuderne',lat:48.17659,lon:16.33422},
  {id:'a1236',plz:'1050',strasse:'Ramperstorffergasse',hnr:'68',titel:'DDr.',name:'Eric Daniel Schulz',lat:48.19027,lon:16.35519},
  {id:'a1237',plz:'1020',strasse:'Ennsgasse',hnr:'5',titel:'Dr.',name:'Verena Schulze Grotthoff',lat:48.22165,lon:16.40089},
  {id:'a1238',plz:'1140',strasse:'Hütteldorfer Straße 130C / 4 /',hnr:'L11',titel:'Dr.',name:'Günther Schuster',lat:48.19765,lon:16.29757},
  {id:'a1240',plz:'1050',strasse:'Ramperstorffergasse',hnr:'68',titel:'Dr.',name:'Daniel Schwabl',lat:48.19027,lon:16.35519},
  {id:'a1241',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Alexander Joahnnes Schwärzler',lat:48.21955,lon:16.35453},
  {id:'a1242',plz:'1090',strasse:'Liechtensteinstraße',hnr:'8',titel:'Dr.',name:'Karl Schwaninger',lat:48.21677,lon:16.36307},
  {id:'a1243',plz:'1210',strasse:'Brünner Straße',hnr:'188/7',titel:'Dr.',name:'Marcus Schwarz',lat:48.30357,lon:16.42414},
  {id:'a1244',plz:'1020',strasse:'Taborstraße',hnr:'76/3',titel:'Dr.',name:'Axel Schwehr',lat:48.22803,lon:16.39024},
  {id:'a1245',plz:'1020',strasse:'Taborstraße',hnr:'76/3',titel:'Dr.',name:'Anca Schwehr',lat:48.22803,lon:16.39024},
  {id:'a1246',plz:'1090',strasse:'Frankgasse',hnr:'1',titel:'Dr.',name:'Johannes Schweigreiter',lat:48.21536,lon:16.35725},
  {id:'a1247',plz:'1200',strasse:'Leystraße',hnr:'41/1/4',titel:'Dr.',name:'Birgitta Schwinner',lat:48.24690,lon:16.37495},
  {id:'a1249',plz:'1150',strasse:'Mariahilfer Straße 167 /',hnr:'10',titel:'DDr.',name:'Wolfgang Seemann',lat:48.19538,lon:16.33825},
  {id:'a1250',plz:'1080',strasse:'Lange Gasse',hnr:'72/10',titel:'Dr.',name:'Irene Seemann',lat:48.21123,lon:16.35162},
  {id:'a1251',plz:'1190',strasse:'Lannerstraße',hnr:'23/5',titel:'OMR Dr.',name:'Otmar Seemann',lat:48.23593,lon:16.34502},
  {id:'a1253',plz:'1090',strasse:'Sobieskigasse',hnr:'29',titel:'DDr.',name:'Maximilian Seemann',lat:48.22925,lon:16.35347},
  {id:'a1254',plz:'1100',strasse:'Pernerstorfergasse',hnr:'25/16',titel:'Mag. DDr.',name:'Monika Seitz',lat:48.17609,lon:16.38154},
  {id:'a1256',plz:'1030',strasse:'Marokkanergasse',hnr:'25/1/7',titel:'Dr.',name:'Eva Selli',lat:48.19801,lon:16.38042},
  {id:'a1257',plz:'1090',strasse:'Berggasse',hnr:'25/18',titel:'Prim. Dr.',name:'Edmond Selli',lat:48.21907,lon:16.36519},
  {id:'a1258',plz:'1080',strasse:'Piaristengasse',hnr:'46/12',titel:'Dr.',name:'Monika Semelmayer',lat:48.20754,lon:16.35105},
  {id:'a1260',plz:'1020',strasse:'Leopoldsgasse',hnr:'29/17',titel:'Dr.',name:'Hanno Senger',lat:48.21865,lon:16.37709},
  {id:'a1261',plz:'1010',strasse:'Wallnerstraße',hnr:'2/1/8',titel:'Dr.',name:'Michael Serek',lat:48.21001,lon:16.36630},
  {id:'a1262',plz:'1010',strasse:'Wallnerstraße',hnr:'2/1/8',titel:'Dr.',name:'Otto Serek',lat:48.21001,lon:16.36630},
  {id:'a1263',plz:'1180',strasse:'Schopenhauerstraße',hnr:'28/2',titel:'Dr.',name:'Heide Seyss-Windischbauer',lat:48.22361,lon:16.34799},
  {id:'a1264',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'Dr.',name:'Pegah Shahbazi',lat:48.19748,lon:16.34833},
  {id:'a1265',plz:'1160',strasse:'Wattgasse',hnr:'63',titel:'Dr.',name:'Ragheed Shamoon',lat:48.22018,lon:16.32061},
  {id:'a1266',plz:'1200',strasse:'Dammstraße',hnr:'8/11',titel:'Mag.',name:'Benjamin Shamuilov',lat:48.23475,lon:16.37434},
  {id:'a1267',plz:'1100',strasse:'Herzgasse',hnr:'99/8/6',titel:'Mag.',name:'El-Nathan Shamuilov',lat:48.16882,lon:16.36558},
  {id:'a1268',plz:'1180',strasse:'Schumanngasse',hnr:'15/19',titel:'',name:'Oren Shani',lat:48.22118,lon:16.33811},
  {id:'a1269',plz:'1120',strasse:'Flurschützstraße',hnr:'23/1',titel:'Dr.',name:'Besnik Shemo',lat:48.18070,lon:16.34505},
  {id:'a1270',plz:'1220',strasse:'Zschokkegasse',hnr:'140',titel:'Dr.',name:'Jacqueline Shnawa',lat:48.22002,lon:16.46409},
  {id:'a1272',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'',name:'Srdan Sicar',lat:48.22664,lon:16.35181},
  {id:'a1273',plz:'1170',strasse:'Dornbacher Straße',hnr:'1',titel:'Dr.',name:'Ewa Siejka',lat:48.22629,lon:16.30730},
  {id:'a1275',plz:'1140',strasse:'Waidhausenstraße',hnr:'11',titel:'DDr.',name:'Silvia Marianne Silli',lat:48.19678,lon:16.28055},
  {id:'a1276',plz:'1060',strasse:'Stumpergasse',hnr:'45/1/6',titel:'Dr.',name:'Michael Silvar',lat:48.19538,lon:16.34288},
  {id:'a1277',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Jelena Simatovic',lat:48.21955,lon:16.35453},
  {id:'a1278',plz:'1070',strasse:'Neubaugasse',hnr:'11/10',titel:'Dr.',name:'Erwin Sindelar',lat:48.20082,lon:16.34911},
  {id:'a1279',plz:'1010',strasse:'Himmelpfortgasse',hnr:'17/10',titel:'Dr.',name:'Daniela Skiba',lat:48.20528,lon:16.37427},
  {id:'a1280',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'DDr.',name:'Astrid Martina Skolka',lat:48.21955,lon:16.35453},
  {id:'a1281',plz:'1010',strasse:'Opernring',hnr:'19/6',titel:'Dr. med. univ.',name:'Michaela Skrein',lat:48.20239,lon:16.36949},
  {id:'a1282',plz:'1060',strasse:'Mariahilfer Straße',hnr:'111/1/2',titel:'Dr.',name:'Bernhard Slavicek',lat:48.19598,lon:16.34024},
  {id:'a1283',plz:'1200',strasse:'Brigittenauer Lände',hnr:'156/5/2',titel:'DDr.',name:'Ellen Slezak',lat:48.22597,lon:16.36817},
  {id:'a1285',plz:'1030',strasse:'Wehleweg',hnr:'5/1',titel:'Dr.',name:'Veronika Smarikova',lat:48.19994,lon:16.40531},
  {id:'a1288',plz:'1120',strasse:'Otto Probst Straße',hnr:'25/13/3',titel:'Dr.',name:'Andreas Sobczyk',lat:48.15413,lon:16.34735},
  {id:'a1289',plz:'1090',strasse:'Roßauer Lände 23a /',hnr:'1',titel:'Dr.',name:'Gerda Söchting',lat:48.22371,lon:16.36713},
  {id:'a1290',plz:'1080',strasse:'Lange Gasse',hnr:'76/16',titel:'Univ.-Doz. DDr.',name:'Peter Solar',lat:48.21123,lon:16.35162},
  {id:'a1291',plz:'1010',strasse:'Lichtenfelsgasse',hnr:'1/5',titel:'DDr.',name:'Markus Clemens Sollinger',lat:48.21001,lon:16.35712},
  {id:'a1292',plz:'1010',strasse:'Zelinkagasse',hnr:'14',titel:'Dr.',name:'Michaela Sommer',lat:48.21660,lon:16.37054},
  {id:'a1293',plz:'1140',strasse:'Hütteldorfer Straße',hnr:'315/1',titel:'Dr. med. univ. Dr. med. dent.',name:'Rita Sommergut-Eberhardt',lat:48.19761,lon:16.29867},
  {id:'a1294',plz:'1190',strasse:'Döblinger Hauptstraße',hnr:'66/9',titel:'Dr. med. dent.',name:'Silke Spanlang',lat:48.23352,lon:16.35305},
  {id:'a1295',plz:'1040',strasse:'Rainergasse',hnr:'27/2/1',titel:'Dr.',name:'Ingrid Spata-Krauß',lat:48.18950,lon:16.37019},
  {id:'a1296',plz:'1020',strasse:'Taborstraße',hnr:'27/37',titel:'Dr.',name:'Doris Sperl',lat:48.21861,lon:16.38090},
  {id:'a1297',plz:'1020',strasse:'Taborstraße',hnr:'27/37',titel:'Dr.',name:'Michael Sperl',lat:48.21861,lon:16.38090},
  {id:'a1298',plz:'1080',strasse:'Piaristengasse',hnr:'41',titel:'Dr.',name:'Martina Sperr-Röckl',lat:48.20976,lon:16.35039},
  {id:'a1299',plz:'1030',strasse:'Rochusgasse',hnr:'2/19',titel:'Dr. med. dent.',name:'Ludwig Spusta',lat:48.20126,lon:16.38918},
  {id:'a1300',plz:'1150',strasse:'Winckelmannstraße',hnr:'2/9',titel:'Dr. med. dent.',name:'Bertly St. Clair Osorno',lat:48.18851,lon:16.32056},
  {id:'a1301',plz:'1190',strasse:'Huschkagasse',hnr:'15',titel:'Dr.',name:'Michaela Stadler Niedermeyer',lat:48.25211,lon:16.34607},
  {id:'a1302',plz:'1090',strasse:'Kolingasse',hnr:'17/3',titel:'Dr.',name:'Gerhard Stanek',lat:48.21574,lon:16.36235},
  {id:'a1303',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85-87',titel:'Dr.',name:'Peter Karl Stanek',lat:48.19748,lon:16.34833},
  {id:'a1305',plz:'1030',strasse:'Boerhaavegasse',hnr:'12/29',titel:'Dr.',name:'Sara Stanic',lat:48.19587,lon:16.39209},
  {id:'a1306',plz:'1230',strasse:'Breitenfurter Straße',hnr:'360-368/1/1',titel:'Dr.',name:'Fransziska Stanzl',lat:48.13593,lon:16.28220},
  {id:'a1307',plz:'1230',strasse:'Breitenfurter Straße',hnr:'360-368/1/1',titel:'Dr..',name:'Michael Stanzl',lat:48.13593,lon:16.28220},
  {id:'a1308',plz:'1160',strasse:'Richard Wagner Platz',hnr:'3/1',titel:'Dr.',name:'Otto-Felix Stary',lat:48.20896,lon:16.32716},
  {id:'a1309',plz:'1160',strasse:'Richard Wagner Platz',hnr:'3/1',titel:'Dr.',name:'Karin Stary',lat:48.20896,lon:16.32716},
  {id:'a1310',plz:'1080',strasse:'Lange Gasse',hnr:'65',titel:'Dr.',name:'Christoph Staus',lat:48.21422,lon:16.35085},
  {id:'a1311',plz:'1140',strasse:'Linzer Straße',hnr:'280/4',titel:'Dr.',name:'Natalie Stefan',lat:48.19870,lon:16.27199},
  {id:'a1315',plz:'1010',strasse:'Rudolfsplatz',hnr:'14',titel:'Dr.',name:'Valerie Steiger-Ronay',lat:48.21442,lon:16.37092},
  {id:'a1316',plz:'1040',strasse:'Favoritenstraße',hnr:'44',titel:'Dr.',name:'Ernest Steiner',lat:48.19023,lon:16.37166},
  {id:'a1317',plz:'1120',strasse:'Füchselhofgasse',hnr:'2/12',titel:'Dr.',name:'Nick Steiner',lat:48.18082,lon:16.32916},
  {id:'a1318',plz:'1210',strasse:'Kürschnergasse',hnr:'1c',titel:'Dr.',name:'Huberta Steiner',lat:48.26741,lon:16.44778},
  {id:'a1319',plz:'1230',strasse:'Dr. Neumann Gasse',hnr:'9',titel:'Dr.',name:'Karin Steininger',lat:48.13831,lon:16.28642},
  {id:'a1320',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'Dr.',name:'Djan Stekic Angerpointner',lat:48.22664,lon:16.35181},
  {id:'a1321',plz:'1170',strasse:'Leopold Ernst Gasse',hnr:'21/4',titel:'DDr.',name:'Vesna Stephan-Bauer',lat:48.22193,lon:16.33385},
  {id:'a1322',plz:'1120',strasse:'Schönbrunner Straße',hnr:'148/1',titel:'Dr.',name:'Johanna Steyrer',lat:48.18301,lon:16.32398},
  {id:'a1323',plz:'1120',strasse:'Schönbrunner Straße',hnr:'148/1',titel:'Dr.',name:'Mathias Steyrer',lat:48.18301,lon:16.32398},
  {id:'a1324',plz:'1100',strasse:'Wienerbergstraße',hnr:'13',titel:'Dr.',name:'Michaela Stichaller',lat:48.16919,lon:16.34527},
  {id:'a1325',plz:'1140',strasse:'Hütteldorfer Straße',hnr:'197/8',titel:'Dr. med. dent.',name:'Christian Stieg',lat:48.19761,lon:16.29867},
  {id:'a1327',plz:'1230',strasse:'Perfektastraße',hnr:'40/4',titel:'Dr.',name:'Alina Catharina Stöber',lat:48.13732,lon:16.31570},
  {id:'a1328',plz:'1040',strasse:'Schikanedergasse',hnr:'1/2',titel:'DDr.',name:'Andreas Stockner',lat:48.19682,lon:16.36444},
  {id:'a1329',plz:'1150',strasse:'Hütteldorferstraße',hnr:'1/8',titel:'Dr.',name:'Dragan Stojanovic',lat:48.20150,lon:16.33665},
  {id:'a1330',plz:'1130',strasse:'Speisinger Straße',hnr:'46-48/4/1',titel:'Dr.',name:'Christiane Stokreiter-Ebner',lat:48.16963,lon:16.28514},
  {id:'a1332',plz:'1140',strasse:'Bierhäuselberggasse',hnr:'96/2',titel:'Dr.',name:'Alina Strasser',lat:48.20784,lon:16.24362},
  {id:'a1334',plz:'1140',strasse:'Bierhäuselberggasse',hnr:'96/1',titel:'Dr.',name:'Silvia Strasser-Kollmann',lat:48.20784,lon:16.24362},
  {id:'a1335',plz:'1200',strasse:'Leystraße',hnr:'134/13',titel:'Dr.',name:'Hans Strassl',lat:48.24317,lon:16.37780},
  {id:'a1336',plz:'1210',strasse:'Wildgänsegasse',hnr:'6',titel:'DDr.',name:'Martina Strasz',lat:48.24204,lon:16.40568},
  {id:'a1338',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'Dr.',name:'Julia Stria',lat:48.22664,lon:16.35181},
  {id:'a1339',plz:'1030',strasse:'Weyrgasse',hnr:'7/8',titel:'Dr.',name:'Markus Stumvoll',lat:48.20459,lon:16.38916},
  {id:'a1340',plz:'1180',strasse:'Gertrudplatz',hnr:'7/1',titel:'Dr.',name:'Sabine Stumvoll',lat:48.22591,lon:16.34486},
  {id:'a1341',plz:'1220',strasse:'Lavaterstraße',hnr:'9/5',titel:'Dr.',name:'Birgit Stursa',lat:48.22351,lon:16.47344},
  {id:'a1342',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'Dr.',name:'Maja Sukalo',lat:48.22664,lon:16.35181},
  {id:'a1343',plz:'1020',strasse:'Lessinggasse',hnr:'19/7',titel:'Dr.',name:'Titanilla Süle',lat:48.22373,lon:16.38388},
  {id:'a1344',plz:'1010',strasse:'Opernring',hnr:'19',titel:'Dr.',name:'Stephan Suhsmann',lat:48.20301,lon:16.36528},
  {id:'a1345',plz:'1140',strasse:'Linzer Straße',hnr:'103/10',titel:'DDr.',name:'Christian Sulek',lat:48.20347,lon:16.24275},
  {id:'a1346',plz:'1170',strasse:'Hormayrgasse',hnr:'12/7',titel:'DDr.',name:'Verena Sulek',lat:48.21879,lon:16.33082},
  {id:'a1347',plz:'1220',strasse:'Langobardenstraße',hnr:'122',titel:'Dr.',name:'Aida Suljevic-Seherija',lat:48.21931,lon:16.46448},
  {id:'a1348',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Lejla Suljkanovic',lat:48.21955,lon:16.35453},
  {id:'a1349',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Nedim Suljkanovic',lat:48.21955,lon:16.35453},
  {id:'a1351',plz:'1010',strasse:'Renngasse',hnr:'15',titel:'Dr.',name:'Grazyna Szczurowski',lat:48.21372,lon:16.36825},
  {id:'a1353',plz:'1150',strasse:'Schwendergasse',hnr:'35-37',titel:'Dr..',name:'Peter Szemcsak',lat:48.19061,lon:16.32582},
  {id:'a1354',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Csenge Szepesi',lat:48.21955,lon:16.35453},
  {id:'a1355',plz:'1090',strasse:'Wasagasse',hnr:'24',titel:'Dr.',name:'György Sziklavari',lat:48.21850,lon:16.35991},
  {id:'a1356',plz:'1050',strasse:'Schönbrunner Straße',hnr:'89/2',titel:'Dr. med. dent.',name:'Ekrem Tafaj',lat:48.19411,lon:16.35955},
  {id:'a1357',plz:'1100',strasse:'Quellenstraße',hnr:'160/10',titel:'Dr. med. dent.',name:'Shadi Tahvildari',lat:48.17299,lon:16.39440},
  {id:'a1358',plz:'1150',strasse:'Schwendergasse',hnr:'15/!',titel:'Dr.',name:'Mansour Tajalli',lat:48.19076,lon:16.32895},
  {id:'a1359',plz:'1200',strasse:'Engerthstraße',hnr:'52/2',titel:'',name:'Ishak Janbert Tamzok',lat:48.23390,lon:16.39210},
  {id:'a1360',plz:'1230',strasse:'Karl Tornay Gasse 45-47 /',hnr:'1',titel:'Dr.',name:'Goran Tanasic',lat:48.13126,lon:16.31851},
  {id:'a1361',plz:'1130',strasse:'Altgasse',hnr:'23/5',titel:'Dr.',name:'Maximilian Tasch',lat:48.18586,lon:16.29840},
  {id:'a1362',plz:'1210',strasse:'Karl Aschenbrenner Gasse',hnr:'3',titel:'Dr.',name:'Aleksandra Tashkovska',lat:48.25351,lon:16.39736},
  {id:'a1363',plz:'1190',strasse:'Heiligenstädter Straße 181 /',hnr:'23',titel:'Dr.',name:'Günter Tautscher',lat:48.26219,lon:16.36694},
  {id:'a1364',plz:'1140',strasse:'Cumberlandstraße',hnr:'27/5',titel:'Dr.',name:'Jasmin Tavakolian',lat:48.19233,lon:16.29299},
  {id:'a1365',plz:'1200',strasse:'Gerhardusgasse',hnr:'19',titel:'Dr.',name:'Abdussalam Tayeb',lat:48.23173,lon:16.36592},
  {id:'a1367',plz:'1220',strasse:'Rennbahnweg',hnr:'13/21/1',titel:'ao. Univ.-Prof. DDr.',name:'Gabor Tepper',lat:48.25877,lon:16.44570},
  {id:'a1368',plz:'1220',strasse:'Rennbahnweg',hnr:'13/21/1',titel:'Dr. med. dent.',name:'Christina Claudia Tepper',lat:48.25877,lon:16.44570},
  {id:'a1369',plz:'1220',strasse:'Rennbahnweg',hnr:'13/21/1',titel:'DDr.',name:'Susanna Tepper',lat:48.25877,lon:16.44570},
  {id:'a1371',plz:'1050',strasse:'Reinprechtsdorfer Straße',hnr:'13/4',titel:'DDr.',name:'Ingrid Terpotiz-Schranz',lat:48.18466,lon:16.35504},
  {id:'a1374',plz:'1100',strasse:'Karmarschgasse',hnr:'17/26',titel:'Dr.',name:'Vedrana Tesic',lat:48.17917,lon:16.36500},
  {id:'a1376',plz:'1220',strasse:'Langobardenstraße',hnr:'122',titel:'Dr.',name:'Miriam Testor',lat:48.21931,lon:16.46448},
  {id:'a1377',plz:'1050',strasse:'Strobachgasse',hnr:'7-9',titel:'Dr.',name:'Erik Thaller',lat:48.19248,lon:16.35817},
  {id:'a1378',plz:'1230',strasse:'Dr. Neumann Gasse',hnr:'9',titel:'Dr.',name:'Daniela Elisabeth Thielmann',lat:48.13831,lon:16.28642},
  {id:'a1379',plz:'1220',strasse:'Kagraner Platz',hnr:'14',titel:'MR DDr.',name:'Barbara Thornton',lat:48.24922,lon:16.44759},
  {id:'a1380',plz:'1220',strasse:'Zschokkegasse',hnr:'140',titel:'Dr.',name:'Alexander Philip Tietz',lat:48.22002,lon:16.46409},
  {id:'a1382',plz:'1090',strasse:'Canisiusgasse',hnr:'2/3',titel:'Dr.',name:'Paul Tischler',lat:48.22810,lon:16.35215},
  {id:'a1383',plz:'1220',strasse:'Hausgrundweg',hnr:'48/56',titel:'DDr.',name:'Petra Titz',lat:48.22466,lon:16.46130},
  {id:'a1384',plz:'1140',strasse:'Zennerstraße',hnr:'14/2/7',titel:'Dr.',name:'Laurenz Stefan Tonkovitsch',lat:48.20148,lon:16.30735},
  {id:'a1385',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'Dr.',name:'Tijana Tosic',lat:48.22664,lon:16.35181},
  {id:'a1386',plz:'1010',strasse:'Gablenzgasse',hnr:'11/2',titel:'Dr.',name:'Gyula-Julius Toth',lat:48.20416,lon:16.33626},
  {id:'a1387',plz:'1010',strasse:'Tuchlauben',hnr:'7a/13',titel:'Dr.',name:'Peter Toth',lat:48.20958,lon:16.36864},
  {id:'a1388',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'Dr.',name:'Antonia Traby',lat:48.22664,lon:16.35181},
  {id:'a1389',plz:'1150',strasse:'Wieningerplatz',hnr:'6',titel:'Dr.',name:'Erich Trauschke',lat:48.19429,lon:16.31852},
  {id:'a1390',plz:'1180',strasse:'Salierigasse',hnr:'27',titel:'Univ. Doz. Dr.',name:'Mario Traxler',lat:48.23103,lon:16.32710},
  {id:'a1391',plz:'1140',strasse:'Kienmayergasse',hnr:'31/11',titel:'Dr.',name:'Wolfgang Traxler',lat:48.20188,lon:16.31131},
  {id:'a1393',plz:'1140',strasse:'Linzer Straße',hnr:'48/6',titel:'Dr.',name:'Reiner Treven',lat:48.20347,lon:16.24275},
  {id:'a1394',plz:'1010',strasse:'Wipplingerstraße',hnr:'29/3',titel:'Dr.',name:'Fanny Katharina Triessnig',lat:48.21201,lon:16.37038},
  {id:'a1395',plz:'1090',strasse:'Löblichgasse',hnr:'14',titel:'Dr.',name:'Neda Trivic',lat:48.22664,lon:16.35181},
  {id:'a1396',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Bojana Trmcic',lat:48.21955,lon:16.35453},
  {id:'a1397',plz:'1080',strasse:'Josefstädter Straße',hnr:'80',titel:'Dr.',name:'Hannah Trnka',lat:48.21134,lon:16.34074},
  {id:'a1399',plz:'1080',strasse:'Albertgasse',hnr:'3/6',titel:'Dr.',name:'Michael Truppe',lat:48.21489,lon:16.34381},
  {id:'a1400',plz:'1020',strasse:'Untere Augartenstraße',hnr:'39',titel:'Dr.',name:'Roland Tschalakow',lat:48.22273,lon:16.37484},
  {id:'a1401',plz:'1030',strasse:'Gärtnergasse',hnr:'6/2',titel:'Dr.',name:'Katharina Lia Veronika Tschepper',lat:48.20509,lon:16.38751},
  {id:'a1402',plz:'1030',strasse:'Gärtnergasse',hnr:'6/2',titel:'Dr. med. dent.',name:'Thomas Tschepper',lat:48.20509,lon:16.38751},
  {id:'a1403',plz:'1180',strasse:'Herbeckstraße',hnr:'74/1',titel:'Dr.',name:'Arne Tschmelitsch',lat:48.23245,lon:16.31773},
  {id:'a1404',plz:'1030',strasse:'Uchatiusgasse',hnr:'4/5',titel:'Dr.',name:'Anamarija Tunjic',lat:48.20536,lon:16.39018},
  {id:'a1405',plz:'1030',strasse:'Am Heumarkt',hnr:'7/16',titel:'Dr.',name:'Franz-Karl Tuppy',lat:48.20423,lon:16.38310},
  {id:'a1406',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Dino Tur',lat:48.21955,lon:16.35453},
  {id:'a1407',plz:'1160',strasse:'Ottakringerstraße',hnr:'103',titel:'Dr.',name:'Dragan Tur',lat:48.21335,lon:16.32133},
  {id:'a1408',plz:'1080',strasse:'Josefstädter Straße',hnr:'74',titel:'Dr.',name:'Doris Turnock-Schauerhuber',lat:48.21089,lon:16.34241},
  {id:'a1409',plz:'1090',strasse:'Porzellangasse 27 /',hnr:'7a',titel:'Dr.',name:'Alina Tymoshchuk',lat:48.21930,lon:16.36278},
  {id:'a1410',plz:'1090',strasse:'Währinger Straße',hnr:'23/1',titel:'Univ.-Prof. DDr.',name:'Christian Ulm',lat:48.22168,lon:16.35404},
  {id:'a1412',plz:'1090',strasse:'Pelikangasse',hnr:'15',titel:'Dr.',name:'Gerhard Undt',lat:48.21715,lon:16.34803},
  {id:'a1413',plz:'1210',strasse:'Karl Aschenbrenner Gasse',hnr:'3',titel:'Dr.',name:'Matthias Unger',lat:48.25351,lon:16.39736},
  {id:'a1414',plz:'1030',strasse:'Erdbergstraße 202',hnr:'E7a',titel:'Dr.',name:'Gerda Hermine Unterköfler',lat:48.19027,lon:16.41417},
  {id:'a1416',plz:'1040',strasse:'Wiedner Hauptstraße',hnr:'18',titel:'DDr.',name:'Marcus Vachuda',lat:48.19678,lon:16.36721},
  {id:'a1417',plz:'1140',strasse:'Märzstraße',hnr:'149/17',titel:'Dr.',name:'Babak Vafojoo',lat:48.19682,lon:16.30926},
  {id:'a1418',plz:'1170',strasse:'Hormayrgasse',hnr:'55',titel:'Dr.',name:'Silvio Valdec',lat:48.22381,lon:16.33333},
  {id:'a1421',plz:'1030',strasse:'Salesianergasse',hnr:'4/3',titel:'Dr.',name:'Bruno Valic',lat:48.20072,lon:16.38073},
  {id:'a1422',plz:'1180',strasse:'Ferrogasse',hnr:'12/15',titel:'Mag.',name:'Vesela Valkova',lat:48.23250,lon:16.32805},
  {id:'a1423',plz:'1230',strasse:'Breitenfurter Straße',hnr:'360-368/1/1',titel:'Dr.',name:'Sabiha Merve Varol',lat:48.13593,lon:16.28220},
  {id:'a1424',plz:'1190',strasse:'Grinzinger Straße',hnr:'149a',titel:'DDr.',name:'Christoph Vasak',lat:48.25483,lon:16.36727},
  {id:'a1426',plz:'1090',strasse:'Nußdorfer Straße',hnr:'14',titel:'Dr.',name:'Werner Velikogne',lat:48.22381,lon:16.35408},
  {id:'a1428',plz:'1090',strasse:'Liechtensteinstraße',hnr:'62/3',titel:'Dr.',name:'Birgit Vetter-Scheidl',lat:48.22860,lon:16.35612},
  {id:'a1429',plz:'1100',strasse:'Herzgasse',hnr:'85/15',titel:'Dr.',name:'Borivoj Vezmar',lat:48.17292,lon:16.36654},
  {id:'a1430',plz:'1010',strasse:'Hoher Markt',hnr:'4/46',titel:'Dr. med. dent.',name:'Mario Viden',lat:48.21061,lon:16.37322},
  {id:'a1431',plz:'1100',strasse:'Hintschiggasse',hnr:'3/4/1',titel:'Dr.',name:'Nina Viden',lat:48.15567,lon:16.34423},
  {id:'a1432',plz:'1100',strasse:'Hintschiggasse',hnr:'3/3/1',titel:'DDr.',name:'Danko Viden',lat:48.15842,lon:16.34572},
  {id:'a1433',plz:'1100',strasse:'Hintschiggasse',hnr:'3/4/1',titel:'Dr.',name:'Stella Viden',lat:48.15567,lon:16.34423},
  {id:'a1434',plz:'1090',strasse:'Spitalgasse',hnr:'17/A',titel:'Dr.',name:'Mate Andras Vincze',lat:48.21750,lon:16.35114},
  {id:'a1435',plz:'1200',strasse:'Adalbert Stifter Straße',hnr:'35/6/1',titel:'Dr.',name:'Christa Vogel',lat:48.24068,lon:16.36997},
  {id:'a1436',plz:'1230',strasse:'Karl Heinz Straße',hnr:'67/1/2',titel:'Dr.',name:'Philipp Fabian Vogel',lat:48.15756,lon:16.30989},
  {id:'a1437',plz:'1230',strasse:'Breitenfurter Straße',hnr:'360-368/1/1',titel:'Dr.',name:'Valentina-Amelie Voigt',lat:48.13593,lon:16.28220},
  {id:'a1438',plz:'1010',strasse:'Rotenturmstraße',hnr:'21/5',titel:'Dr.',name:'Alexander Vollgruber',lat:48.21172,lon:16.37611},
  {id:'a1439',plz:'1220',strasse:'Doeltergasse',hnr:'3/1/1',titel:'Dr.',name:'Hilmar Jobst Giso Von Jeinsen',lat:48.25718,lon:16.43736},
  {id:'a1441',plz:'1170',strasse:'Elterleinplatz',hnr:'1/7a',titel:'DDr.',name:'Karin Vornwagner',lat:48.21813,lon:16.33130},
  {id:'a1442',plz:'1230',strasse:'Draschestraße',hnr:'31/3',titel:'Dr.',name:'Natasa Vukajlovic',lat:48.14717,lon:16.35698},
  {id:'a1443',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85/87',titel:'Dr.',name:'Nevena Vukicevic-Klisic',lat:48.19748,lon:16.34833},
  {id:'a1444',plz:'1160',strasse:'Feßtgasse',hnr:'10',titel:'Dr.',name:'Paul Vyslonzil',lat:48.21194,lon:16.32549},
  {id:'a1445',plz:'1010',strasse:'Renngasse',hnr:'15',titel:'DDr.',name:'Benjamin Peter Wachter',lat:48.21372,lon:16.36825},
  {id:'a1446',plz:'1090',strasse:'Nordbergstraße',hnr:'6/3',titel:'DDr.',name:'Stefan Wagesreither',lat:48.22647,lon:16.36198},
  {id:'a1447',plz:'1190',strasse:'Sollingergasse',hnr:'16',titel:'Dr.',name:'Arne Wagner',lat:48.24246,lon:16.33546},
  {id:'a1448',plz:'1080',strasse:'Glasergasse',hnr:'14/21',titel:'DDDr.',name:'Florian Wagner',lat:48.22433,lon:16.36278},
  {id:'a1450',plz:'1010',strasse:'Renngasse',hnr:'15',titel:'Dr.',name:'Rene Wagner',lat:48.21372,lon:16.36825},
  {id:'a1451',plz:'1150',strasse:'Reithofferplatz',hnr:'6/11',titel:'Dr.',name:'Malgorzata Wajnikonis',lat:48.19851,lon:16.33161},
  {id:'a1452',plz:'1140',strasse:'Gruschaplatz',hnr:'8',titel:'Dr.',name:'Barbara Waldbauer',lat:48.19464,lon:16.28290},
  {id:'a1453',plz:'1210',strasse:'Jedleseer Straße',hnr:'91',titel:'Dr. med. univ.',name:'Andrea Waldhof',lat:48.26493,lon:16.38494},
  {id:'a1454',plz:'1130',strasse:'Altgasse',hnr:'11',titel:'Dr.',name:'Barbara Wamprechtshammer',lat:48.18515,lon:16.29941},
  {id:'a1455',plz:'1060',strasse:'Gumpendorferstraße',hnr:'115',titel:'DDr.',name:'Klaus Wamprechtshammer',lat:48.19081,lon:16.34640},
  {id:'a1457',plz:'1190',strasse:'Zehenthofgasse',hnr:'28',titel:'DDR.',name:'Georg Watzak',lat:48.24780,lon:16.34612},
  {id:'a1458',plz:'1030',strasse:'Wassergasse',hnr:'28/17',titel:'Dr.',name:'Georg Watzek',lat:48.20255,lon:16.39701},
  {id:'a1459',plz:'1060',strasse:'Schmalzhofgasse',hnr:'22/25',titel:'DDr.',name:'Clemens Wawra',lat:48.19542,lon:16.34676},
  {id:'a1461',plz:'1090',strasse:'Liechtensteinstraße',hnr:'104',titel:'Dr.',name:'Elfriede Johanna Weber',lat:48.22983,lon:16.35650},
  {id:'a1464',plz:'1090',strasse:'Berggasse',hnr:'7/6',titel:'',name:'Lennart Wedekind',lat:48.21744,lon:16.35991},
  {id:'a1465',plz:'1010',strasse:'Seilerstätte',hnr:'7/6',titel:'Dr.',name:'Thilo Weeger',lat:48.20523,lon:16.37475},
  {id:'a1466',plz:'1220',strasse:'Wagramer Straße',hnr:'74/16',titel:'Dr.',name:'Alicia Wegund',lat:48.24614,lon:16.43976},
  {id:'a1467',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Christian Otmar Wehner',lat:48.21955,lon:16.35453},
  {id:'a1469',plz:'1080',strasse:'Josefstädter Straße',hnr:'13/25',titel:'Dr. med. univ. et med. dent.',name:'Stephen Weinländer',lat:48.20941,lon:16.35138},
  {id:'a1471',plz:'1010',strasse:'Börseplatz',hnr:'6/1/8',titel:'Dr..',name:'Ernst Weinmann',lat:48.21491,lon:16.36778},
  {id:'a1473',plz:'1130',strasse:'Speisinger Straße',hnr:'18/1/16',titel:'Dr.',name:'Angelika Caroline Weissenböck',lat:48.16895,lon:16.28488},
  {id:'a1474',plz:'1200',strasse:'Dresdner Straße',hnr:'112/4/9',titel:'Dr.',name:'Zeinab Weli',lat:48.23224,lon:16.38475},
  {id:'a1475',plz:'1010',strasse:'Seilerstätte',hnr:'11/5',titel:'Dr.',name:'Andreas Werner',lat:48.20611,lon:16.37667},
  {id:'a1476',plz:'1130',strasse:'Geylinggasse',hnr:'27/16',titel:'MR Dr.',name:'Elisabeth Wernhart-Hallas',lat:48.18689,lon:16.27482},
  {id:'a1477',plz:'1050',strasse:'Hartmanngasse',hnr:'10/20',titel:'Dr.',name:'Sandra Wichlas',lat:48.18885,lon:16.36270},
  {id:'a1478',plz:'1060',strasse:'Mariahilfer Straße',hnr:'105',titel:'Dr.',name:'Felix Wick',lat:48.19673,lon:16.34509},
  {id:'a1479',plz:'1190',strasse:'Kreindlgasse',hnr:'18/2',titel:'Dr.',name:'Christina Wicke',lat:48.23798,lon:16.35163},
  {id:'a1480',plz:'1190',strasse:'An der Zwerchwiese',hnr:'8',titel:'MR Dr.',name:'Susanne Wicke',lat:48.25288,lon:16.29375},
  {id:'a1483',plz:'1040',strasse:'Mommsengasse',hnr:'28',titel:'Dr.',name:'Maximilian Wienerroither',lat:48.18858,lon:16.37861},
  {id:'a1484',plz:'1100',strasse:'Wienerbergstraße',hnr:'13',titel:'Dr.',name:'Andreas Wiesbauer',lat:48.16919,lon:16.34527},
  {id:'a1485',plz:'1010',strasse:'Wipplingerstraße',hnr:'10',titel:'Dr.',name:'Sabine Wiesinger',lat:48.21216,lon:16.37020},
  {id:'a1486',plz:'1040',strasse:'Gußhausstraße',hnr:'9/6',titel:'Dr.',name:'Georg Winkler',lat:48.19680,lon:16.37034},
  {id:'a1487',plz:'1090',strasse:'Widerhofergasse',hnr:'5/3',titel:'Dr.',name:'Linda Winkler',lat:48.22322,lon:16.35456},
  {id:'a1488',plz:'1090',strasse:'Widerhofergasse',hnr:'5/3',titel:'Dr.',name:'Olivia Katharina Winkler',lat:48.22322,lon:16.35456},
  {id:'a1489',plz:'1150',strasse:'Gablenzgasse',hnr:'21/13',titel:'Dr.',name:'Harald Winter',lat:48.20566,lon:16.32297},
  {id:'a1492',plz:'1160',strasse:'Sandleitengasse',hnr:'12',titel:'Dr',name:'Peter Wirth',lat:48.21697,lon:16.30771},
  {id:'a1493',plz:'1160',strasse:'Sandleitengasse',hnr:'12',titel:'Dr',name:'Veronika Wirth',lat:48.21697,lon:16.30771},
  {id:'a1494',plz:'1030',strasse:'Jacquingasse',hnr:'41',titel:'ZA',name:'David Wiss',lat:48.19061,lon:16.38491},
  {id:'a1495',plz:'1020',strasse:'Karmelitergasse',hnr:'13/17',titel:'Dr. med. dent.',name:'Natascha Witzmann',lat:48.21647,lon:16.37944},
  {id:'a1496',plz:'1180',strasse:'Währinger Straße',hnr:'96/16',titel:'Dr.',name:'Gerhard Witzmann',lat:48.22749,lon:16.33876},
  {id:'a1497',plz:'1080',strasse:'Blindengasse',hnr:'8/5',titel:'Dr.',name:'Ines Elisabeth Witzmann',lat:48.21414,lon:16.34156},
  {id:'a1498',plz:'11190',strasse:'Döblinger Gürtel',hnr:'2/7-8',titel:'Dr.',name:'Bernhard Witzmann',lat:48.23439,lon:16.35535},
  {id:'a1499',plz:'1110',strasse:'Herbortgasse',hnr:'22',titel:'Dr.',name:'Julian Wohanka',lat:48.17140,lon:16.41095},
  {id:'a1500',plz:'1210',strasse:'Karl Aschenbrenner Gasse',hnr:'3',titel:'Dr.',name:'Katharina Woletz',lat:48.25351,lon:16.39736},
  {id:'a1501',plz:'1030',strasse:'Ungargasse',hnr:'4/3',titel:'Dr.',name:'Agnes Wolf',lat:48.19788,lon:16.38726},
  {id:'a1503',plz:'1160',strasse:'Thaliastraße',hnr:'22',titel:'Dr.',name:'Elisabeth Wolf',lat:48.20912,lon:16.33567},
  {id:'a1504',plz:'1020',strasse:'Praterstraße',hnr:'40/4',titel:'Mag. Dr.',name:'Anna Wolfsegger',lat:48.21551,lon:16.38578},
  {id:'a1505',plz:'1020',strasse:'Brigittenauer Lände',hnr:'4/1',titel:'Dr.',name:'Christine Wolner',lat:48.22597,lon:16.36817},
  {id:'a1506',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Lukas Andreas Wolschner',lat:48.21955,lon:16.35453},
  {id:'a1510',plz:'1180',strasse:'Martinstraße',hnr:'132',titel:'Dr. med. dent.',name:'Patricia Wruhs',lat:48.22071,lon:16.34052},
  {id:'a1511',plz:'1010',strasse:'Lugeck',hnr:'7/28',titel:'Dr',name:'Florian Erich Josef Wruhs',lat:48.21009,lon:16.37438},
  {id:'a1512',plz:'1160',strasse:'Redtenbachergasse',hnr:'55/8',titel:'Dr. med. dent.',name:'Stefan Wuketich',lat:48.21497,lon:16.31511},
  {id:'a1513',plz:'1180',strasse:'Gentzgasse',hnr:'14/7',titel:'Dr.',name:'Otto Wuketich',lat:48.22954,lon:16.33322},
  {id:'a1514',plz:'1010',strasse:'Dorotheergasse',hnr:'7/5',titel:'Dr.',name:'Anne Wunderlich',lat:48.20651,lon:16.36860},
  {id:'a1516',plz:'1070',strasse:'Mariahilfer Straße',hnr:'126/16',titel:'Priv.-Doz. DDr.',name:'Kaan Cagatay Yerit',lat:48.19671,lon:16.34416},
  {id:'a1517',plz:'1170',strasse:'Rhigasgasse',hnr:'8',titel:'Dr.',name:'Setareh Younes Abhari',lat:48.22301,lon:16.32311},
  {id:'a1518',plz:'1220',strasse:'Aladar Pecht Gasse',hnr:'10/24',titel:'Dr.',name:'Indira Ysupkhanova',lat:48.25326,lon:16.44344},
  {id:'a1519',plz:'1020',strasse:'Taborstraße',hnr:'39/4',titel:'Dr.',name:'Andreas Zadina',lat:48.22571,lon:16.38395},
  {id:'a1522',plz:'1010',strasse:'Hoher Markt',hnr:'12/18',titel:'Dr.',name:'Mohammad Mehdi Zahedi',lat:48.21061,lon:16.37322},
  {id:'a1523',plz:'1220',strasse:'Langobardenstraße',hnr:'176/3/1+2',titel:'Dr.',name:'Thomas Zajicek',lat:48.21727,lon:16.47715},
  {id:'a1524',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Konstantin Zauza',lat:48.21955,lon:16.35453},
  {id:'a1525',plz:'1190',strasse:'Grinzinger Straße',hnr:'149a',titel:'Univ.-Prof. DDr.',name:'Werner Zechner',lat:48.25483,lon:16.36727},
  {id:'a1527',plz:'1150',strasse:'Reichsapfelgasse',hnr:'19/5',titel:'Dr.',name:'Eirini Zgkouri',lat:48.18762,lon:16.32504},
  {id:'a1529',plz:'1080',strasse:'Josefstädter Straße',hnr:'74',titel:'Dr.',name:'Irene Zifko',lat:48.21089,lon:16.34241},
  {id:'a1532',plz:'1050',strasse:'Ramperstorffergasse',hnr:'68',titel:'',name:'Marlene Zimmermann',lat:48.19027,lon:16.35519},
  {id:'a1534',plz:'1040',strasse:'Schäffergasse',hnr:'20',titel:'Dr.',name:'Jasmina Zimonjic',lat:48.19394,lon:16.36373},
  {id:'a1536',plz:'1090',strasse:'Günthergasse',hnr:'2/3',titel:'DDr.',name:'Wolf-Dietrich Zinn-Zinnenburg',lat:48.21657,lon:16.35834},
  {id:'a1537',plz:'1150',strasse:'Johnstraße',hnr:'69',titel:'Dr.',name:'Gerhard Zips',lat:48.19946,lon:16.31843},
  {id:'a1538',plz:'1050',strasse:'Pilgramgasse',hnr:'1/2/8',titel:'DDr.',name:'Daniela Zitny-Haberl',lat:48.19176,lon:16.35731},
  {id:'a1539',plz:'1160',strasse:'Menzelgasse',hnr:'6/1',titel:'Dr.',name:'Farzad Ziya Ghazvini',lat:48.20813,lon:16.33698},
  {id:'a1540',plz:'1030',strasse:'Beatrixgasse',hnr:'3/5',titel:'Dr.',name:'Andreas Zizlavsky',lat:48.20157,lon:16.38047},
  {id:'a1542',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85/87',titel:'Dr.',name:'Qiyong Zuo',lat:48.19748,lon:16.34833},
  {id:'a1543',plz:'1090',strasse:'Sensengasse',hnr:'2a',titel:'Dr.',name:'Lana Zorana Zupancic Cepic',lat:48.21955,lon:16.35453},
  {id:'a1544',plz:'1060',strasse:'Mariahilfer Straße',hnr:'85/87',titel:'Dr.',name:'Elena Zymbal',lat:48.19748,lon:16.34833},
];

/* ── STORAGE ─────────────────────────────────────────── */
const S = {
  KEY_ADR:'nv_adressen',KEY_LOG:'nv_protokoll',KEY_SES:'nv_session',
  getAdressen(){
    const raw=localStorage.getItem(this.KEY_ADR);
    if(!raw){
      const init=SEED_ADRESSEN.map(a=>({...a,status:'verfuegbar',benutzer_id:null,reserviert_am:null,erledigt_am:null}));
      this.saveAdressen(init);return init;
    }
    return JSON.parse(raw);
  },
  saveAdressen(list){localStorage.setItem(this.KEY_ADR,JSON.stringify(list));},
  getProtokoll(){return JSON.parse(localStorage.getItem(this.KEY_LOG)||'[]');},
  addProtokoll(entry){
    const log=this.getProtokoll();log.unshift(entry);
    if(log.length>200)log.splice(200);
    localStorage.setItem(this.KEY_LOG,JSON.stringify(log));
  },
  getSession(){return JSON.parse(localStorage.getItem(this.KEY_SES)||'null');},
  setSession(u){localStorage.setItem(this.KEY_SES,JSON.stringify(u));},
  clearSession(){localStorage.removeItem(this.KEY_SES);},
  reset(){
    localStorage.removeItem(this.KEY_ADR);
    localStorage.removeItem(this.KEY_LOG);
    toast('Daten zurückgesetzt ✓');
    setTimeout(()=>location.reload(),900);
  }
};

/* ── AUTH ────────────────────────────────────────────── */
const auth={
  login(){
    const email=q('#inp-email').value.trim().toLowerCase();
    const pw=q('#inp-pw').value;
    const user=DEMO_USERS.find(u=>u.email.toLowerCase()===email&&u.pw===pw);
    if(!user){q('#login-err').textContent='E-Mail oder Passwort falsch.';return;}
    S.setSession(user);
    q('#login-err').textContent='';
    initApp(user);
  },
  logout(){S.clearSession();location.reload();},
  current(){return S.getSession();}
};

document.addEventListener('DOMContentLoaded',()=>{
  q('#inp-pw').addEventListener('keydown',e=>{if(e.key==='Enter')auth.login();});
  q('#inp-email').addEventListener('keydown',e=>{if(e.key==='Enter')q('#inp-pw').focus();});
  const ses=auth.current();
  if(ses)initApp(ses);else showEl('scr-login');
});

/* ── NAV ─────────────────────────────────────────────── */
let currentTab='home',mapInited=false;

function showTab(tab){
  currentTab=tab;
  qAll('.panel').forEach(p=>p.classList.remove('active'));
  qAll('.nav-btn').forEach(b=>b.classList.toggle('active',b.dataset.tab===tab));
  const panel=q('#p-'+tab);
  if(panel)panel.classList.add('active');
  if(tab==='meine')renderMeine();
  if(tab==='archive')renderArchive();
  if(tab==='admin')renderAdmin();
  if(tab==='karte'){initMap();updateMap();}
  window.scrollTo({top:0,behavior:'instant'});
}

/* ── INIT ────────────────────────────────────────────── */
function initApp(user){
  hideEl('scr-login');showEl('scr-app');
  q('#ab-user').textContent=user.name;
  if(user.rolle==='admin')showEl('nav-admin');
  updateMeineBadge();
}

/* ── LOCATION ────────────────────────────────────────── */
let userLoc=null,selectedNum=10;

function setNum(n){
  selectedNum=n;
  qAll('.num-btn').forEach(b=>b.classList.toggle('sel',parseInt(b.textContent)===n));
}

const loc={
  getGPS(){
    if(!navigator.geolocation){toast('GPS nicht verfügbar');return;}
    toast('GPS wird ermittelt …');
    navigator.geolocation.getCurrentPosition(
      pos=>{
        userLoc={lat:pos.coords.latitude,lon:pos.coords.longitude,label:'GPS-Standort'};
        setLocDisplay('GPS-Standort');toast('Standort ermittelt ✓');
      },
      err=>{toast('GPS-Fehler: '+err.message);},
      {enableHighAccuracy:true,timeout:10000}
    );
  },
  async geocode(){
    const val=q('#loc-input').value.trim();if(!val)return;
    toast('Adresse wird gesucht …');
    try{
      const url='https://nominatim.openstreetmap.org/search?q='+encodeURIComponent(val+', Wien')+'&format=json&limit=1&accept-language=de';
      const res=await fetch(url,{headers:{'User-Agent':'NOVUM-ZIV-Demo/1.0'}});
      const data=await res.json();
      if(!data.length){toast('Adresse nicht gefunden');return;}
      userLoc={lat:parseFloat(data[0].lat),lon:parseFloat(data[0].lon),label:data[0].display_name.split(',')[0]};
      setLocDisplay(userLoc.label);toast('Adresse gefunden ✓');
    }catch(e){toast('Geocoding-Fehler');}
  }
};

function setLocDisplay(text){q('#loc-text').textContent=text;showEl('loc-display');}

/* ── SEARCH ──────────────────────────────────────────── */
async function doSearch(){
  if(!userLoc){
    userLoc={lat:48.2082,lon:16.3738,label:'Stephansplatz (Standard)'};
    setLocDisplay(userLoc.label);
  }
  const btn=q('#search-btn');
  btn.disabled=true;q('#search-label').textContent='Suche läuft …';q('#search-icon').textContent='⏳';
  try{
    const adressen=S.getAdressen();
    const user=auth.current();
    let available=adressen.filter(a=>
      a.status==='verfuegbar'||(a.status==='in_bearbeitung'&&a.benutzer_id===user.id)
    );
    if(!available.length){
      q('#results-wrap').innerHTML='<div class="empty-state"><div class="big">🎉</div>Alle Adressen sind bereits erledigt!</div>';
      return;
    }
    available=available.map(a=>({...a,_dist:haversine(userLoc.lat,userLoc.lon,a.lat,a.lon)}))
      .sort((a,b)=>a._dist-b._dist).slice(0,50);
    let results;
    try{results=await getOSRMTimes(userLoc,available);}
    catch(e){results=available.map(a=>({...a,dauer_s:Math.round(a._dist/83.3*60),meter:Math.round(a._dist)}));}
    results.sort((a,b)=>a.dauer_s-b.dauer_s);
    renderResults(results.slice(0,selectedNum));
  }finally{
    btn.disabled=false;
    q('#search-label').textContent='Nächste Adressen suchen';
    q('#search-icon').textContent='🔍';
  }
}

async function getOSRMTimes(origin,targets){
  const coords=[[origin.lon,origin.lat],...targets.map(a=>[a.lon,a.lat])];
  const coordStr=coords.map(c=>c[0]+','+c[1]).join(';');
  const url='https://router.project-osrm.org/table/v1/foot/'+coordStr+'?sources=0&annotations=duration,distance';
  const res=await fetch(url);const data=await res.json();
  if(data.code!=='Ok')throw new Error('OSRM error');
  const dur=data.durations[0];const dist=data.distances?data.distances[0]:null;
  return targets.map((a,i)=>({...a,dauer_s:Math.round(dur[i+1]||0),meter:dist?Math.round(dist[i+1]||a._dist):Math.round(a._dist)}));
}

function haversine(lat1,lon1,lat2,lon2){
  const R=6371000,dLat=(lat2-lat1)*Math.PI/180,dLon=(lon2-lon1)*Math.PI/180;
  const a=Math.sin(dLat/2)**2+Math.cos(lat1*Math.PI/180)*Math.cos(lat2*Math.PI/180)*Math.sin(dLon/2)**2;
  return R*2*Math.atan2(Math.sqrt(a),Math.sqrt(1-a));
}

/* ── RENDER RESULTS ──────────────────────────────────── */
let lastResults=[];

function renderResults(list){
  lastResults=list;
  const user=auth.current();const adressen=S.getAdressen();
  if(!list.length){
    q('#results-wrap').innerHTML='<div class="empty-state"><div class="big">🔍</div>Keine verfügbaren Adressen in der Nähe.</div>';
    return;
  }
  q('#results-wrap').innerHTML=list.map((a,idx)=>{
    const min=Math.round(a.dauer_s/60);
    const mStr=a.meter>=1000?(a.meter/1000).toFixed(1)+' km':a.meter+' m';
    const cur=adressen.find(x=>x.id===a.id)||a;
    const isMine=cur.status==='in_bearbeitung'&&cur.benutzer_id===user.id;
    let actions='';
    if(isMine)actions=`<button class="btn-done" onclick="dlg.open('${a.id}')">✏️ Ergebnis eintragen</button>`;
    else if(cur.status==='verfuegbar')actions=`<button class="btn-take" onclick="uebernehmen('${a.id}')">📌 Übernehmen</button>`;
    return`<div class="addr-card" id="card-${a.id}">
      <div class="addr-header">
        <div class="addr-num">${idx+1}</div>
        <div class="addr-main">
          <div class="addr-street">${a.strasse} ${a.hnr}</div>
          ${(a.titel||a.name)?`<div class="addr-arzt">${[a.titel,a.name].filter(Boolean).join(' ')}</div>`:''}
          <div class="addr-plz">${a.plz} Wien${isMine?' &nbsp;<span class="mine-pill">Meine</span>':''}</div>
        </div>
        <div class="addr-time">
          <div class="addr-min">🚶 ${min} min</div>
          <div class="addr-dist">${mStr}</div>
        </div>
      </div>
      ${actions?`<div class="addr-actions">${actions}</div>`:''}
    </div>`;
  }).join('');
}

/* ── ADDRESS ACTIONS ─────────────────────────────────── */
function uebernehmen(id){
  const user=auth.current();const adressen=S.getAdressen();
  const a=adressen.find(x=>x.id===id);
  if(!a||a.status!=='verfuegbar'){toast('Adresse nicht mehr verfügbar');return;}
  a.status='in_bearbeitung';a.benutzer_id=user.id;a.reserviert_am=new Date().toISOString();
  S.saveAdressen(adressen);
  S.addProtokoll({id:uid(),adressen_id:id,benutzer_id:user.id,
    aktion:'uebernommen',zeitpunkt:new Date().toISOString(),notiz:'',
    adresse:`${a.strasse} ${a.hnr}, ${a.plz}`});
  updateMeineBadge();
  toast(`Übernommen: ${a.strasse} ${a.hnr} ✓`);
  if(lastResults.length)renderResults(lastResults);
}

/* ── DIALOG ──────────────────────────────────────────── */
const dlg={
  currentId:null,selectedAction:null,
  open(id){
    this.currentId=id;this.selectedAction=null;
    const a=S.getAdressen().find(x=>x.id===id);
    const arztLine=a&&(a.titel||a.name)?` — ${[a.titel,a.name].filter(Boolean).join(' ')}`:'';
    q('#dlg-addr-text').textContent=a?`${a.strasse} ${a.hnr}, ${a.plz} Wien${arztLine}`:id;
    q('#dlg-note').value='';q('#dlg-save').disabled=true;
    qAll('.dlg-opt').forEach(b=>b.classList.remove('selected'));
    showEl('dlg-overlay');
  },
  select(btn){
    this.selectedAction=btn.dataset.action;
    qAll('.dlg-opt').forEach(b=>b.classList.remove('selected'));
    btn.classList.add('selected');q('#dlg-save').disabled=false;
  },
  save(){
    if(!this.selectedAction)return;
    const user=auth.current();const adressen=S.getAdressen();
    const a=adressen.find(x=>x.id===this.currentId);
    if(!a){this.close();return;}
    const now=new Date().toISOString();
    a.status='archiviert';a.erledigt_am=now;
    S.saveAdressen(adressen);
    S.addProtokoll({id:uid(),adressen_id:a.id,benutzer_id:user.id,
      aktion:this.selectedAction,zeitpunkt:now,notiz:q('#dlg-note').value.trim(),
      adresse:`${a.strasse} ${a.hnr}, ${a.plz}`});
    updateMeineBadge();toast('Gespeichert ✓');this.close();
    if(lastResults.length)renderResults(lastResults);
  },
  close(){hideEl('dlg-overlay');this.currentId=null;this.selectedAction=null;}
};

/* ── MEINE ───────────────────────────────────────────── */
function renderMeine(){
  const user=auth.current();
  const mine=S.getAdressen().filter(a=>a.status==='in_bearbeitung'&&a.benutzer_id===user.id);
  const el=q('#meine-wrap');
  if(!mine.length){
    el.innerHTML='<div class="empty-state"><div class="big">📌</div>Keine reservierten Adressen.<br>Gehe auf "Suchen" und übernimm Adressen.</div>';
    return;
  }
  el.innerHTML=`<div class="section-title">${mine.length} reservierte Adresse${mine.length!==1?'n':''}</div>`+
    mine.map(a=>{
      const since=a.reserviert_am?new Date(a.reserviert_am).toLocaleString('de-AT',{day:'2-digit',month:'2-digit',hour:'2-digit',minute:'2-digit'}):'';
      return`<div class="mine-card">
        <div class="mine-header">
          <div class="mine-icon">📌</div>
          <div class="mine-info">
            <div class="mine-street">${a.strasse} ${a.hnr}</div>
            ${(a.titel||a.name)?`<div class="addr-arzt">${[a.titel,a.name].filter(Boolean).join(' ')}</div>`:''}
            <div class="mine-plz">${a.plz} Wien</div>
            <div class="mine-since">Reserviert: ${since}</div>
          </div>
        </div>
        <div class="mine-actions">
          <button class="btn-done" style="width:100%" onclick="dlg.open('${a.id}')">✏️ Ergebnis eintragen</button>
        </div>
      </div>`;
    }).join('');
}

function updateMeineBadge(){
  const user=auth.current();if(!user)return;
  const count=S.getAdressen().filter(a=>a.status==='in_bearbeitung'&&a.benutzer_id===user.id).length;
  const badge=q('#badge-meine');
  badge.textContent=count;count>0?showEl(badge):hideEl(badge);
}

/* ── ARCHIVE ─────────────────────────────────────────── */
function renderArchive(){
  const user=auth.current();const isAdmin=user.rolle==='admin';
  const archived=S.getAdressen()
    .filter(a=>a.status==='archiviert'&&(isAdmin||a.benutzer_id===user.id))
    .sort((a,b)=>new Date(b.erledigt_am)-new Date(a.erledigt_am));
  const log=S.getProtokoll();const el=q('#archive-wrap');
  if(!archived.length){
    el.innerHTML='<div class="empty-state"><div class="big">📦</div>Noch keine abgeschlossenen Adressen.</div>';return;
  }
  const ICONS={waehlt_uns:'🗳️',waehlt_nicht:'❌',ueberlegt:'🤔',kein_interesse_wahl:'🚫',sonstige:'💬',reaktiviert:'🔄'};
  const LABELS={waehlt_uns:'Wählt uns',waehlt_nicht:'Wählt uns nicht',ueberlegt:'Überlegt noch',kein_interesse_wahl:'Kein Interesse an der Wahl',sonstige:'Sonstige Angaben',reaktiviert:'Reaktiviert'};
  el.innerHTML=`<div class="section-title">${archived.length} abgeschlossen${isAdmin?' (alle)':''}</div>`+
    archived.map(a=>{
      const entry=log.find(l=>l.adressen_id===a.id&&l.aktion!=='uebernommen');
      const icon=entry?ICONS[entry.aktion]||'📋':'📋';
      const when=a.erledigt_am?new Date(a.erledigt_am).toLocaleString('de-AT',{day:'2-digit',month:'2-digit',hour:'2-digit',minute:'2-digit'}):'';
      const label=entry?LABELS[entry.aktion]||entry.aktion:'';
      return`<div class="arch-card">
        <div class="arch-header">
          <div class="arch-icon">${icon}</div>
          <div>
            <div class="arch-street">${a.strasse} ${a.hnr}, ${a.plz} Wien</div>
            ${(a.titel||a.name)?`<div class="addr-arzt">${[a.titel,a.name].filter(Boolean).join(' ')}</div>`:''}
            <div class="arch-meta">${label}${when?' · '+when:''}${entry&&entry.notiz?' · '+entry.notiz:''}</div>
          </div>
        </div>
      </div>`;
    }).join('');
}

/* ── ADMIN ───────────────────────────────────────────── */
function renderAdmin(){
  const adressen=S.getAdressen();const log=S.getProtokoll();
  const total=adressen.length;
  const verf=adressen.filter(a=>a.status==='verfuegbar').length;
  const bear=adressen.filter(a=>a.status==='in_bearbeitung').length;
  const unter=log.filter(l=>l.aktion==='waehlt_uns').length;
  q('#admin-stats').innerHTML=`
    <div class="stat-chip chip-b"><span class="sc-icon">🏠</span><span class="sc-label">Gesamt</span><span class="sc-val">${total}</span></div>
    <div class="stat-chip chip-g"><span class="sc-icon">✅</span><span class="sc-label">Verfügbar</span><span class="sc-val">${verf}</span></div>
    <div class="stat-chip chip-y"><span class="sc-icon">📌</span><span class="sc-label">Reserviert</span><span class="sc-val">${bear}</span></div>
    <div class="stat-chip chip-r"><span class="sc-icon">🗳️</span><span class="sc-label">Wählt uns</span><span class="sc-val">${unter}</span></div>`;
  const ICONS={waehlt_uns:'🗳️',waehlt_nicht:'❌',ueberlegt:'🤔',kein_interesse_wahl:'🚫',sonstige:'💬',uebernommen:'📌',reaktiviert:'🔄'};
  const LABELS={waehlt_uns:'Wählt uns',waehlt_nicht:'Wählt uns nicht',ueberlegt:'Überlegt noch',kein_interesse_wahl:'Kein Interesse an der Wahl',sonstige:'Sonstige Angaben',uebernommen:'Übernommen',reaktiviert:'Reaktiviert'};
  const recent=log.slice(0,15);
  q('#admin-log').innerHTML=recent.length?recent.map(l=>{
    const u=DEMO_USERS.find(u=>u.id===l.benutzer_id);
    const when=new Date(l.zeitpunkt).toLocaleString('de-AT',{day:'2-digit',month:'2-digit',hour:'2-digit',minute:'2-digit'});
    return`<div class="log-item">
      <div class="log-dot ld-${l.aktion}"></div>
      <div class="log-main">
        <div class="log-aktion">${ICONS[l.aktion]||'📋'} ${LABELS[l.aktion]||l.aktion}</div>
        <div class="log-detail">${l.adresse||''} · ${u?u.name.split(' ').pop():'?'} · ${when}</div>
        ${l.notiz?`<div class="log-detail" style="font-style:italic">"${l.notiz}"</div>`:''}
      </div>
    </div>`;
  }).join(''):'<div class="log-item" style="color:var(--sub)">Noch keine Einträge.</div>';
  q('#admin-users').innerHTML=DEMO_USERS.map(u=>{
    const mine=S.getAdressen().filter(a=>a.benutzer_id===u.id);
    const active=mine.filter(a=>a.status==='in_bearbeitung').length;
    const done=mine.filter(a=>a.status==='archiviert').length;
    const unt=log.filter(l=>l.benutzer_id===u.id&&l.aktion==='waehlt_uns').length;
    return`<div class="log-item">
      <div class="log-dot" style="background:${u.rolle==='admin'?'var(--g)':'#3b82f6'}"></div>
      <div class="log-main">
        <div class="log-aktion">${u.name}${u.rolle==='admin'?' 👑':''}</div>
        <div class="log-detail">Aktiv: ${active} · Erledigt: ${done} · Wählt uns: ${unt}</div>
      </div>
    </div>`;
  }).join('');
}

/* ── MAP ─────────────────────────────────────────────── */
let leafletMap=null,mapMarkers=[];
function initMap(){
  if(mapInited)return;mapInited=true;
  leafletMap=L.map('map',{zoomControl:true}).setView([48.2082,16.3738],13);
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',{
    attribution:'© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',maxZoom:19
  }).addTo(leafletMap);
}
function updateMap(){
  if(!leafletMap)return;
  mapMarkers.forEach(m=>m.remove());mapMarkers=[];
  const user=auth.current();
  const COL={verfuegbar:'#2C6E49',in_bearbeitung:'#F9A825',archiviert:'#9ca3af'};
  S.getAdressen().filter(a=>a.status!=='archiviert').forEach(a=>{
    const col=COL[a.status]||'#9ca3af';
    const icon=L.divIcon({
      html:`<div style="width:12px;height:12px;border-radius:50%;background:${col};border:2px solid #fff;box-shadow:0 1px 4px rgba(0,0,0,.4)"></div>`,
      className:'',iconSize:[12,12],iconAnchor:[6,6]
    });
    const m=L.marker([a.lat,a.lon],{icon}).addTo(leafletMap);
    const isMine=a.benutzer_id===user.id;
    m.bindPopup(`<strong>${a.strasse} ${a.hnr}</strong><br>${a.plz} Wien<br>Status: ${a.status}${isMine?'<br><em>Deine Adresse</em>':''}`);
    mapMarkers.push(m);
  });
  if(userLoc){
    const uI=L.divIcon({
      html:'<div style="width:16px;height:16px;border-radius:50%;background:#3b82f6;border:3px solid #fff;box-shadow:0 1px 6px rgba(0,0,0,.5)"></div>',
      className:'',iconSize:[16,16],iconAnchor:[8,8]
    });
    const um=L.marker([userLoc.lat,userLoc.lon],{icon:uI}).addTo(leafletMap);
    um.bindPopup('<strong>Dein Standort</strong>');mapMarkers.push(um);
    leafletMap.setView([userLoc.lat,userLoc.lon],14);
  }
  setTimeout(()=>leafletMap.invalidateSize(),100);
}

/* ── HELPERS ─────────────────────────────────────────── */
function q(sel){return document.querySelector(sel);}
function qAll(sel){return document.querySelectorAll(sel);}
function showEl(el){(typeof el==='string'?q('#'+el):el).classList.remove('hidden');}
function hideEl(el){(typeof el==='string'?q('#'+el):el).classList.add('hidden');}
function uid(){return Math.random().toString(36).slice(2)+Date.now().toString(36);}
let toastT;
function toast(msg){
  const el=q('#toast');el.textContent=msg;el.classList.add('show');
  clearTimeout(toastT);toastT=setTimeout(()=>el.classList.remove('show'),2300);
}
</script>
</body>
</html>
