## Artifact Registry ##

resource "google_artifact_registry_repository" "repo" {
  for_each = toset(var.somaz_repo)

  location      = var.region
  repository_id = each.key
  format        = "DOCKER" # DOCKER is for Docker images. You can also specify "MAVEN" or "NPM" for Java and JavaScript packages, respectively.

  labels = local.default_labels
}

resource "google_artifact_registry_repository" "prod_repo" {
  for_each = toset(var.prod_somaz_repo)

  location      = var.prod_region
  repository_id = each.key
  format        = "DOCKER" # DOCKER is for Docker images. You can also specify "MAVEN" or "NPM" for Java and JavaScript packages, respectively.

  labels = local.default_labels
}
