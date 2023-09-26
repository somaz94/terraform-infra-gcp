# Terraform Infrastructure for BigQuery and Storage on GCP

This `somaz-bigquery-project` directory contains Terraform configurations dedicated to setting up and managing Google BigQuery resources, cloud storage, and integrations such as exporting data from BigQuery to Google Sheets and MongoDB to BigQuery within the Google Cloud Platform (GCP).

<br/>

## Directory Structure

- **bigquery-to-google-sheet**: A submodule or collection of Terraform configurations and scripts tailored for exporting data from Google BigQuery to Google Sheets.
- **mongodb-to-bigquery**: A submodule or collection of Terraform configurations and scripts tailored for importing data from MongoDB to Google BigQuery.
- **mongodb-bigquery-googlesheet-workflow.tf**: Configurations for Google BigQuery and Cloud functions and Cloud Scheduler and Dataflow and DataSet
- **bigquery.tfvars**: Contains variable definitions and values specific to the BigQuery configurations.
- **cloud-storage.tf**: Terraform configurations related to setting up and managing Google Cloud Storage resources.
- **locals.tf**: Defines local variables which can be used across various Terraform configurations within this directory.
- **provider.tf**: Specifies the provider configurations, guiding Terraform's interactions with the Google Cloud Platform.
- **terraform-backend.tf**: Configuration related to Terraform's state management setup.
- **variables.tf**: Centralizes variable definitions applicable for all the Terraform configurations in this directory.

<br/>

## Usage

To utilize the configurations in this directory:

1. Ensure Terraform is installed and correctly set up.
2. Navigate to the `somaz-bigquery-project` directory:

```bash
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/terraform-infra-gcp/key/admin-somaz-bigquery-project.json"

terraform init && terraform fmt
terraform validate
terraform plan
terraform apply
```

