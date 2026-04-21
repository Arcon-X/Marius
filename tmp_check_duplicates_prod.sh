#!/usr/bin/env bash
set -euo pipefail
sudo -u postgres psql -d novumziv <<'"'"'SQL'"'"'
\pset tuples_only on
\pset format aligned

SELECT 'active_duplicate_marks' AS metric, COUNT(*)::text AS value
FROM duplicate_markierungen
WHERE restored_at IS NULL;

WITH n AS (
  SELECT
    id,
    lower(trim(coalesce(plz,''))) AS plz_k,
    lower(regexp_replace(trim(coalesce(strasse,'')), '\\s+', ' ', 'g')) AS str_k,
    lower(replace(trim(coalesce(hausnummer,'')), ' ', '')) AS hnr_k,
    lower(replace(trim(coalesce(zusatz,'')), ' ', '')) AS zus_k,
    status
  FROM adressen
)
SELECT 'duplicate_groups_all_rows' AS metric, COUNT(*)::text AS value
FROM (
  SELECT plz_k, str_k, hnr_k, zus_k
  FROM n
  GROUP BY 1,2,3,4
  HAVING COUNT(*) > 1
) g;

WITH n AS (
  SELECT
    id,
    lower(trim(coalesce(plz,''))) AS plz_k,
    lower(regexp_replace(trim(coalesce(strasse,'')), '\\s+', ' ', 'g')) AS str_k,
    lower(replace(trim(coalesce(hausnummer,'')), ' ', '')) AS hnr_k,
    lower(replace(trim(coalesce(zusatz,'')), ' ', '')) AS zus_k,
    status
  FROM adressen
  WHERE status IN ('verfuegbar','in_bearbeitung')
)
SELECT 'duplicate_groups_search_pool' AS metric, COUNT(*)::text AS value
FROM (
  SELECT plz_k, str_k, hnr_k, zus_k
  FROM n
  GROUP BY 1,2,3,4
  HAVING COUNT(*) > 1
) g;

WITH n AS (
  SELECT
    id,
    lower(trim(coalesce(plz,''))) AS plz_k,
    lower(regexp_replace(trim(coalesce(strasse,'')), '\\s+', ' ', 'g')) AS str_k,
    lower(replace(trim(coalesce(hausnummer,'')), ' ', '')) AS hnr_k,
    lower(replace(trim(coalesce(zusatz,'')), ' ', '')) AS zus_k,
    status
  FROM adressen
  WHERE status IN ('verfuegbar','in_bearbeitung')
), g AS (
  SELECT plz_k, str_k, hnr_k, zus_k, COUNT(*) AS c
  FROM n
  GROUP BY 1,2,3,4
  HAVING COUNT(*) > 1
)
SELECT 'duplicate_rows_search_pool' AS metric, COALESCE(SUM(c),0)::text AS value
FROM g;
SQL