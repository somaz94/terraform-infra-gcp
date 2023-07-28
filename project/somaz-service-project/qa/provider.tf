provider "google" {
  credentials = file("../../../key/admin-somaz-service-project-qa.json")
  project     = var.project
  region      = var.region
}

provider "google-beta" {
  credentials = file("../../../key/admin-somaz-service-project-qa.json")
  project     = var.project
  region      = var.region
}
