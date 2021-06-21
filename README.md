# dtltasu_infra
dtltasu Infra repository



Connecting with one command: ssh -A -t appuser@178.154.227.171 ssh -A 10.129.0.12

Connecting with alias:
      1. Create File ~/.ssh/config
      2. Add in the file code below:
           Host someinternalhost                                  # name alias
               HostName 10.129.0.12                               # address remote host
               User appuser                                       # user for connect
               ProxyCommand ssh appuser@178.154.227.171 nc %h %p  #command for conneting  (or  ProxyCommand ssh appuser@178.154.227.171 -W %h:%p)

Conf OpenVpn:
     bastion_IP = 178.154.227.171
     someinternalhost_IP = 10.129.0.12
     user = test
     key = 6214157507237678334670591556762
     profile for connect = cloud-bastion.ovpn
