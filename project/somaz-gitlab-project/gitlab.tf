## Compute Engine ##(gitlab)

resource "google_compute_disk" "git_data_disk" {
  name  = "git-data-disk"
  type  = "pd-balanced"
  size  = 100
  zone  = "${var.region}-a"
}

resource "google_compute_disk" "lfs_objects_disk" {
  name  = "lfs-objects-disk"
  type  = "pd-balanced"
  size  = 100
  zone  = "${var.region}-a"
}

resource "google_compute_disk" "backups_disk" {
  name  = "backups-disk"
  type  = "pd-balanced"
  size  = 100
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
      sudo EXTERNAL_URL="https://gitlab.example.com/" apt-get install gitlab-ce     # Replace with your Domain
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
    subnetwork = "${var.subnet_share}-gitlab-a"

    access_config {
      ## Include this section to give the VM an external ip ##
      nat_ip = google_compute_address.gitlab_server_ip.address
    }
  }

}

## firewall
resource "google_compute_firewall" "gitlab_server_group_health_check" {

  name    = "allow-gitlab-server-group-health-check"
  network = var.shared_vpc

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = [var.gitlab_server]
}


## dns
resource "google_compute_global_address" "gitlab_server_lb_ip" {
  name = var.gitlab_server_lb_ip_name
}

resource "google_dns_record_set" "gitlab_server_record" {
  depends_on   = [google_dns_managed_zone.mgmt_zone]
  name         = "gitlab.example.com." # Notice the trailing dot, it's necessary and Replace with your Domain
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.mgmt_zone.name
  rrdatas      = [google_compute_global_address.gitlab_server_lb_ip.address] # Replace with your IP address
}

# lb
resource "google_compute_managed_ssl_certificate" "gitlab_server" {
  name = "gitlab-server-ssl-cert"
  managed {
    domains = ["gitlab.example.com"]
  }
}

resource "google_compute_instance_group" "gitlab_server" {
  depends_on  = [google_compute_instance.gitlab_server]
  name        = "gitlab-server-group"
  description = "Instance Group for gitlab server"
  zone        = "${var.region}-a"
  instances   = [google_compute_instance.gitlab_server.self_link]

  named_port {
    name = "https"
    port = 443
  }

  named_port {
    name = "gitlab-server"
    port = 22
  }

}

resource "google_compute_health_check" "gitlab_server_health_check" {
  name               = "gitlab-server-health-check"
  check_interval_sec = 1
  timeout_sec        = 1
  tcp_health_check {
    port = 443
  }
}


resource "google_compute_backend_service" "gitlab_server_backend" {
  name        = "gitlab-server-backend-service"
  description = "Backend Service for gitlab server"
  protocol    = "HTTPS"
  port_name   = "https"
  backend {
    group = google_compute_instance_group.gitlab_server.self_link
  }
  health_checks = [google_compute_health_check.gitlab_server_health_check.self_link]
}


resource "google_compute_target_https_proxy" "gitlab_server" {
  name             = "gitlab-server-https-proxy"
  description      = "HTTPS proxy for gitlab server"
  url_map          = google_compute_url_map.gitlab_server_url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.gitlab_server.self_link]
}


resource "google_compute_url_map" "gitlab_server_url_map" {
  name            = "gitlab-server-url-map"
  description     = "URL map for gitlab server"
  default_service = google_compute_backend_service.gitlab_server_backend.self_link
  depends_on = [google_compute_backend_service.gitlab_server_backend]
}


resource "google_compute_global_forwarding_rule" "gitlab_server" {
  name       = "gitlab-server-forwarding-rule"
  target     = google_compute_target_https_proxy.gitlab_server.self_link
  ip_address = google_compute_global_address.gitlab_server_lb_ip.address
  port_range = "443"
}




