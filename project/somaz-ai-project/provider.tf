provider "google" {
  credentials = file("../../key/admin-somaz-ai-project.json")
  project     = var.project
  region      = var.region
}

provider "google-beta" {
  credentials = file("../../key/admin-somaz-ai-project.json")
  project     = var.project
  region      = var.region
}



