# Terraform Infrastructure for `somaz-service-project` (Production Environment)

This directory holds Terraform configurations specifically designed for the Production environment of the `somaz-service-project` on Google Cloud Platform (GCP). It comprises configurations and resources from cloud storage to Kubernetes, reflecting the final, optimal setup designed for stable, production usage.

<br/>

## Directory Structure

- **cloud-armor.tf**: Contains definitions and configurations for Google Cloud Armor. It caters to context-aware access configurations and shields the environment against potential security threats.
- **cloud-cdn.tf**: Defines the Terraform setups for Google Cloud Content Delivery Network (CDN). This ensures quick and reliable content delivery to users.
- **cloud-dns-lb-ip.tf**: Dedicated configurations for Google Cloud DNS and the load balancer IP resources.
- **cloud-storage.tf**: Manages Google Cloud Storage, offering a reliable and scalable space for cloud-based storage needs.
- **compute-engine.tf**: Holds Terraform configurations related to Google Compute Engine, enabling the provisioning of virtual machines and associated resources.
- **db-redis.tf**: Specific configurations for the Redis database on Google Cloud, detailing its setup, maintenance, and optimizations.
- **kubernetes-engine.tf**: The primary configurations for Google Kubernetes Engine, enabling scalable and manageable container orchestration.
- **locals.tf**: Houses the definitions of local variables used internally across the Terraform scripts in this directory.
- **provider.tf**: Defines the provider configurations, primarily for communication between Terraform and Google Cloud Platform.
- **secret-manager.tf**: Contains configurations specific to Google Cloud's Secret Manager, allowing for secure management of sensitive data.
- **terraform-backend.tf**: Defines Terraform's state management and backend configurations.
- **variables.tf**: Central repository for variable definitions applicable to the Terraform configurations within this directory.
- **prod.tfvars**: Specific variable definitions and values unique to the Production environment.

<br/>

## Usage

To utilize the configurations in this directory:

1. Ensure Terraform is installed and correctly set up.
2. Navigate to the `somaz-service-project/prod` directory:

```bash
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/terraform-infra-gcp/key/admin-somaz-service-project-prod.json"

terraform init && terraform fmt
terraform validate
terraform plan
terraform apply
```

