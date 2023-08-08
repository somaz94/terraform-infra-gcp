## Compute Engine ##
resource "google_compute_address" "bastion_ip" {
  name = var.bastion_ip
}

resource "google_compute_instance" "bastion" {
  depends_on = [google_compute_address.bastion_ip]

  name                      = var.bastion
  machine_type              = "e2-small"
  labels                    = local.default_labels
  zone                      = "${var.region}-a"
  allow_stopping_for_update = true

  tags = [var.prod_nfs_client]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  metadata = {
    ssh-keys = "nerdystar:${file("../../../key/somaz-bastion.pub")}"
  }

  metadata_startup_script = <<-EOF
      #!/bin/bash
      sudo apt-get update
      sudo apt-get install -y apt-transport-https ca-certificates curl nfs-common mysql-client
      curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
      sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
      sudo mkdir -p /home/somaz/prod
      sudo mount -t nfs <prod-nfs-server-ip>:/nfs/prod /home/somaz/prod   # change <prod-nfs-server-ip>
      echo "<prod-nfs-server-ip>:/nfs/prod /home/somaz/prod nfs defaults 0 0" | sudo tee -a /etc/fstab
      EOF

  network_interface {
    network    = "projects/${var.host_project}/global/networks/${var.shared_vpc}"
    subnetwork = "projects/${var.host_project}/regions/${var.region}/subnetworks/${var.subnet_share}-prod-a"

    access_config {
      ## Include this section to give the VM an external ip ##
      nat_ip = google_compute_address.bastion_ip.address
    }
  }

}
