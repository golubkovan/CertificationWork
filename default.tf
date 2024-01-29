terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

locals {
  folder_id = "b1gs0pm6ll8cf737ur0d"
  cloud_id = "b1gn49oi728vfl0b0e11"
}

provider "yandex" {
  service_account_key_file = "/home/agolubkov/authorized_key.json"
  cloud_id                 = local.cloud_id
  folder_id                = local.folder_id
  zone                     = "ru-central1-a"
}

resource "yandex_container_registry" "agolubkovreg" {
  name = "agolubkovreg"
  folder_id = local.folder_id
  labels = {
    my-label = "agolubkovreg1"
  }
}
resource "yandex_container_registry_iam_binding" "puller" {
  registry_id = yandex_container_registry.agolubkovreg.id
  role        = "container-registry.images.puller"
  members = [
    "system:allUsers",
  ]
}
resource "yandex_container_registry_iam_binding" "pusher" {
  registry_id = yandex_container_registry.agolubkovreg.id
  role        = "container-registry.images.pusher"
  members = [
    "system:allUsers",
  ]
}