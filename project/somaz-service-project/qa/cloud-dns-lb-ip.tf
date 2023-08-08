## Load Balancer Static IP & Cloud DNS Record  ##
resource "google_compute_global_address" "web_lb_ip" {
  name = var.web_lb_ip_name
}

resource "google_dns_record_set" "web_record" {
  depends_on = [google_compute_global_address.web_lb_ip]
  name         = "qa-web.somaz.link." # Notice the trailing dot, it's necessary
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
  depends_on = [google_compute_global_address.game_lb_ip]
  name         = "qa-game.somaz.link."
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
  depends_on = [google_compute_global_address.was_lb_ip]
  name         = "qa-was.somaz.link."
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
  depends_on = [google_compute_global_address.asset_somaz_link_lb_ip]
  name         = "qa-asset.somaz.link."
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
  depends_on = [google_compute_global_address.somaz_link_lb_ip]
  name         = "qa.somaz.link."
  type         = "A"
  ttl          = 300
  managed_zone = "somaz-link"
  project      = var.host_project
  rrdatas      = [google_compute_global_address.somaz_link_lb_ip.address]
}


