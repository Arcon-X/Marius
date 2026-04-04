#!/usr/bin/env bash
set -euo pipefail

LOGIN_EMAIL="${LOGIN_EMAIL:-}"
LOGIN_PASS="${LOGIN_PASS:-}"

if [[ -z "$LOGIN_EMAIL" || -z "$LOGIN_PASS" ]]; then
	echo "ERROR: LOGIN_EMAIL und LOGIN_PASS muessen gesetzt sein."
	exit 1
fi

sudo -u postgres psql -d novumziv -v ON_ERROR_STOP=1 -c "SELECT api.login('${LOGIN_EMAIL}', '${LOGIN_PASS}');"