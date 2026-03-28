#!/bin/bash
# NOVUM-ZIV — Harden Toggle
# Schaltet zwischen Dev-Modus (kein Rate-Limit, CORS offen) und Prod-Modus um.
# Verwendung: bash toggle_harden.sh

FLAG="/tmp/novumziv_dev_mode"

if [ -f "$FLAG" ]; then
  # ── DEV → PROD ─────────────────────────────────────────────────────────────
  echo "🔒 Wechsle zu PROD-Modus (Hardening aktiv) ..."

  cat > /etc/nginx/sites-available/novumziv << 'NGINX_PROD'
limit_req_zone $binary_remote_addr zone=login:10m rate=5r/m;
limit_req_zone $binary_remote_addr zone=api:10m rate=30r/m;

server {
    listen 443 ssl;
    server_name 204.168.217.211.nip.io;

    ssl_certificate /etc/letsencrypt/live/204.168.217.211.nip.io/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/204.168.217.211.nip.io/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "DENY" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;

    set $cors_origin "";
    if ($http_origin = "https://arcon-x.github.io") {
        set $cors_origin $http_origin;
    }

    client_max_body_size 64k;

    location /api/rpc/login {
        limit_req zone=login burst=3 nodelay;
        limit_req_status 429;
        add_header Access-Control-Allow-Origin $cors_origin always;
        add_header Access-Control-Allow-Methods "POST, OPTIONS" always;
        add_header Access-Control-Allow-Headers "Content-Type, Authorization, Prefer" always;
        add_header Access-Control-Max-Age 3600 always;
        add_header Strict-Transport-Security "max-age=63072000; includeSubDomains" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-Frame-Options "DENY" always;
        if ($request_method = 'OPTIONS') { return 204; }
        proxy_pass http://127.0.0.1:3000/rpc/login;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location ~ ^/api/rpc/(change_password|change_email|admin_reset_password)$ {
        limit_req zone=login burst=2 nodelay;
        limit_req_status 429;
        add_header Access-Control-Allow-Origin $cors_origin always;
        add_header Access-Control-Allow-Methods "POST, OPTIONS" always;
        add_header Access-Control-Allow-Headers "Content-Type, Authorization, Prefer" always;
        add_header Access-Control-Max-Age 3600 always;
        add_header Strict-Transport-Security "max-age=63072000; includeSubDomains" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-Frame-Options "DENY" always;
        if ($request_method = 'OPTIONS') { return 204; }
        proxy_pass http://127.0.0.1:3000/$1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /api/ {
        limit_req zone=api burst=10 nodelay;
        limit_req_status 429;
        add_header Access-Control-Allow-Origin $cors_origin always;
        add_header Access-Control-Allow-Methods "GET, POST, PATCH, DELETE, OPTIONS" always;
        add_header Access-Control-Allow-Headers "Content-Type, Authorization, Prefer" always;
        add_header Access-Control-Max-Age 3600 always;
        add_header Strict-Transport-Security "max-age=63072000; includeSubDomains" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-Frame-Options "DENY" always;
        if ($request_method = 'OPTIONS') { return 204; }
        proxy_pass http://127.0.0.1:3000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_hide_header Server;
        proxy_hide_header X-Powered-By;
    }

    server_tokens off;
}

server {
    listen 80;
    server_name 204.168.217.211.nip.io;
    return 301 https://$host$request_uri;
}
NGINX_PROD

  nginx -t && systemctl reload nginx && rm -f "$FLAG"
  echo "✅ PROD-Modus aktiv — Rate-Limiting & CORS-Restriktion eingeschaltet"

else
  # ── PROD → DEV ─────────────────────────────────────────────────────────────
  echo "🔓 Wechsle zu DEV-Modus (kein Rate-Limit, CORS offen) ..."

  cat > /etc/nginx/sites-available/novumziv << 'NGINX_DEV'
server {
    listen 443 ssl;
    server_name 204.168.217.211.nip.io;

    ssl_certificate /etc/letsencrypt/live/204.168.217.211.nip.io/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/204.168.217.211.nip.io/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "DENY" always;

    client_max_body_size 1m;

    location /api/ {
        add_header Access-Control-Allow-Origin "*" always;
        add_header Access-Control-Allow-Methods "GET, POST, PATCH, DELETE, OPTIONS" always;
        add_header Access-Control-Allow-Headers "Content-Type, Authorization, Prefer" always;
        add_header Access-Control-Max-Age 3600 always;
        if ($request_method = 'OPTIONS') { return 204; }
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
    server_name 204.168.217.211.nip.io;
    return 301 https://$host$request_uri;
}
NGINX_DEV

  nginx -t && systemctl reload nginx && touch "$FLAG"
  echo "✅ DEV-Modus aktiv — kein Rate-Limit, CORS offen für alle Origins"
  echo "⚠️  Danach unbedingt wieder: bash toggle_harden.sh"
fi
