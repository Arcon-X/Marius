# NOVUM-ZIV — Dateien auf Server hochladen und Setup starten
# In PowerShell ausführen: .\server\upload_and_run.ps1

$SERVER_IP = "204.168.217.211"
$SSH_KEY   = "$env:USERPROFILE\.ssh\id_ed25519_novumziv2"
$SSH_OPTS  = "-i `"$SSH_KEY`" -o StrictHostKeyChecking=no"

Write-Host ""
Write-Host "============================================================"
Write-Host "  NOVUM-ZIV Server Setup"
Write-Host "  Server: $SERVER_IP"
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
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no root@$SERVER_IP "chmod +x /root/setup_server.sh && bash /root/setup_server.sh"

Write-Host ""
Write-Host "============================================================"
Write-Host "  FERTIG! Server ist bereit."
Write-Host "  API: http://$SERVER_IP/api/"
Write-Host "============================================================"
