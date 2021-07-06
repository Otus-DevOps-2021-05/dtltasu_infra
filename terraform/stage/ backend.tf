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
