#!/usr/bin/env bash

apt-get update
apt-get install -y git
apt-get install -y policykit-1
sudo chmod -R 0777 /opt

cd /opt
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

mv -f /tmp/puma.service /etc/systemd/system/puma.service
systemctl daemon-reload
systemctl enable puma.service
systemctl start puma.service
