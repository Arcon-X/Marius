---
title: "NOVUM-ZIV — Dokumentations-Hub"
---

<style>
.site-header { display: none !important; }
.hub-hero {
  border: 1px solid #d0d7de;
  border-radius: 14px;
  padding: 1rem;
  background: linear-gradient(135deg, #f0f7ff 0%, #ffffff 55%, #eef9f2 100%);
  margin-bottom: .9rem;
}
.hub-hero h1 { margin: 0 0 .35rem 0; font-size: 1.4rem; }
.hub-hero p { margin: 0; color: #57606a; }
.doc-nav {
  position: sticky;
  top: .5rem;
  z-index: 20;
  background: #ffffff;
  border: 1px solid #d0d7de;
  border-radius: 10px;
  padding: .7rem;
  margin: .2rem 0 1rem 0;
  box-shadow: 0 2px 8px rgba(0,0,0,.05);
}
.doc-nav-title {
  font-size: .8rem;
  color: #57606a;
  font-weight: 700;
  margin-bottom: .45rem;
}
.doc-nav-links {
  display: flex;
  gap: .4rem;
  overflow-x: auto;
  padding-bottom: .15rem;
}
.doc-nav-links a {
  text-decoration: none;
  border: 1px solid #d0d7de;
  background: #f6f8fa;
  color: #24292f;
  border-radius: 999px;
  padding: .32rem .72rem;
  white-space: nowrap;
  font-size: .82rem;
  font-weight: 600;
}
.doc-nav-links a.active {
  background: #1f6feb;
  border-color: #1f6feb;
  color: #fff;
}
.doc-nav-links a:focus-visible {
  outline: 2px solid #1f6feb;
  outline-offset: 2px;
}
.quick-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: .65rem;
  margin-top: .85rem;
}
.quick-card {
  border: 1px solid #d0d7de;
  border-radius: 10px;
  background: #fff;
  padding: .75rem .8rem;
}
.quick-card h3 { margin: 0 0 .35rem 0; font-size: .95rem; }
.quick-card p { margin: 0 0 .5rem 0; color: #57606a; font-size: .86rem; }
.quick-card a { text-decoration: none; font-weight: 700; color: #0969da; }
.section-title {
  margin: 1.05rem 0 .35rem 0;
  font-size: .86rem;
  color: #57606a;
  letter-spacing: .05em;
  text-transform: uppercase;
}
.hub-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: .7rem;
  margin-top: .9rem;
}
.hub-card {
  border: 1px solid #d0d7de;
  border-radius: 10px;
  padding: .8rem .9rem;
  background: #fff;
}
.hub-card h3 { margin: 0 0 .35rem 0; font-size: 1rem; }
.hub-card p { margin: 0 0 .65rem 0; color: #57606a; font-size: .9rem; }
.hub-card a {
  display: inline-block;
  text-decoration: none;
  border: 1px solid #1f6feb;
  color: #1f6feb;
  border-radius: 999px;
  padding: .25rem .65rem;
  font-size: .82rem;
  font-weight: 700;
}
.hub-card .meta {
  display: inline-block;
  margin-bottom: .45rem;
  font-size: .72rem;
  color: #57606a;
  border: 1px solid #d0d7de;
  border-radius: 999px;
  padding: 1px 7px;
  background: #f6f8fa;
}
.map-wrap {
  border: 1px solid #d0d7de;
  border-radius: 12px;
  padding: .75rem;
  background: #fff;
  margin-top: .7rem;
}
.map-wrap h3 {
  margin: 0 0 .45rem 0;
  font-size: .95rem;
}
.map-wrap p {
  margin: 0 0 .55rem 0;
  color: #57606a;
  font-size: .86rem;
}
</style>

<div class="hub-hero">
  <h1>NOVUM-ZIV — Dokumentations-Hub</h1>
  <p>Zentraler Einstieg fuer Betrieb, Steuerung und Weiterentwicklung. Alle Kernunterlagen sind hier gebuendelt.</p>
</div>

<div class="doc-nav" role="navigation" aria-label="Dokumentationsnavigation">
  <div class="doc-nav-title">Dokumentation</div>
  <div class="doc-nav-links">
    <a href="/docs/index.html" class="active" aria-current="page">Hub</a>
    <a href="/SPEC.html">SPEC</a>
    <a href="/docs/technik.html">Technik</a>
    <a href="/docs/db_model.html">DB</a>
    <a href="/docs/features.html">Features</a>
    <a href="/docs/import_report.html">Import</a>
    <a href="/docs/domain.html">Domain</a>
    <a href="/docs/report_executive_summary.html">Exec</a>
    <a href="/docs/report_business_kpi.html">KPI</a>
  </div>
</div>

## Schnellstart

<div class="quick-grid">
  <div class="quick-card">
    <h3>Management-Readout</h3>
    <p>Projektwirkung und KPI-Status fuer Steering und Abschlussgespraeche.</p>
    <a href="/docs/report_executive_summary.html">Executive Summary →</a>
  </div>
  <div class="quick-card">
    <h3>Operativer Betrieb</h3>
    <p>Systembetrieb, Infrastruktur und Sicherheitsrahmen schnell nachlesen.</p>
    <a href="/docs/technik.html">Technik →</a>
  </div>
  <div class="quick-card">
    <h3>Rechte im Team</h3>
    <p>Kompakte Rollenlogik: Was Admins duerfen und was fuer Mitarbeitende gilt.</p>
    <a href="/docs/technik.html#rechtemodell">Rechtemodell →</a>
  </div>
  <div class="quick-card">
    <h3>Daten- und Logikbasis</h3>
    <p>Datenmodell, Prozesse und End-to-End Spezifikation fuer technische Arbeit.</p>
    <a href="/SPEC.html">SPEC →</a>
  </div>
</div>

<div class="map-wrap">
  <h3>Dokumentenlandkarte</h3>
  <p>So greifen die Unterlagen ineinander:</p>
  <svg viewBox="0 0 860 245" width="100%" role="img" aria-label="Dokumentenlandkarte">
    <rect x="10" y="20" width="150" height="46" rx="9" fill="#e7f0ff" stroke="#96b9f2" />
    <text x="85" y="49" text-anchor="middle" font-size="13" fill="#1f2a44">Import</text>
    <rect x="190" y="20" width="150" height="46" rx="9" fill="#eafbf0" stroke="#95d5aa" />
    <text x="265" y="49" text-anchor="middle" font-size="13" fill="#1b4332">Features</text>
    <rect x="370" y="20" width="150" height="46" rx="9" fill="#fff5e9" stroke="#f2c17d" />
    <text x="445" y="49" text-anchor="middle" font-size="13" fill="#7f5539">DB Model</text>
    <rect x="550" y="20" width="140" height="46" rx="9" fill="#f4f0ff" stroke="#b4a7e7" />
    <text x="620" y="49" text-anchor="middle" font-size="13" fill="#3f356b">Technik</text>
    <rect x="710" y="20" width="140" height="46" rx="9" fill="#f7f7f7" stroke="#c4c4c4" />
    <text x="780" y="49" text-anchor="middle" font-size="13" fill="#3f3f3f">Domain</text>

    <line x1="85" y1="72" x2="85" y2="116" stroke="#9aa4b2" stroke-width="1.5" />
    <line x1="265" y1="72" x2="265" y2="116" stroke="#9aa4b2" stroke-width="1.5" />
    <line x1="445" y1="72" x2="445" y2="116" stroke="#9aa4b2" stroke-width="1.5" />
    <line x1="620" y1="72" x2="620" y2="116" stroke="#9aa4b2" stroke-width="1.5" />
    <line x1="780" y1="72" x2="780" y2="116" stroke="#9aa4b2" stroke-width="1.5" />

    <rect x="286" y="116" width="288" height="50" rx="10" fill="#ffffff" stroke="#7aa2da" stroke-width="2" />
    <text x="430" y="147" text-anchor="middle" font-size="14" font-weight="700" fill="#1f4f8c">SPEC (technische Gesamtklammer)</text>

    <line x1="430" y1="172" x2="430" y2="196" stroke="#9aa4b2" stroke-width="1.5" />
    <rect x="235" y="196" width="180" height="40" rx="9" fill="#edf6ff" stroke="#a5c8f0" />
    <text x="325" y="221" text-anchor="middle" font-size="13" fill="#1f4f8c">Executive Summary</text>
    <rect x="445" y="196" width="180" height="40" rx="9" fill="#eefdf5" stroke="#9edab9" />
    <text x="535" y="221" text-anchor="middle" font-size="13" fill="#1b6a43">Business KPI Report</text>
  </svg>
</div>

<div class="section-title">Kernunterlagen</div>

<div class="hub-grid">
  <div class="hub-card">
    <span class="meta">Systemreferenz</span>
    <h3>📚 Gesamtspezifikation (SPEC)</h3>
    <p>Vollständige End-to-End Spezifikation des gesamten Projekts.</p>
    <a href="/SPEC.html">Öffnen</a>
  </div>
  <div class="hub-card">
    <span class="meta">Betrieb</span>
    <h3>⚙️ Technische Dokumentation</h3>
    <p>Architektur, Betrieb, Security, Deployment und Kosten.</p>
    <a href="/docs/technik.html">Öffnen</a>
  </div>
  <div class="hub-card">
    <span class="meta">Daten</span>
    <h3>🗄️ Datenbank-Modell</h3>
    <p>Tabellen, Beziehungen, Views, RPCs und Constraints.</p>
    <a href="/docs/db_model.html">Öffnen</a>
  </div>
  <div class="hub-card">
    <span class="meta">Fachlich</span>
    <h3>📋 Feature-Dokumentation</h3>
    <p>Funktionale Beschreibung aller Kernmodule und Admin-Funktionen.</p>
    <a href="/docs/features.html">Öffnen</a>
  </div>
  <div class="hub-card">
    <span class="meta">Datengrundlage</span>
    <h3>📄 Adress-Import Report</h3>
    <p>Importstatistik, Geocoding-Methodik und Datenqualität.</p>
    <a href="/docs/import_report.html">Öffnen</a>
  </div>
  <div class="hub-card">
    <span class="meta">Infrastruktur</span>
    <h3>🌐 Domain konfigurieren</h3>
    <p>DNS/TLS, Migration, Ziel-Domain und Rollback-Strategie.</p>
    <a href="/docs/domain.html">Öffnen</a>
  </div>

  <div class="hub-card">
    <span class="meta">Abschluss</span>
    <h3>🧾 Executive Summary</h3>
    <p>Management-Readout mit Zielerreichung, KPIs, Risiken und Entscheidungen.</p>
    <a href="/docs/report_executive_summary.html">Öffnen</a>
  </div>
  <div class="hub-card">
    <span class="meta">Abschluss</span>
    <h3>📊 Business KPI Report</h3>
    <p>Bezirksvergleich mit Effizienz, Restlast und Ergebnis-Interpretation.</p>
    <a href="/docs/report_business_kpi.html">Öffnen</a>
  </div>
</div>
