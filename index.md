---
layout: default
title: Startseite
nav_order: 1
---

# Nächstgelegene Adressen — Tool

Diese Seite dokumentiert die Lösung zur Ermittlung der N nächstgelegenen Adressen aus einer Liste von ca. 2.000 österreichischen Adressen, ausgehend von einem beliebigen Startpunkt.

---

## Dokumente

- [Nächstgelegene Adressen — Vollständiger Lösungsbericht]({{ "/Address_Clustering_Report" | relative_url }})

---

## Kurzübersicht

| Phase | Methode | Kosten |
|-------|---------|--------|
| Phase 1 | Einmalige Geokodierung aller Adressen, dann KNN-Luftliniensuche | **$0** |
| Phase 2 | Echte Gehstrecken-API für die Top-N Kandidaten | $0 im kostenlosen Tarif |

> Eingabe: Startadresse + N → Ausgabe: N nächstgelegene Adressen, sortiert nach Entfernung.

---

*Last updated: March 3, 2026*
