#!/bin/bash

read -p "Enter IP Address: " ip_address
read -sp "Enter SSH Password: " ssh_password
echo
read -p "Enter SSL Email: " ssl_email
read -p "Enter Domain: " domain
read -p "Enter App Name: " app_name

gh secret set IP_ADDRESS --body "$ip_address"
gh secret set SSH_PASSWORD --body "$ssh_password"
gh secret set SSL_EMAIL --body "$ssl_email"
gh secret set DOMAIN --body "$domain"
gh secret set APP_NAME --body "$app_name"
