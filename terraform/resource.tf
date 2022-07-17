resource "yandex_compute_instance" "clickhouse" {
  name     = "clickhouse"
  hostname = "clickhouse"
  zone     = "ru-central1-b"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu-20-04
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    ssh-keys           = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    serial-port-enable = 1
  }
}

resource "yandex_compute_instance" "vector" {
  name     = "vector"
  hostname = "vector"
  zone     = "ru-central1-b"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.centos-7
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    ssh-keys           = "centos:${file("~/.ssh/id_rsa.pub")}"
    serial-port-enable = 1
  }
}

resource "yandex_compute_instance" "lighthouse" {
  name     = "lighthouse"
  hostname = "lighthouse"
  zone     = "ru-central1-b"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.centos-7
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    ssh-keys           = "centos:${file("~/.ssh/id_rsa.pub")}"
    serial-port-enable = 1
  }
}
