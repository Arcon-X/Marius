#!/bin/bash
cat > /etc/nginx/sites-available/novumziv << 'EOF'
server {
    server_name 204.168.217.211.nip.io;

    location /api/ {
        proxy_pass http://127.0.0.1:3000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/204.168.217.211.nip.io/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/204.168.217.211.nip.io/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}

server {
    if ($host = 204.168.217.211.nip.io) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

    listen 80;
    server_name 204.168.217.211.nip.io;
    return 404; # managed by Certbot
}
EOF

nginx -t && systemctl reload nginx && echo "NGINX_RELOADED"
