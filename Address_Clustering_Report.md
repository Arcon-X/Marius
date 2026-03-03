---
layout: default
title: Nearest Address Finder — Solution Report
---

# Nearest Address Finder — Solution Report

**Date:** March 3, 2026  
**Prepared by:** GitHub Copilot  
**Topic:** Find the N nearest addresses from a list of ~2,000 based on a given origin location

---

## Business Requirement

The team maintains a list of approximately **2,000 Austrian addresses** (stored in Excel/CSV). Given any **origin address** and a desired **count N**, the system must return the **N nearest addresses** from the list — sorted by distance from the origin.

**Example:** Starting from the office at Jägerstraße 23/4, 1200 Wien — find the 5 nearest addresses from the full list.

**Example address list:**

| ZIP  | City | Street                    |
|------|------|---------------------------|
| 1190 | Wien | Heiligenstädter Straße 69/10 |
| 1200 | Wien | Jägerstraße 23/4          |
| 1220 | Wien | Trondheimgasse sa/1/14    |

**Use cases:** field work planning, canvassing route scheduling, tariff assignment optimization.

---

## Recommended Solution: Two-Phase Approach

### Phase 1 — Straight-line KNN Search (Free, immediate)

**How it works:**
1. Each address in the list is **geocoded once** (converted to GPS coordinates) using OpenStreetMap's Nominatim service — no cost, no API key required. Results are cached locally.
2. The **origin address** is also geocoded (one request).
3. Straight-line (Haversine) distances are calculated from the origin to every address in the list.
4. The list is **sorted by distance** and the top N addresses are returned.
5. Results are exported to Excel, sorted nearest-first.

**Example output for N=5:**

| Rank | ZIP  | City | Street | Distance |
|------|------|------|--------|----------|
| 1 | 1200 | Wien | Grünentorgasse 12 | 180 m |
| 2 | 1200 | Wien | Wallensteinstraße 5/3 | 340 m |
| 3 | 1190 | Wien | Heiligenstädter Straße 69/10 | 610 m |
| 4 | 1200 | Wien | Dresdner Straße 44 | 820 m |
| 5 | 1210 | Wien | Floridsdorfer Hauptstraße 1 | 1.1 km |

**Technical stack:**

| Component | Tool | Cost |
|-----------|------|------|
| Geocoding | Nominatim (OpenStreetMap) | Free |
| KNN search | scipy / numpy (Haversine) | Free |
| Input/Output | pandas + openpyxl | Free |
| Language | Python 3 | Free |

**Estimated geocoding time:** ~33 minutes for 2,000 addresses (Nominatim enforces 1 request/second)  
> Geocoding results are cached in a local CSV — subsequent queries against the same list are **instant**.

**Accuracy note:** Straight-line distance does not account for physical obstacles (rivers, parks, one-way streets). For Vienna (Wien), urban density makes this accurate to within 10–15% of real walking distance.

---

### Phase 2 — Actual Walking Distance Refinement (Optional, adds cost)

If real street-level walking distances are required (e.g. the origin is near a river or park that skews straight-line results), a routing API can be called for **only the top N candidates** returned by Phase 1 — keeping API call volume minimal.

| Provider | Free Tier | Cost per query batch (N=5) | Notes |
|---|---|---|---|
| **Google Maps Distance Matrix API** | $200/month credit | ~$0.005 per query | Easy to use, very accurate |
| **OpenRouteService (ORS)** | 500 requests/day free | ~$0 on free tier for low volume | EU-based, good for Austria |
| **HERE Maps Matrix Routing** | 1,000 requests/day free | ~$0 on free tier | |
| **OSRM (self-hosted)** | Unlimited | Server cost only | Best if querying thousands of times/day |

**Smart hybrid strategy (cost-optimized):**
- Phase 1 (free) narrows 2,000 addresses down to top 20 candidates using straight-line distance
- Phase 2 calls the walking API for only those 20 candidates to get precise results
- Final top N are returned sorted by real walking distance
- This reduces API calls from 2,000 to just 20 per query — cutting costs by **99%**

---

## Recommended Phased Rollout

```
Phase 1 (Week 1):  Geocode all 2,000 addresses + build KNN query tool  →  $0 cost
Phase 2 (Week 2):  Test queries with real origin addresses, review results
Phase 3 (TBD):     Add walking API refinement if straight-line accuracy is insufficient
```

---

## Output

The tool accepts:
- **Origin address** (ZIP + City + Street, or free text)
- **N** — number of nearest addresses to return

And produces a sorted Excel output:

