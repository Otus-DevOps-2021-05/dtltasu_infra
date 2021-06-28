#!/usr/bin/env bash

wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list


apt-get update
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
apt-get install -y apt-transport-https ca-certificates
apt-get --assume-yes update
apt-get --assume-yes -y install mongodb-org

systemctl start mongod && systemctl enable mongod
