## common ##
variable "project" {}
variable "host_project" {}
variable "region" {}
variable "environment" {}
variable "terraform" {}

## terraform tfstate backend ##
variable "tf_state_bucket" {}

## gcs_buckets ##
variable "asset_somaz_link" {}
variable "somaz_link" {}
variable "stg_somaz_link" {}
variable "asset_somaz_link_members" {
  description = "List of members to grant permissions to"
  type        = list(string)
}

## secret manager ##
variable "db_secret" {}
variable "db_username" {}
variable "db_password" {}
variable "username" {}
variable "password" {}
variable "bastion_user" {}
variable "bastion_pem_key" {}
variable "gcs_cloudfront" {}
variable "gcs_cloudfront_service_account" {}
variable "gcs_cloudfront_service_account_key" {}


## vpc ##
variable "shared_vpc" {}
variable "subnet_share" {}
variable "gke_pod" {}
variable "gke_service" {}

## compute engine(bastion)
variable "bastion" {}
variable "bastion_ip" {}
variable "public_ip" {}
variable "prod_nfs_client" {}


# DB(Mysql) ##
variable "db_admin_user" {}
variable "db_admin_password" {}
variable "db_name" {}
variable "additional_databases" {
  description = "Additional databases to be created"
  type = list(object({
    name      = string
    charset   = string
    collation = string
  }))
}

## GKE ##
variable "gke" {}

## LoadBalancer ##
variable "web_lb_ip_name" {}
variable "game_lb_ip_name" {}
variable "was_lb_ip_name" {}
variable "somaz_link_lb_ip_name" {}
variable "asset_somaz_link_lb_ip_name" {}
variable "stg_somaz_link_lb_ip_name" {}

## Cloud Armor ##
variable "ip_allow_rule_name" {}
variable "region_block_rule_name" {}
