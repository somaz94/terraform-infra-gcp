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
ai_server        = "ai-server"
ai_server_ip     = "ai-server-ip"
nfs_client       = "nfs-client"
django_server    = "django-server"
django_server_ip = "django-server-ip"
l4_server_1      = "l4-server-1"
l4_server_1_ip   = "l4-server-1-ip"

## DB(Postgresql) ##
db_admin_user     = "admin"
db_admin_password = "somaz"
db_name           = "ai-somaz-db"
redis_name        = "ai-somaz-redis"

## cloud run ##
nginx_cloudrun       = "somaz-nginx-cloudrun"
shared_vpc_connector = "shared-vpc-connector"

## cloud dns ##
django_lb_ip_name = "django-lb-ip"