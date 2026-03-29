#!/bin/bash
# Setup systemd timer for daily address verification
# Runs verify_adressen.py at 03:00 every night until all addresses are verified.
set -e

SCRIPT_SRC="verify_adressen.py"
SCRIPT_DST="/root/verify_adressen.py"
VENV="/root/venv_verify"

echo "Creating Python venv and installing dependencies..."
apt-get install -y -q python3-venv python3-pip 2>/dev/null || true
python3 -m venv "$VENV"
"$VENV/bin/pip" install --quiet --upgrade pip
"$VENV/bin/pip" install --quiet duckduckgo_search requests

echo "Copying verify script..."
cp "$SCRIPT_SRC" "$SCRIPT_DST" 2>/dev/null || true  # run locally on server
chmod 700 "$SCRIPT_DST"

echo "Creating systemd service..."
cat > /etc/systemd/system/verify-adressen.service << 'SERVICE'
[Unit]
Description=NOVUM-ZIV Adress-Verifizierung (daily batch)
After=network.target

[Service]
Type=oneshot
ExecStart=/root/venv_verify/bin/python /root/verify_adressen.py
StandardOutput=append:/var/log/verify_adressen.log
StandardError=append:/var/log/verify_adressen.log
WorkingDirectory=/root
Environment=PYTHONUNBUFFERED=1
SERVICE

echo "Creating systemd timer (daily at 03:00)..."
cat > /etc/systemd/system/verify-adressen.timer << 'TIMER'
[Unit]
Description=NOVUM-ZIV Adress-Verifizierung Timer
Requires=verify-adressen.service

[Timer]
OnCalendar=*-*-* 03:00:00
Persistent=true
AccuracySec=30min

[Install]
WantedBy=timers.target
TIMER

systemctl daemon-reload
systemctl enable --now verify-adressen.timer
echo ""
systemctl status verify-adressen.timer --no-pager
echo ""
echo "OK: Timer aktiv. Erster Lauf: heute nacht 03:00 Uhr."
echo "Logs: journalctl -u verify-adressen.service -f"
echo "      tail -f /var/log/verify_adressen.log"
