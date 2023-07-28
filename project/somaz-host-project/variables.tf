## common ##
variable "project" {}
variable "region" {}
variable "prod_region" {}
variable "environment" {}
variable "terraform" {}

## terraform tfstate backend ##
variable "tf_state_bucket" {}

## vpc ##
variable "shared_vpc" {}
variable "subnet_share" {}
variable "service_project" {
  type = list(string)
}
variable "dev_gke_pod" {}
variable "dev_gke_service" {}
variable "qa_gke_pod" {}
variable "qa_gke_service" {}
variable "mgmt_gke_pod" {}
variable "mgmt_service" {}

## prod_vpc
variable "prod_shared_vpc" {}
variable "prod_subnet_share" {}
variable "prod_service_project" {
  type = list(string)
}
variable "prod_gke_pod" {}
variable "prod_gke_service" {}

## compute engine ##
variable "nfs_server" {}
variable "service_server" {}
variable "prod_nfs_server" {}
variable "nfs_client" {}
variable "prod_nfs_client" {}
variable "nfs_server_ip" {}
variable "service_server_ip" {}
variable "prod_nfs_server_ip" {}
variable "public_ip" {}
variable "public_ip2" {}

## firewall ##
variable "shared_vpc_internal_rules" {
  description = "The internal firewall rules"
  type = map(object({
    protocol = string
    ports    = list(string)
  }))
}

## Cloud NAT & Router ##
variable "nat_router" {}
variable "nat_name" {}

## Prod Cloud NAT & Router ##
variable "prod_nat_router" {}
variable "prod_nat_name" {}

## GKE ##
variable "mgmt_somaz_gke" {}

## LoadBalancer ##
variable "argocd_lb_ip_name" {}
variable "prometheus_lb_ip_name" {}
variable "grafana_lb_ip_name" {}
variable "loki_lb_ip_name" {}
variable "mongo_log_lb_ip_name" {}
variable "blockchain_lb_ip_name" {}

## Artifact Registry ##
variable "somaz_repo" {
  description = "List of Artifact Registry dsp repository names"
  type        = list(string)
}

## Prod Artifact Registry ##
variable "prod_somaz_repo" {
  description = "List of Artifact Registry prod dsp repository names"
  type        = list(string)
}