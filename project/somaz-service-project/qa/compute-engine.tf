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

  tags = [var.nfs_client]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  metadata = {
    ssh-keys = "somaz:${file("../../../key/somaz-bastion.pub")}" # Change somaz (your compute engine user)
  }

  metadata_startup_script = <<-EOF
      #!/bin/bash
      sudo apt-get update
      sudo apt-get install -y apt-transport-https ca-certificates curl nfs-common mysql-client
      curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
      sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
      sudo mkdir -p /home/somaz/dev /home/somaz/qa
      sudo mount -t nfs <nfs-server-ip>:/nfs/qa /home/somaz/qa    # change <nfs-server-ip>
      echo "<nfs-server-ip>:/nfs/qa /home/somaz/qa nfs defaults 0 0" | sudo tee -a /etc/fstab
      EOF

  network_interface {
    network    = "projects/${var.host_project}/global/networks/${var.shared_vpc}"
    subnetwork = "projects/${var.host_project}/regions/${var.region}/subnetworks/${var.subnet_share}-dev-a"

    access_config {
      ## Include this section to give the VM an external ip ##
      nat_ip = google_compute_address.bastion_ip.address
    }
  }

}
