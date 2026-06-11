output "vm_external_ip" {
  value = yandex_vpc_address.kittygram_external_ip.external_ipv4_address[0].address
}

output "static_ip_id" {
  value       = yandex_vpc_address.kittygram_external_ip.id
  description = "ID статического IP — используйте для import, если IP уже зарезервирован в консоли YC"
}

output "kittygram_url" {
  value = "http://${yandex_vpc_address.kittygram_external_ip.external_ipv4_address[0].address}:${var.gateway_port}"
}

output "media_bucket_name" {
  value = yandex_storage_bucket.kittygram_media.bucket
}
