## common ##
project      = "somaz-service-project-qa"
host_project = "somaz-host-project"
region       = "asia-northeast3"
environment  = "qa"
terraform    = "true"

## terraform tfstate backend ##
tf_state_bucket = "somaz-service-project-terraform-remote-tfstate"

## gcs_buckets ##
asset_somaz_link         = "qa-asset.somaz.link"
somaz_link               = "qa.somaz.link"
asset_somaz_link_members = ["user:somaz@somaz.link", "user:somazx@somaz.link"]

## secret_manager ##
db_secret                        = "qa-somaz-database"
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
shared_vpc   = "mgmt-share-vpc"
subnet_share = "mgmt-share-sub"
gke_pod      = "qa-somaz-gke-pod"
gke_service  = "qa-somaz-gke-service"

## compute engine ##
bastion    = "qa-somaz-bastion"
bastion_ip = "bastion-ip"
public_ip  = "xx.xx.xx.xxx"
nfs_client = "nfs-client"

## DB(Mysql) ##
db_admin_user     = "admin"
db_admin_password = "somaz"
db_name           = "qa-somaz-db"

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
redis = "qa-somaz-redis"

## GKE ##
gke = "qa-somaz-gke"

## LoadBalancer ##
web_lb_ip_name              = "qa-somaz-gke-web-lb-ip"
game_lb_ip_name             = "qa-somaz-gke-game-lb-ip"
was_lb_ip_name              = "qa-somaz-gke-was-lb-ip"
somaz_link_lb_ip_name       = "qa-somaz-link-cdn-lb-ip"
asset_somaz_link_lb_ip_name = "qa-asset-somaz-link-cdn-lb-ip"

## Cloud Armor ##
ip_allow_rule_name = "ip-allow-rule"
