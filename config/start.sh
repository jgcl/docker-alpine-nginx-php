#!/bin/sh

# Tweak nginx to match the workers to cpu's
procs=$(cat /proc/cpuinfo | grep processor | wc -l)
sed -i -e "s/worker_processes 4/worker_processes $procs/" /etc/nginx/nginx.conf

# change user from workdir
chown -R www:www /var/www/src

# Start supervisord and services
exec supervisord -c /etc/supervisord.conf
