//------------Create BuildVM---------------------//
resource "yandex_compute_instance" "build-vm" {
  name = "build-vm"
  allow_stopping_for_update = true
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd88m3uah9t47loeseir" # ОС (Ubuntu, 22.04 LTS)
    }
  }

  network_interface {
    subnet_id = "e9besrroes8vu5s5ce0a" # одна из дефолтных подсетей
    nat = true # автоматически установить динамический ip
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }

connection {
    type     = "ssh"
    user     = "jenkins"
    private_key = file("~/.ssh/id_rsa")
    host = yandex_compute_instance.build-vm.network_interface.0.nat_ip_address
  }
provisioner "remote-exec" {
    inline = [
      "sudo apt update", 
    ]
  }
}



#----------PROD VM-------------#
resource "yandex_compute_instance" "prod-vm" {
  name = "prod-vm"
  allow_stopping_for_update = true
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd88m3uah9t47loeseir" # ОС (Ubuntu, 22.04 LTS)
    }
  }

  network_interface {
    subnet_id = "e9besrroes8vu5s5ce0a" # одна из дефолтных подсетей
    nat = true # автоматически установить динамический ip
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
connection {
    type     = "ssh"
    user     = "jenkins"
    private_key = file("~/.ssh/id_rsa")
    host = yandex_compute_instance.prod-vm.network_interface.0.nat_ip_address
  }
provisioner "remote-exec" {
    inline = [
      "sudo apt update", 
    ]
  }
}


output "nat_ip_vm_build" {
  value = yandex_compute_instance.build-vm.network_interface.0.nat_ip_address
}
output "nat_ip__vm_prod" {
  value = yandex_compute_instance.prod-vm.network_interface.0.nat_ip_address
}