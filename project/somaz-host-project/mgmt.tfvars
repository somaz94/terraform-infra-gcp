## common ##
project     = "somaz-host-project"
region      = "asia-northeast3"
prod_region = "asia-northeast1"
environment = "mgmt"
terraform   = "true"

## terraform tfstate backend ##
tf_state_bucket = "somaz-host-project-terraform-remote-tfstate"

## vpc ##
shared_vpc       = "mgmt-share-vpc"
service_project  = ["somaz-service-project-dev", "somaz-service-project-qa", "somaz-gitlab-project", "somaz-service-project-prod", "somaz-bigquery-project", "somaz-ai-project"]
subnet_share     = "mgmt-share-sub"
dev_gke_pod      = "dev-somaz-gke-pod"
dev_gke_service  = "dev-somaz-gke-service"
qa_gke_pod       = "qa-somaz-gke-pod"
qa_gke_service   = "qa-somaz-gke-service"
mgmt_gke_pod     = "mgmt-somaz-gke-pod"
mgmt_gke_service = "mgmt-somaz-gke-service"

## prod_vpc
prod_shared_vpc      = "prod-mgmt-share-vpc"
prod_subnet_share    = "prod-mgmt-share-sub"
prod_service_project = ["somaz-service-project-prod"]
prod_gke_pod         = "prod-somaz-gke-pod"
prod_gke_service     = "prod-somaz-gke-service"

## compute engine ##
nfs_server         = "nfs-server"
service_server     = "service-server"
prod_nfs_server    = "prod-nfs-server"
gitlab_server      = "gitlab-server"
nfs_client         = "nfs-client"
prod_nfs_client    = "prod-nfs-client"
nfs_server_ip      = "nfs-server-ip"
service_server_ip  = "service-server-ip"
prod_nfs_server_ip = "prod-nfs-server-ip"
public_ip          = "xx.xx.xx.xxx" # your public ip
public_ip2         = "xx.xx.xx.xxx" # your public ip

## firewall ##
shared_vpc_internal_rules = {
  tcp_all  = { protocol = "tcp", ports = ["0-65535"] },
  udp_all  = { protocol = "udp", ports = ["0-65535"] },
  icmp_all = { protocol = "icmp", ports = [] }
}

## Cloud NAT & Router ##
nat_router = "mgmt-share-vpc-nat-router"
nat_name   = "mgmt-share-vpc-nat"

## Prod Cloud NAT & Router ##
prod_nat_router = "prod-mgmt-share-vpc-nat-router"
prod_nat_name   = "prod-mgmt-share-vpc-nat"

## GKE ##
mgmt_gke = "mgmt-somaz-gke"

## LoadBalancer ##
argocd_lb_ip_name     = "mgmt-somaz-gke-argocd-lb-ip"
prometheus_lb_ip_name = "mgmt-somaz-gke-prometheus-lb-ip"
grafana_lb_ip_name    = "mgmt-somaz-gke-grafana-lb-ip"
loki_lb_ip_name       = "mgmt-somaz-gke-loki-lb-ip"
mongo_log_lb_ip_name  = "mgmt-somaz-mongo-log-lb-ip"
blockchain_lb_ip_name = "mgmt-somaz-blockchain-lb-ip"

## Artifact Registry ##
somaz_repo      = ["somaz-web", "somaz-game", "somaz-was"]
prod_somaz_repo = ["somaz-web", "somaz-game", "somaz-was"]

# gitlab
gitlab_server_lb_ip_name = "mgmt-gitlab-server-lb-ip"
gitlab_server_ip         = "gitlab-server-ip"
