## Private Service Access ##
module "private_service_access" {
  source        = "../../modules/private_service_access"
  address       = "10.1.16.0"
  prefix_length = 20
  project_id    = var.project
  vpc_network   = var.shared_vpc
  labels        = local.default_labels

  depends_on = [module.vpc]
}

## Prod Private Service Access ##
module "prod_private_service_access" {
  source        = "../../modules/private_service_access"
  address       = "10.1.32.0"
  prefix_length = 20
  project_id    = var.project
  vpc_network   = var.prod_shared_vpc
  labels        = local.default_labels

  depends_on = [module.prod_vpc]
}
