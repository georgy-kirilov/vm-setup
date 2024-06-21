# Setup SSL using `Let's Encrypt` and `Certbot`

## 0. SSH into the Virtual Machine

```bash
ssh root@<vm-ip-address>
```

## 1. Create the following project directories:

```bash
mkdir /srv/my-web-app
```
```bash
mkdir /srv/my-web-app/certbot/certs
```
```bash
mkdir /srv/my-web-app/certbot/www
```
```bash
mkdir /srv/my-web-app/nginx
```

## 2. Secure copy the required files:

```bash
scp ./compose.yml root@<vm-domain>:/srv/my-web-app
```
```bash
scp ./nginx/nginx.certbot.conf root@<vm-domain>:/srv/my-web-app/nginx/nginx.conf
```

## 3. Obtain SSL certificate:

### 3.1 Start the containers:
```bash
docker compose up -d
```

### 3.2 Run the certbot utility tool as container:
```bash
docker run --rm \
    -v "$(pwd)/certbot/certs:/etc/letsencrypt" \
    -v "$(pwd)/certbot/www:/var/www/certbot" \
    certbot/certbot certonly \
    --webroot \
    --webroot-path=/var/www/certbot \
    -d <vm-domain> \
    --email <your-email-address> \
    --agree-tos \
    --no-eff-email
```

### 3.3 Stop and remove the running containers:
```bash
docker compose down
```

### 3.4 Secure copy the actual `nginx.conf` file:
```bash
scp ./nginx/nginx.conf root@<vm-domain>:/srv/my-web-app/nginx/nginx.conf
```

### 3.5 Start the containers:
```bash
docker compose up
```
