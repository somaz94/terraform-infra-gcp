## CDN ##
resource "google_compute_managed_ssl_certificate" "cdn_lb_certificate" {
  name = "dev-somaz-link-ssl-cert"

  managed {
    domains = [var.somaz_link]
  }
}

resource "google_compute_backend_bucket" "somaz_link_bucket_backend" {
  name                 = "dev-somaz-link-backend"
  bucket_name          = var.somaz_link # replace with your bucket name
  enable_cdn           = true
  edge_security_policy = module.cloud_armor_ip_allow.policy_self_link

  depends_on = [google_storage_bucket.somaz_link, module.cloud_armor_ip_allow]
}

resource "google_compute_url_map" "cdn_url_map" {
  name            = "dev-somaz-link-url-map"
  default_service = google_compute_backend_bucket.somaz_link_bucket_backend.id

  depends_on = [google_storage_bucket.somaz_link, google_compute_backend_bucket.somaz_link_bucket_backend]
}

resource "google_compute_global_forwarding_rule" "https_forwarding_rule" {
  name       = "dev-somaz-link-https-forwarding-rule"
  target     = google_compute_target_https_proxy.cdn_https_proxy.self_link
  port_range = "443"
  ip_address = google_compute_global_address.somaz_link_lb_ip.address
}

resource "google_compute_target_https_proxy" "cdn_https_proxy" {
  name             = "dev-somaz-link-https-proxy"
  url_map          = google_compute_url_map.cdn_url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.cdn_lb_certificate.self_link]
}
