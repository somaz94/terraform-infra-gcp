locals {

  default_labels = {
    environment = var.environment
    terraform   = var.terraform
  }

  default_map_labels = merge(
    {
      "${var.db_secret}" = {
        environment = var.environment
        terraform   = var.terraform
      },
      "${var.gcs_cloudcdn}" = {
        environment = var.environment
        terraform   = var.terraform
      }
    }
  )

  buckets_versioning = {
    "${var.tf_state_bucket}" = true
  }

  lifecycle_rules = {
    "${var.tf_state_bucket}" = [
      {
        action = {
          type = "Delete"
        },
        condition = {
          age        = 120,
          with_state = "ARCHIVED"
        }
      }
    ]
  }

}
