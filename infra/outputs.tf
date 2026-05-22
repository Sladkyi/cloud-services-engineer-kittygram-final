output "vm_external_ip" {
  value = yandex_compute_instance.kittygram_vm.network_interface[0].nat_ip_address
}

output "kittygram_url" {
  value = "http://${yandex_compute_instance.kittygram_vm.network_interface[0].nat_ip_address}:${var.gateway_port}"
}

output "media_bucket_name" {
  value = yandex_storage_bucket.kittygram_media.bucket
}
