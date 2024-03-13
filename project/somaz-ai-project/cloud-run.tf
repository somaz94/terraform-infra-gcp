## vpc connector ##
resource "google_vpc_access_connector" "shared_vpc_connector" {
  name   = var.shared_vpc_connector
  region = var.region
  subnet {
    name       = "${var.subnet_share}-wcidfu-b"
    project_id = var.host_project
  }
}

## cloud run ##
resource "google_cloud_run_service" "nginx_cloudrun" {
  name     = var.nginx_cloudrun
  location = var.region

  depends_on = [google_vpc_access_connector.shared_vpc_connector]

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"        = "10"
        "autoscaling.knative.dev/minScale"        = "2"
        "run.googleapis.com/cloudsql-instances"   = module.postgresql.instance_connection_name
        "run.googleapis.com/client-name"          = "terraform"
        "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.shared_vpc_connector.name
        "run.googleapis.com/vpc-access-egress"    = "all-traffic"
        # "run.googleapis.com/ingress" = "all" # Options: "all", "internal", "internal-and-cloud-load-balancing"
      }
    }

    spec {
      containers {
        image = "asia-northeast3-docker.pkg.dev/mgmt-2023/somaz-nginx-cloudrun/somaz-nginx-cloudrun:dev"

        ports {
          container_port = 8080
        }


        env {
          name  = "DBNAME"
          value = var.db_name
        }

        env {
          name  = "DBUSERNAME"
          value = var.db_admin_user
        }

        env {
          name  = "DBPASSWORD"
          value = var.db_admin_password
        }

        env {
          name  = "DBHOST"
          value = "10.x.x.x"
        }

        env {
          name  = "DBPORT"
          value = "5432"
        }

        env {
          name  = "REDIS_HOST"
          value = module.memorystore.host
        }

        env {
          name  = "REDIS_PORT"
          value = "6379"
        }


        resources {
          limits = {
            cpu    = "2000m" # 2 vCPU
            memory = "8096Mi" # 8096 MiB
          }
        }

      }

      container_concurrency = 80 // Optional: Adjust based on your needs
    }
  }

  autogenerate_revision_name = true

  traffic {
    percent         = 100
    latest_revision = true
  }

  # lifecycle {
  #   ignore_changes = [
  #     template[0].spec[0].containers[0].image, # image terraform으로 변경시 제거하고 진행
  #     template[0].metadata[0].annotations, # annotaions 변경시 제거하고 진행
  #   ]
  # }

}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "wcidfu_backend_cloudrun_noauth" {
  location    = google_cloud_run_service.nginx_cloudrun.location
  project     = google_cloud_run_service.nginx_cloudrun.project
  service     = google_cloud_run_service.nginx_cloudrun.name

  policy_data = data.google_iam_policy.noauth.policy_data
}
