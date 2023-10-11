## CDN(qa_somaz_link) ##
resource "google_compute_managed_ssl_certificate" "cdn_lb_certificate" {
  name = "qa-somaz-link-ssl-cert"

  managed {
    domains = [var.somaz_link]
  }
}

resource "google_compute_backend_bucket" "somaz_link_bucket_backend" {
  name                 = "qa-somaz-link-backend"
  bucket_name          = var.somaz_link # replace with your bucket name
  enable_cdn           = true
  edge_security_policy = module.cloud_armor_ip_allow.policy_self_link
  compression_mode = "AUTOMATIC"  # Compression Mode Settings(AUTOMATIC/DISABLED)

  depends_on = [google_storage_bucket.somaz_link, module.cloud_armor_ip_allow]
}

resource "google_compute_url_map" "cdn_url_map" {
  name            = "qa-somaz-link-url-map"
  default_service = google_compute_backend_bucket.somaz_link_bucket_backend.id

  depends_on = [google_storage_bucket.somaz_link, google_compute_backend_bucket.somaz_link_bucket_backend]
}

resource "google_compute_global_forwarding_rule" "https_forwarding_rule" {
  name       = "qa-somaz-link-https-forwarding-rule"
  target     = google_compute_target_https_proxy.cdn_https_proxy.self_link
  port_range = "443"
  ip_address = google_compute_global_address.somaz_link_lb_ip.address
}

resource "google_compute_target_https_proxy" "cdn_https_proxy" {
  name             = "qa-somaz-link-https-proxy"
  url_map          = google_compute_url_map.cdn_url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.cdn_lb_certificate.self_link]
}

## CDN(qa_asset_somaz_link) ##
resource "google_compute_managed_ssl_certificate" "asset_cdn_lb_certificate" {
  name = "qa-asset-somaz-link-ssl-cert"

  managed {
    domains = [var.asset_somaz_link]
  }
}

resource "google_compute_backend_bucket" "asset_somaz_link_bucket_backend" {
  name        = "qa-asset-somaz-link-backend"
  bucket_name = var.asset_somaz_link # replace with your bucket name
  enable_cdn  = true
  compression_mode = "AUTOMATIC"  # Compression Mode Settings(AUTOMATIC/DISABLED)

  depends_on = [google_storage_bucket.asset_somaz_link, module.cloud_armor_ip_allow]
}

resource "google_compute_url_map" "asset_cdn_url_map" {
  name            = "qa-asset-somaz-link-url-map"
  default_service = google_compute_backend_bucket.asset_somaz_link_bucket_backend.id

  depends_on = [google_storage_bucket.asset_somaz_link, google_compute_backend_bucket.asset_somaz_link_bucket_backend]
}

resource "google_compute_target_https_proxy" "asset_cdn_https_proxy" {
  name             = "qa-asset-luxon-games-https-proxy"
  url_map          = google_compute_url_map.asset_cdn_url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.asset_cdn_lb_certificate.self_link]
}

resource "google_compute_global_forwarding_rule" "asset_https_forwarding_rule" {
  name       = "qa-asset-somaz-link-https-forwarding-rule"
  target     = google_compute_target_https_proxy.asset_cdn_https_proxy.self_link
  port_range = "443"
  ip_address = google_compute_global_address.asset_somaz_link_lb_ip.address
}


