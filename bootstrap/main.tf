module "state_backend" {
  source = "./modules/state_backend"

  resource_group_name  = var.resource_group_name
  location             = var.location
  storage_account_name = var.storage_account_name
  container_name       = var.container_name
  user_object_id       = var.user_object_id
}

module "maker_identity" {
  source = "./modules/maker_identity"

  name                = var.managed_identity_name
  resource_group_name = module.state_backend.resource_group_name
  location            = module.state_backend.location
  subscription_id     = var.subscription_id
  storage_account_id  = module.state_backend.storage_account_id
  gitlab_project_path = var.gitlab_project_path
}

module "entra_auth" {
  source = "./modules/entra_auth"

  application_name = var.application_name
  redirect_uris    = ["${trimsuffix(var.backend_api_url, "/")}/.auth/login/aad/callback"]
  owner_object_ids = {
    admin_user     = var.user_object_id
    maker_identity = module.maker_identity.principal_id
  }
}
