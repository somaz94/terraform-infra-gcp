## common ##
project      = "somaz-service-project-prod"
host_project = "somaz-host-project"
region       = "asia-northeast1"
environment  = "prod"
terraform    = "true"

## terraform tfstate backend ##
tf_state_bucket = "somaz-service-project-terraform-remote-tfstate"

## gcs_buckets ##
asset_somaz_link         = "asset.somaz.link"
stg_somaz_link           = "stg.somaz.link"
somaz_link               = "somaz.link"
asset_somaz_link_members = ["user:somaz@somaz.link", "user:somazx@somaz.link"]

## secret_manager ##
db_secret                        = "prod-somaz-database"
db_username                      = "admin"
db_password                      = "somaz"
username                         = "admin"
password                         = "somaz"
bastion_user                     = "somaz"
bastion_pem_key                  = "../../../key/somaz-bastion.pub"
gcs_cloudcdn                     = "somaz-gcs_cloudcdn"
gcs_cloudcdn_service_account     = "somaz-gcs_cloudcdn@somaz-host-project.iam.gserviceaccount.com"
gcs_cloudcdn_service_account_key = "../../../key/somaz-gcs-cloudcdn.json"

## vpc ##
shared_vpc           = "prod-mgmt-share-vpc"
subnet_share         = "prod-mgmt-share-sub"
prod_dsp_gke_pod     = "prod-dsp-gke-pod"
prod_dsp_gke_service = "prod-dsp-gke-service"

## compute engine ##
bastion         = "prod-somaz-bastion"
bastion_ip      = "prod-bastion-ip"
public_ip       = "xx.xx.xx.xxx"
prod_nfs_client = "prod-nfs-client"

## DB(Mysql) ##
db_admin_user     = "admin"
db_admin_password = "somaz"
db_name           = "prod-somaz-db"

additional_databases = [
  {
    name      = "web"
    charset   = "utf8mb3"
    collation = "utf8mb3_general_ci"
  },
  {
    name      = "game"
    charset   = "utf8mb3"
    collation = "utf8mb3_general_ci"
  },
  {
    name      = "was"
    charset   = "utf8mb3"
    collation = "utf8mb3_general_ci"
  }
]

# Memorystore(Redis)
redis = "prod-somaz-redis"

## GKE ##
gke = "prod-somaz-gke"

## LoadBalancer ##
web_lb_ip_name              = "prod-somaz-gke-web-lb-ip"
game_lb_ip_name             = "prod-somaz-gke-game-lb-ip"
was_lb_ip_name              = "prod-somaz-gke-was-lb-ip"
somaz_link_lb_ip_name       = "prod-somaz-link-cdn-lb-ip"
asset_somaz_link_lb_ip_name = "prod-asset-somaz-link-cdn-lb-ip"
stg_somaz_link_lb_ip_name   = "prod-stg-somaz-link-cdn-lb-ip"

## Cloud Armor ##
ip_allow_rule_name     = "ip-allow-rule"
region_block_rule_name = "region-block-rule"