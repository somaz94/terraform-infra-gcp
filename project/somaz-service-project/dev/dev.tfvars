## common ##
project      = "somaz-service-project-dev"
host_project = "somaz-host-project"
region       = "asia-northeast3"
environment  = "dev"
terraform    = "true"

## terraform tfstate backend ##
tf_state_bucket = "somaz-service-project-terraform-remote-tfstate"

## gcs_buckets ##
asset_somaz_link         = "dev-asset.somaz.link"
somaz_link               = "dev.somaz.link"
asset_somaz_link_members = ["user:somaz@somaz.link", "user:somazx@somaz.link"]

## secret_manager ##
db_secret                        = "dev-somaz-database"
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
gke_pod      = "dev-somaz-gke-pod"
gke_service  = "dev-somaz-gke-service"

## compute engine ##
bastion    = "dev-somaz-bastion"
bastion_ip = "bastion-ip"
public_ip  = "xx.xx.xx.xxx"
nfs_client = "nfs-client"

## DB(Mysql) ##
db_admin_user     = "admin"
db_admin_password = "somaz"
db_name           = "dev-somaz-db"

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
redis = "dev-somaz-redis"

## GKE ##
gke = "dev-somaz-gke"

## LoadBalancer ##
web_lb_ip_name        = "dev-somaz-gke-web-lb-ip"
game_lb_ip_name       = "dev-somaz-gke-game-lb-ip"
was_lb_ip_name        = "dev-somaz-gke-was-lb-ip"
somaz_link_lb_ip_name = "dev-somaz-link-cdn-lb-ip"

## Cloud Armor ##
ip_allow_rule_name = "ip-allow-rule"

## Firestore Instance ##
firestore_instances = {
  nfs1 = {
    instance_name          = "dev1-somaz-firestore"
    file_share_name        = "dev1"
    file_share_capacity_gb = 2560
    file_share_ip_ranges   = ["10.0.0.0/8"]
  }
  nfs2 = {
    instance_name          = "dev2-somaz-firestore"
    file_share_name        = "dev2"
    file_share_capacity_gb = 2560
    file_share_ip_ranges   = ["10.0.0.0/8"]
  }
  # Add more instances as needed
}
