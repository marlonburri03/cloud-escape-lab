config {
  format     = "compact"
  call_module_type = "local"
}

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# Many variables are declared as architectural placeholders for the next
# iteration (e.g., hub_firewall_private_ip for the central egress route).
# We disable this rule during MVP/MLP to avoid premature deletion of
# planned interfaces. Re-enable once the architecture stabilises.
rule "terraform_unused_declarations" {
  enabled = false
}

plugin "azurerm" {
  enabled = true
  version = "0.27.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}