| Column | Description |
|---|---|
| `Rank` | 1 = nearest, 2 = second nearest, etc. |
| `ZIP` | Postal code |
| `City` | City |
| `Street` | Street address |
| `Latitude` | GPS latitude |
| `Longitude` | GPS longitude |
| `Distance_m` | Straight-line distance from origin in meters |
| `Walking_m` *(Phase 2)* | Real walking distance in meters (optional) |

Optionally, an **interactive HTML map** can also be generated showing the origin pin and the N nearest addresses.

---

## Next Steps

- [ ] Confirm default value of N (e.g. return 5 nearest? 10? configurable per query?)
- [ ] Confirm output format (Excel only, or also HTML map with pins)
- [ ] Provide sample Excel/CSV file with the 2,000 addresses for development
- [ ] Decide if Phase 2 (real walking distance) is needed after Phase 1 results are reviewed

---

## Summary

| | Phase 1 (Straight-line KNN) | Phase 2 (Walking API refinement) |
|---|---|---|
| **Cost** | $0 | $0 on free tiers for low volume |
| **Accuracy** | Good (±10–15% vs real walking) | High (real street routing) |
| **Speed** | ~33 min geocoding (once), then instant | +1–2 sec per query for API call |
| **Complexity** | Low | Low–Medium |
| **Recommended?** | Yes — start here | Add only if accuracy is critical |

---

## How It Works — Simple Flow

```
User provides:  "Jägerstraße 23/4, 1200 Wien"  +  N = 5
        ↓
Geocode origin address  →  (lat, lon)
        ↓
Calculate distance from origin to all 2,000 addresses
        ↓
Sort by distance, return top 5
        ↓
Export to Excel + optional HTML map
```

---

## Scale Estimate: 10 Workers, Daily Route Planning

### Assumptions

| Parameter | Value |
|---|---|
| Field workers | 10 |
| Addresses in pool | 2,000 |
| Addresses visited per worker per day | ~15 |
| KNN queries per worker per day | 1 (morning plan) + 1 re-plan midday = **2** |
| N (nearest addresses returned) | 5 |
| Working days per month | 22 |

---

### Request Volume Breakdown

#### Geocoding Requests (Nominatim / OpenStreetMap)

| Event | Requests | Frequency |
|---|---|---|
| Initial setup — geocode all 2,000 addresses | 2,000 | **Once only**, then cached |
| Daily — geocode each worker's origin (start location) | 10 | Per day |
| Daily — re-plan midday (optional) | 10 | Per day |
| **Total daily (after setup)** | **~20 requests/day** | |
| **Total monthly** | **~440 requests/month** | |

> Nominatim allows ~1 request/second and is designed for reasonable use — 20 req/day is negligible.

---

#### KNN Computation — Phase 1 Straight-line (No API)

All math runs **locally** in Python. Zero external requests per query.

| Event | API calls |
|---|---|
| Calculate distance to all 2,000 addresses | **0** — computed on-device |
| Sort and return top 5 | **0** |
| **Cost** | **$0 forever** |

---

#### Walking Distance Refinement — Phase 2 (Optional API)

Strategy: narrow to top 20 candidates via straight-line, then call walking API for only those 20.

| Event | Elements per query | Queries/day | Elements/day |
|---|---|---|---|
| 10 workers × 2 queries | 20 candidates | 20 queries | **400 elements/day** |
| Monthly (22 days) | | | **~8,800 elements/month** |

**Cost per provider:**

| Provider | Free Tier | Monthly usage | Monthly cost |
|---|---|---|---|
| **Nominatim + Phase 1 only** | Unlimited | 440 geocodes | **$0** |
| **OpenRouteService (ORS)** | 500 req/day | 400 elements/day | **$0** (well within free tier) |
| **Google Maps Distance Matrix** | $200 credit/month | 8,800 elements × $0.005 | **~$0.44/month** |
| **OSRM self-hosted** | Unlimited | Unlimited | **$0** (server cost only) |

---

### Coverage — How Long to Visit All 2,000 Addresses?

```
10 workers × 15 visits/day = 150 addresses covered per day
2,000 addresses ÷ 150 per day = ~13–14 working days ≈ 3 weeks
```

> Workers naturally gravitate toward the same geographic zones if starting from similar origins — use different starting points per worker to maximize daily coverage spread.

---

### Summary — Is Free Tier Sufficient?

| Metric | Free Tier Limit | Our Usage | OK? |
|---|---|---|---|
| Nominatim geocoding | ~1,000 req/day safe | 20 req/day | ✅ Yes |
| ORS walking API | 500 req/day | ~20 req/day | ✅ Yes |
| Google Maps credit | $200/month | ~$0.44/month | ✅ Yes |

**Conclusion: 10 workers doing daily route planning against 2,000 addresses costs $0/month on free tiers. Even with Google Maps, the cost is under $1/month.**
