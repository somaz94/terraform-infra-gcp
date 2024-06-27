## DB(Mysql) ##
module "prod_mysql" {
  source                          = "../../../modules/mysql"
  name                            = var.db_name
  project_id                      = var.project
  database_version                = "MYSQL_8_0"
  region                          = var.region
  zone                            = "${var.region}-a"
  tier                            = "db-custom-2-3840"
  deletion_protection             = false
  root_password                   = var.db_admin_password
  availability_type               = "ZONAL" # if use HA : REGIONAL
  maintenance_window_day          = "1"
  maintenance_window_hour         = "0"
  maintenance_window_update_track = "stable"

  ip_configuration = {
    ipv4_enabled                                  = false
    require_ssl                                   = false
    private_network                               = "projects/${var.host_project}/global/networks/${var.shared_vpc}"
    authorized_networks                           = []
    allocated_ip_range                            = "google-managed-services-prod-mgmt-share-vpc"
    enable_private_path_for_google_cloud_services = true
  }

  user_labels = local.default_labels

  database_flags = [
    {
      name  = "long_query_time"
      value = "1"
    }
  ]

  additional_users = [
    {
      name            = var.db_admin_user
      password        = var.db_admin_password
      host            = "%" // host from where the user can connect.
      random_password = false
      type            = "BUILT_IN" // normal user or admin.
    }
  ]

  additional_databases = var.additional_databases

  backup_configuration = {
    enabled                        = true // 백업 활성화
    binary_log_enabled             = true // 바이너리 로깅 활성화
    start_time                     = "05:00" // 백업 시작 시간 (UTC)
    location                       = var.region // 백업 위치 설정
    point_in_time_recovery_enabled = true // 시점 복구 활성화
    transaction_log_retention_days = "7" // 트랜잭션 로그 보존 일수
    retained_backups               = 7 // 보존할 백업 수
    retention_unit                 = "COUNT" // 보존 단위 (COUNT 또는 DAYS)
  }


}

module "mysql_public" {

  source           = "../../../modules/mysql_public"
  name             = var.db_name_public
  project_id       = var.project
  database_version = "MYSQL_5_7"
  region           = var.region
  zone             = "${var.region}-a"
  # tier             = "db-custom-2-3840"
  tier                            = "db-custom-2-7680"
  deletion_protection             = false
  root_password                   = var.db_admin_password
  availability_type               = "ZONAL"
  maintenance_window_day          = "1"
  maintenance_window_hour         = "0"
  maintenance_window_update_track = "stable"


  ip_configuration = {
    ipv4_enabled = true
    # require_ssl  = false
    authorized_networks = [
      {
        name  = "somaz-public-access"
        value = "00.00.00.00/27" # your public ip
      },
      {
        name  = "github-public"
        value = "0.0.0.0/0"
      }
    ]
    private_network                               = "projects/${var.host_project}/global/networks/${var.shared_vpc}"
    allocated_ip_range                            = "google-managed-services-prod-mgmt-share-vpc"
    enable_private_path_for_google_cloud_services = true
  }

  user_labels = local.default_labels

  database_flags = [
    {
      name  = "long_query_time"
      value = "1"
    }
  ]

  additional_users = [
    {
      name            = var.db_admin_user
      password        = var.db_admin_password
      host            = "%" // host from where the user can connect.
      random_password = false
      type            = "BUILT_IN" // normal user or admin.
    }
  ]

  # additional_databases = var.additional_databases

  backup_configuration = {
    enabled                        = true // 백업 활성화
    binary_log_enabled             = true // 바이너리 로깅 활성화
    start_time                     = "05:00" // 백업 시작 시간 (UTC)
    location                       = var.region // 백업 위치 설정
    point_in_time_recovery_enabled = true // 시점 복구 활성화
    transaction_log_retention_days = "7" // 트랜잭션 로그 보존 일수
    retained_backups               = 7 // 보존할 백업 수
    retention_unit                 = "COUNT" // 보존 단위 (COUNT 또는 DAYS)
  }


}

## memorystore(redis) ##
module "memorystore" {
  source = "../../../modules/memorystore"

  name        = var.redis
  project     = var.project
  region      = var.region
  labels      = local.default_labels
  location_id = "${var.region}-a"
  # alternative_location_id = "projects/${var.host_project}/global/networks/${var.shared_vpc}-b"
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