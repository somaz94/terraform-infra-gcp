## GCS Buckets(Cloud Storage=S3) ##
module "gcs_buckets" {
  source          = "../../../modules/gcs_buckets"
  names           = keys(local.buckets_versioning)
  project_id      = var.project
  location        = var.region
  labels          = local.default_labels
  versioning      = local.buckets_versioning
  lifecycle_rules = local.lifecycle_rules
}

resource "google_storage_bucket" "asset_somaz_link" {
  name                        = var.asset_somaz_link
  location                    = var.region
  uniform_bucket_level_access = true
  storage_class               = "STANDARD"
  labels                      = local.default_labels
  // delete bucket and contents on destroy.
  force_destroy = true
  // Assign specialty files
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  cors {
    origin          = ["*"]
    method          = ["GET", "POST"]
    response_header = ["*"]
    max_age_seconds = 3600
  }

}

resource "google_storage_bucket_iam_member" "public_read_asset_somaz_link" {
  bucket = google_storage_bucket.asset_somaz_link.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"

  depends_on = [google_storage_bucket.asset_somaz_link]
}


resource "google_storage_bucket_iam_member" "asset_somaz_link_members" {
  for_each = toset(var.asset_somaz_link_members)

  bucket = var.asset_somaz_link
  role   = "roles/storage.objectAdmin"
  member = each.key

  depends_on = [google_storage_bucket.asset_somaz_link]
}

resource "google_project_iam_binding" "asset_somaz_link_list_bucket_permissions" {
  project = var.project
  role    = "organizations/${var.organization}/roles/StoragelistRole"

  members = var.asset_somaz_link

  depends_on = [google_storage_bucket.asset_somaz_link]
}


resource "google_storage_bucket" "somaz_link" {
  name                        = var.somaz_link
  location                    = var.region
  uniform_bucket_level_access = true
  storage_class               = "STANDARD"
  labels                      = local.default_labels
  // delete bucket and contents on destroy.
  force_destroy = true
  // Assign specialty files
  website {
    main_page_suffix = "index"
    not_found_page   = "404"
  }
}

resource "google_storage_bucket_iam_member" "public_read_somaz_link" {
  bucket = google_storage_bucket.somaz_link.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_bucket" "stg_somaz_link" {
  name                        = var.stg_somaz_link
  location                    = var.region
  uniform_bucket_level_access = true
  storage_class               = "STANDARD"
  labels                      = local.default_labels
  // delete bucket and contents on destroy.
  force_destroy = true
  // Assign specialty files
  website {
    main_page_suffix = "index"
    not_found_page   = "404"
  }

  cors {
    origin          = ["*"]
    method          = ["GET", "POST"]
    response_header = ["*"]
    max_age_seconds = 3600
  }

}

resource "google_storage_bucket_iam_member" "public_read_stg_somaz_link" {
  bucket = google_storage_bucket.stg_somaz_link.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

