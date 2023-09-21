resource "google_filestore_instance" "nfs" {
  for_each = var.firestore_instances
  name     = each.value.instance_name
  location = "${var.region}-a"
  labels   = local.default_labels
  tier     = "BASIC_SSD"

  file_shares {
    name        = each.value.file_share_name
    capacity_gb = each.value.file_share_capacity_gb

    nfs_export_options {
      ip_ranges   = each.value.file_share_ip_ranges
      access_mode = "READ_WRITE"
      squash_mode = "NO_ROOT_SQUASH"
    }
  }

  networks {
    network      = "projects/${var.host_project}/global/networks/${var.shared_vpc}"
    modes        = ["MODE_IPV4"]
    connect_mode = "PRIVATE_SERVICE_ACCESS"
  }
}
