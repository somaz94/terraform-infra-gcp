## common ##
locals {

  default_labels = {
    environment = var.environment
    terraform   = var.terraform
  }

  buckets_versioning = {
    "${var.tf_state_bucket}" = true
  }

}

