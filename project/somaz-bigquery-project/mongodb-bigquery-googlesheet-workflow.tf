## Service Account ##
module "service_accounts_bigquery" {
  source       = "../../modules/service_accounts"
  project_id   = var.project
  names        = ["bigquery"]
  display_name = "bigquery"
  description  = "bigquery admin"
}

## Service Account IAM ##
resource "google_project_iam_member" "service_account_roles" {
  depends_on = [module.service_accounts_bigquery]

  for_each = toset([
    "roles/iam.serviceAccountUser",
    "roles/iam.serviceAccountTokenCreator",
    "roles/bigquery.admin",
    "roles/storage.admin",
    "roles/cloudscheduler.admin",
    "roles/cloudfunctions.developer",
    "roles/dataflow.admin",
    "roles/dataflow.worker"
  ])

  project = var.project
  role    = each.value
  member  = "serviceAccount:${module.service_accounts_bigquery.emails["bigquery"]}"
}

## Biguery MongoDB Dataset ##
resource "google_bigquery_dataset" "mongodb_dataset" {
  dataset_id    = "mongodb_dataset"
  friendly_name = "mongodb_dataset"
  description   = "This is a test description"
  location      = var.region
  labels        = local.default_labels

  access {
    role          = "OWNER"
    user_by_email = module.service_accounts_bigquery.email # bigquery admin account
  }

  access {
    role          = "OWNER"
    user_by_email = "admin-bigquery@somaz-bigquery-project.iam.gserviceaccount.com" # terraform admin account
  }
}

## Bigquery Source / Temp Bucket
resource "google_storage_bucket" "mongodb_cloud_function_storage" {

  name                        = "mongodb-cloud-function-storage"
  location                    = var.region
  labels                      = local.default_labels
  uniform_bucket_level_access = true
  force_destroy               = true
}

## mongodb -> bigquery table workflow
resource "null_resource" "mongodb_bigquery_zip_cloud_function" {
  depends_on = [google_bigquery_dataset.mongodb_dataset, google_storage_bucket.mongodb_cloud_function_storage]

  provisioner "local-exec" {
    command = <<EOT
      cd ./mongodb-to-bigquery
      zip -r mongodb-to-bigquery.zip main.py requirements.txt
    EOT
  }

  triggers = {
    main_content_hash         = filesha256("./mongodb-to-bigquery/main.py")
    requirements_content_hash = filesha256("./mongodb-to-bigquery/requirements.txt")
  }
}

resource "google_storage_bucket_object" "mongodb_bigquery_cloudfunction_archive" {
  depends_on = [null_resource.mongodb_bigquery_zip_cloud_function]

  name   = "source/mongodb-to-bigquery.zip"
  bucket = google_storage_bucket.mongodb_cloud_function_storage.name
  source = "./mongodb-to-bigquery/mongodb-to-bigquery.zip"
}

## cloud_function
resource "google_cloudfunctions_function" "mongodb_bigquery_dataflow_function" {
  depends_on = [null_resource.mongodb_bigquery_zip_cloud_function, google_storage_bucket_object.mongodb_bigquery_cloudfunction_archive]

  name                  = "mongodb-to-bigquery-dataflow"
  description           = "Function to mongodb-to-bigquery the Dataflow job"
  runtime               = "python38"
  service_account_email = module.service_accounts_bigquery.email
  docker_registry       = "ARTIFACT_REGISTRY"
  timeout               = 540

  available_memory_mb   = 512
  source_archive_bucket = google_storage_bucket.mongodb_cloud_function_storage.name
  source_archive_object = google_storage_bucket_object.mongodb_bigquery_cloudfunction_archive.name
  trigger_http          = true
  entry_point           = "start_dataflow"

  environment_variables = {
    PROJECT_ID            = var.project,
    REGION                = var.region,
    SHARED_VPC            = var.shared_vpc,
    SUBNET_SHARE          = var.subnet_share,
    SERVICE_ACCOUNT_EMAIL = module.service_accounts_bigquery.email
  }
}

## cloud_scheduler
resource "google_cloud_scheduler_job" "mongodb_bigquery_job" {
  depends_on = [google_cloudfunctions_function.mongodb_bigquery_dataflow_function]
  name       = "mongodb-to-bigquery-daily-job"
  region     = var.region
  schedule   = "20 9 * * *" # Daily 09:20 AM

  http_target {
    http_method = "POST"
    uri         = google_cloudfunctions_function.mongodb_bigquery_dataflow_function.https_trigger_url
    oidc_token {
      service_account_email = module.service_accounts_bigquery.email
    }
  }
}

# Configuration for Cloud Storage Bucket for deploying a Cloud Function to deduplicate BigQuery
resource "google_storage_bucket" "bigquery_deduplication_storage" {
  name                        = "bigquery-deduplication-storage"
  location                    = var.region
  labels                      = local.default_labels
  uniform_bucket_level_access = true
  force_destroy               = true
}

