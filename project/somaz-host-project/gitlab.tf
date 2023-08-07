# lb
resource "google_compute_managed_ssl_certificate" "gitlab_server" {
  name = "gitlab-server-ssl-cert"
  managed {
    domains = ["gitlab.somaz.link"]
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





