#!/bin/bash

domain_name=$1
email=$2

nginx_conf_content="events {}

http {
    server {
        listen 80;
        server_name $domain_name;

        location /.well-known/acme-challenge/ {
            root /var/www/certbot;
            allow all;
        }

        location / {
            return 301 https://\$host\$request_uri;
        }
    }
}"

nginxPath="./nginx"

# Ensure the directory exists
if [[ ! -d "$nginxPath" ]]; then
    mkdir -p "$nginxPath"
fi

# Write the content to the nginx.conf file using a here document
cat <<EOF > "$nginxPath/nginx.conf"
$nginx_conf_content
EOF

certsPath="./certbot/certs"

# Ensure the certs directory exists
if [[ ! -d "$certsPath" ]]; then
    mkdir -p "$certsPath"
fi

wwwPath="./certbot/www"

# Ensure the www directory exists
if [[ ! -d "$wwwPath" ]]; then
    mkdir -p "$wwwPath"
fi

# Stop and remove all containers
docker stop $(docker ps -aq) && docker rm $(docker ps -aq)

# Run NGINX container
docker run -d \
  --name ssl-nginx \
  --restart unless-stopped \
  -p 80:80 \
  -p 443:443 \
  -v $(pwd)/nginx/nginx.conf:/etc/nginx/nginx.conf \
  -v $(pwd)/certbot/certs:/etc/letsencrypt:ro \
  -v $(pwd)/certbot/www:/var/www/certbot \
  nginx

# Wait until NGINX is up and running
while ! docker exec ssl-nginx nginx -t &>/dev/null; do
    echo "Waiting for NGINX to be fully started..."
    sleep 2
done

# Run Certbot utility container once NGINX is fully up
docker run --rm \
    -v $(pwd)/certbot/certs:/etc/letsencrypt \
    -v $(pwd)/certbot/www:/var/www/certbot \
    certbot/certbot certonly \
    --webroot \
    --webroot-path=/var/www/certbot \
    -d $domain_name \
    --email $email \
    --agree-tos \
    --no-eff-email

# Ensure Certbot completes before stopping containers
echo "Certbot process completed, now stopping containers."

# Stop and remove all containers
docker stop $(docker ps -aq) && docker rm $(docker ps -aq)

new_nginx_conf_content="events {}

http {
    server {
        listen 80;
        server_name $domain_name;

        location /.well-known/acme-challenge/ {
            root /var/www/certbot;
        }

        location / {
            return 301 https://\$host\$request_uri;
        }
    }

    server {
        listen 443 ssl;
        http2 on;
        server_name $domain_name;

        ssl_certificate /etc/letsencrypt/live/$domain_name/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/$domain_name/privkey.pem;

        add_header Strict-Transport-Security \"max-age=31536000; includeSubDomains\" always;
        add_header X-Frame-Options "SAMEORIGIN";
        add_header X-Content-Type-Options \"nosniff\";
        add_header X-XSS-Protection \"1; mode=block\";

        location / {
            root /usr/share/nginx/html;
            index index.html;
        }
    }
}"

# Write the new content to the nginx.conf file using a here document
cat <<EOF > "$nginxPath/nginx.conf"
$new_nginx_conf_content
EOF

# Run NGINX container
docker run -d \
  --name nginx \
  --restart unless-stopped \
  -p 80:80 \
  -p 443:443 \
  -v $(pwd)/nginx/nginx.conf:/etc/nginx/nginx.conf \
  -v $(pwd)/certbot/certs:/etc/letsencrypt:ro \
  -v $(pwd)/certbot/www:/var/www/certbot \
  nginx
