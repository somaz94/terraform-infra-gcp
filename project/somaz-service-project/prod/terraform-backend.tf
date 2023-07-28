## Terraform Backend ##
terraform {
  backend "gcs" {
    bucket = "prod-luxon-terraform-remote-tfstate"
    prefix = "prod-luxon"
  }
}
