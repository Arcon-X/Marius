---
layout: default
title: Address Clustering & Walking Distance Report
---

# Address Clustering & Walking Distance — Solution Report

**Date:** March 3, 2026  
**Prepared by:** GitHub Copilot  
**Topic:** Automated grouping of ~2,000 addresses by walkable proximity

---

## Business Requirement

The team needs to process a list of approximately **2,000 Austrian addresses** (stored in Excel/CSV) and group them into **clusters of geographically nearby addresses** to optimize walking routes for field work (e.g. canvassing, delivery, tariff assignments).

**Example input addresses:**

| ZIP  | City | Street                    |
|------|------|---------------------------|
| 1190 | Wien | Heiligenstädter Straße 69/10 |
| 1200 | Wien | Jägerstraße 23/4          |
| 1220 | Wien | Trondheimgasse sa/1/14    |

---

## Recommended Solution: Two-Phase Approach

### Phase 1 — Straight-line Clustering (Free, immediate)

**How it works:**
1. Each address is **geocoded** (converted to GPS coordinates) using OpenStreetMap's Nominatim service — no cost, no API key required
2. Addresses are grouped using **DBSCAN clustering** (a proximity-based algorithm) based on configurable radius (e.g. 500–800 meters)
3. Results are exported back to Excel with a `Cluster_ID` column added

**Technical stack:**

| Component | Tool | Cost |
|-----------|------|------|
| Geocoding | Nominatim (OpenStreetMap) | Free |
| Clustering | scikit-learn (Python) | Free |
| Input/Output | pandas + openpyxl | Free |
| Language | Python 3 | Free |

**Estimated geocoding time:** ~33 minutes for 2,000 addresses (Nominatim enforces 1 request/second)  
> Geocoding results will be cached locally — subsequent runs are instant.

**Accuracy note:** Crow-flies distance does not account for physical obstacles (rivers, parks, one-way streets). For Vienna (Wien), urban density makes this generally accurate enough for clustering purposes.

---

### Phase 2 — Actual Walking Distance Refinement (Optional, adds cost)

If real street-level walking distances are required, the following providers can be used **within already-identified clusters** (to minimize API call volume):

| Provider | Free Tier | Est. Cost at Scale | Notes |
|---|---|---|---|
| **Google Maps Distance Matrix API** | $200/month credit | Very high for full matrix (~$20,000+) | Not recommended for full 2,000×2,000 matrix |
| **OpenRouteService (ORS)** | 500 requests/day | ~$50/month (paid plan) | Good quality, REST API, EU-based |
| **HERE Maps Matrix Routing** | 1,000 requests/day free | Similar to ORS | |
| **OSRM (self-hosted)** | Unlimited (self-hosted) | Server cost only (~$0 if existing infra) | Best for scale; uses free OSM data |

**Smart hybrid strategy (cost-optimized):**
- Use Phase 1 (free) to create clusters
- Only call a walking API **within each cluster** to refine internal ordering
- This reduces required API calls from millions to a few thousand — cutting costs by 99%+

---

## Recommended Phased Rollout

```
Phase 1 (Week 1):  Straight-line geocoding + DBSCAN clustering  →  $0 cost
Phase 2 (Week 2):  Evaluate cluster quality with team
Phase 3 (TBD):     If needed, add walking API for intra-cluster sorting
```

---

## Output

The script will produce an Excel file with the original data plus:

| Column Added | Description |
|---|---|
| `Latitude` | GPS latitude of the address |
| `Longitude` | GPS longitude of the address |
| `Cluster_ID` | Group number (addresses in the same cluster are walkably close) |

Optionally, an **interactive HTML map** can also be generated to visually review clusters before use.

---

## Next Steps

- [ ] Confirm target clustering radius (e.g. 500m / 800m / 1km per cluster)
- [ ] Confirm output format (Excel only, or also HTML map)
- [ ] Provide sample Excel/CSV file for development
- [ ] Decide if Phase 2 (real walking distance) is needed after Phase 1 results are reviewed

---

## Summary

| | Phase 1 (Straight-line) | Phase 2 (Walking API) |
|---|---|---|
| **Cost** | $0 | $0–$50+/month depending on provider |
| **Accuracy** | Good (±10–15% vs real walking) | High (real street routing) |
| **Speed** | ~33 min first run, instant after | Hours to days depending on volume |
| **Complexity** | Low | Medium |
| **Recommended?** | Yes — start here | Only if Phase 1 is insufficient |
