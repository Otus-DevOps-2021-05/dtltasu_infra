# dtltasu_infra
dtltasu Infra repository


### Lesson 6 ###
tetapp_IP=178.154.252.211
testapp_port= 9292

yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --metadata-from-file user-data=start_up_script.sh
  --ssh-key ~/.ssh/appuser.pub


____________________________________________________________





Connecting with one command: ssh -A -t appuser@178.154.227.171 ssh -A 10.129.0.12

Connecting with alias:
      1. Create File ~/.ssh/config
      2. Add in the file code below:
           Host someinternalhost                                  # name alias
               HostName 10.129.0.12                               # address remote host
               User appuser                                       # user for connect
               ProxyCommand ssh appuser@178.154.227.171 nc %h %p  #command for conneting  (or  ProxyCommand ssh appuser@178.154.227.171 -W %h:%p)
       3. Alias for connecting = ssh someinternalhost

Conf OpenVpn:
     bastion_IP = 178.154.227.171
     someinternalhost_IP = 10.129.0.12
     user = test
     key = 6214157507237678334670591556762
     profile for connect = cloud-bastion.ovpn


Access to pritnul https://178-154-227-171.sslip.io with ssl
