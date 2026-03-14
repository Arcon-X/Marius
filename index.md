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
  {id:'a01',plz:'1010',strasse:'Kärntner Straße',          hnr:'12', lat:48.2046,lon:16.3711},
  {id:'a02',plz:'1010',strasse:'Stephansplatz',            hnr:'3',  lat:48.2085,lon:16.3728},
  {id:'a03',plz:'1010',strasse:'Rotenturmstraße',          hnr:'8',  lat:48.2092,lon:16.3752},
  {id:'a04',plz:'1010',strasse:'Wollzeile',                hnr:'5',  lat:48.2087,lon:16.3769},
  {id:'a05',plz:'1010',strasse:'Schottengasse',            hnr:'2',  lat:48.2138,lon:16.3682},
  {id:'a06',plz:'1010',strasse:'Graben',                   hnr:'15', lat:48.2083,lon:16.3694},
  {id:'a07',plz:'1010',strasse:'Am Hof',                   hnr:'7',  lat:48.2113,lon:16.3673},
  {id:'a08',plz:'1010',strasse:'Bäckerstraße',             hnr:'7',  lat:48.2078,lon:16.3763},
  {id:'a09',plz:'1020',strasse:'Praterstraße',             hnr:'10', lat:48.2143,lon:16.3877},
  {id:'a10',plz:'1020',strasse:'Taborstraße',              hnr:'14', lat:48.2161,lon:16.3813},
  {id:'a11',plz:'1020',strasse:'Untere Augartenstraße',    hnr:'4',  lat:48.2195,lon:16.3800},
  {id:'a12',plz:'1020',strasse:'Ausstellungsstraße',       hnr:'12', lat:48.2225,lon:16.3940},
  {id:'a13',plz:'1030',strasse:'Rennweg',                  hnr:'12', lat:48.1983,lon:16.3847},
  {id:'a14',plz:'1030',strasse:'Landstraßer Hauptstraße',  hnr:'5',  lat:48.2006,lon:16.3863},
  {id:'a15',plz:'1030',strasse:'Erdbergstraße',            hnr:'5',  lat:48.1968,lon:16.3932},
  {id:'a16',plz:'1040',strasse:'Wiedner Hauptstraße',      hnr:'8',  lat:48.1978,lon:16.3700},
  {id:'a17',plz:'1040',strasse:'Favoritenstraße',          hnr:'4',  lat:48.1960,lon:16.3691},
  {id:'a18',plz:'1040',strasse:'Theresianumgasse',         hnr:'3',  lat:48.1950,lon:16.3722},
  {id:'a19',plz:'1050',strasse:'Margaretenstraße',         hnr:'15', lat:48.1952,lon:16.3637},
  {id:'a20',plz:'1050',strasse:'Reinprechtsdorfer Straße', hnr:'5',  lat:48.1903,lon:16.3598},
  {id:'a21',plz:'1060',strasse:'Mariahilfer Straße',       hnr:'45', lat:48.1997,lon:16.3572},
  {id:'a22',plz:'1060',strasse:'Gumpendorfer Straße',      hnr:'3',  lat:48.1970,lon:16.3548},
  {id:'a23',plz:'1070',strasse:'Neubaugasse',              hnr:'10', lat:48.2028,lon:16.3530},
  {id:'a24',plz:'1070',strasse:'Siebensterngasse',         hnr:'5',  lat:48.2052,lon:16.3510},
  {id:'a25',plz:'1080',strasse:'Josefstädter Straße',      hnr:'10', lat:48.2092,lon:16.3490},
  {id:'a26',plz:'1080',strasse:'Feldgasse',                hnr:'3',  lat:48.2137,lon:16.3501},
  {id:'a27',plz:'1090',strasse:'Währinger Straße',         hnr:'10', lat:48.2172,lon:16.3600},
  {id:'a28',plz:'1090',strasse:'Nußdorfer Straße',         hnr:'5',  lat:48.2248,lon:16.3612},
  {id:'a29',plz:'1100',strasse:'Favoritenstraße',          hnr:'80', lat:48.1752,lon:16.3712},
  {id:'a30',plz:'1100',strasse:'Laxenburger Straße',       hnr:'5',  lat:48.1700,lon:16.3680},
  {id:'a31',plz:'1110',strasse:'Simmeringer Hauptstraße',  hnr:'15', lat:48.1751,lon:16.4054},
  {id:'a32',plz:'1120',strasse:'Meidlinger Hauptstraße',   hnr:'5',  lat:48.1791,lon:16.3278},
  {id:'a33',plz:'1130',strasse:'Hietzinger Hauptstraße',   hnr:'10', lat:48.1843,lon:16.2981},
  {id:'a34',plz:'1140',strasse:'Hütteldorfer Straße',      hnr:'10', lat:48.2012,lon:16.3030},
  {id:'a35',plz:'1150',strasse:'Mariahilfer Straße',       hnr:'140',lat:48.1968,lon:16.3278},
  {id:'a36',plz:'1160',strasse:'Ottakringer Straße',       hnr:'10', lat:48.2112,lon:16.3210},
  {id:'a37',plz:'1170',strasse:'Hernalser Hauptstraße',    hnr:'10', lat:48.2200,lon:16.3182},
  {id:'a38',plz:'1180',strasse:'Währinger Gürtel',         hnr:'5',  lat:48.2241,lon:16.3302},
  {id:'a39',plz:'1190',strasse:'Heiligenstädter Straße',   hnr:'5',  lat:48.2369,lon:16.3652},
  {id:'a40',plz:'1190',strasse:'Grinzinger Allee',         hnr:'3',  lat:48.2560,lon:16.3601},
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
    q('#dlg-addr-text').textContent=a?`${a.strasse} ${a.hnr}, ${a.plz} Wien`:id;
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
