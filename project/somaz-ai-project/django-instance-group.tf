resource "google_compute_managed_ssl_certificate" "django_server" {
  name = "django-ssl-cert"
  managed {
    domains = ["django.somaz.link"]
  }
}

resource "google_compute_instance_group" "django_server" {
  name        = "django-server-group"
  description = "Instance Group for django server"
  zone        = "${var.region}-a"
  instances   = [google_compute_instance.django_server.self_link]

  named_port {
    name = "http"
    port = 80
  }

  named_port {
    name = "https"
    port = 443
  }

  named_port {
    name = "backend-celery"
    port = 8080
  }
}

resource "google_compute_health_check" "backend_celery_health_check" {
  name               = "backend-celery-health-check"
  check_interval_sec = 1
  timeout_sec        = 1
  tcp_health_check {
    port = 8080
  }
}

resource "google_compute_backend_service" "backend_celery_backend_service" {
  name        = "backend-celery-backend-service"
  description = "Backend Service for Backend Celery"
  protocol    = "HTTP"
  port_name   = "backend-celery"
  backend {
    group = google_compute_instance_group.django_server.self_link
  }
  health_checks = [google_compute_health_check.backend_celery_health_check.self_link]
}

resource "google_compute_url_map" "backend_celery_url_map" {
  name            = "backend-celery-url-map"
  description     = "URL map for backend-celery LB"
  default_service = google_compute_backend_service.backend_celery_backend_service.self_link
  depends_on      = [google_compute_backend_service.backend_celery_backend_service]
}

resource "google_compute_target_https_proxy" "backend_celery_https_proxy" {
  name             = "backend-celery-https-proxy"
  description      = "HTTPS proxy for Backend Celery service"
  url_map          = google_compute_url_map.backend_celery_url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.django_server.self_link]
}

resource "google_compute_global_forwarding_rule" "backend_celery_https_forwarding_rule" {
  name       = "backend-celery-https-forwarding-rule"
  target     = google_compute_target_https_proxy.backend_celery_https_proxy.self_link
  ip_address = google_compute_global_address.django_lb_ip.address
  port_range = "443"
}

resource "google_compute_url_map" "backend_celery_http_to_https_redirect" {
  name = "backend-celery-http-redirect"
  default_url_redirect {
    https_redirect  = true
    strip_query     = false
  }
}

resource "google_compute_target_http_proxy" "backend_celery_http_proxy" {
  name    = "backend-celery-http-proxy"
  url_map = google_compute_url_map.backend_celery_http_to_https_redirect.self_link
}

resource "google_compute_global_forwarding_rule" "backend_celery_http_forwarding_rule" {
  name       = "backend-celery-http-forwarding-rule"
  target     = google_compute_target_http_proxy.backend_celery_http_proxy.self_link
  ip_address = google_compute_global_address.django_lb_ip.address
  port_range = "80"
}

