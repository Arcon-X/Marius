SELECT 'active_marks_with_result' AS metric, COUNT(*) AS value
FROM duplicate_markierungen dm
WHERE dm.restored_at IS NULL
  AND EXISTS (
    SELECT 1 FROM protokoll p
    WHERE p.adressen_id = dm.adressen_id
      AND p.aktion IN ('waehlt_uns','waehlt_nicht','ueberlegt','kein_interesse_wahl','sonstige')
  );

WITH n AS (
  SELECT
    a.id,
    a.status,
    lower(trim(coalesce(a.plz,''))) AS plz_k,
    lower(regexp_replace(trim(coalesce(a.strasse,'')), '\\s+', ' ', 'g')) AS str_k,
    lower(replace(trim(coalesce(a.hausnummer,'')), ' ', '')) AS hnr_k,
    lower(replace(trim(coalesce(a.zusatz,'')), ' ', '')) AS zus_k,
    EXISTS (
      SELECT 1 FROM protokoll p
      WHERE p.adressen_id = a.id
        AND p.aktion IN ('waehlt_uns','waehlt_nicht','ueberlegt','kein_interesse_wahl','sonstige')
    ) AS has_result
  FROM adressen a
  WHERE a.status IN ('verfuegbar','in_bearbeitung')
), g AS (
  SELECT plz_k, str_k, hnr_k, zus_k
  FROM n
  GROUP BY 1,2,3,4
  HAVING COUNT(*) > 1
)
SELECT 'remaining_search_pool_rows_with_result' AS metric, COUNT(*) AS value
FROM n
JOIN g USING (plz_k, str_k, hnr_k, zus_k)
WHERE has_result;

WITH n AS (
  SELECT
    a.id,
    a.status,
    lower(trim(coalesce(a.plz,''))) AS plz_k,
    lower(regexp_replace(trim(coalesce(a.strasse,'')), '\\s+', ' ', 'g')) AS str_k,
    lower(replace(trim(coalesce(a.hausnummer,'')), ' ', '')) AS hnr_k,
    lower(replace(trim(coalesce(a.zusatz,'')), ' ', '')) AS zus_k,
    EXISTS (
      SELECT 1 FROM protokoll p
      WHERE p.adressen_id = a.id
        AND p.aktion IN ('waehlt_uns','waehlt_nicht','ueberlegt','kein_interesse_wahl','sonstige')
    ) AS has_result
  FROM adressen a
  WHERE a.status IN ('verfuegbar','in_bearbeitung')
), g AS (
  SELECT plz_k, str_k, hnr_k, zus_k
  FROM n
  GROUP BY 1,2,3,4
  HAVING COUNT(*) > 1
)
SELECT 'remaining_search_pool_rows_without_result' AS metric, COUNT(*) AS value
FROM n
JOIN g USING (plz_k, str_k, hnr_k, zus_k)
WHERE NOT has_result;