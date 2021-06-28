#!/bin/bash

# Create instance reddit
yc compute instance create --name reddit-app --hostname reddit-app --memory=4  --create-boot-disk name=reddit-full,size=20,image-id=fd8h74hlvvkq0k7k98th --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 --metadata serial-port-enable=1 --ssh-key ~/.ssh/appuser.pub
