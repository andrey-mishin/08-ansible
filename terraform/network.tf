resource "yandex_vpc_network" "default" {
  name = "clickhouse_network"
}

resource "yandex_vpc_subnet" "default" {
  name           = "clickhouse_subnet"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["192.168.10.0/28"]
}
