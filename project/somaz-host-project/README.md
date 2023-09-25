# Terraform Infrastructure for GCP - `somaz-host-project` Directory

The `somaz-host-project` directory is a collection of Terraform configurations dedicated to setting up a host project in the Google Cloud Platform using a Shared VPC (Virtual Private Cloud). Shared VPC allows organizations to connect resources from multiple projects to a common VPC so that they can communicate with each other securely and efficiently.

<br/>

## Directory Structure

- **artifact-registry.tf**: Configuration related to the [Artifact Registry](https://cloud.google.com/artifact-registry), Google Cloud's package management and software distribution system.
- **cloud-storage.tf**: Setups for Google Cloud Storage resources.
- **gitlab.tf**: Configuration tailored for integrating and managing GitLab resources and services within the GCP environment.
- **mgmt.tfvars**: Variable definitions specifically designed for management-related tasks within the host project.
- **private-service-access.tf**: Configuration concerning private connections to GCP services.
- **variables.tf**: Centralizes variable definitions for the Terraform configurations.
- **cloud-dns-lb-ip.tf**: Manages load balancer IP configurations for Google Cloud DNS.
- **compute-engine.tf**: Terraform definitions for Google Compute Engine, providing scalable and flexible virtual machine instances.
- **kubernetes-engine.tf**: Configurations related to Google Kubernetes Engine for container orchestration.
- **mongo-log-blockchain-lb.tf**: Configurations associated with MongoDB logging and blockchain load balancers.
- **provider.tf**: Specifies provider configurations, guiding Terraform's interactions with GCP resources.
- **vpc.tf**: Definitions associated with the creation and management of the Shared VPC.
- **cloud-nat.tf**: Setups for Google Cloud NAT, allowing instances in a VPC to access the internet.
- **firewall.tf**: Terraform configurations for firewall rules to control incoming and outgoing traffic.
- **locals.tf**: Defines local variables for reuse across various Terraform configurations.
- **outputs.tf**: Specifies output parameters to display results or data from Terraform operations.
- **terraform-backend.tf**: Configuration for Terraform's state management.
- **workload-identity-federation.tf**: Setups concerning Google Cloud's workload identity federation for improved security.

<br/>

## Usage

To utilize the configurations in this directory:

1. Ensure Terraform is installed and correctly set up.
2. Navigate to the `somaz-host-project` directory:

```bash
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/terraform-infra-gcp/key/admin-somaz-host-project.json"

terraform init && terraform fmt
terraform validate
terraform plan
terraform apply
```
