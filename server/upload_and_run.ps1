# NOVUM-ZIV — Dateien auf Server hochladen und Setup starten
# In PowerShell ausführen: .\server\upload_and_run.ps1

$SERVER_IP = if ($env:NOVUMZIV_SERVER_IP) { $env:NOVUMZIV_SERVER_IP } else { "204.168.217.211" }
$SERVER_DOMAIN = if ($env:NOVUMZIV_SERVER_DOMAIN) { $env:NOVUMZIV_SERVER_DOMAIN } else { "$SERVER_IP.nip.io" }
$SSH_KEY   = "$env:USERPROFILE\.ssh\id_ed25519_novumziv2"

Write-Host ""
Write-Host "============================================================"
Write-Host "  NOVUM-ZIV Server Setup"
Write-Host "  Server: $SERVER_IP"
Write-Host "  Domain: $SERVER_DOMAIN"
Write-Host "============================================================"
Write-Host ""

# Dateien hochladen
Write-Host "> Skripte hochladen..."
scp -i "$SSH_KEY" -o StrictHostKeyChecking=no `
    "server\setup_server.sh" `
    "server\create_users.py" `
    "import.sql" `
    "root@${SERVER_IP}:/root/"

Write-Host "OK Dateien hochgeladen"
Write-Host ""
Write-Host "> Setup starten (dauert ca. 3-5 Minuten)..."
Write-Host ""

# Setup-Skript ausführen
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no root@$SERVER_IP "chmod +x /root/setup_server.sh && SERVER_IP='$SERVER_IP' SERVER_DOMAIN='$SERVER_DOMAIN' bash /root/setup_server.sh"

Write-Host ""
Write-Host "============================================================"
Write-Host "  FERTIG! Server ist bereit."
Write-Host "  API: http://$SERVER_IP/api/"
Write-Host "  API: https://$SERVER_DOMAIN/api/"
Write-Host "============================================================"
