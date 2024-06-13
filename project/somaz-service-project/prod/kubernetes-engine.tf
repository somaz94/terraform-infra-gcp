## GKE IAM Binding 선행 작업 진행하기 ##
## BUG!!! Terraform으로 진행하면, 기존에 binding 되어있는 리소스가 사라짐. ##
## 참고 사이트 https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-shared-vpc?hl=ko#gcloud_3 ##

# Google Kubernetes Cluster Engine(GKE)
# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

provider "kubernetes" {
  alias                  = "gke_autopilot"  # Autopilot용 별칭 설정
  host                   = "https://${module.gke_autopilot.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke_autopilot.ca_certificate)
}

module "gke_autopilot" {
  providers = {
    kubernetes = kubernetes.gke_autopilot  # Autopilot provider 사용
  }
  source                            = "../../../modules/gke_autopilot"
  project_id                        = var.project
  network_project_id                = var.host_project
  cluster_resource_labels           = local.default_labels
  name                              = var.gke
  region                            = var.region
  zones                             = ["${var.region}-a", "${var.region}-b"]
  network                           = var.shared_vpc
  subnetwork                        = "${var.subnet_share}-prod-a"
  ip_range_pods                     = "prod-somaz-gke-pod"
  ip_range_services                 = "prod-somaz-gke-service"
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

# Standard 클러스터를 위한 Kubernetes Provider
provider "kubernetes" {
  alias                  = "gke_standard"  # Standard용 별칭 설정
  host                   = "https://${module.gke_standard.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke_standard.ca_certificate)
}

# GKE Standard Cluster Configuration
module "gke_standard" {
  providers = {
    kubernetes = kubernetes.gke_standard  # standard provider 사용
  }
  source                     = "../../../modules/gke_standard"
  project_id                 = var.project
  network_project_id         = var.host_project
  cluster_resource_labels    = local.default_labels
  name                       = var.sd_gke
  region                     = var.region
  zones                      = ["${var.region}-a", "${var.region}-b"]
  network                    = var.shared_vpc
  subnetwork                 = "${var.subnet_share}-prod-b"
  ip_range_pods              = "prod-somaz-gke-sd-pod"
  ip_range_services          = "prod-somaz-gke-sd-service"
  http_load_balancing        = true
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  istio                      = false
  cloudrun                   = false
  dns_cache                  = false
  firewall_inbound_ports            = ["0-65535"]
  master_authorized_networks = [
    {
      cidr_block   = "${var.public_ip}/32"
      display_name = "Public ip"
    },
  ]

  node_pools = [
    {
      name               = "${var.sd_gke}-node-pool"
      machine_type       = "e2-medium"
      node_locations     = "asia-northeast3-a,asia-northeast3-b"
      min_count          = 1
      max_count          = 100
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 3  # Adjust initial node count as needed
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }

  node_pools_labels = {
    all = local.default_labels
  }
}
