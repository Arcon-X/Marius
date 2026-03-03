---
layout: default
title: Home
nav_order: 1
---

# Nearest Address Finder

This site documents the solution for finding the N nearest addresses from a list of ~2,000 Austrian addresses, starting from any given origin location.

---

## Documents

- [Nearest Address Finder — Full Report]({{ "/Address_Clustering_Report" | relative_url }})

---

## Quick Summary

| Phase | Method | Cost |
|-------|--------|------|
| Phase 1 | Geocode all addresses once, then KNN straight-line search | **$0** |
| Phase 2 | Real walking distance API for top N candidates | $0 on free tiers |

> Input: origin address + N → Output: N nearest addresses sorted by distance.

---

*Last updated: March 3, 2026*
