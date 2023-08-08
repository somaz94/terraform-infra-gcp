## Cloud DNS ##
resource "google_dns_managed_zone" "mgmt_zone" {
  name     = "mgmt-somaz-link"
  dns_name = "mgmt.somaz.link." # Notice the trailing dot, it's necessary
}

resource "google_dns_managed_zone" "root_zone" {
  name     = "somaz_link"
  dns_name = "somaz.link."
}

## Load Balancer Static IP & Cloud DNS Record  ##
resource "google_compute_global_address" "argocd_lb_ip" {
  name = var.argocd_lb_ip_name
}

resource "google_dns_record_set" "argocd_record" {
  depends_on = [
    google_dns_managed_zone.mgmt_zone,
    google_compute_global_address.argocd_lb_ip
  ]
  name         = "argocd.mgmt.somaz.link." # Notice the trailing dot, it's necessary
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.mgmt_zone.name
  rrdatas      = [google_compute_global_address.argocd_lb_ip.address] # Replace with your IP address
}

resource "google_compute_global_address" "prometheus_lb_ip" {
  name = var.prometheus_lb_ip_name
}

resource "google_dns_record_set" "prometheus_record" {
  depends_on = [
    google_dns_managed_zone.mgmt_zone,
    google_compute_global_address.prometheus_lb_ip
  ]
  name         = "prometheus.mgmt.somaz.link." # Notice the trailing dot, it's necessary
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.mgmt_zone.name
  rrdatas      = [google_compute_global_address.prometheus_lb_ip.address] # Replace with your IP address
}

resource "google_compute_global_address" "grafana_lb_ip" {
  name = var.grafana_lb_ip_name
}

resource "google_dns_record_set" "grafana_record" {
  depends_on = [
    google_dns_managed_zone.mgmt_zone,
    google_compute_global_address.grafana_lb_ip
  ]
  name         = "grafana.mgmt.somaz.link." # Notice the trailing dot, it's necessary
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.mgmt_zone.name
  rrdatas      = [google_compute_global_address.grafana_lb_ip.address] # Replace with your IP address
}

resource "google_compute_global_address" "loki_lb_ip" {
  name = var.loki_lb_ip_name
}

resource "google_dns_record_set" "loki_record" {
  depends_on = [
    google_dns_managed_zone.mgmt_zone,
    google_compute_global_address.loki_lb_ip
  ]
  name         = "loki.mgmt.somaz.link." # Notice the trailing dot, it's necessary
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.mgmt_zone.name
  rrdatas      = [google_compute_global_address.loki_lb_ip.address] # Replace with your IP address
}

## ganache server mongodb blockchain setting ##
resource "google_compute_global_address" "mongo_log_lb_ip" {
  name = var.mongo_log_lb_ip_name
}

resource "google_compute_global_address" "blockchain_lb_ip" {
  name = var.blockchain_lb_ip_name
}

resource "google_compute_global_address" "gitlab_server_lb_ip" {
  name = var.gitlab_server_lb_ip_name
}

resource "google_dns_record_set" "mongo_log_record" {
  depends_on = [
    google_dns_managed_zone.mgmt_zone,
    google_compute_global_address.mongo_log_lb_ip
  ]
  name         = "mongo-log.mgmt.somaz.link." # Notice the trailing dot, it's necessary
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.mgmt_zone.name
  rrdatas      = [google_compute_global_address.mongo_log_lb_ip.address] # Replace with your IP address
}

resource "google_dns_record_set" "blockchain_record" {
  depends_on = [
    google_dns_managed_zone.mgmt_zone,
    google_compute_global_address.blockchain_lb_ip
  ]
  name         = "blockchain.mgmt.somaz.link." # Notice the trailing dot, it's necessary
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.mgmt_zone.name
  rrdatas      = [google_compute_global_address.blockchain_lb_ip.address] # Replace with your IP address
}

resource "google_dns_record_set" "gitlab_server_record" {
  depends_on = [
    google_dns_managed_zone.mgmt_zone,
    google_compute_global_address.gitlab_server_lb_ip
  ]
  name         = "gitlab.mgmt.somaz.link." # Notice the trailing dot, it's necessary and Replace with your Domain
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.mgmt_zone.name
  rrdatas      = [google_compute_global_address.gitlab_server_lb_ip.address] # Replace with your IP address
}
