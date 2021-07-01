variable cloud_id {
  description = "Cloud"
}
variable folder_id {
  description = "Folder"
}
variable region_id {
  description = "region"
  # Значение по умолчанию
  default = "ru-central1"
}
variable zone_id {
  description = "zone"
  default = "ru-central1-a"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable image_id {
  description = "Disk image"
}
variable subnet_id{
  description = "Subnet"
}
variable service_account_key_file {
  description = "terraform.json"
}

variable private_key_path {
  description = "path to private key"
}
