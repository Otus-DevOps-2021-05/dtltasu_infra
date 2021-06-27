#!/usr/bin/env bash

# Install git
sudo apt install -y git

#Clone repo
cd /home/yc-user

git clone -b monolith https://github.com/express42/reddit.git

#Install dependicies
cd reddit && bundle install

#Start project
puma -d
