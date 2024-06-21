#!/bin/bash

read -p "Enter IP Address: " ip_address
read -p "Enter SSH Password: " ssh_password
read -p "Enter SSL Email: " ssl_email
read -p "Enter Domain: " domain
read -p "Enter App Name: " app_name

gh secret set IP_ADDRESS -b"$ip_address"
gh secret set SSH_PASSWORD -b"$ssh_password"
gh secret set SSL_EMAIL -b"$ssl_email"
gh secret set DOMAIN -b"$domain"
gh secret set APP_NAME -b"$app_name"
