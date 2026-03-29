#!/bin/bash
# Manually stop the daily verification timer
systemctl disable --now verify-adressen.timer
echo "OK: verify-adressen.timer deaktiviert."
systemctl status verify-adressen.timer --no-pager || true
