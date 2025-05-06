data "variable" location {
  name = "location"
  type = "string"
}

locals {
  location_variable_exist = length(data.variable.location.result) == 1
}

transform "update_in_place" telemetry {
  for_each = local.location_variable_exist ? [1] : toset([])
  target_block_address = "resource.modtm_telemetry.telemetry"
  asraw {
    tags = {
      subscription_id = one(data.azurerm_client_config.telemetry).subscription_id
      tenant_id       = one(data.azurerm_client_config.telemetry).tenant_id
      module_source   = one(data.modtm_module_source.telemetry).module_source
      module_version  = one(data.modtm_module_source.telemetry).module_version
      random_id       = one(random_uuid.telemetry).result
      location        = var.location
    }
  }
}
