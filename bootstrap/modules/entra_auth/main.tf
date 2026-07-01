resource "azuread_application" "app" {
  display_name = var.application_name

  web {
    redirect_uris = var.redirect_uris

    implicit_grant {
      id_token_issuance_enabled = true
    }
  }

  lifecycle {
    ignore_changes = [owners]
  }
}

resource "azuread_service_principal" "service_principal" {
  client_id = azuread_application.app.client_id
}

resource "azuread_application_password" "client_secret" {
  application_id = azuread_application.app.id
}

resource "azuread_application_owner" "owner" {
  for_each        = var.owner_object_ids
  application_id  = azuread_application.app.id
  owner_object_id = each.value
}
