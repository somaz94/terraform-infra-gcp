module "postgresql" {
  source                          = "../../modules/postgresql"
  name                            = var.db_name
  project_id                      = var.project
  database_version                = "POSTGRES_15"
  region                          = var.region
  tier                            = "db-custom-2-3840"
  deletion_protection             = false
  root_password                   = var.db_admin_password
  availability_type               = "ZONAL"
  maintenance_window_day          = "1"
  maintenance_window_hour         = "0"
  maintenance_window_update_track = "stable"

  ip_configuration = {
    ipv4_enabled                                  = false
    require_ssl                                   = false
    ssl_mode                                      = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    private_network                               = "projects/${var.host_project}/global/networks/${var.shared_vpc}"
    authorized_networks                           = []
    allocated_ip_range                            = "google-managed-services-mgmt-share-vpc"
    enable_private_path_for_google_cloud_services = true
  }

  user_labels = local.default_labels

  database_flags = [
    {
      name  = "log_min_duration_statement"
      value = "1000" # 1초 이상 실행되는 모든 쿼리를 로깅합니다.
    }
  ]

  additional_users = [
    {
      name            = var.db_admin_user
      password        = var.db_admin_password
      random_password = false
    }
  ]

  additional_databases = [
    {
      name      = "somaz"
      charset   = "UTF8"       # PostgreSQL의 경우, 일반적으로 UTF8을 사용합니다.
      collation = "en_US.UTF8" # 적절한 collation 설정을 선택하세요.
    }
  ]
}

## memorystore(redis) ##
module "memorystore" {
  source      = "../../modules/memorystore"
  name        = var.redis_name
  project     = var.project
  region      = var.region
  labels      = local.default_labels
  location_id = "${var.region}-a"
  enable_apis             = true
  auth_enabled            = false
  transit_encryption_mode = "DISABLED"
  tier                    = "BASIC"
  connect_mode            = "PRIVATE_SERVICE_ACCESS"
  authorized_network      = "projects/${var.host_project}/global/networks/${var.shared_vpc}"
  reserved_ip_range       = "google-managed-services-mgmt-share-vpc"
  memory_size_gb          = 1
  persistence_config = {
    persistence_mode    = "DISABLED"
    rdb_snapshot_period = null
  }
}
