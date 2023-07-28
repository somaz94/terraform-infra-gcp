## gcs_buckets ##
output "bucket_urls" {
  description = "Self link of all the buckets."
  value       = module.gcs_buckets.urls
}

output "bucket_names" {
  description = "Names of all the buckets."
  value       = module.gcs_buckets.names
}

## secret_manager ##
output "secret_names" {
  value       = module.secret_manager.secret_names
  description = "List of secret names"
}

output "secret_versions" {
  value       = module.secret_manager.secret_versions
  description = "List of secret versions"
}

## Compute Engine(bastion) ##
output "bastion_name" {
  value       = google_compute_instance.bastion.name
  description = "The name of the bastion host"
}

output "bastion_external_ip" {
  value       = google_compute_address.bastion_ip.address
  description = "The external IP address of the bastion host"
}

## DB ##
output "db_instance_name" {
  value = module.mysql.instance_name
}

output "db_private_ip_address" {
  value = module.mysql.private_ip_address
}

output "mysql_conn" {
  value       = module.mysql.instance_connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "mysql_user_pass" {
  value     = module.mysql.generated_user_password
  sensitive = true
}

# GKE ##
output "name" {
  description = "The name of the cluster"
  value       = module.gke_autopilot.name
}

output "network_project_id" {
  description = "The project ID of the shared VPC's host (for shared vpc support)"
  value       = var.host_project
}

output "network_id" {
  description = "The network_id"
  value       = var.shared_vpc
}

output "cluster_ca_certificate" {
  description = "The public certificate that is the root of trust for the cluster."
  value       = base64decode(module.gke_autopilot.ca_certificate)
  sensitive   = true
}
