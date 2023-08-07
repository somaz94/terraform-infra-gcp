## Compute Engine ##
resource "google_compute_address" "nfs_server_ip" {
  name = var.nfs_server_ip
}

resource "google_compute_disk" "additional_pd_balanced" {
  name = "nfs-disk"
  type = "pd-balanced"
  zone = "${var.region}-a"
  size = 100
}

resource "google_compute_instance" "nfs_server" {
  depends_on = [
    module.vpc,
    google_compute_address.nfs_server_ip,
    google_compute_disk.additional_pd_balanced
  ]

  name                      = var.nfs_server
  machine_type              = "e2-standard-2"
  labels                    = local.default_labels
  zone                      = "${var.region}-a"
  allow_stopping_for_update = true

  tags = [var.nfs_server]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  attached_disk {
    source      = google_compute_disk.additional_pd_balanced.self_link
    device_name = google_compute_disk.additional_pd_balanced.name
  }

  metadata = {
    ssh-keys = "somaz:${file("../../key/somaz-nfs-server.pub")}" # Change somaz (your compute engine user)
  }

  metadata_startup_script = <<-EOF
      #!/bin/bash
      sudo apt-get update
      sudo apt-get install -y nfs-kernel-server
      sudo mkdir /nfs
      sudo mkfs.xfs /dev/sdb
      echo -e '/dev/sdb /nfs xfs defaults,nofail 0 0' | sudo tee -a /etc/fstab
      sudo mount -a
      sudo mkdir -p /nfs/dev /nfs/qa 
      sudo chown nobody:nogroup /nfs/dev /nfs/qa 
      sudo chmod 777 /nfs/dev /nfs/qa1
      echo '/nfs/dev 10.0.0.0/8(rw,sync,no_subtree_check)' | sudo tee -a /etc/exports
      echo '/nfs/qa 10.0.0.0/8(rw,sync,no_subtree_check)' | sudo tee -a /etc/exports
      sudo exportfs -a
      sudo systemctl restart nfs-kernel-server
      EOF

  network_interface {
    network    = var.shared_vpc
    subnetwork = "${var.subnet_share}-mgmt-a"

    access_config {
      ## Include this section to give the VM an external ip ##
      nat_ip = google_compute_address.nfs_server_ip.address

    }
  }
}

## Compute Engine ##
resource "google_compute_address" "prod_nfs_server_ip" {
  name   = var.prod_nfs_server_ip
  region = var.prod_region
}

resource "google_compute_disk" "prod_additional_pd_balanced" {
  name = "prod-nfs-disk"
  type = "pd-balanced"
  zone = "${var.prod_region}-a"
  size = 100
}

resource "google_compute_instance" "prod_nfs_server" {
  depends_on = [
    module.prod_vpc,
    google_compute_address.prod_nfs_server_ip,
    google_compute_disk.prod_additional_pd_balanced
  ]

  name                      = var.prod_nfs_server
  machine_type              = "e2-standard-2"
  labels                    = local.default_labels
  zone                      = "${var.prod_region}-a"
  allow_stopping_for_update = true

  tags = [var.prod_nfs_server]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  attached_disk {
    source      = google_compute_disk.prod_additional_pd_balanced.self_link
    device_name = google_compute_disk.prod_additional_pd_balanced.name
  }

  metadata = {
    ssh-keys = "somaz:${file("../../key/somaz-nfs-server.pub")}"
  }

  metadata_startup_script = <<-EOF
      #!/bin/bash
      sudo apt-get update
      sudo apt-get install -y nfs-kernel-server
      sudo mkdir /nfs
      sudo mkfs.xfs /dev/sdb
      echo -e '/dev/sdb /nfs xfs defaults,nofail 0 0' | sudo tee -a /etc/fstab
      sudo mount -a
      sudo mkdir -p /nfs/prod
      sudo chown nobody:nogroup /nfs/prod
      sudo chmod 777 /nfs/prod
      echo '/nfs/prod 10.0.0.0/8(rw,sync,no_subtree_check)' | sudo tee -a /etc/exports
      sudo exportfs -a
      sudo systemctl restart nfs-kernel-server
      EOF

  network_interface {
    network    = var.prod_shared_vpc
    subnetwork = "${var.prod_subnet_share}-mgmt-a"

    access_config {
      ## Include this section to give the VM an external ip ##
      nat_ip = google_compute_address.prod_nfs_server_ip.address

    }
  }
}

