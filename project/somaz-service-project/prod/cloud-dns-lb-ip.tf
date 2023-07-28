## Load Balancer Static IP & Cloud DNS Record  ##
resource "google_compute_global_address" "web_lb_ip" {
  name = var.web_lb_ip_name
}

resource "google_dns_record_set" "web_record" {
  name         = "web.somaz.link." # Notice the trailing dot, it's necessary
  type         = "A"
  ttl          = 300
  managed_zone = "somaz-link"
  project      = var.host_project
  rrdatas      = [google_compute_global_address.web_lb_ip.address] # Replace with your IP address
}

resource "google_compute_global_address" "game_lb_ip" {
  name = var.game_lb_ip_name
}

resource "google_dns_record_set" "game_record" {
  name         = "game.somaz.link."
  type         = "A"
  ttl          = 300
  managed_zone = "somaz-link"
  project      = var.host_project
  rrdatas      = [google_compute_global_address.game_lb_ip.address]
}

resource "google_compute_global_address" "was_lb_ip" {
  name = var.was_lb_ip_name
}

resource "google_dns_record_set" "was_record" {
  name         = "was.somaz.link."
  type         = "A"
  ttl          = 300
  managed_zone = "somaz-link"
  project      = var.host_project
  rrdatas      = [google_compute_global_address.was_lb_ip.address]
}

resource "google_compute_global_address" "asset_somaz_link_lb_ip" {
  name = var.asset_somaz_link_lb_ip_name
}

resource "google_dns_record_set" "asset_record" {
  name         = "asset.somaz.link."
  type         = "A"
  ttl          = 300
  managed_zone = "somaz-link"
  project      = var.host_project
  rrdatas      = [google_compute_global_address.asset_somaz_link_lb_ip.address]
}

resource "google_compute_global_address" "somaz_link_lb_ip" {
  name = var.somaz_link_lb_ip_name
}

resource "google_dns_record_set" "cdn_record" {
  name         = "somaz.link."
  type         = "A"
  ttl          = 300
  managed_zone = "somaz-link"
  project      = var.host_project
  rrdatas      = [google_compute_global_address.somaz_link_lb_ip.address]
}

resource "google_compute_global_address" "stg_somaz_link_lb_ip" {
  name = var.stg_somaz_link_lb_ip_name
}

resource "google_dns_record_set" "stg_cdn_record" {
  name         = "stg.somaz.link."
  type         = "A"
  ttl          = 300
  managed_zone = "somaz-link"
  project      = var.host_project
  rrdatas      = [google_compute_global_address.stg_somaz_link_lb_ip.address]
}


