## common ##
project      = "somaz-ai-project"
host_project = "somaz-host-project"
region       = "asia-northeast3"
environment  = "bigquery"
terraform    = "true"

## terraform tfstate backend ##
tf_state_bucket = "somaz-ai-project-terraform-remote-tfstate"

## vpc ##
shared_vpc   = "mgmt-share-vpc"
subnet_share = "mgmt-share-sub"

## compute engine ##
ai_server    = "ai-server"
ai_server_ip = "ai-server-ip"
nfs_client   = "nfs-client"

## DB(Postgresql) ##
db_admin_user     = "admin"
db_admin_password = "somaz"
db_name           = "ai-somaz-db"
redis_name        = "ai-somaz-redis"

## cloud run ##
nginx_cloudrun = "somaz-nginx-cloudrun"
shared_vpc_connector = "shared-vpc-connector"