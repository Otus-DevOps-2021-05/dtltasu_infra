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
