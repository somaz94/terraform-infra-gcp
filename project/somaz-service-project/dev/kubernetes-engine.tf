## GKE IAM Binding 선행 작업 진행하기 ##
## BUG!!! Terraform으로 진행하면, 기존에 binding 되어있는 리소스가 사라짐. ##
## 참고 사이트 https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-shared-vpc?hl=ko#gcloud_3 ##

# Google Kubernetes Cluster Engine(GKE)
# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke_autopilot.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke_autopilot.ca_certificate)
}

module "gke_autopilot" {
  source                            = "../../../modules/gke_autopilot"
  project_id                        = var.project
  network_project_id                = var.host_project
  cluster_resource_labels           = local.default_labels
  name                              = var.gke
  region                            = var.region
  zones                             = ["${var.region}-a", "${var.region}-b"]
  network                           = var.shared_vpc
  subnetwork                        = "${var.subnet_share}-dev-a"
  ip_range_pods                     = "dev-somaz-gke-pod"
  ip_range_services                 = "dev-somaz-gke-service"
  enable_cost_allocation            = false # Enables Cost Allocation Feature and the cluster name and namespace of your GKE workloads appear in the labels field of the billing export to BigQuery
  grant_registry_access             = true
  add_cluster_firewall_rules        = true
  add_master_webhook_firewall_rules = true
  firewall_inbound_ports            = ["0-65535"]
  master_authorized_networks = [
    {
      cidr_block   = "${var.public_ip}/32"
      display_name = "Public ip"
    },
  ]
}
