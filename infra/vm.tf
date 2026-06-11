data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2404-lts"
}

resource "yandex_compute_instance" "kittygram_vm" {
  name        = var.vm_name
  hostname    = var.vm_name
  zone        = var.zone
  platform_id = "standard-v3"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 100
  }

  scheduling_policy {
    preemptible = false
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.kittygram_subnet.id
    nat                = true
    nat_ip_address     = yandex_vpc_address.kittygram_external_ip.external_ipv4_address[0].address
    security_group_ids = [yandex_vpc_security_group.kittygram_sg.id]
  }

  metadata = {
    user-data = templatefile("${path.module}/cloud-init.yml", {
      vm_user        = var.vm_user
      vm_name        = var.vm_name
      ssh_public_key = var.ssh_public_key
    })
    ssh-keys = "${var.vm_user}:${var.ssh_public_key}"
  }

  allow_stopping_for_update = true
}
