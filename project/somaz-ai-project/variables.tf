## common ##
variable "project" {}
variable "host_project" {}
variable "region" {}
variable "region" {}
variable "environment" {}
variable "terraform" {}

## terraform tfstate backend ##
variable "tf_state_bucket" {}

## vpc ##
variable "shared_vpc" {}
variable "subnet_share" {}

## compute engine
variable "ai_server" {}
variable "ai_server_ip" {}
variable "nfs_client" {}

## DB(Postgresql) ##
variable "db_admin_user" {}
variable "db_admin_password" {}
variable "db_name" {}
variable "redis_name" {}

## cloud run ##
variable "nginx_cloudrun" {}
variable "shared_vpc_connector" {}