WITH n AS (
  SELECT
    a.id,
    a.status,
    a.benutzer_id,
    a.reserviert_am,
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
), rem AS (
  SELECT n.*
  FROM n JOIN g USING (plz_k, str_k, hnr_k, zus_k)
  WHERE NOT n.has_result
)
SELECT status, (benutzer_id IS NOT NULL) AS has_benutzer, (reserviert_am IS NOT NULL) AS has_reserviert, COUNT(*)
FROM rem
GROUP BY 1,2,3
ORDER BY 4 DESC;