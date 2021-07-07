variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable subnet_id{
  description = "Subnet"
}

variable app_disk_image {
description = "Disk image for reddit db"
default = "reddit-app-base"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
  default = "~/.ssh/ubuntu"
}

variable db_nat_ip_address {
  description = "db ip address"
}
