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
    memory        = 2
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 15
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.kittygram_subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.kittygram_sg.id]
  }

  scheduling_policy {
    preemptible = true
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
