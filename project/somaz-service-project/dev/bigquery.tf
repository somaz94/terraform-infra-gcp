## BigQuery DB Connection ##
resource "google_bigquery_connection" "sql_connection" {
  connection_id = "dev-somaz-sql-connection"
  location      = var.region
  friendly_name = "dev-somaz-sql-connection"
  description   = "test"
  cloud_sql {
    instance_id = "somaz-service-project-dev:asia-northeast3:dev-somaz-db" # <project>:<region>:<DB name>
    database    = "web"
    type        = "MYSQL"
    credential {
      username = var.db_admin_user
      password = var.db_admin_password
    }
  }
}
