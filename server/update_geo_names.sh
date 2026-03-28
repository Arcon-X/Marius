#!/bin/bash
# NOVUM-ZIV — geo_name für alle Adressen mit Koordinaten aktualisieren
# Nutzt Nominatim Reverse-Geocoding → Teil nach Straßenname (Viertel, Bezirk)
# Direkt auf dem Server via psql ausführen
set -e

DB="novumziv"
TOTAL=$(sudo -u postgres psql -t -A -d $DB -c \
  "SELECT count(*) FROM adressen WHERE lat IS NOT NULL AND lon IS NOT NULL;")
echo "Adressen mit Koordinaten: $TOTAL"

UPDATED=0
ERRORS=0
SKIPPED=0

# Adressen mit Koordinaten holen (id, lat, lon, strasse, hausnummer)
sudo -u postgres psql -t -A -F '|' -d $DB -c \
  "SELECT id, lat, lon, strasse, hausnummer FROM adressen WHERE lat IS NOT NULL AND lon IS NOT NULL ORDER BY id;" \
| while IFS='|' read -r ID LAT LON STRASSE HNR; do
  [ -z "$ID" ] && continue

  # Nominatim Reverse Geocoding
  RESULT=$(curl -s --max-time 10 \
    "https://nominatim.openstreetmap.org/reverse?lat=${LAT}&lon=${LON}&format=json&accept-language=de&zoom=18" \
    -H "User-Agent: NOVUM-ZIV-GeoUpdate/1.0" 2>/dev/null || echo "")

  if [ -z "$RESULT" ]; then
    ERRORS=$((ERRORS + 1))
    echo "  FEHLER: $STRASSE $HNR (curl)"
    sleep 1.2
    continue
  fi

  DISPLAY=$(echo "$RESULT" | python3 -c "
import sys,json
try:
  d=json.load(sys.stdin)
  dn=d.get('display_name','')
  if dn:
    parts=[p.strip() for p in dn.split(',')]
    # Alles nach dem Straßennamen (Viertel, Bezirksteil)
    print(', '.join(parts[1:3]) if len(parts)>2 else parts[0])
  else:
    print('')
except:
  print('')
" 2>/dev/null)

  if [ -z "$DISPLAY" ]; then
    SKIPPED=$((SKIPPED + 1))
    sleep 1.2
    continue
  fi

  # SQL-sicher escapen (einfache Anführungszeichen verdoppeln)
  SAFE_DISPLAY=$(echo "$DISPLAY" | sed "s/'/''/g")

  sudo -u postgres psql -q -d $DB -c \
    "UPDATE adressen SET geo_name = '${SAFE_DISPLAY}' WHERE id = '${ID}';" 2>/dev/null

  UPDATED=$((UPDATED + 1))
  if [ $((UPDATED % 50)) -eq 0 ]; then
    echo "  [$UPDATED] ✓ $STRASSE $HNR → $DISPLAY"
  fi

  # Nominatim Rate-Limit: 1 req/sec
  sleep 1.1
done

echo ""
echo "Fertig! Aktualisiert: $UPDATED, Übersprungen: $SKIPPED, Fehler: $ERRORS"
