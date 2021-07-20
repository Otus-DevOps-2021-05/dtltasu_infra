# dtltasu_infra

![AppVeyor](https://img.shields.io/appveyor/build/dtltasu/git@github.com:Otus-DevOps-2021-05/dtltasu_infra.git?style=flat-square)

[![Run tests for OTUS homework](https://github.com/Otus-DevOps-2021-05/dtltasu_infra/actions/workflows/run-tests.yml/badge.svg)](https://github.com/Otus-DevOps-2021-05/dtltasu_infra/actions/workflows/run-tests.yml)

dtltasu Infra repository
### Lesson 12 ###
1. Создали ветку ansible-3
2. Создали роли для  app and db окружения
3. Изменили плейбуки для использования ролей
4. Уничтожили инстансы, подняли по новой, пргнали плейбуки с ролями, все работает
5. Провели настройку stage окружения
6. Разнесли файлы по папкам
7. Провели настройку prod окружения
8. Добавили роль jdauphant.nginx в плейбукк app
9. Добавил переменные для работы nginx в  environments/stages/group_vars/app
nginx_sites:
  default:
    - listen 80
    - server_name "reddit"
    - location / {
       proxy_pass http://127.0.0.1:9292;
      }

для открытия порта необходимо создавать и настроивать ресурс
https://cloud.yandex.ru/docs/vpc/operations/security-group-create
но в yc и так все работает отлично
10. Применил плейбук site для stage все работает и на порту 9292 и 80
11. Cоздали vault.key для шифрования и расшифровки файлов и добавили в ansible.cfg
[defaults]
...
vault_password_file = vault.key
12. Создали плейбук для сздния пользователей и добавили его в site.yml
13. Для каждого окружения создали енвайроментс для создания пользователей
14. Пользователись создались yc позволять сразу заходить пользователям по ssh
без включения допольнительных настроек
15. Задание со * на динамик инвентри делать не стал, т.к.  нет нормального дин инвентори,
планирую доделать после.
16. Добавлены првоерки и бейдж





### Lesson 11 ###

1. Создали ветку ansible-2
2. Создали плейбук reddit_app и протестировали его
3. Создали плейбук для нескольких сценариев reddit_app2
4. Разбиваем один плейбук на несколько  app db  and deploy
5. Изменяем packer provision для работы с ansible плейбоками и перезапекаем новые образы

6. задание со * оставил на потом  пока не получается его победить.
Bash script считаю так себе решинеием, а питон скрирты пока не получается победить
то ли из-за кривых рук или из-за mac на m1 , с ансибле слишком много ошибок и не состыковок ,
почти все дз через боль))))
Посоветуюсь на работе с сеньером и позже дополню пр/



### Lesson 10 ###
1. Создали папку и  ветку для работы с ansible
2. Проверили установку python and pip
3. Создали файл  requirements.txt с рекомендуемой версией ansible и установили ансибле
   pip install -r requirements.txt
4. Подняли два инстанса  cd terraform/stage; terraform apply
5. Создали простой файл inventory
  appserver ansible_host=***.***.***.*** ansible_user=appuser ansible_private_key_file=~/.ssh/appuser
6. Проверили подключение и работу ансибле с инстансами
  ansible appserver -i ./inventory -m ping
7. Создали файл ansible.cfg и перенесли туда данные о подключении. пользователя, файла инвент и тд для упрощенной работы.
8. Удалили перенесенную инфу из файла инвентори и проверили работу комманд ansible dbserver -m command -a uptime
9. Сформировали новый файл  inventory.yml и указали его в  *.cfg проверили работу ansible dbserver -m command -a uptime
10. Пишщем первый плейбук clone.yml и запускаем ansible-playbook clone.yml
11. после клонирования запускаем команду  для удаления склонированного ansible app -m command -a 'rm -rf ~/reddit'
12. Запускаем плейбук еще раз, клонирование прошло успешно т.к. папка была удалена предыдущей командой

Задание  со  звездочкой
Нашел готовое решение для данной задачи с генерацие на лету, но решил его не использвать ))
создал json файл командой ansible-inventory -i ./inventory.yml --list --output=./inventory.json

