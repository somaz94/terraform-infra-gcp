resource "google_compute_managed_ssl_certificate" "mongo_log" {
  name = "mongo-log-ssl-cert"
  managed {
    domains = ["mongo-log.somaz.link"]
  }
}

resource "google_compute_managed_ssl_certificate" "blockchain" {
  name = "blockchain-ssl-cert"
  managed {
    domains = ["blockchain.gcp-somaz.link"]
  }
}

resource "google_compute_instance_group" "service_server" {
  name        = "ganache-server-group"
  description = "Instance Group for service server"
  zone        = "${var.region}-a"
  instances   = [google_compute_instance.service_server.self_link]

  named_port {
    name = "http"
    port = 80
  }

  named_port {
    name = "https"
    port = 443
  }

  named_port {
    name = "mongo-log"
    port = 27017
  }

  named_port {
    name = "blockchain"
    port = 7545
  }
}

resource "google_compute_http_health_check" "mongo_log_health_check" {
  name               = "mongo-log-health-check"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
  port               = 27017
}

resource "google_compute_health_check" "blockchain_health_check" {
  name               = "blockchain-health-check"
  check_interval_sec = 1
  timeout_sec        = 1
  tcp_health_check {
    port = 7545
  }
}

resource "google_compute_backend_service" "mongo_log_backend" {
  name        = "mongo-log-backend-service"
  description = "Backend Service for MongoDB logs"
  protocol    = "HTTP"
  port_name   = "mongo-log"
  backend {
    group = google_compute_instance_group.service_server.self_link
  }
  health_checks = [google_compute_http_health_check.mongo_log_health_check.self_link]
}

resource "google_compute_backend_service" "blockchain_backend" {
  name        = "blockchain-backend-service"
  description = "Backend Service for Blockchain"
  protocol    = "HTTP"
  port_name   = "blockchain"
  backend {
    group = google_compute_instance_group.service_server.self_link
  }
  health_checks = [google_compute_health_check.blockchain_health_check.self_link]
}

resource "google_compute_target_https_proxy" "mongo_log" {
  name             = "mongo-log-https-proxy"
  description      = "HTTPS proxy for MongoDB log service"
  url_map          = google_compute_url_map.mongo_log_url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.mongo_log.self_link]
}

resource "google_compute_target_https_proxy" "blockchain" {
  name             = "blockchain-https-proxy"
  description      = "HTTPS proxy for Blockchain service"
  url_map          = google_compute_url_map.blockchain_url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.blockchain.self_link]
}

resource "google_compute_url_map" "mongo_log_url_map" {
  name            = "mongo-log-url-map"
  description     = "URL map for mongo-log LB"
  default_service = google_compute_backend_service.mongo_log_backend.self_link

  depends_on = [google_compute_backend_service.mongo_log_backend]
}

resource "google_compute_url_map" "blockchain_url_map" {
  name            = "blockchain-url-map"
  description     = "URL map for blockchain LB"
  default_service = google_compute_backend_service.blockchain_backend.self_link

  depends_on = [google_compute_backend_service.blockchain_backend]
}

resource "google_compute_global_forwarding_rule" "mongo_log" {
  name       = "mongo-log-forwarding-rule"
  target     = google_compute_target_https_proxy.mongo_log.self_link
  ip_address = google_compute_global_address.mongo_log_lb_ip.address
  port_range = "443"
}

resource "google_compute_global_forwarding_rule" "blockchain" {
  name       = "blockchain-forwarding-rule"
  target     = google_compute_target_https_proxy.blockchain.self_link
  ip_address = google_compute_global_address.blockchain_lb_ip.address
  port_range = "443"
}
