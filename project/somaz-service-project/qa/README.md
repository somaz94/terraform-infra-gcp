# Terraform Infrastructure for `somaz-service-project` (QA Environment)

This directory encompasses Terraform configurations fashioned for the QA (Quality Assurance) environment of the `somaz-service-project` on Google Cloud Platform (GCP). It emphasizes the alignment of resources from cloud storage to Kubernetes, with an inclination towards a unified cloud setup that closely mimics production for testing purposes.

<br/>

## Directory Structure

- **cloud-armor.tf**: Contains configurations associated with Google Cloud Armor. This involves both context-aware access configurations and defense against potential threats.
- **cloud-cdn.tf**: Houses Terraform setups for the Google Cloud Content Delivery Network (CDN), facilitating faster content delivery to users.
- **cloud-dns-lb-ip.tf**: Dedicated configurations for Google Cloud DNS load balancer IP resources.
- **cloud-storage.tf**: Manages configurations related to Google Cloud Storage, which offers a unified space for object storage in the cloud.
- **compute-engine.tf**: Handles Terraform configurations tailored for Google Compute Engine, orchestrating the provisioning and management of virtual machines and accompanying resources.
- **db-redis.tf**: Specifically caters to the Redis database on Google Cloud, detailing its setup and optimizations.
- **kubernetes-engine.tf**: The core Terraform configurations orchestrating the Google Kubernetes Engine resources, facilitating container orchestration at scale.
- **locals.tf**: Centralized definition space for local variables, intended for internal use across the various Terraform scripts in this directory.
- **provider.tf**: Describes and manages the provider configurations, guiding Terraform's integration and dialogues with the Google Cloud Platform.
- **secret-manager.tf**: Configurations are particular to Google Cloud's Secret Manager, facilitating secure handling of sensitive data.
- **terraform-backend.tf**: Emphasizes Terraform's state management and backend configurations.
- **variables.tf**: This is the main reservoir for variable definitions, pertinent to the entirety of Terraform configurations in this directory.
- **qa.tfvars**: A dedicated space for variable definitions and values that are unique to the QA environment.

<br/>

## Usage

To utilize the configurations in this directory:

1. Ensure Terraform is installed and correctly set up.
2. Navigate to the `somaz-service-project/qa` directory:

```bash
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/terraform-infra-gcp/key/admin-somaz-service-project-qa.json"

terraform init && terraform fmt
terraform validate
terraform plan
terraform apply
```

