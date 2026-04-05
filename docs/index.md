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
    <a href="/docs/features.html" title="Produktfunktionen und User-Flow">Features</a>
    <a href="/docs/technik.html" title="Technische Architektur, Betrieb und Sicherheit">Technik</a>
    <a href="/docs/db_model.html" title="Datenmodell, Views, RPCs und Constraints">DB Model</a>
    <a href="/docs/import_report.html" title="Datenherkunft, Geocoding und Qualitaet">Import Report</a>
    <a href="/docs/domain.html" title="Domain, TLS und Migrationsbetrieb">Domain</a>
    <a href="/docs/report_executive_summary.html" title="Management-Zusammenfassung fuer Abschluss">Executive Summary</a>
    <a href="/docs/report_business_kpi.html" title="KPI-Vertiefung mit Bezirks- und Teamwerten">Business KPI</a>
  </div>
</div>

## Die Doku ist auf einen durchgehenden Pfad aufgebaut. Wenn du neu einsteigst, lies in dieser Reihenfolge:

1. [Features](/docs/features.html "Produktablauf vom Suchen bis zum Archiv")
2. [Technik](/docs/technik.html "Architektur, Sicherheit und Rechtemodell")
3. [DB Model](/docs/db_model.html "Tabellen, Beziehungen, Views und RPCs")
4. [Import Report](/docs/import_report.html "Datenherkunft und Geocoding-Qualitaet")
5. [Domain](/docs/domain.html "Deployment, Domainwechsel und Servermigration")
6. [Executive Summary](/docs/report_executive_summary.html "Abschlusssicht fuer Steering und Stakeholder")
7. [Business KPI](/docs/report_business_kpi.html "Kennzahlen, Formeln und Bezirksvergleich")

Wenn du stattdessen nur eine schnelle Management-Sicht brauchst, starte direkt mit [Executive Summary](/docs/report_executive_summary.html "Kurzfazit und Abschlussentscheidungen") und gehe danach in [Business KPI](/docs/report_business_kpi.html "Detailmetriken und Interpretationsregeln").

<div class="map-wrap">
  <h3>Dokumentenlandkarte</h3>
  <p>Aktuelle Struktur als durchgehender Lesepfad:</p>
  <svg viewBox="0 0 860 245" width="100%" role="img" aria-label="Dokumentenlandkarte">
    <defs>
      <marker id="arrow" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto">
        <path d="M0,0 L8,4 L0,8 Z" fill="#8b949e" />
      </marker>
    </defs>

    <rect x="10" y="70" width="110" height="50" rx="10" fill="#eafbf0" stroke="#95d5aa" />
    <text x="65" y="101" text-anchor="middle" font-size="13" fill="#1b4332">Features</text>

    <rect x="132" y="70" width="110" height="50" rx="10" fill="#f4f0ff" stroke="#b4a7e7" />
    <text x="187" y="101" text-anchor="middle" font-size="13" fill="#3f356b">Technik</text>

    <rect x="254" y="70" width="110" height="50" rx="10" fill="#fff5e9" stroke="#f2c17d" />
    <text x="309" y="101" text-anchor="middle" font-size="13" fill="#7f5539">DB Model</text>

    <rect x="376" y="70" width="110" height="50" rx="10" fill="#e7f0ff" stroke="#96b9f2" />
    <text x="431" y="101" text-anchor="middle" font-size="13" fill="#1f2a44">Import</text>

    <rect x="498" y="70" width="110" height="50" rx="10" fill="#f7f7f7" stroke="#c4c4c4" />
    <text x="553" y="101" text-anchor="middle" font-size="13" fill="#3f3f3f">Domain</text>

    <rect x="620" y="70" width="110" height="50" rx="10" fill="#edf6ff" stroke="#a5c8f0" />
    <text x="675" y="101" text-anchor="middle" font-size="12" fill="#1f4f8c">Executive Summary</text>

    <rect x="742" y="70" width="110" height="50" rx="10" fill="#eefdf5" stroke="#9edab9" />
    <text x="797" y="101" text-anchor="middle" font-size="12" fill="#1b6a43">Business KPI</text>

    <line x1="120" y1="95" x2="129" y2="95" stroke="#8b949e" stroke-width="1.6" marker-end="url(#arrow)" />
    <line x1="242" y1="95" x2="251" y2="95" stroke="#8b949e" stroke-width="1.6" marker-end="url(#arrow)" />
    <line x1="364" y1="95" x2="373" y2="95" stroke="#8b949e" stroke-width="1.6" marker-end="url(#arrow)" />
    <line x1="486" y1="95" x2="495" y2="95" stroke="#8b949e" stroke-width="1.6" marker-end="url(#arrow)" />
    <line x1="608" y1="95" x2="617" y2="95" stroke="#8b949e" stroke-width="1.6" marker-end="url(#arrow)" />
    <line x1="730" y1="95" x2="739" y2="95" stroke="#8b949e" stroke-width="1.6" marker-end="url(#arrow)" />
  </svg>
</div>
