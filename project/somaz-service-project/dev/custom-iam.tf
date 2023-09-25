# resource "google_project_iam_custom_role" "gcs_upload_viewer_role" {
#   role_id     = "CustomUploaderViewer"
#   title       = "Custom Uploader and Viewer"
#   description = "Can upload and view objects but not delete them"
#   permissions = [
#     "storage.objects.create",
#     "storage.objects.get",
#     "storage.objects.list"
#   ]
# }

# resource "google_storage_bucket_iam_member" "asset_bucket_custom_role" {
#   bucket = google_storage_bucket.asset_somaz_link
#   role   = "projects/${var.project_id}/roles/${google_project_iam_custom_role.gcs_upload_viewer_role.role_id}"

#   members = [
#     "user:<USER_EMAIL>"
#   ]
# }


