## GCS Buckets ##
output "bucket_names" {
  description = "The names of the created GCS buckets."
  value       = module.gcs_buckets.names
}

## VPC ##
output "vpc_name" {
  description = "The name of the created VPC."
  value       = module.vpc.network_name
}

output "subnets" {
  description = "The subnets of the created VPC."
  value       = module.vpc.subnets
}

## Compute Engine ##
output "nfs_server" {
  description = "The name of the NFS server instance."
  value       = google_compute_instance.nfs_server.name
}

output "nfs_server_internal_ip" {
  description = "The internal IP address of the NFS server instance."
  value       = google_compute_instance.nfs_server.network_interface[0].network_ip
}

output "nfs_server_external_ip" {
  description = "The external IP address of the NFS server instance."
  value       = google_compute_instance.nfs_server.network_interface[0].access_config[0].nat_ip
}

output "additional_pd_balanced" {
  description = "The name of the additional persistent disk."
  value       = google_compute_disk.additional_pd_balanced.name
}


# GKE ##
output "name" {
  description = "The name of the cluster"
  value       = module.gke_autopilot.name
}

output "cluster_ca_certificate" {
  description = "The public certificate that is the root of trust for the cluster."
  value       = base64decode(module.gke_autopilot.ca_certificate)
  sensitive   = true
}