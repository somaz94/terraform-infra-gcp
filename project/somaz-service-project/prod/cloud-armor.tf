## Cloud Armor ##
module "cloud_armor_ip_allow" {
  source = "../../../modules/cloud_armor"

  project_id          = var.project
  name                = var.ip_allow_rule_name
  description         = "Cloud Armor Edge security policy for IP Allow"
  default_rule_action = "deny(403)"
  type                = "CLOUD_ARMOR_EDGE"

  custom_rules = {
    allow_specific_ip_range = {
      action      = "allow"
      priority    = 10
      description = "Allow specific IP ranges"
      expression  = <<-EOT
        inIpRange(origin.ip, '14.32.77.192/27') || inIpRange(origin.ip, '106.247.237.200/30') 
      EOT
    }
  }
}

module "cloud_armor_region_block" {
  source = "../../../modules/cloud_armor"

  project_id          = var.project
  name                = var.region_block_rule_name
  description         = "Cloud Armor Edge security policy for Region block"
  default_rule_action = "deny(403)"
  type                = "CLOUD_ARMOR_EDGE"

  custom_rules = {
    block_specific_regions = {
      action      = "allow"
      priority    = 1
      description = "Block China Regions"
      expression  = <<-EOT
        origin.region_code != "CN"
      EOT
    }
  }
}
