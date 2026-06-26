resource "azuread_application" "this" {
  display_name = var.application_name

  web {
    redirect_uris = var.redirect_uris
  }
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application.this.client_id
}

resource "azuread_application_password" "this" {
  application_id = azuread_application.this.id
}

resource "azuread_application_owner" "this" {
  for_each        = var.owner_object_ids
  application_id  = azuread_application.this.id
  owner_object_id = each.value
}
