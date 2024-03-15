# Load Balancer Static IP & Cloud DNS Record #
resource "google_compute_global_address" "django_lb_ip" {
  name = var.django_lb_ip_name
}

resource "google_dns_record_set" "django_record" {
  name         = "django.somaz.link."
  type         = "A"
  ttl          = 300
  managed_zone = "somaz-link"
  project      = var.host_project
  rrdatas      = [google_compute_global_address.django_lb_ip.address]

  depends_on = [google_compute_global_address.django_lb_ip]
}

