#!/bin/bash

sudo apt update

sudo apt install ufw

sudo ufw allow OpenSSH

echo 'y' | sudo ufw enable

sudo ufw allow 2375,2376/tcp

sudo ufw allow 80,443/tcp

sudo ufw reload

sudo ufw status

curl https://get.docker.com | sh

docker --version

docker compose version

docker run -d -p 80:80 --name dns-nginx nginx

docker ps
