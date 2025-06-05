locals {
    sync_main_telemetry_tf = strcontains(env("AVMSCRIPT_VERSION"), "canary")
  }

data "local" avm_azapi_header {
  name = "avm_azapi_header"
}

locals {
  avm_azapi_header_exists          = try(data.local.avm_azapi_header.result["avm_azapi_header"] != null, false)
  azapi_headers_locals = {
    valid_module_source_regex = <<-EOT
    [
      "registry.terraform.io/[A|a]zure/.+",
      "registry.opentofu.io/[A|a]zure/.+",
      "git::https://github\\.com/[A|a]zure/.+",
      "git::ssh:://git@github\\.com/[A|a]zure/.+",
    ]
EOT
    fork_avm                  = "!anytrue([for r in local.valid_module_source_regex : can(regex(r, one(data.modtm_module_source.telemetry).module_source))])"
    avm_azapi_headers         = <<-EOT
  !var.enable_telemetry ? {} : (local.fork_avm ? {
    fork_avm  = "true"
    random_id = one(random_uuid.telemetry).result
    } : {
    avm                = "true"
    random_id          = one(random_uuid.telemetry).result
    avm_module_source  = one(data.modtm_module_source.telemetry).module_source
    avm_module_version = one(data.modtm_module_source.telemetry).module_version
  })
EOT
  }
  avm_azapi_header = "join(\" \", [ for k, v in local.avm_azapi_headers : \"$${k}=$${v}\" ])"
}

transform "new_block" new_avm_azapi_header_local {
  for_each       = local.sync_main_telemetry_tf && !local.avm_azapi_header_exists ? toset([1]) : toset([])
  new_block_type = "locals"
  filename       = "main.telemetry.tf"
  body           = <<-EOT
    # tflint-ignore: terraform_unused_declarations
    avm_azapi_header = ${local.avm_azapi_header}
EOT
}

transform "ensure_local" azapi_headers_helper_local {
  for_each           = local.sync_main_telemetry_tf ? local.azapi_headers_locals : {}
  name               = each.key
  fallback_file_name = "main.telemetry.tf"
  value_as_string    = each.value
}

# We can declare tflint-ignore annotation only by using new_block, so we don't provision ensure_local if local.avm_azapi_headers is absent
transform "ensure_local" azapi_headers_local {
  for_each           = local.sync_main_telemetry_tf && local.avm_azapi_header_exists ? toset([1]) : toset([])
  name               = "avm_azapi_header"
  fallback_file_name = "main.telemetry.tf"
  value_as_string    = local.avm_azapi_header
}

data "data" "azurerm_client_config" {
  data_source_type = "azurerm_client_config"
}

locals {
  data_azurerm_client_config_telemetry_exists = try(data.data.azurerm_client_config.result["azurerm_client_config"].telemetry.mptf != null, false)
}

transform "remove_block" azurerm_client_config {
  for_each             = local.sync_main_telemetry_tf && local.data_azurerm_client_config_telemetry_exists ? toset([1]) : toset([])
  target_block_address = "data.azurerm_client_config.telemetry"
}

data "data" "azapi_client_config" {
  data_source_type = "azapi_client_config"
}

locals {
  data_azapi_client_config_telemetry_exists = try(data.data.azapi_client_config.result["azapi_client_config"].telemetry.mptf != null, false)
}

transform "new_block" azapi_client_config {
  for_each       = local.sync_main_telemetry_tf && !local.data_azapi_client_config_telemetry_exists ? toset([1]) : toset([])
  new_block_type = "data"
  labels         = ["azapi_client_config", "telemetry"]
  filename       = "main.telemetry.tf"
  asraw {
    count       = var.enable_telemetry ? 1 : 0
  }
}

transform "update_in_place" azapi_client_config {
  for_each             = local.sync_main_telemetry_tf && local.data_azapi_client_config_telemetry_exists ? toset([1]) : toset([])
  target_block_address = "data.azapi_client_config.telemetry"
  asraw {
    count       = var.enable_telemetry ? 1 : 0
  }
}

data "data" modtm_module_source {
  data_source_type = "modtm_module_source"
}

