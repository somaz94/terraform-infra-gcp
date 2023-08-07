## Network(Shared VPC) ##

module "vpc" {
  source = "../../modules/network"

  project_id                             = var.project
  network_name                           = var.shared_vpc
  shared_vpc_host                        = true
  delete_default_internet_gateway_routes = true
  auto_create_subnetworks                = false
  routing_mode                           = "REGIONAL"

  subnets = [
    {
      subnet_name           = "${var.subnet_share}-dev-a"
      subnet_ip             = "10.77.1.0/24"
      subnet_region         = var.region
      subnet_private_access = "true"
    },
    {
      subnet_name           = "${var.subnet_share}-dev-b"
      subnet_ip             = "10.77.2.0/24"
      subnet_region         = var.region
      subnet_private_access = "true"
    },
    {
      subnet_name           = "${var.subnet_share}-qa-a"
      subnet_ip             = "10.77.11.0/24"
      subnet_region         = var.region
      subnet_private_access = "true"
    },
    {
      subnet_name           = "${var.subnet_share}-qa-b"
      subnet_ip             = "10.77.12.0/24"
      subnet_region         = var.region
      subnet_private_access = "true"
    },
    {
      subnet_name           = "${var.subnet_share}-mgmt-a"
      subnet_ip             = "10.77.101.0/24"
      subnet_region         = var.region
      subnet_private_access = "true"
    },
    {
      subnet_name           = "${var.subnet_share}-mgmt-b"
      subnet_ip             = "10.77.102.0/24"
      subnet_region         = var.region
      subnet_private_access = "true"
    }  
  ]

  secondary_ranges = {
    "${var.subnet_share}-dev-a" = [
      {
        range_name    = var.dev_gke_pod
        ip_cidr_range = "10.11.0.0/17"
      },
      {
        range_name    = var.dev_gke_service
        ip_cidr_range = "10.11.128.0/22"
      },
    ]

    "${var.subnet_share}-qa-a" = [
      {
        range_name    = var.qa_gke_pod
        ip_cidr_range = "10.12.0.0/17"
      },
      {
        range_name    = var.qa_gke_service
        ip_cidr_range = "10.12.128.0/22"
      },
    ]

    "${var.subnet_share}-mgmt-a" = [
      {
        range_name    = var.mgmt_gke_pod
        ip_cidr_range = "10.21.0.0/17"
      },
      {
        range_name    = var.mgmt_gke_service
        ip_cidr_range = "10.21.128.0/22"
      },
    ]


  }

  routes = [
    {
      name              = "${var.shared_vpc}-rt"
      description       = "Routing Table to access the internet"
      destination_range = "0.0.0.0/0"
      next_hop_internet = "true"
    }
  ]
}

resource "google_compute_shared_vpc_host_project" "host_project" {
  project = var.project # Replace this with your host project ID in quotes
}

resource "google_compute_shared_vpc_service_project" "service_project" {
  depends_on      = [google_compute_shared_vpc_host_project.host_project]
  for_each        = toset(var.service_project)
  host_project    = var.project
  service_project = each.key
}

## Network(Prod Shared VPC) ##
module "prod_vpc" {
  source = "../../modules/network"

  project_id                             = var.project
  network_name                           = var.prod_shared_vpc
  shared_vpc_host                        = true
  delete_default_internet_gateway_routes = true
  auto_create_subnetworks                = false
  routing_mode                           = "REGIONAL"

  subnets = [
    {
      subnet_name           = "${var.prod_subnet_share}-mgmt-a"
      subnet_ip             = "10.77.111.0/24"
      subnet_region         = var.prod_region
      subnet_private_access = "true"
    },
    {
      subnet_name           = "${var.prod_subnet_share}-mgmt-b"
      subnet_ip             = "10.77.112.0/24"
      subnet_region         = var.prod_region
      subnet_private_access = "true"
    },
    {
      subnet_name           = "${var.prod_subnet_share}-prod-a"
      subnet_ip             = "10.77.151.0/24"
      subnet_region         = var.prod_region
      subnet_private_access = "true"
    },
    {
      subnet_name           = "${var.prod_subnet_share}-prod-b"
      subnet_ip             = "10.77.152.0/24"
      subnet_region         = var.prod_region
      subnet_private_access = "true"
    }
  ]

  secondary_ranges = {
    "${var.prod_subnet_share}-prod-a" = [
      {
        range_name    = var.prod_dsp_gke_pod
        ip_cidr_range = "10.101.0.0/17"
      },
      {
        range_name    = var.prod_dsp_gke_service
        ip_cidr_range = "10.101.128.0/22"
      },
    ]
  }

  routes = [
    {
      name              = "${var.prod_shared_vpc}-rt"
      description       = "Routing Table to access the internet"
      destination_range = "0.0.0.0/0"
      next_hop_internet = "true"
    }
  ]
}

resource "google_compute_shared_vpc_service_project" "prod_service_project" {
  depends_on      = [google_compute_shared_vpc_host_project.host_project]
  for_each        = toset(var.prod_service_project)
  host_project    = var.project
  service_project = each.key
}