## Compute Engine ##
resource "google_compute_address" "service_server_ip" {
  name = var.service_server_ip
}

resource "google_compute_instance" "service_server" {
  depends_on = [
    google_compute_address.service_server_ip
  ]

  name                      = var.service_server
  machine_type              = "n2-standard-2"
  labels                    = local.default_labels
  zone                      = "${var.region}-a"
  allow_stopping_for_update = true

  tags = [var.nfs_client, var.service_server]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = 100
    }
  }

  metadata = {
    ssh-keys = "somaz:${file("../../key/somaz-service-server.pub")}"
  }

  network_interface {
    network    = var.shared_vpc
    subnetwork = "${var.subnet_share}-mgmt-b"

    access_config {
      ## Include this section to give the VM an external ip ##
      nat_ip = google_compute_address.service_server_ip.address
    }
  }

}

## Compute Engine ##(gitlab)

resource "google_compute_disk" "git_data_disk" {
  name  = "git-data-disk"
  type  = "pd-balanced"
  size  = 500
  zone  = "${var.region}-a"
}

resource "google_compute_disk" "lfs_objects_disk" {
  name  = "lfs-objects-disk"
  type  = "pd-balanced"
  size  = 500
  zone  = "${var.region}-a"
}

resource "google_compute_disk" "backups_disk" {
  name  = "backups-disk"
  type  = "pd-balanced"
  size  = 1000
  zone  = "${var.region}-a"
}

resource "google_compute_address" "gitlab_server_ip" {
  name = var.gitlab_server_ip
}

resource "google_compute_instance" "gitlab_server" {
  depends_on = [
    google_compute_address.gitlab_server_ip,
    google_compute_disk.git_data_disk,
    google_compute_disk.lfs_objects_disk,
    google_compute_disk.backups_disk    
  
  ]

  name                      = var.gitlab_server
  machine_type              = "n2-standard-2"
  labels                    = local.default_labels
  zone                      = "${var.region}-a"
  allow_stopping_for_update = true

  tags = [var.nfs_client, var.gitlab_server]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = 100
    }
  }

  attached_disk {
    source      = google_compute_disk.git_data_disk.self_link
    device_name = google_compute_disk.git_data_disk.name
  }

  attached_disk {
    source      = google_compute_disk.lfs_objects_disk.self_link
    device_name = google_compute_disk.lfs_objects_disk.name
  }

  attached_disk {
    source      = google_compute_disk.backups_disk.self_link
    device_name = google_compute_disk.backups_disk.name
  }

  metadata = {
    ssh-keys = "somaz:${file("../../key/somaz-gitlab-server.pub")}"
  }

  metadata_startup_script = <<-EOF
      #!/bin/bash
      sudo apt-get update
      sudo apt-get install -y curl openssh-server ca-certificates
      curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash 
      sudo EXTERNAL_URL="https://gitlab.somaz.link/" apt-get install gitlab-ce     # Replace with your Domain
      echo "letsencrypt['enable'] = false" | sudo tee -a /etc/gitlab/gitlab.rb
      sleep 10
      sudo gitlab-ctl reconfigure
      sudo gitlab-ctl restart
      sudo mkfs.ext4 /dev/sdb
      sudo mkfs.ext4 /dev/sdc
      sudo mkfs.ext4 /dev/sdd
      echo "/dev/sdb /var/opt/gitlab/git-data ext4 defaults 0 0" | sudo tee -a /etc/fstab
      echo "/dev/sdc /var/opt/gitlab/gitlab-rails/shared/lfs-objects ext4 defaults 0 0" | sudo tee -a /etc/fstab
      echo "/dev/sdd /var/opt/gitlab/backups ext4 defaults 0 0" | sudo tee -a /etc/fstab
      sudo mount -a
      EOF        

  network_interface {
    network    = var.shared_vpc
    subnetwork = "${var.subnet_share}-mgmt-a"

    access_config {
      ## Include this section to give the VM an external ip ##
      nat_ip = google_compute_address.gitlab_server_ip.address
    }
  }

}