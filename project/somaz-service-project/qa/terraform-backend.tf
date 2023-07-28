## Terraform Backend ##
terraform {
  backend "gcs" {
    bucket = "somaz-service-project-terraform-remote-tfstate"
    prefix = "qa"
  }
}
