provider "google" {
  credentials = file("../../key/admin-somaz-host-project.json")
  project     = var.project
  region      = var.region
}

provider "google-beta" {
  credentials = file("../../key/admin-somaz-host-project.json")
  project     = var.project
  region      = var.region
}
