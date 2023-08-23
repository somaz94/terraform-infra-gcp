## Terraform Backend ## (Available after gcs bucket creation.)

terraform {
  backend "gcs" {
    bucket = "somaz-host-project-terraform-remote-tfstate"
    prefix = "mgmt"
  }
}

