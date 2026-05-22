variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "yc_key_file" {
  type    = string
  default = "authorized_key.json"
}

variable "ssh_public_key" {
  type = string
}

variable "vm_name" {
  type    = string
  default = "kittygram-vm"
}

variable "vm_user" {
  type    = string
  default = "yc-user"
}

variable "gateway_port" {
  type    = number
  default = 9000
}

variable "s3_bucket_name" {
  type    = string
  default = "kittygram-media-sladkiy"
}
