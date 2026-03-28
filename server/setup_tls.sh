#!/bin/bash
set -e

DOMAIN="204.168.217.211.nip.io"

# Nginx config schreiben
cat > /etc/nginx/sites-available/novumziv << 'EOF'
server {
    listen 80;
    server_name 204.168.217.211.nip.io;

    location /api/ {
        proxy_pass http://127.0.0.1:3000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        add_header 'Access-Control-Allow-Origin' '*' always;
        add_header 'Access-Control-Allow-Methods' 'GET, POST, PATCH, DELETE, OPTIONS' always;
        add_header 'Access-Control-Allow-Headers' 'Authorization, Content-Type, Prefer' always;
        if ($request_method = OPTIONS) { return 204; }
    }
}
EOF

ln -sf /etc/nginx/sites-available/novumziv /etc/nginx/sites-enabled/novumziv

nginx -t
systemctl reload nginx
echo "NGINX_OK"

# Certbot installieren falls nötig
if ! command -v certbot &>/dev/null; then
    apt-get install -y certbot python3-certbot-nginx
fi

# TLS-Zertifikat holen
certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos -m admin@novumziv.at
echo "CERTBOT_OK"
