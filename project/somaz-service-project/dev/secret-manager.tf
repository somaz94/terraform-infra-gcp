## Secret Manager ##
module "secret_manager" {
  source     = "../../../modules/secret_manager"
  project_id = var.project
  labels     = local.default_map_labels
  secrets = [
    {
      name                  = var.db_secret
      automatic_replication = true
      secret_data = jsonencode({
        username            = var.db_username
        password            = var.db_password
        dev-username        = var.username
        dev-password        = var.password
        dev-bastion-user    = var.bastion_user
        dev-bastion-pem-key = "${trimspace(file(var.bastion_pem_key))}"
      })
    },
    {
      name                  = var.gcs_cloudcdn
      automatic_replication = true
      secret_data = jsonencode({
        service-account     = var.gcs_cloudcdn_service_account
        service-account-key = "${trimspace(file(var.gcs_cloudcdn_service_account_key))}"
      })
    }
  ]
}
