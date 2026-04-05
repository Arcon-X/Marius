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
.doc-nav-links a:focus-visible { outline: 2px solid #1f6feb; outline-offset: 2px; }
.table-wrap { overflow-x: auto; }
.table-wrap table { width: 100%; border-collapse: collapse; }
.table-wrap th, .table-wrap td { border: 1px solid #d0d7de; padding: .45rem .55rem; text-align: left; }
.table-wrap th { background: #f6f8fa; }
.note { border-left: 4px solid #0969da; background: #ddf4ff; padding: .6rem .8rem; border-radius: 4px; margin: .8rem 0; }
.warn { border-left: 4px solid #d1242f; background: #ffebe9; padding: .6rem .8rem; border-radius: 4px; margin: .8rem 0; }
.print-btn { border: 1px solid #1f6feb; color: #1f6feb; background: #fff; border-radius: 999px; padding: .35rem .8rem; font-weight: 700; cursor: pointer; }
.muted { color: #57606a; font-size: .85rem; }
.live-pill { display: inline-block; margin-left: .45rem; font-size: .72rem; font-weight: 700; color: #1f6feb; background: #ddf4ff; border: 1px solid #96d0ff; border-radius: 999px; padding: 1px 8px; }
@media print {
  .doc-nav, .print-wrap { display: none !important; }
  a[href]:after { content: "" !important; }
}
</style>

# Business KPI Report

<div class="doc-nav" role="navigation" aria-label="Dokumentationsnavigation">
  <div class="doc-nav-title">Dokumentation</div>
  <div class="doc-nav-links">
    <a href="/docs/features.html" title="Produktfunktionen und User-Flow">Features</a>
    <a href="/docs/technik.html" title="Technische Architektur, Betrieb und Sicherheit">Technik</a>
    <a href="/docs/db_model.html" title="Datenmodell, Views, RPCs und Constraints">DB Model</a>
    <a href="/docs/import_report.html" title="Datenherkunft, Geocoding und Qualitaet">Import Report</a>
    <a href="/docs/domain.html" title="Domain, TLS und Migrationsbetrieb">Domain</a>
    <a href="/docs/report_executive_summary.html" title="Management-Zusammenfassung fuer Abschluss">Executive Summary</a>
    <a href="/docs/report_business_kpi.html" class="active" aria-current="page" title="KPI-Vertiefung mit Bezirks- und Teamwerten">Business KPI</a>
  </div>
</div>

<div class="print-wrap" style="margin-bottom:.8rem">
  <button class="print-btn" onclick="window.print()">PDF exportieren</button>
</div>

**Stand:** 05.04.2026  
**Fokus:** Bezirksvergleich nach erledigten Adressen und Effizienzbewertung.

## Lesefluss-Einordnung

- Diese Seite ist die **Detail- und Mess-Ebene** des Abschlussberichts.
- Vorher: [Executive Summary](/docs/report_executive_summary.html "Management-Fazit und Abschlussentscheidungen")
- Methodischer Kontext: [Technik](/docs/technik.html "Sicherheits-, API- und Rollenlogik") und [DB Model](/docs/db_model.html "Datenstruktur hinter den KPI-Werten")
- Zurück zum Einstieg: [Hub](/docs/index.html "Gefuehrter Lesefluss ueber alle Kernseiten")

<div class="note" id="live-kpi-status">Lade Live-Reportdaten ...</div>

## 1. KPI-Definitionen

- **Erledigungsquote Bezirk** = $archiviert_{bezirk} / gesamt_{bezirk}$
- **Besuchsquote Bezirk** = $(archiviert + in\_bearbeitung)_{bezirk} / gesamt_{bezirk}$
- **Wählt-uns-Quote Bezirk** = $waehlt\_uns_{bezirk} / besucht_{bezirk}$
- **Team-Effizienz Bezirk** = $archiviert_{bezirk} / aktive\_mitglieder_{bezirk}$
- **Übernommen pro Benutzer** = Anzahl Protokoll-Einträge mit `aktion = uebernommen` je `benutzer_id`
- **Zurückgegeben pro Benutzer** = Anzahl Protokoll-Einträge mit `aktion = reaktiviert` und `notiz = "Zurückgegeben"` je `benutzer_id`
- **Rückgabequote pro Benutzer** = $zurueckgegeben_{user} / uebernommen_{user}$

<div class="note">
Datenbasis: `adressen` + `protokoll` nach der gleichen Korrektur-/Reaktivierungslogik wie im Archivbereich der App. Der Kennwert „Zurückgegeben" wird im Reporting bewusst aus `reaktiviert` + Notiz „Zurückgegeben" abgeleitet.
</div>

## 2. Bezirksmapping (PLZ → Bezirk)

- 1010→1, 1020→2, …, 1090→9, 1100→10, …, 1230→23
- Fehlende/ungültige PLZ werden separat als „Unzugeordnet“ geführt.

## 3. Bezirksvergleich (Template für Abschlussstichtag)

<div class="table-wrap" id="district-kpi-wrap"></div>

\* Effizienz = erledigt pro aktivem Teammitglied mit Aktivitäten im Bezirk.

## 4. Team-Event-KPIs (pro Benutzer)

<div class="table-wrap" id="team-kpi-wrap"></div>

<div class="muted" id="team-kpi-hint"></div>

- Für `Übernommen` zählen nur `protokoll`-Zeilen mit `aktion = uebernommen`.
- Für `Zurückgegeben` zählen nur `protokoll`-Zeilen mit `aktion = reaktiviert` und Notiz „Zurückgegeben".
- Bei `Übernommen = 0` wird die Rückgabequote als `n/a` ausgewiesen.

## 5. Interpretation (Management-Readout)

1. Top 3 Bezirke nach Erledigungsquote.
2. Bezirke mit hoher Aktivität, aber niedriger Wählt-uns-Quote.
3. Bezirke mit hoher Restlast (Gesamt - Erledigt).
4. Sofortmaßnahmen pro Cluster (hoch/mittel/niedrig).

## 6. Qualitätsregeln für Vergleichbarkeit

<div class="warn">
Bei sehr kleinen Fallzahlen (z. B. n &lt; 10) immer mit Vorsicht interpretieren und im Report markieren.
</div>

- Nur gültige Ergebnisse nach letzter Reaktivierung zählen.
- Korrigierte Ergebnisse überschreiben ältere Ergebnisse.
- Bezirkseffizienz nur aus aktiven Teammitgliedern mit Bezirksaktivität ableiten.
- Team-Rückgaben im Reporting nur über `reaktiviert` + Notiz „Zurückgegeben" zählen.

## 7. Export-Workflow

1. Abschlussstichtag fixieren.
2. KPI-Tabelle final befüllen.
3. Seite als PDF exportieren (`PDF exportieren`).
4. PDF im Abschlussprotokoll und Steering-Dossier ablegen.

<script>
(function(){
  const SB_URL='/api';
  const RESULT_ACTIONS=new Set(['waehlt_uns','waehlt_nicht','ueberlegt','kein_interesse_wahl','sonstige']);

  const q=(id)=>document.getElementById(id);
  const esc=(v)=>String(v==null?'':v).replace(/[&<>"']/g,(m)=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]));
  const pct=(num,den)=>den>0?((num/den)*100).toFixed(1).replace('.',',')+'%':'-';
  const fmtNum=(n)=>Number(n||0).toLocaleString('de-AT');

  function parseDistrict(plz){
    const p=String(plz||'').trim();
    if(!/^\d{4}$/.test(p))return null;
    const n=Number(p);
    if(n<1010||n>1230||n%10!==0)return null;
    const d=(n-1000)/10;
    if(d<1||d>23)return null;
    return d;
  }

  function getSessionToken(){
    try{
      const raw=sessionStorage.getItem('nv_session')||localStorage.getItem('nv_session');
      if(raw){
        const s=JSON.parse(raw);
        if(s&&s.token)return s.token;
      }
      const docsRaw=localStorage.getItem('nv_docs_token');
      if(docsRaw){
        const d=JSON.parse(docsRaw);
        if(d&&d.token&&d.exp&&Date.now()<d.exp)return d.token;
        localStorage.removeItem('nv_docs_token');
      }
      return null;
    }catch(_e){return null;}
  }

  async function fetchJson(url,token){
    const headers=token?{'Authorization':'Bearer '+token}:{ };
    const res=await fetch(url,{headers});
    if(!res.ok)throw new Error('HTTP '+res.status);
    return res.json();
  }

  async function loadData(){
    let adressen=[];
    let log=[];
    try{adressen=JSON.parse(localStorage.getItem('nv_adressen')||'[]');}catch(_e){adressen=[];}
    try{log=JSON.parse(localStorage.getItem('nv_protokoll')||'[]');}catch(_e){log=[];}

    const token=getSessionToken();
    if(!adressen.length){
      try{adressen=await fetchJson(SB_URL+'/adressen?select=*',token);}catch(_e){}
    }
    if(!log.length){
      try{log=await fetchJson(SB_URL+'/protokoll?select=*',token);}catch(_e){}
    }

    let users=[];
    try{users=JSON.parse(localStorage.getItem('nv_users_cache')||'[]');}catch(_e){users=[];}
    try{
      const apiUsers=await fetchJson(SB_URL+'/benutzer?select=id,name',token);
      if(Array.isArray(apiUsers)&&apiUsers.length){
        users=apiUsers;
        try{localStorage.setItem('nv_users_cache',JSON.stringify(apiUsers));}catch(_e){}
      }
    }catch(_e){}
    return {adressen,log,users};
  }

  function buildDistrictRows(adressen,log){
    const addrById=new Map(adressen.map(a=>[a.id,a]));
    const lastReakt={};
    log.forEach(l=>{
      if(l.aktion==='reaktiviert'){
        const t=new Date(l.zeitpunkt||0).getTime();
        if(!lastReakt[l.adressen_id]||t>lastReakt[l.adressen_id])lastReakt[l.adressen_id]=t;
      }
    });

    const latestResult={};
    log.forEach(l=>{
      if(!RESULT_ACTIONS.has(l.aktion))return;
      const cut=lastReakt[l.adressen_id]||0;
      const t=new Date(l.zeitpunkt||0).getTime();
      if(t<=cut)return;
      if(!latestResult[l.adressen_id]||t>latestResult[l.adressen_id].t)latestResult[l.adressen_id]={a:l.aktion,t};
    });

    const districts={};
    for(let d=1;d<=23;d++)districts[d]={total:0,inBearb:0,done:0,waehltUns:0,activeUsers:new Set()};
    const unknown={total:0,inBearb:0,done:0,waehltUns:0,activeUsers:new Set()};

    adressen.forEach(a=>{
      const d=parseDistrict(a.plz);
      const bucket=d?districts[d]:unknown;
      bucket.total++;
      if(a.status==='in_bearbeitung')bucket.inBearb++;
      if(a.status==='archiviert')bucket.done++;
      const res=latestResult[a.id];
      if(res&&res.a==='waehlt_uns')bucket.waehltUns++;
    });

    log.forEach(l=>{
      if(!l.benutzer_id)return;
      const a=addrById.get(l.adressen_id);
      if(!a)return;
      const d=parseDistrict(a.plz);
      (d?districts[d]:unknown).activeUsers.add(l.benutzer_id);
    });

    const rows=[];
    for(let d=1;d<=23;d++){
      const x=districts[d];
      const visited=x.done+x.inBearb;
      const eff=x.activeUsers.size?x.done/x.activeUsers.size:null;
      rows.push({
        name:String(d),
        plz:String(1000+d*10),
        total:x.total,
        inBearb:x.inBearb,
        done:x.done,
        donePct:pct(x.done,x.total),
        waehltUns:x.waehltUns,
        waehltUnsPct:pct(x.waehltUns,visited),
        eff:eff==null?'-':eff.toFixed(2).replace('.',',')
      });
    }
    const uVisited=unknown.done+unknown.inBearb;
    const uEff=unknown.activeUsers.size?unknown.done/unknown.activeUsers.size:null;
    rows.push({
      name:'Unzugeordnet',plz:'leer/invalid',total:unknown.total,inBearb:unknown.inBearb,done:unknown.done,
      donePct:pct(unknown.done,unknown.total),waehltUns:unknown.waehltUns,waehltUnsPct:pct(unknown.waehltUns,uVisited),
      eff:uEff==null?'-':uEff.toFixed(2).replace('.',',')
    });
    return rows;
  }

  function buildTeamRows(log,users){
    const names=new Map((users||[]).map(u=>[u.id,u.name||u.id]));
    const byUser={};
    log.forEach(l=>{
      if(!l.benutzer_id)return;
      if(!byUser[l.benutzer_id])byUser[l.benutzer_id]={taken:0,back:0};
      if(l.aktion==='uebernommen')byUser[l.benutzer_id].taken++;
      if(l.aktion==='reaktiviert'&&String(l.notiz||'').trim()==='Zurückgegeben')byUser[l.benutzer_id].back++;
    });
    return Object.entries(byUser)
      .map(([id,v])=>({
        name:names.get(id)||('User '+id.slice(0,8)),
        taken:v.taken,
        back:v.back,
        ratio:v.taken>0?((v.back/v.taken)*100).toFixed(1).replace('.',',')+'%':'n/a',
        hint:v.taken>0?'':'keine Übernahmen'
      }))
      .sort((a,b)=>b.taken-a.taken||b.back-a.back||a.name.localeCompare(b.name,'de'));
  }

  function renderDistrict(rows){
    const html=['<table><thead><tr><th>Bezirk</th><th>PLZ-Basis</th><th>Gesamt</th><th>In Bearbeitung</th><th>Erledigt</th><th>Erledigungsquote</th><th>Wählt-uns</th><th>Wählt-uns-Quote</th><th>Effizienz*</th></tr></thead><tbody>'];
    rows.forEach(r=>{
      html.push('<tr><td>'+esc(r.name)+'</td><td>'+esc(r.plz)+'</td><td>'+fmtNum(r.total)+'</td><td>'+fmtNum(r.inBearb)+'</td><td>'+fmtNum(r.done)+'</td><td>'+esc(r.donePct)+'</td><td>'+fmtNum(r.waehltUns)+'</td><td>'+esc(r.waehltUnsPct)+'</td><td>'+esc(r.eff)+'</td></tr>');
    });
    html.push('</tbody></table>');
    q('district-kpi-wrap').innerHTML=html.join('');
  }

  function renderTeam(rows){
    if(!rows.length){
      q('team-kpi-wrap').innerHTML='<table><tbody><tr><td>Keine Team-Events verfügbar.</td></tr></tbody></table>';
      return;
    }
    const html=['<table><thead><tr><th>Benutzer</th><th>Übernommen</th><th>Zurückgegeben</th><th>Rückgabequote</th><th>Hinweis</th></tr></thead><tbody>'];
    rows.forEach(r=>{
      html.push('<tr><td>'+esc(r.name)+'</td><td>'+fmtNum(r.taken)+'</td><td>'+fmtNum(r.back)+'</td><td>'+esc(r.ratio)+'</td><td>'+esc(r.hint||'-')+'</td></tr>');
    });
    html.push('</tbody></table>');
    q('team-kpi-wrap').innerHTML=html.join('');
  }

  (async function init(){
    try{
      const {adressen,log,users}=await loadData();
      if(!adressen.length){
        q('live-kpi-status').innerHTML='Keine Daten gefunden. Bitte App einmal öffnen und synchronisieren, dann den Report neu laden.';
        return;
      }
      renderDistrict(buildDistrictRows(adressen,log));
      renderTeam(buildTeamRows(log,users));
      q('live-kpi-status').innerHTML='Live-Reportdaten geladen <span class="live-pill">LIVE</span>';
      q('team-kpi-hint').textContent='Quelle: lokaler Cache (nv_adressen/nv_protokoll) mit API-Fallback; Benutzer-Namen werden bei verfügbarer Auth ergänzt.';
    }catch(err){
      q('live-kpi-status').textContent='Live-Auswertung fehlgeschlagen: '+(err&&err.message?err.message:'Unbekannter Fehler');
    }
  })();
})();
</script>
