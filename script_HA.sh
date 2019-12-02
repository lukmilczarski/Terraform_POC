#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

# install haproxy
apt-get update
apt-get -y install haproxy

# copy cfg filr
cp /tmp/haproxy.cfg /etc/haproxy/haproxy.cfg

# make sure haproxy is started
systemctl stop haproxy
systemctl enable haproxy
systemctl start haproxy
