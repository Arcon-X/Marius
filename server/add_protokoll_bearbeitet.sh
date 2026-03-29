#!/bin/bash
# Add 'bearbeitet' to protokoll.aktion constraint (for address edit history)
set -e

sudo -u postgres psql -d novumziv << 'ENDSQL'
-- Drop old constraint and add updated one including 'bearbeitet'
ALTER TABLE protokoll DROP CONSTRAINT IF EXISTS protokoll_aktion_check;
ALTER TABLE protokoll ADD CONSTRAINT protokoll_aktion_check CHECK (aktion IN (
  'uebernommen','waehlt_uns','waehlt_nicht','ueberlegt',
  'kein_interesse_wahl','sonstige','reaktiviert','bearbeitet'
));

\echo '=== Constraint updated ==='
SELECT constraint_name, check_clause
FROM information_schema.check_constraints
WHERE constraint_name='protokoll_aktion_check';
ENDSQL
echo "Done."
