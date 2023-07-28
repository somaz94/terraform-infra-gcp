## common ##
locals {

  default_labels = {
    environment = var.environment
    terraform   = var.terraform
  }

  default_map_labels = {
    environment = {
      key1 = var.environment
    },
    terraform = {
      key2 = var.terraform
    }
  }

  buckets_versioning = {
    "${var.tf_state_bucket}" = true
  }

}
