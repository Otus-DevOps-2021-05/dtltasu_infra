#!/usr/bin/env bash

# Update repo list
sudo apt update

# install ruby
sudo apt install -y ruby-full ruby-bundler build-essential

# install git
sudo apt install -y git

# add key and repo for mongoDB
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list

# install mongoDB
sudo apt-get update
sudo apt-get install -y mongodb-org

sudo systemctl start mongod && sudo systemctl enable mongod

#deploy project

cd /home/yc-user

git clone -b monolith https://github.com/express42/reddit.git

cd reddit && bundle install

puma -d
