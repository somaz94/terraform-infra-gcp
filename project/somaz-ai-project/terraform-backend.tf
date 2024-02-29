## Terraform Backend ##
terraform {
  backend "gcs" {
    bucket = "somaz-ai-project-terraform-remote-tfstate"
    prefix = "ai"
  }
}


