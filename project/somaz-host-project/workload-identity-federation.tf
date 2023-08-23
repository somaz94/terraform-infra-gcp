## Service Account ##
module "service_accounts" {
  source       = "../../modules/service_accounts"
  project_id   = var.project
  names        = ["github-action"]
  display_name = "github-action"
  description  = "github-action admin"
}

## Workload Identity Federation ##

data "google_service_account" "github-action" {
  account_id = "github-action"

  depends_on = [module.service_accounts]
}

module "workload_identity_federation" {
  source      = "../../modules/workload_identity_federation"
  project_id  = var.project
  pool_id     = "pool-github-action"
  provider_id = "provider-github-action"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.aud"        = "assertion.aud"
    "attribute.repository" = "assertion.repository"
  }
  issuer_uri = "https://token.actions.githubusercontent.com"

  service_accounts = [
    {
      name           = data.google_service_account.github-action.name
      attribute      = "attribute.repository/somaz94/*" # attribute.repository/github repository/*
      all_identities = true
    }
  ]
}
