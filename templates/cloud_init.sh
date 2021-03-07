#!/bin/bash

apt-get update && apt-get install -y software-properties-common \
  unzip \
  nodejs \
  npm \
  nginx

npm install -g pm2
pm2 startup systemd
systemctl enable nginx

rm /etc/nginx/sites-available/default
cat > "/etc/nginx/sites-available/default" <<NGIN
server {
    listen 80;    server_name your_domain.com;    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
     }
}
NGIN

systemctl restart nginx

mkdir /root/myapp
cat > "/root/myapp/app.js" <<APP
var express = require('express');
var app = express();

app.get('/', function(req, res){
   res.send("Hello World!");
});

app.listen(8080, 'localhost');
APP

cd /root/myapp
npm install express
pm2 start app.js
# node app.js