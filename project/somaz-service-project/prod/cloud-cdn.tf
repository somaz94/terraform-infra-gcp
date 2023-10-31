## CDN(somaz_link) ##
resource "google_compute_managed_ssl_certificate" "cdn_lb_certificate" {
  name = "somaz-link-ssl-cert"

  managed {
    domains = [var.somaz_link]
  }
}

resource "google_compute_backend_bucket" "somaz_link_bucket_backend" {
  name                 = "somaz-link-backend"
  bucket_name          = var.somaz_link # replace with your bucket name
  enable_cdn           = true
  edge_security_policy = module.cloud_armor_region_block.policy_self_link
  compression_mode     = "AUTOMATIC" # Compression Mode Settings(AUTOMATIC/DISABLED)
  custom_response_headers = [
    "Access-Control-Allow-Origin: *",
    "Access-Control-Allow-Methods: GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE",
    "Access-Control-Allow-Headers: *",
    "Strict-Transport-Security: max-age=31536000",     # Maximum age (max-age): 31536000 (seconds)
    "X-Content-Type-Options: nosniff",                 # Prevents MIME type sniffing
    "X-XSS-Protection: 1; mode=block",                 # Enabled, blocking mode
    "Referrer-Policy: strict-origin-when-cross-origin" # Referrer-Policy setting
  ]

  depends_on = [google_storage_bucket.somaz_link, module.cloud_armor_ip_allow]
}

resource "google_compute_url_map" "cdn_url_map" {
  name            = "somaz-link-url-map"
  default_service = google_compute_backend_bucket.somaz_link_bucket_backend.id

  depends_on = [google_storage_bucket.somaz_link, google_compute_backend_bucket.somaz_link_bucket_backend]
}

resource "google_compute_global_forwarding_rule" "https_forwarding_rule" {
  name       = "somaz-link-https-forwarding-rule"
  target     = google_compute_target_https_proxy.cdn_https_proxy.self_link
  port_range = "443"
  ip_address = google_compute_global_address.somaz_link_lb_ip.address
}

resource "google_compute_target_https_proxy" "cdn_https_proxy" {
  name             = "somaz-link-https-proxy"
  url_map          = google_compute_url_map.cdn_url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.cdn_lb_certificate.self_link]
}


## CDN(asset_somaz_link) ##
resource "google_compute_managed_ssl_certificate" "asset_cdn_lb_certificate" {
  name = "asset-somaz-link-ssl-cert"

  managed {
    domains = [var.asset_somaz_link]
  }
}

resource "google_compute_backend_bucket" "asset_somaz_link_bucket_backend" {
  name             = "asset-somaz-link-backend"
  bucket_name      = var.asset_somaz_link # replace with your bucket name
  enable_cdn       = true
  compression_mode = "AUTOMATIC" # Compression Mode Settings(AUTOMATIC/DISABLED)

  depends_on = [google_storage_bucket.asset_somaz_link, module.cloud_armor_ip_allow]
}

resource "google_compute_url_map" "asset_cdn_url_map" {
  name            = "asset-somaz-link-url-map"
  default_service = google_compute_backend_bucket.asset_somaz_link_bucket_backend.id

  depends_on = [google_storage_bucket.asset_somaz_link, google_compute_backend_bucket.asset_somaz_link_bucket_backend]
}

resource "google_compute_target_https_proxy" "asset_cdn_https_proxy" {
  name             = "asset-luxon-games-https-proxy"
  url_map          = google_compute_url_map.asset_cdn_url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.asset_cdn_lb_certificate.self_link]
}

resource "google_compute_global_forwarding_rule" "asset_https_forwarding_rule" {
  name       = "asset-somaz-link-https-forwarding-rule"
  target     = google_compute_target_https_proxy.asset_cdn_https_proxy.self_link
  port_range = "443"
  ip_address = google_compute_global_address.asset_somaz_link_lb_ip.address
}

## CDN(stg_somaz_link) ##
resource "google_compute_managed_ssl_certificate" "stg_cdn_lb_certificate" {
  name = "stg-somaz-link-ssl-cert"

  managed {
    domains = [var.somaz_link]
  }
}

resource "google_compute_backend_bucket" "stg_somaz_link_bucket_backend" {
  name                 = "stg-somaz-link-backend"
  bucket_name          = var.stg_somaz_link # replace with your bucket name
  enable_cdn           = true
  edge_security_policy = module.cloud_armor_ip_allow.policy_self_link
  compression_mode     = "AUTOMATIC" # Compression Mode Settings(AUTOMATIC/DISABLED)

  depends_on = [google_storage_bucket.stg_somaz_link, module.cloud_armor_ip_allow]
}

resource "google_compute_url_map" "stg_cdn_url_map" {
  name            = "stg-somaz-link-url-map"
  default_service = google_compute_backend_bucket.stg_somaz_link_bucket_backend.id

  depends_on = [google_storage_bucket.stg_somaz_link, google_compute_backend_bucket.somaz_link_bucket_backend]
}

resource "google_compute_global_forwarding_rule" "stg_https_forwarding_rule" {
  name       = "stg-somaz-link-https-forwarding-rule"
  target     = google_compute_target_https_proxy.stg_cdn_https_proxy.self_link
  port_range = "443"
  ip_address = google_compute_global_address.stg_somaz_link_lb_ip.address
}

resource "google_compute_target_https_proxy" "stg_cdn_https_proxy" {
  name             = "stg-somaz-link-https-proxy"
  url_map          = google_compute_url_map.stg_cdn_url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.stg_cdn_lb_certificate.self_link]
}