и создал скрипт для испольования этого фалйла
#!/bin/bash
if [ $# -eq 0
  then
  echo "Usage: script --list"
  exit 1
fi
if [ $1 = "--list" ]
  then
  cat ./inventory.json
fi




### Lesson 9 ###
1 Создал ветку terrform-2
2 Создал  IP для внешнего ресурса в main.tf
  resource "yandex_vpc_network" "app-network" {
name = "reddit-app-network"
}
resource "yandex_vpc_subnet" "app-subnet" {
name = "reddit-app-subnet"
zone = "ru-central1-a"
network_id = "${yandex_vpc_network.app-network.id}"
v4_cidr_blocks = ["192.168.10.0/24"]
}

3 В создание инстанса добавили данныйе о созданных ресурсах
  network_interface {
    subnet_id = yandex_vpc_subnet.app-subnet.id
    nat = true
  }

4 Создаем два шаблона для app и db (*.json) на основе ubuntu16.json, в файлах меняем image_(name, family) и disk name
5 Билдимс новые образы
 packer build -var-file=./variables.json ./app.json
 packer build -var-file=./variables.json ./db.json

6 Разбили основной файл main.tf на две части app.tf and db.tf
7 Определили новые переменные и бобзначили их
   variable app_disk_image {
  description = "disk image for reddit app"
  default     = "reddit-app-base"
  }
   variable db_disk_image {
  description = "disk image for mongodb"
  default     = "reddit-db-base"


   app_disk_image            = "reddit-app-base"
   db_disk_image             = "reddit-db-base"

8 Вносим описание ресурсов в app and db  *.tf в main- файле оставется только блок с provider
9 В outputs .yf вставляем новые данные
   output "external_ip_address_app" {
  value = yandex_compute_instance.app.network_interface.0.nat_ip_address
}
output "external_ip_address_db" {
  value = yandex_compute_instance.db.network_interface.0.nat_ip_address
}


10 Для модульной структуры создаем папки modules/app modules/db в папке terraform в каждой папке создаем структуру файлов
main.tf outputs.tf variables.tf по аналогии с папкой terraform и вносим изменения

11 из директории terraform удаляем  app.tf, db.tf и vpc.tf
12 в файле main указываем использование модулей
    module "app" {
  source          = "./modules/app"
  public_key_path = var.public_key_path
  app_disk_image  = var.app_disk_image
  subnet_id       = var.subnet_id
}

module "db" {
  source          = "./modules/db"
  public_key_path = var.public_key_path
  db_disk_image   = var.db_disk_image
  subnet_id       = var.subnet_id
}

затем необходимо загрузить модули  terraform get

13 Для преиспользования модулей создаем папки prod and stage и копируем туда основные файлы и корректиреум их под свое окружение/

Задание со * :
Для смоздания хранилище нам необходимо создать сервисный аккаунт или создать для существующего статический ключ доступа yc iam access-key create --service-account-name my-robot
сохраняем идентификатор key_id и секретный ключ secret они будут показаны один раз и будут необходимы для бакета
для создания бакета создаем файл в дериктории терраформ storage-backet.tf
  provider "yandex" {
  version                  = "~> 0.43"
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone_id
}

#resource "yandex_vpc_network" "app-network" {
#  name = "reddit-app-network"
#}

#resource "yandex_vpc_subnet" "app-subnet" {
#  name           = "reddit-app-subnet"
#  zone           = "ru-central1-a"
#  network_id     = "${yandex_vpc_network.app-network.id}"
#  v4_cidr_blocks = ["192.168.10.0/24"]
#}

resource "yandex_storage_bucket" "aireshilov" {
  access_key = var.key_id
  secret_key = var.secret_key
  bucket = var.bucket_name
}

после этого в каждой папке модулей создаем файл backend.tf  с указанием бакенда
  terraform {
  backend "s3" {
      endpoint = "storage.yandexcloud.net"
      bucket   = "aireshilov"
      key      = "stage/terraform.tfstate"
      region   = "ru-central1"
      access_key = "SKKWZ-bgZLxvBhCocc3Y"
      secret_key = "QEO5pVAqPYHxgNI1WnPiFY8GCvH5-snswdhhdOPW"
      skip_region_validation      = true
      skip_credentials_validation = true
  }
}

После этого файл terraform.tfstate можно удалять

14  Задание с **
 Возвращаем /files в модуль app
 для того чтоб app получило доступ к db
в puma.service добавляем переменную DATABASE_URL которую получаем из outputs модуля db внешний ип адресс и подсовываем
listener mongodb определяет через парметр bindIp: его мы меняем через sed в провижионере db main.tf





### Lesson 8 ###

1 создаем ветку terraform-1
2 устанавливаем терраформ по инструкции для нашей ОС
3 создаем сервисный аакаунт для terraform
yc iam service-account create --name terraform --folder-id b1gm9eibqggfmlau7l0q
 yc iam service-account get terraform | \
 grep ^id | \
awk '{print $2}'
yc resource-manager folder add-access-binding --id b1gm9eibqggfmlau7l0q \
--role editor \
4 добавляем переменную для ключа export YC_SERVICE_ACCOUNT_KEY_FILE=$HOME/lessons/terraform.json
5 заполянем main.tf после инициализации, пробуем создать инстанс terraform init && terraform apply
получаем ошибку на не корректное кол-во ресурсов меняфем cores 2
6 после попытки подключиться по ssh поулчаем ошибку доступа, в файл main.tf добавляем параметр
metadata = {
   ssh-keys= "ubuntu:${file("~/.ssh/ubuntu.pub")}"
}

7 Для вывода параметров созданных инстансов создаем файл outputs.ts , данные выводятся командой terraform output
8 Настраиваем првиожионеры один для работы с файлами, а второй для запуска комманд

provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

provisioner "remote-exec" {
  script = "files/deploy.sh"
}

для работы провижионеров создаем радел connection

connection {
  type  = "ssh"
  host  = yandex_compute_instance.app.network_interface.0.nat_ip_address
  user  = "ubuntu"
  agent = false
  # путь до приватного ключа
  private_key = file("~/.ssh/yc")
}

9 создаем файл для описания переменных variables.tf

variable region_id {
  description = "region"
  # Значение по умолчанию
  default = "ru-central1"
можно указать данный для использования по умолчанию

10 созданем файл для определения переменных terraform.tfvars

region_id                = "ru-central1"

11 переносим переменный в файл main.tf

region_id = var.region_id

Задание со **

1 Создаем файл lb.tf
2 Сначала нужно создать таргет группу для подключения к балансировщику
resource "yandex_lb_target_group" "loadbalancer" {
  name       = "lb-group"
  region_id  = var.region_id
  folder_id  = var.folder_id


  dynamic "target" {
      for_each  = yandex_compute_instance.app.*.network_interface.0.ip_address
      content {
          subnet_id = var.subnet_id
          address   = target.value
      }
  }

3 Создаем ресур самого балансировщика
resource "yandex_lb_network_load_balancer" "lb"{
    name = "loadbalancer"
    type = "external"


    listener {
        name        = "listener"
        port        = 80
        target_port = 9292

        external_address_spec {
            ip_version = "ipv4"
        }
    }

4 Приатачиваем группу к балансировщику
attached_target_group {
        target_group_id = yandex_lb_target_group.loadbalancer.id

        healthcheck {
            name    = "tcp"
            tcp_options {
                port = 9292
            }
        }
    }

5 В отутпутс добавляем данные для вывода балансировщика
output "external_ip_address_lb" {
  value = yandex_lb_network_load_balancer.lb.listener.*.external_address_spec[0].*.address
}

6 Создаем еще один инстанс с аналогичными параметрами первого,чтоб балансировщику было между кем переключаться, меняем только имя
7 новый инстанс добаляем в таргет группу
(все данные оставил закомменчиными в файлах)

8 в отпутс меняем данные для вывода двух инстансов
output "external_ip_address_app" {
  value = yandex_compute_instance.app[*].network_interface.0.nat_ip_address
}

9 Т.к. копировать одинаковые инстансы в файлах не очень удобно, будем их создавать через переменною count

в variables добавляем

variable instances {
  description = "count instance"
  default     = 1
}

второй инстанс можно удалить и поправить первый

resource "yandex_compute_instance" "app" {
  count = var.instances
  name = "reddit-app-${count.index}"

connection {

    host  = self.network_interface.0.nat_ip_address
параметр self указывает на родителький параметр resource resource -- "yandex_compute_instance" "app"

через dynamic и for-each правим target балансировщика

dynamic "target" {
      for_each  = yandex_compute_instance.app.*.network_interface.0.ip_address
      content {
          subnet_id = var.subnet_id
          address   = target.value
      }
  }


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
