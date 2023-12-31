## common ##
project      = "somaz-bigquery-project"
host_project = "somaz-host-project"
region       = "asia-northeast3"
environment  = "bigquery"
terraform    = "true"

## terraform tfstate backend ##
tf_state_bucket = "somaz-bigquery-project-terraform-remote-tfstate"

## vpc ##
shared_vpc   = "mgmt-share-vpc"
subnet_share = "mgmt-share-sub"
