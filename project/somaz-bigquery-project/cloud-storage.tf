## GCS Buckets(Cloud Storage=S3) ##
module "gcs_buckets" {
  source     = "../../modules/gcs_buckets"
  names      = keys(local.buckets_versioning)
  project_id = var.project
  location   = var.region
  labels     = local.default_labels
  versioning = local.buckets_versioning

}