transform "new_block" new_modtm_module_source {
  for_each       = local.sync_main_telemetry_tf && try(data.data.modtm_module_source.result["modtm_module_source"].telemetry == null, true) ? toset([1]) : toset([])
  new_block_type = "data"
  labels         = ["modtm_module_source", "telemetry"]
  filename       = "main.telemetry.tf"
  asraw {
    count       = var.enable_telemetry ? 1 : 0
    module_path = path.module
  }
}

transform "update_in_place" modtm_module_source {
  for_each             = local.sync_main_telemetry_tf && try(data.data.modtm_module_source.result["modtm_module_source"].telemetry != null, false) ? toset([1]) : toset([])
  target_block_address = "data.modtm_module_source.telemetry"
  asraw {
    count       = var.enable_telemetry ? 1 : 0
    module_path = path.module
  }
  depends_on = [
    transform.new_block.new_modtm_module_source
  ]
}

data "resource" "random_uuid" {
  resource_type = "random_uuid"
}

transform "new_block" new_random_uuid {
  for_each       = local.sync_main_telemetry_tf && try(data.resource.random_uuid.result["random_uuid"].telemetry == null, true) ? toset([1]) : toset([])
  new_block_type = "resource"
  labels         = ["random_uuid", "telemetry"]
  filename       = "main.telemetry.tf"
  asraw {
    count = var.enable_telemetry ? 1 : 0
  }
}

transform "update_in_place" random_uuid {
  for_each             = local.sync_main_telemetry_tf && try(data.resource.random_uuid.result["random_uuid"].telemetry != null, false) ? toset([1]) : toset([])
  target_block_address = "resource.random_uuid.telemetry"
  asraw {
    count = var.enable_telemetry ? 1 : 0
  }
  depends_on = [
    transform.new_block.new_random_uuid
  ]
}

data "resource" "modtm_telemetry_telemetry" {
  resource_type = "modtm_telemetry"
}

data "variable" location {
  name = "location"
  type = "string"
}

data "resource" "modtm_telemetry" {
  resource_type = "modtm_telemetry"
}

data "local" "main_location" {
  name = "main_location"
}

locals {
  location_variable_exist       = length(data.variable.location.result) == 1
  local_dot_main_location_exist = length(data.local.main_location.result) == 1
  resource_modtm_telemetry_telemetry_exists = try(data.resource.modtm_telemetry_telemetry.result["modtm_telemetry"].telemetry.mptf != null, false)
  location_pair = local.local_dot_main_location_exist ? "{ location = local.main_location }" : (
            local.location_variable_exist ? "{ location = var.location }" : "{}"
  )
}

transform "new_block" new_modtm_telemetry_telemetry {
  for_each       = local.sync_main_telemetry_tf && !local.resource_modtm_telemetry_telemetry_exists ? toset([1]) : toset([])
  new_block_type = "resource"
  labels         = ["modtm_telemetry", "telemetry"]
  filename       = "main.telemetry.tf"
  asstring {
    count = "var.enable_telemetry ? 1 : 0"

    tags = <<-EOT
    merge({
      subscription_id = one(data.azapi_client_config.telemetry).subscription_id
      tenant_id       = one(data.azapi_client_config.telemetry).tenant_id
      module_source   = one(data.modtm_module_source.telemetry).module_source
      module_version  = one(data.modtm_module_source.telemetry).module_version
      random_id       = one(random_uuid.telemetry).result
    }, ${local.location_pair})
EOT
  }
}

transform "update_in_place" modtm_telemetry_telemetry {
  for_each             = local.sync_main_telemetry_tf && local.resource_modtm_telemetry_telemetry_exists ? toset([1]) : toset([])
  target_block_address = "resource.modtm_telemetry.telemetry"
  asstring {
    count = "var.enable_telemetry ? 1 : 0"

    tags = <<-EOT
    merge({
      subscription_id = one(data.azapi_client_config.telemetry).subscription_id
      tenant_id       = one(data.azapi_client_config.telemetry).tenant_id
      module_source   = one(data.modtm_module_source.telemetry).module_source
      module_version  = one(data.modtm_module_source.telemetry).module_version
      random_id       = one(random_uuid.telemetry).result
    }, ${local.location_pair})
EOT
  }
}