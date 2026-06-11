resource "yandex_vpc_address" "kittygram_external_ip" {
  name = "kittygram-external-ip"

  external_ipv4_address {
    zone_id = var.zone
  }
}
