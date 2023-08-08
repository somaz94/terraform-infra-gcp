## Load Balancer Static IP & Cloud DNS Record  ##
resource "google_compute_global_address" "web_lb_ip" {
  name = var.web_lb_ip_name
}

resource "google_dns_record_set" "web_record" {
  depends_on = [google_compute_global_address.web_lb_ip]
  name         = "dev-web.somaz.link." # Notice the trailing dot, it's necessary
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
  name         = "dev-game.somaz.link."
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
  name         = "dev-was.somaz.link."
  type         = "A"
  ttl          = 300
  managed_zone = "somaz-link"
  project      = var.host_project
  rrdatas      = [google_compute_global_address.was_lb_ip.address]
}

resource "google_dns_record_set" "asset_record" {
  name         = "dev-asset.somaz.link." # Notice the trailing dot, it's necessary
  type         = "CNAME"
  ttl          = 300
  managed_zone = "somaz-link"
  project      = var.host_project
  rrdatas      = ["c.storage.googleapis.com."] # CNAME destination for GCS buckets
}

resource "google_compute_global_address" "somaz_link_lb_ip" {
  name = var.somaz_link_lb_ip_name
}

resource "google_dns_record_set" "cdn_record" {
  depends_on = [google_compute_global_address.somaz_link_lb_ip]
  name         = "dev.somaz.link."
  type         = "A"
  ttl          = 300
  managed_zone = "somaz-link"
  project      = var.host_project
  rrdatas      = [google_compute_global_address.somaz_link_lb_ip.address]
}
