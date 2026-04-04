# NOVUM-ZIV — Verify script + cron-Timer deployen
# Aufruf: .\server\deploy_verify.ps1

$SERVER_IP = if ($env:NOVUMZIV_SERVER_IP) { $env:NOVUMZIV_SERVER_IP } else { "204.168.217.211" }
$SERVER_DOMAIN = if ($env:NOVUMZIV_SERVER_DOMAIN) { $env:NOVUMZIV_SERVER_DOMAIN } else { "$SERVER_IP.nip.io" }
$SSH_KEY   = "$env:USERPROFILE\.ssh\id_ed25519_novumziv2"

Write-Host ""
Write-Host "============================================================"
Write-Host "  NOVUM-ZIV Verifizierungs-Deployment"
Write-Host "  Server: $SERVER_IP"
Write-Host "  Domain: $SERVER_DOMAIN"
Write-Host "============================================================"
Write-Host ""

Write-Host "> Dateien hochladen..."
scp -i "$SSH_KEY" -o StrictHostKeyChecking=no `
    "verify_adressen.py" `
    "server\setup_verify_cron.sh" `
    "server\stop_verify_cron.sh" `
    "root@${SERVER_IP}:/root/"

Write-Host "OK Dateien hochgeladen"
Write-Host ""
Write-Host "> Timer einrichten..."
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no root@$SERVER_IP `
    "chmod +x /root/setup_verify_cron.sh /root/stop_verify_cron.sh && bash /root/setup_verify_cron.sh"

Write-Host ""
Write-Host "============================================================"
Write-Host "  FERTIG! Timer laeuft taeglich um 03:00 Uhr."
Write-Host "  Logs: ssh root@$SERVER_IP 'tail -f /var/log/verify_adressen.log'"
Write-Host "  Stop: ssh root@$SERVER_IP 'bash /root/stop_verify_cron.sh'"
Write-Host "  API Target: https://$SERVER_DOMAIN/api"
Write-Host "============================================================"
