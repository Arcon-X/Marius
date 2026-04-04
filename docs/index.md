---
title: "NOVUM-ZIV — Dokumentations-Hub"
---

<style>
.site-header { display: none !important; }
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
</style>

# NOVUM-ZIV — Dokumentations-Hub

<div class="doc-nav" role="navigation" aria-label="Dokumentationsnavigation">
  <div class="doc-nav-title">Dokumentation</div>
  <div class="doc-nav-links">
    <a href="/docs/index.html" class="active">Hub</a>
    <a href="/docs/import_report.html">Import</a>
    <a href="/docs/features.html">Features</a>
    <a href="/docs/technik.html">Technik</a>
    <a href="/docs/db_model.html">DB</a>
    <a href="/SPEC.html">SPEC</a>
    <a href="/docs/domain.html">Domain</a>
    <a href="/docs/tests_businesscases.html">Tests BC</a>
    <a href="/tests/backend/README.html">Tests Backend</a>
  </div>
</div>

Alle Projekt-Reports sind hier zentral erreichbar.

## Reports

<div class="hub-grid">
  <div class="hub-card">
    <h3>📄 Adress-Import Report</h3>
    <p>Importstatistik, Geocoding-Methodik und Datenqualität.</p>
    <a href="/docs/import_report.html">Öffnen</a>
  </div>
  <div class="hub-card">
    <h3>📋 Feature-Dokumentation</h3>
    <p>Funktionale Beschreibung aller Kernmodule und Admin-Funktionen.</p>
    <a href="/docs/features.html">Öffnen</a>
  </div>
  <div class="hub-card">
    <h3>⚙️ Technische Dokumentation</h3>
    <p>Architektur, Betrieb, Security, Deployment und Kosten.</p>
    <a href="/docs/technik.html">Öffnen</a>
  </div>
  <div class="hub-card">
    <h3>🗄️ Datenbank-Modell</h3>
    <p>Tabellen, Beziehungen, Views, RPCs und Constraints.</p>
    <a href="/docs/db_model.html">Öffnen</a>
  </div>
  <div class="hub-card">
    <h3>📚 Gesamtspezifikation (SPEC)</h3>
    <p>Vollständige End-to-End Spezifikation des gesamten Projekts.</p>
    <a href="/SPEC.html">Öffnen</a>
  </div>
  <div class="hub-card">
    <h3>🌐 Domain konfigurieren</h3>
    <p>DNS/TLS, Migration, Ziel-Domain und Rollback-Strategie.</p>
    <a href="/docs/domain.html">Öffnen</a>
  </div>
  <div class="hub-card">
    <h3>🧪 Testreport nach Business-Cases</h3>
    <p>Ergebnisse nach fachlichen Szenarien inkl. Mobile-Checks.</p>
    <a href="/docs/tests_businesscases.html">Öffnen</a>
  </div>
  <div class="hub-card">
    <h3>🧪 Backend-Testdokumentation</h3>
    <p>Setup, Safety-Model und Ausführung der Live-API-Tests.</p>
    <a href="/tests/backend/README.html">Öffnen</a>
  </div>
</div>
