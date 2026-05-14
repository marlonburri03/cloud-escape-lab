tenant_id       = "00000000-0000-0000-0000-000000000001"
subscription_id = "00000000-0000-0000-0000-000000000002"
use_oidc        = true

location    = "northeurope"
name_prefix = "lab-prod-escape"

tags = {
  project     = "cloud-escape-lab"
  environment = "poc"
  owner       = "contoso-escape"
}

# vended spoke network references
spoke_vnet_resource_group = "rg-network-lab-prod-escape"
spoke_vnet_name           = "vnet-lab-prod-escape-ne-01"
hub_firewall_private_ip   = "10.10.0.4"

# subnets inside the vended vnet (10.20.18.0/24)
subnet_app_address_prefix = "10.20.18.128/27"
subnet_pe_address_prefix  = "10.20.18.192/27"

# workload
workload_resource_group_name = "rg-workload-lab-prod-escape"

# hub references
appgw_subnet_cidr = "10.10.2.0/24"

# azure container registry
acr_name = "acrlabprodescape"
acr_sku  = "Basic"

# frontend image references
frontend_image_name = "frontend"
frontend_image_tag  = "bootstrap"
