#!/bin/bash
set -e
sudo -u postgres psql -d novumziv << 'ENDSQL'
-- Show current view definition
SELECT definition FROM pg_views WHERE schemaname='api' AND viewname='adressen';
ENDSQL
