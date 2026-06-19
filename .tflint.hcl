config {
  format = "compact"
}

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

rule "terraform_unused_declarations" {
  enabled = true
}

plugin "azurerm" {
  enabled = true
}
