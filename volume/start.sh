#!/bin/sh

# nginx pid
mkdir -p /run/nginx
touch /run/nginx/nginx.pid

# Start supervisord and services
supervisord -n -c /etc/supervisord.conf
