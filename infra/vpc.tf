resource "yandex_vpc_network" "kittygram_network" {
  name = "kittygram-network"
}

resource "yandex_vpc_subnet" "kittygram_subnet" {
  name           = "kittygram-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.kittygram_network.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}
