#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

# install apache
apt-get update
apt-get -y install apache2

cp /tmp/index.html /var/www/html/index.html

# make sure apache is started
systemctl stop apache2
systemctl enable apache2
systemctl start apache2
