resource "google_organization_iam_custom_role" "storage-list-custom-role" {
  role_id     = "StoragelistRole"
  org_id      = "" # org_id
  title       = "Storage list Role"
  description = "A Storage list Role"
  permissions = ["storage.buckets.list"]
}

