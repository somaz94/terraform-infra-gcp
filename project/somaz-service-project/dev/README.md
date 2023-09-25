# Terraform Infrastructure for `somaz-service-project` (Development Environment)

This directory contains Terraform configurations tailored for the development environment of the `somaz-service-project` on Google Cloud Platform (GCP). It manages a variety of resources from BigQuery to Kubernetes Engine, ensuring an integrated cloud setup.

<br/>

## Directory Structure

- **bigquery.tf**: Terraform configurations for managing Google BigQuery resources.  
- **cloud-armor.tf**: Configurations related to Google Cloud Armor, for context-aware access and threat defense.
- **cloud-cdn.tf**: Setups for Google Cloud Content Delivery Network (CDN) resources.
- **cloud-dns-lb-ip.tf**: Configurations related to Google Cloud DNS load balancer IP addresses.
- **cloud-storage.tf**: Terraform configurations for setting up and managing Google Cloud Storage resources.
- **compute-engine.tf**: Terraform configurations for Google Compute Engine resources, which include virtual machine instances and related resources.
- **custom-iam.tf**: Configurations related to custom IAM roles and permissions.
- **db-redis.tf**: Terraform configurations related to Redis database setup on Google Cloud.
- **firestore-instance.tf**: Configurations for Firestore database instances.
- **kubernetes-engine.tf**: Contains the main Terraform configurations for managing Google Kubernetes Engine resources.
- **locals.tf**: Defines local variables which can be used across various Terraform configurations within this directory.
- **provider.tf**: Specifies the provider configurations, guiding Terraform's interactions with the Google Cloud Platform.
- **secret-manager.tf**: Configurations related to Google Cloud Secret Manager.
- **terraform-backend.tf**: Configuration related to Terraform's state management setup.
- **variables.tf**: Centralizes variable definitions applicable for all the Terraform configurations in this directory.
- **dev.tfvars**: Contains variable definitions and values specific to the development environment.

<br/>

## Usage

To utilize the configurations in this directory:

1. Ensure Terraform is installed and correctly set up.
2. Navigate to the `somaz-service-project/dev` directory:

```bash
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/terraform-infra-gcp/key/admin-somaz-service-project-dev.json"

terraform init && terraform fmt
terraform validate
terraform plan
terraform apply
```

