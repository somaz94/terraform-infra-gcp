## Cloud NAT & Router ##
resource "google_compute_router" "router" {
  depends_on = [module.vpc]
  name    = var.nat_router
  network = var.shared_vpc
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  depends_on = [google_compute_router_nat.nat]  
  name                               = var.nat_name
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

## Prod Cloud NAT & Router ##
resource "google_compute_router" "prod_router" {
  depends_on = [module.prod_vpc]
  name    = var.prod_nat_router
  network = var.prod_shared_vpc
  region  = var.prod_region
}

resource "google_compute_router_nat" "prod_nat" {
  depends_on = [google_compute_router_nat.prod_nat]  
  name                               = var.prod_nat_name
  router                             = google_compute_router.prod_router.name
  region                             = google_compute_router.prod_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
