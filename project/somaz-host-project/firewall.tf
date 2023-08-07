## Firewall ##
resource "google_compute_firewall" "nfs_server_ssh" {
  depends_on = [
    module.vpc
  ]

  name    = "allow-ssh-nfs-server"
  network = var.shared_vpc

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["${var.public_ip}/32", "${var.public_ip2}/32", "0.0.0.0/0"]
  target_tags   = [var.nfs_server, var.nfs_client, var.service_server, var.gitlab_server]
}


resource "google_compute_firewall" "shared_vpc_internal" {
  depends_on = [
    module.vpc
  ]

  name    = "allow-shared-vpc-internal"
  network = var.shared_vpc

  dynamic "allow" {
    for_each = var.shared_vpc_internal_rules
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  source_ranges = ["10.0.0.0/8"]
}

resource "google_compute_firewall" "prod_nfs_server_ssh" {
  depends_on = [
    module.prod_vpc
  ]

  name    = "prod-allow-ssh-nfs-server"
  network = var.prod_shared_vpc

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["${var.public_ip}/32", "${var.public_ip2}/32", "0.0.0.0/0"]
  target_tags   = [var.prod_nfs_server, var.prod_nfs_client]
}


resource "google_compute_firewall" "prod_shared_vpc_internal" {
  depends_on = [
    module.prod_vpc
  ]

  name    = "prod-allow-shared-vpc-internal"
  network = var.prod_shared_vpc

  dynamic "allow" {
    for_each = var.shared_vpc_internal_rules
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  source_ranges = ["10.0.0.0/8"]
}


resource "google_compute_firewall" "ganache_instance_group_health_check" {
  depends_on = [
    module.vpc
  ]

  name    = "allow-ganache-instance-group-health-check"
  network = var.shared_vpc

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "7545", "27017"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]     # Don't Change https://cloud.google.com/load-balancing/docs/health-checks?hl=ko#firewall_rules
  target_tags   = [var.ganache_server]
}
