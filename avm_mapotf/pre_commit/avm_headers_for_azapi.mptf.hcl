locals {
  avm_headers_for_azapi_enabled = strcontains(env("AVMSCRIPT_VERSION"), "canary")
}

data "variable" enable_telemetry {
  name = "enable_telemetry"
}

locals {
  var_dot_enable_telemetry_exists = try(data.variable.enable_telemetry.result["enable_telemetry"] != null, false)
}

transform "new_block" new_enable_telemetry_variable {
  for_each       = local.avm_headers_for_azapi_enabled && !local.var_dot_enable_telemetry_exists ? toset([1]) : toset([])
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
  for_each             = local.avm_headers_for_azapi_enabled && local.var_dot_enable_telemetry_exists ? toset([1]) : toset([])
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

locals {
  azapi_resource_with_full_headers_types = toset([
    "azapi_data_plane_resource",
    "azapi_resource",
  ])
}

data "resource" "azapi_resources_with_full_headers" {
  for_each      = local.azapi_resource_with_full_headers_types
  resource_type = each.key
}

data "resource" "azapi_update_resource" {
    resource_type = "azapi_update_resource"
}

locals {
  all_azapi_resources_with_full_headers = flatten([
    for resource in data.resource.azapi_resources_with_full_headers : [
      for result_set in resource.result : flatten([
        for r in result_set : r
      ])
    ] if local.avm_headers_for_azapi_enabled
  ])
  all_azapi_resources_with_full_headers_map = {
    for r in local.all_azapi_resources_with_full_headers : r.mptf.block_address => r
  }
  azapi_update_resource_addresses = toset([
    for _, resource in data.resource.azapi_update_resource.result["azapi_update_resource"] : resource.mptf.block_address
  ])
}

transform "update_in_place" full_headers {
  for_each             = local.all_azapi_resources_with_full_headers_map
  target_block_address = each.key
  asstring {
    create_headers = try(strcontains(each.value.create_headers, "local.avm_azapi_header"), false) ? each.value.create_headers : (
      try(each.value.create_headers == "", true) ? "{ \"User-Agent\" : local.avm_azapi_header }" : "merge(${each.value.create_headers}, { \"User-Agent\" : local.avm_azapi_header })"
    )
    delete_headers = try(strcontains(each.value.delete_headers, "local.avm_azapi_header"), false) ? each.value.delete_headers : (
      try(each.value.delete_headers == "", true) ? "{ \"User-Agent\" : local.avm_azapi_header }" : "merge(${each.value.delete_headers}, { \"User-Agent\" : local.avm_azapi_header })"
    )
    read_headers = try(strcontains(each.value.read_headers, "local.avm_azapi_header"), false) ? each.value.read_headers : (
      try(each.value.read_headers == "", true) ? "{ \"User-Agent\" : local.avm_azapi_header }" : "merge(${each.value.read_headers}, { \"User-Agent\" : local.avm_azapi_header })"
    )
    update_headers = try(strcontains(each.value.update_headers, "local.avm_azapi_header"), false) ? each.value.update_headers : (
      try(each.value.update_headers == "", true) ? "{ \"User-Agent\" : local.avm_azapi_header }" : "merge(${each.value.update_headers}, { \"User-Agent\" : local.avm_azapi_header })"
    )
  }
}

transform "update_in_place" azapi_update_resource_headers {
  for_each             = local.avm_headers_for_azapi_enabled ? local.azapi_update_resource_addresses : toset([])
  target_block_address = each.value
  asstring {
    read_headers = try(strcontains(each.value.read_headers, "local.avm_azapi_header"), false) ? each.value.read_headers : (
      try(each.value.read_headers == "", true) ? "{ \"User-Agent\" : local.avm_azapi_header }" : "merge(${each.value.read_headers}, { \"User-Agent\" : local.avm_azapi_header })"
    )
    update_headers = try(strcontains(each.value.update_headers, "local.avm_azapi_header"), false) ? each.value.update_headers : (
      try(each.value.update_headers == "", true) ? "{ \"User-Agent\" : local.avm_azapi_header }" : "merge(${each.value.update_headers}, { \"User-Agent\" : local.avm_azapi_header })"
    )
  }
}