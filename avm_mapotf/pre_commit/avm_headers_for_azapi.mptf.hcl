data "local" avm_azapi_headers {
  name = "avm_azapi_headers"
}

locals {
  var_dot_enable_telemeetry_exists = try(data.variable.enable_telemetry.result["enable_telemetry"] != null, false)
  avm_azapi_headers_exists         = try(data.local.avm_azapi_headers.result["avm_azapi_headers"] != null, false)
}

locals {
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
}

transform "new_block" new_avm_azapi_headers_local {
  for_each       = local.avm_azapi_headers_exists ? toset([]) : toset([1])
  new_block_type = "locals"
  filename       = "main.telemetry.tf"
  body           = <<-EOT
    valid_module_source_regex = ${local.azapi_headers_locals.valid_module_source_regex}
    fork_avm = ${local.azapi_headers_locals.fork_avm}
    # tflint-ignore: terraform_unused_declarations
    avm_azapi_headers = ${local.azapi_headers_locals.avm_azapi_headers}
EOT
}

transform "ensure_local" azapi_headers_local {
  for_each           = local.azapi_headers_locals
  name               = each.key
  fallback_file_name = "main.telemetry.tf"
  value_as_string    = each.value

  depends_on = [
    transform.new_block.new_avm_azapi_headers_local
  ]
}

data "variable" enable_telemetry {
  name = "enable_telemetry"
}

transform "new_block" new_enable_telemetry_variable {
  for_each       = local.var_dot_enable_telemeetry_exists ? toset([]) : toset([1])
  new_block_type = "variable"
  labels         = ["enable_telemetry"]
  filename       = "variables.tf"
  asraw {
    type        = bool
    default     = true
    description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
    nullable    = false
  }
}

transform "update_in_place" enable_telemetry_variable {
  for_each             = local.var_dot_enable_telemeetry_exists ? toset([1]) : toset([])
  target_block_address = "variable.enable_telemetry"
  asraw {
    type        = bool
    default     = true
    description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
    nullable    = false
  }
  depends_on = [
    transform.new_block.new_enable_telemetry_variable
  ]
}

data "resource" "random_uuid" {
  resource_type = "random_uuid"
}

transform "new_block" new_random_uuid {
  for_each       = try(data.resource.random_uuid.result["random_uuid"].telemetry != null, false) ? toset([]) : toset([1])
  new_block_type = "resource"
  labels         = ["random_uuid", "telemetry"]
  filename       = "main.telemetry.tf"
  asraw {
    count = var.enable_telemetry ? 1 : 0
  }
}

transform "update_in_place" random_uuid {
  for_each             = try(data.resource.random_uuid.result["random_uuid"].telemetry != null, false) ? toset([1]) : toset([])
  target_block_address = "resource.random_uuid.telemetry"
  asraw {
    count = var.enable_telemetry ? 1 : 0
  }
  depends_on = [
    transform.new_block.new_random_uuid
  ]
}

data "data" modtm_module_source {
  data_source_type = "modtm_module_source"
}

transform "new_block" new_modtm_module_source {
  for_each       = try(data.data.modtm_module_source.result["modtm_module_source"].telemetry != null, false) ? toset([]) : toset([1])
  new_block_type = "data"
  labels         = ["modtm_module_source", "telemetry"]
  filename       = "main.telemetry.tf"
  asraw {
    count       = var.enable_telemetry ? 1 : 0
    module_path = path.module
  }
}

transform "update_in_place" modtm_module_source {
  for_each             = try(data.data.modtm_module_source.result["modtm_module_source"].telemetry != null, false) ? toset([1]) : toset([])
  target_block_address = "data.modtm_module_source.telemetry"
  asraw {
    count       = var.enable_telemetry ? 1 : 0
    module_path = path.module
  }
  depends_on = [
    transform.new_block.new_modtm_module_source
  ]
}

locals {
  azapi_resource_types = toset([
    "azapi_data_plane_resource",
    "azapi_resource",
    "azapi_update_resource",
  ])
}

data "resource" "azapi_resource" {
  for_each      = local.azapi_resource_types
  resource_type = each.key
}

locals {
  all_azapi_resources = flatten([
    for resource in data.resource.azapi_resource : [
      for result_set in resource.result : flatten([
        for r in result_set : r
      ])
    ]
  ])
  all_azapi_resources_map = {
    for r in local.all_azapi_resources : r.mptf.block_address => r
  }
}

transform "update_in_place" headers {
  for_each             = local.all_azapi_resources_map
  target_block_address = each.key
  asstring {
    create_headers = try(strcontains(each.value.create_headers, "local.avm_azapi_headers"), false) ? each.value.create_headers : (
      try(each.value.create_headers == "", true) ? "local.avm_azapi_headers" : "merge(${each.value.create_headers}, local.avm_azapi_headers)"
    )
    delete_headers = try(strcontains(each.value.delete_headers, "local.avm_azapi_headers"), false) ? each.value.delete_headers : (
      try(each.value.delete_headers == "", true) ? "local.avm_azapi_headers" : "merge(${each.value.delete_headers}, local.avm_azapi_headers)"
    )
    reader_headers = try(strcontains(each.value.reader_headers, "local.avm_azapi_headers"), false) ? each.value.reader_headers : (
      try(each.value.reader_headers == "", true) ? "local.avm_azapi_headers" : "merge(${each.value.reader_headers}, local.avm_azapi_headers)"
    )
    update_headers = try(strcontains(each.value.update_headers, "local.avm_azapi_headers"), false) ? each.value.update_headers : (
      try(each.value.update_headers == "", true) ? "local.avm_azapi_headers" : "merge(${each.value.update_headers}, local.avm_azapi_headers)"
    )
  }
}