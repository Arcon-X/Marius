---
title: "NOVUM-ZIV — Business KPI Report"
---

<style>
.site-header { display: none !important; }
.doc-nav { position: sticky; top: .5rem; z-index: 20; background: #fff; border: 1px solid #d0d7de; border-radius: 10px; padding: .7rem; margin: .2rem 0 1rem 0; box-shadow: 0 2px 8px rgba(0,0,0,.05); }
.doc-nav-title { font-size: .8rem; color: #57606a; font-weight: 700; margin-bottom: .45rem; }
.doc-nav-links { display: flex; gap: .4rem; overflow-x: auto; padding-bottom: .15rem; }
.doc-nav-links a { text-decoration: none; border: 1px solid #d0d7de; background: #f6f8fa; color: #24292f; border-radius: 999px; padding: .32rem .72rem; white-space: nowrap; font-size: .82rem; font-weight: 600; }
.doc-nav-links a.active { background: #1f6feb; border-color: #1f6feb; color: #fff; }
.table-wrap { overflow-x: auto; }
.table-wrap table { width: 100%; border-collapse: collapse; }
.table-wrap th, .table-wrap td { border: 1px solid #d0d7de; padding: .45rem .55rem; text-align: left; }
.table-wrap th { background: #f6f8fa; }
.note { border-left: 4px solid #0969da; background: #ddf4ff; padding: .6rem .8rem; border-radius: 4px; margin: .8rem 0; }
.warn { border-left: 4px solid #d1242f; background: #ffebe9; padding: .6rem .8rem; border-radius: 4px; margin: .8rem 0; }
.print-btn { border: 1px solid #1f6feb; color: #1f6feb; background: #fff; border-radius: 999px; padding: .35rem .8rem; font-weight: 700; cursor: pointer; }
@media print {
  .doc-nav, .print-wrap { display: none !important; }
  a[href]:after { content: "" !important; }
}
</style>

# Business KPI Report

<div class="doc-nav" role="navigation" aria-label="Dokumentationsnavigation">
  <div class="doc-nav-title">Dokumentation</div>
  <div class="doc-nav-links">
    <a href="/docs/index.html">Hub</a>
    <a href="/docs/report_executive_summary.html">Exec</a>
    <a href="/docs/report_business_kpi.html" class="active">KPI</a>
    <a href="/docs/tests_businesscases.html">Tests BC</a>
    <a href="/SPEC.html">SPEC</a>
  </div>
</div>

<div class="print-wrap" style="margin-bottom:.8rem">
  <button class="print-btn" onclick="window.print()">PDF exportieren</button>
</div>

**Stand:** 04.04.2026  
**Fokus:** Bezirksvergleich nach erledigten Adressen und Effizienzbewertung.

## 1. KPI-Definitionen

- **Erledigungsquote Bezirk** = $archiviert_{bezirk} / gesamt_{bezirk}$
- **Besuchsquote Bezirk** = $(archiviert + in\_bearbeitung)_{bezirk} / gesamt_{bezirk}$
- **Wählt-uns-Quote Bezirk** = $waehlt\_uns_{bezirk} / besucht_{bezirk}$
- **Team-Effizienz Bezirk** = $archiviert_{bezirk} / aktive\_mitglieder_{bezirk}$

<div class="note">
Datenbasis: `adressen` + `protokoll` nach der gleichen Korrektur-/Reaktivierungslogik wie im Archivbereich der App.
</div>

## 2. Bezirksmapping (PLZ → Bezirk)

- 1010→1, 1020→2, …, 1090→9, 1100→10, …, 1230→23
- Fehlende/ungültige PLZ werden separat als „Unzugeordnet“ geführt.

## 3. Bezirksvergleich (Template für Abschlussstichtag)

<div class="table-wrap">

| Bezirk | PLZ-Basis | Gesamt | In Bearbeitung | Erledigt | Erledigungsquote | Wählt-uns | Wählt-uns-Quote | Effizienz* |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| 1 | 1010 | - | - | - | - | - | - | - |
| 2 | 1020 | - | - | - | - | - | - | - |
| 3 | 1030 | - | - | - | - | - | - | - |
| ... | ... | ... | ... | ... | ... | ... | ... | ... |
| 23 | 1230 | - | - | - | - | - | - | - |
| Unzugeordnet | leer/invalid | - | - | - | - | - | - | - |

</div>

\* Effizienz = erledigt pro aktivem Teammitglied mit Aktivitäten im Bezirk.

## 4. Interpretation (Management-Readout)

1. Top 3 Bezirke nach Erledigungsquote.
2. Bezirke mit hoher Aktivität, aber niedriger Wählt-uns-Quote.
3. Bezirke mit hoher Restlast (Gesamt - Erledigt).
4. Sofortmaßnahmen pro Cluster (hoch/mittel/niedrig).

## 5. Qualitätsregeln für Vergleichbarkeit

<div class="warn">
Bei sehr kleinen Fallzahlen (z. B. n &lt; 10) immer mit Vorsicht interpretieren und im Report markieren.
</div>

- Nur gültige Ergebnisse nach letzter Reaktivierung zählen.
- Korrigierte Ergebnisse überschreiben ältere Ergebnisse.
- Bezirkseffizienz nur aus aktiven Teammitgliedern mit Bezirksaktivität ableiten.

## 6. Export-Workflow

1. Abschlussstichtag fixieren.
2. KPI-Tabelle final befüllen.
3. Seite als PDF exportieren (`PDF exportieren`).
4. PDF im Abschlussprotokoll und Steering-Dossier ablegen.
