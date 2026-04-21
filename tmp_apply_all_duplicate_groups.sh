#!/usr/bin/env bash
set -euo pipefail

sudo -u postgres psql -d novumziv <<'"'"'SQL'"'"'
DO $$
DECLARE
  v_admin_id uuid;
  rec record;
  r record;
  v_total_groups int := 0;
  v_groups_with_candidates int := 0;
  v_total_candidates int := 0;
  v_marked int := 0;
  v_skipped int := 0;
  v_candidates_with_result int := 0;
BEGIN
  SELECT id INTO v_admin_id
  FROM benutzer
  WHERE rolle = 'admin'
  ORDER BY created_at NULLS LAST, id
  LIMIT 1;

  IF v_admin_id IS NULL THEN
    RAISE EXCEPTION 'Kein Admin-Benutzer gefunden.';
  END IF;

  CREATE TEMP TABLE tmp_dup_candidates (
    adressen_id uuid PRIMARY KEY,
    duplicate_group text,
    has_result boolean
  ) ON COMMIT DROP;

  WITH base AS (
    SELECT
      a.id,
      a.status,
      lower(trim(coalesce(a.plz,''))) AS plz_k,
      lower(regexp_replace(trim(coalesce(a.strasse,'')), '\\s+', ' ', 'g')) AS str_k,
      lower(replace(trim(coalesce(a.hausnummer,'')), ' ', '')) AS hnr_k,
      lower(replace(trim(coalesce(a.zusatz,'')), ' ', '')) AS zus_k,
      EXISTS (
        SELECT 1
        FROM protokoll p
        WHERE p.adressen_id = a.id
          AND p.aktion IN ('waehlt_uns','waehlt_nicht','ueberlegt','kein_interesse_wahl','sonstige')
      ) AS has_result
    FROM adressen a
  ),
  dup_groups AS (
    SELECT plz_k, str_k, hnr_k, zus_k, COUNT(*) AS c
    FROM base
    GROUP BY 1,2,3,4
    HAVING COUNT(*) > 1
  ),
  grouped AS (
    SELECT
      b.*,
      (b.plz_k || '|' || b.str_k || '|' || b.hnr_k || '|' || b.zus_k) AS dup_group,
      ROW_NUMBER() OVER (
        PARTITION BY b.plz_k, b.str_k, b.hnr_k, b.zus_k
        ORDER BY
          CASE WHEN b.has_result THEN 0 ELSE 1 END,
          CASE b.status
            WHEN 'in_bearbeitung' THEN 0
            WHEN 'verfuegbar' THEN 1
            WHEN 'archiviert' THEN 2
            ELSE 3
          END,
          b.id
      ) AS rn
    FROM base b
    JOIN dup_groups g
      ON g.plz_k = b.plz_k
     AND g.str_k = b.str_k
     AND g.hnr_k = b.hnr_k
     AND g.zus_k = b.zus_k
  )
  INSERT INTO tmp_dup_candidates (adressen_id, duplicate_group, has_result)
  SELECT id, dup_group, has_result
  FROM grouped
  WHERE rn > 1;

  SELECT COUNT(*) INTO v_total_candidates FROM tmp_dup_candidates;
  SELECT COUNT(*) INTO v_candidates_with_result FROM tmp_dup_candidates WHERE has_result;

  SELECT COUNT(*) INTO v_total_groups
  FROM (
    SELECT duplicate_group
    FROM tmp_dup_candidates
    GROUP BY duplicate_group
  ) s;

  SELECT COUNT(*) INTO v_groups_with_candidates
  FROM (
    SELECT duplicate_group
    FROM tmp_dup_candidates
    WHERE has_result = false
    GROUP BY duplicate_group
  ) s;

  FOR rec IN
    SELECT adressen_id, duplicate_group
    FROM tmp_dup_candidates
    WHERE has_result = false
    ORDER BY duplicate_group, adressen_id
  LOOP
    SELECT * INTO r
    FROM api.mark_duplicate_adresse(
      rec.adressen_id,
      v_admin_id,
      rec.duplicate_group,
      'auto duplicate cleanup all groups 2026-04-21'
    );

    IF r.status = 'marked' THEN
      v_marked := v_marked + 1;
    ELSE
      v_skipped := v_skipped + 1;
    END IF;
  END LOOP;

  RAISE NOTICE 'admin_id=%', v_admin_id;
  RAISE NOTICE 'total_duplicate_groups_with_rn_gt1_rows=%', v_total_groups;
  RAISE NOTICE 'groups_with_markable_candidates=%', v_groups_with_candidates;
  RAISE NOTICE 'total_candidates_rn_gt1=%', v_total_candidates;
  RAISE NOTICE 'candidates_with_result_not_touched=%', v_candidates_with_result;
  RAISE NOTICE 'marked=% skipped=%', v_marked, v_skipped;
END $$;

SELECT 'active_duplicate_marks' AS metric, COUNT(*) AS value
FROM duplicate_markierungen
WHERE restored_at IS NULL;

SELECT 'search_pool_duplicate_groups' AS metric, COUNT(*) AS value
FROM (
  WITH n AS (
    SELECT
      lower(trim(coalesce(plz,''))) AS plz_k,
      lower(regexp_replace(trim(coalesce(strasse,'')), '\\s+', ' ', 'g')) AS str_k,
      lower(replace(trim(coalesce(hausnummer,'')), ' ', '')) AS hnr_k,
      lower(replace(trim(coalesce(zusatz,'')), ' ', '')) AS zus_k
    FROM adressen
    WHERE status IN ('verfuegbar','in_bearbeitung')
  )
  SELECT plz_k, str_k, hnr_k, zus_k
  FROM n
  GROUP BY 1,2,3,4
  HAVING COUNT(*) > 1
) g;
SQL