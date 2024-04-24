resource "google_pubsub_topic" "process_log_topic" {
  name = "process-log-topic"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_project_sink
resource "google_logging_project_sink" "process_log_sink" {
  name = "process-log-sink"
  # Can export to pubsub, cloud storage, bigquery, log bucket, or another project
  destination = "pubsub.googleapis.com/${google_pubsub_topic.process_log_topic.id}" 
  filter      = "severity >= ERROR" // Adjust the filter according to your needs (DEFAULT,DEBUG,INFO,NOTICE,WARNING,ERROR,CRITICAL,ALERT,EMERGENCY)                                                                     
  # For example, the "severity >= ERROR" filter is set to include all logs at ERROR, CRITAL, Alert, and Emergency levels

  # Grant Pub/Sub publisher rights to the logging service
  unique_writer_identity = true
}

resource "google_pubsub_topic_iam_binding" "process_log_pubsub_binding" {
  topic = google_pubsub_topic.process_log_topic.name
  role  = "roles/pubsub.publisher"

  members = [
    google_logging_project_sink.process_log_sink.writer_identity
  ]
}

## cloudfunction source Bucket
resource "google_storage_bucket" "cloud_function_storage" {

  name                        = "cloud-functions-storage"
  location                    = var.region
  labels                      = local.default_labels
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "null_resource" "process_log_zip_cloud_function" {
  depends_on = [google_storage_bucket.cloud_function_storage]

  provisioner "local-exec" {
    command = <<EOT
      cd ./cloud-functions/process-log
      zip -r process-log.zip main.py requirements.txt
    EOT
  }

  triggers = {
    main_content_hash         = filesha256("./cloud-functions/process-log/main.py")
    requirements_content_hash = filesha256("./cloud-functions/process-log/requirements.txt")
  }
}

resource "google_storage_bucket_object" "process_log_cloudfunction_archive" {
  depends_on = [null_resource.process_log_zip_cloud_function]

  name   = "source/process-log.zip"
  bucket = google_storage_bucket.cloud_function_storage.name
  source = "./cloud-functions/process-log/process-log.zip"
}

resource "google_cloudfunctions_function" "process_log_function" {
  name        = "process-log-function"
  description = "Processes logs from Pub/Sub and transforms them for Prometheus"
  runtime     = "python39"

  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.cloud_function_storage.name
  source_archive_object = google_storage_bucket_object.process_log_cloudfunction_archive.name
  trigger_http          = true
  entry_point           = "process_log"

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.process_log_topic.id
  }

  environment_variables = {
    TOPIC_ID = google_pubsub_topic.process_log_topic.id
  }
}