# Compress and upload the source code for deploying the deduplication Cloud Function
resource "null_resource" "bigquery_deduplication_zip_cloud_function" {
  provisioner "local-exec" {
    command = <<EOT
      cd ./bigquery-deduplication
      zip -r bigquery-deduplication.zip main.py requirements.txt
    EOT
  }

  triggers = {
    main_content_hash         = filesha256("./bigquery-deduplication/main.py")
    requirements_content_hash = filesha256("./bigquery-deduplication/requirements.txt")
  }
}

resource "google_storage_bucket_object" "bigquery_deduplication_cloudfunction_archive" {
  depends_on = [null_resource.bigquery_deduplication_zip_cloud_function]

  name   = "source/bigquery-deduplication.zip"
  bucket = google_storage_bucket.bigquery_deduplication_storage.name
  source = "./bigquery-deduplication/bigquery-deduplication.zip"
}

# Resource for the Cloud Function to remove duplicates in BigQuery
resource "google_cloudfunctions_function" "bigquery_deduplication_function" {
  depends_on = [
    null_resource.bigquery_deduplication_zip_cloud_function,
    google_storage_bucket_object.bigquery_deduplication_cloudfunction_archive
  ]

  name                  = "bigquery-deduplication-function"
  description           = "Function to remove duplicates from BigQuery"
  runtime               = "python38"
  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.bigquery_deduplication_storage.name
  source_archive_object = google_storage_bucket_object.bigquery_deduplication_cloudfunction_archive.name
  trigger_http          = true
  entry_point           = "remove_duplicates"
  timeout               = 540

  service_account_email = module.service_accounts_bigquery.email

  environment_variables = {
    PROJECT_ID = var.project
  }
}

# Resource for Cloud Scheduler job to remove duplicates in BigQuery
resource "google_cloud_scheduler_job" "bigquery_remove_duplicates_job" {
  depends_on = [google_cloudfunctions_function.bigquery_deduplication_function]

  name      = "bigquery-remove-duplicates-daily-job"
  region    = var.region
  schedule  = "0 10 * * *" # Daily at 10:00 AM
  time_zone = "Asia/Seoul"

  http_target {
    http_method = "GET"
    uri         = google_cloudfunctions_function.bigquery_deduplication_function.https_trigger_url
    oidc_token {
      service_account_email = module.service_accounts_bigquery.email
    }
  }
}


# ## bigquery table  -> googlesheet workflow
# resource "null_resource" "bigquery_googlesheet_zip_cloud_function" {
#   depends_on = [google_bigquery_dataset.mongodb_dataset, google_storage_bucket.mongodb_cloud_function_storage]

#   provisioner "local-exec" {
#     command = <<EOT
#       cd ./bigquery-to-google-sheet
#       zip -r bigquery-to-google-sheet.zip main.py requirements.txt bigquery.json
#     EOT
#   }

#   triggers = {
#     main_content_hash         = filesha256("./bigquery-to-google-sheet/main.py")
#     requirements_content_hash = filesha256("./bigquery-to-google-sheet/requirements.txt")
#   }
# }

# resource "google_storage_bucket_object" "bigquery_googlesheet_cloudfunction_archive" {
#   depends_on = [null_resource.bigquery_googlesheet_zip_cloud_function]

#   name   = "source/bigquery-to-google-sheet.zip"
#   bucket = google_storage_bucket.mongodb_cloud_function_storage.name
#   source = "./bigquery-to-google-sheet/bigquery-to-google-sheet.zip"
# }


# ## cloud_function
# resource "google_cloudfunctions_function" "bigquery_googlesheet_function" {
#   depends_on = [null_resource.bigquery_googlesheet_zip_cloud_function, google_storage_bucket_object.bigquery_googlesheet_cloudfunction_archive]

#   name                  = "bigquery-to-googlesheet"
#   description           = "Sync data from BigQuery to Google Sheets"
#   available_memory_mb   = 1024
#   runtime               = "python38"
#   service_account_email = module.service_accounts_bigquery.email
#   docker_registry       = "ARTIFACT_REGISTRY"
#   timeout               = 540

#   # Set the source_directory property here.
#   source_archive_bucket = google_storage_bucket.mongodb_cloud_function_storage.name
#   source_archive_object = google_storage_bucket_object.bigquery_googlesheet_cloudfunction_archive.name
#   trigger_http          = true
#   entry_point           = "bigquery_to_sheets" # Function name inside the Python code

#   environment_variables = {
#     BIGQUERY_TABLE = "${var.project}.mongodb_dataset.mongodb-internal-table",
#     SHEET_ID       = "1sfasdfsdRBtsdfasdfsdfsadfsj5oqYFaXvB_M"
#   }
# }

# ## cloud_scheduler
# resource "google_cloud_scheduler_job" "bigquery_googlesheet_job" {
#   depends_on = [google_cloudfunctions_function.bigquery_googlesheet_function]

#   name     = "bigquery-to-sheet-daliy-job"
#   region   = var.region
#   schedule = "30 15 * * *" # Daily 15:30 PM

#   http_target {
#     http_method = "POST"
#     uri         = google_cloudfunctions_function.bigquery_googlesheet_function.https_trigger_url
#     oidc_token {
#       service_account_email = module.service_accounts_bigquery.email
#     }
#   }
# }

