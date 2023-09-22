## Terraform Backend ##
terraform {
  backend "gcs" {
    bucket = "somaz-bigquery-project-terraform-remote-tfstate"
    prefix = "bigquery"
  }
}

