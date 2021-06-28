# dtltasu_infra
dtltasu Infra repository

### Lesson 7 ###
Установили Packer
Создали сервисный аккаунт для  yc
    SVC_ACCT="service"
FOLDER_ID="abcde"
yc iam service-account create --name $SVC_ACCT --folder-id $FOLDER_ID

Выдали права для folder_id (folder_id узнали - yc config list)
  ACCT_ID=$(yc iam service-account get $SVC_ACCT | \
     grep ^id | \
     awk '{print $2}')

  yc resource-manager folder add-access-binding --id $FOLDER_ID \
     --role editor \
     --service-account-id $ACCT_ID
Создали key file для сервисного аакаунта
   yc iam key create --service-account-id $ACCT_ID --output <вставьте свой путь>/key.json

Для проверки шаблонов сборки ВМ используется команда
  packer validate ./<FILE_NAME>.json

ДЛя сборки образа
   packer build ./<FILE_NAME>.json

Создали шаблон ubuntu16.json для сборки базового образа
Ruby не устанавливался пока в скрипт не добавил строчку "sleep 1"

Cоздал файлы с переменными  variables.json и variables.json.example

На основе ubuntu16.json создал immutable.json
Для запекания образа уже с установленным приложением (для установки приложения использовалась офф документация "puma")
Puma не хотела запускатсья, как сервис, после установки паке apt-get install -y policykit-1 ошибка ушла


В immutable.json добавлен шаг с установкой приложения

Создан скрипт для создания инстанса с установленным приложением из CLI /config-scripts/create-reddit-vm-sh
В скрипт только необходимо добавить id образа который создается из шаблона immutable.json



Для проверки нужно скриптом create-reddit-vm-sh создать инстанс
предварительно подставив в него id image
перейти по адресу <EXTERNAL_IP>:9292







### Lesson 6 ###
testapp_IP = 178.154.252.211
testapp_port = 9292

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
