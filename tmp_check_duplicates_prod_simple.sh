#!/usr/bin/env bash
set -euo pipefail

echo active_duplicate_marks
sudo -u postgres psql -d novumziv -Atc "select count(*) from duplicate_markierungen where restored_at is null;"

echo duplicate_groups_all_rows
sudo -u postgres psql -d novumziv -Atc "with n as (select lower(trim(coalesce(plz,''))) plz_k, lower(regexp_replace(trim(coalesce(strasse,'')),'\\s+',' ','g')) str_k, lower(replace(trim(coalesce(hausnummer,'')),' ','')) hnr_k, lower(replace(trim(coalesce(zusatz,'')),' ','')) zus_k from adressen) select count(*) from (select plz_k,str_k,hnr_k,zus_k from n group by 1,2,3,4 having count(*)>1) g;"

echo duplicate_groups_search_pool
sudo -u postgres psql -d novumziv -Atc "with n as (select lower(trim(coalesce(plz,''))) plz_k, lower(regexp_replace(trim(coalesce(strasse,'')),'\\s+',' ','g')) str_k, lower(replace(trim(coalesce(hausnummer,'')),' ','')) hnr_k, lower(replace(trim(coalesce(zusatz,'')),' ','')) zus_k from adressen where status in ('verfuegbar','in_bearbeitung')) select count(*) from (select plz_k,str_k,hnr_k,zus_k from n group by 1,2,3,4 having count(*)>1) g;"

echo duplicate_rows_search_pool
sudo -u postgres psql -d novumziv -Atc "with n as (select lower(trim(coalesce(plz,''))) plz_k, lower(regexp_replace(trim(coalesce(strasse,'')),'\\s+',' ','g')) str_k, lower(replace(trim(coalesce(hausnummer,'')),' ','')) hnr_k, lower(replace(trim(coalesce(zusatz,'')),' ','')) zus_k from adressen where status in ('verfuegbar','in_bearbeitung')), g as (select plz_k,str_k,hnr_k,zus_k,count(*) c from n group by 1,2,3,4 having count(*)>1) select coalesce(sum(c),0) from g;"