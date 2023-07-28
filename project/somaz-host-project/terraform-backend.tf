## Terraform Backend ##

terraform {
  backend "gcs" {
    bucket = "somaz-host-project-terraform-remote-tfstate"
    prefix = "mgmt"
  }
}

