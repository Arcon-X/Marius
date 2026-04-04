#!/bin/bash
# Migrate from GitHub Pages to self-hosted frontend on Hetzner
# Nginx serves static files + proxies API (same-origin, no CORS needed)
set -e

SERVER_DOMAIN="${SERVER_DOMAIN:-204.168.217.211.nip.io}"

echo "=== Erstelle Web-Root ==="
mkdir -p /var/www/novumziv
chown www-data:www-data /var/www/novumziv

echo "=== Neue Nginx-Config ==="
cat > /etc/nginx/sites-available/novumziv << 'NGINX'
limit_req_zone $binary_remote_addr zone=login:10m rate=5r/m;
limit_req_zone $binary_remote_addr zone=api:10m rate=30r/m;

server {
    listen 443 ssl;
    server_name __SERVER_DOMAIN__;

    ssl_certificate /etc/letsencrypt/live/__SERVER_DOMAIN__/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/__SERVER_DOMAIN__/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "DENY" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;

    client_max_body_size 64k;

    # ── Frontend: Statische Dateien ──
    root /var/www/novumziv;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # ── Login: streng rate-limitiert ──
    location /api/rpc/login {
        limit_req zone=login burst=3 nodelay;
        limit_req_status 429;
        proxy_pass http://127.0.0.1:3000/rpc/login;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # ── Passwort-Endpunkte ──
    location ~ ^/api/rpc/(change_password|change_email|admin_reset_password)$ {
        limit_req zone=login burst=2 nodelay;
        limit_req_status 429;
        proxy_pass http://127.0.0.1:3000/rpc/$1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # ── Allgemeine API ──
    location /api/ {
        limit_req zone=api burst=10 nodelay;
        limit_req_status 429;
        proxy_hide_header Server;
        proxy_hide_header X-Powered-By;
        proxy_pass http://127.0.0.1:3000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    server_tokens off;
}

server {
    listen 80;
    server_name __SERVER_DOMAIN__;
    return 301 https://$host$request_uri;
}
NGINX

sed -i "s/__SERVER_DOMAIN__/${SERVER_DOMAIN}/g" /etc/nginx/sites-available/novumziv

echo "=== Symlink aktualisieren ==="
ln -sf /etc/nginx/sites-available/novumziv /etc/nginx/sites-enabled/novumziv
rm -f /etc/nginx/sites-enabled/default

echo "=== Nginx testen ==="
nginx -t

echo "=== Nginx neu laden ==="
systemctl reload nginx

echo "=== SSH Deploy Key für GitHub Actions ==="
mkdir -p /root/.ssh
if [ ! -f /root/.ssh/id_deploy ]; then
    ssh-keygen -t ed25519 -f /root/.ssh/id_deploy -N "" -C "github-deploy"
    echo ""
    echo "========================================"
    echo "  DEPLOY PUBLIC KEY (für GitHub):"
    echo "========================================"
    cat /root/.ssh/id_deploy.pub
    echo "========================================"
fi

# authorized_keys für Deploy aktualisieren
if ! grep -q "github-deploy" /root/.ssh/authorized_keys 2>/dev/null; then
    cat /root/.ssh/id_deploy.pub >> /root/.ssh/authorized_keys
    echo "Deploy-Key zu authorized_keys hinzugefügt"
fi

echo ""
echo "=== FERTIG ==="
echo "Web-Root: /var/www/novumziv/"
echo "Frontend wird jetzt von Nginx ausgeliefert (kein CORS nötig)"
echo ""
echo "NÄCHSTER SCHRITT:"
echo "  Private Key als GitHub Secret 'DEPLOY_KEY' hinzufügen:"
echo "  cat /root/.ssh/id_deploy"
