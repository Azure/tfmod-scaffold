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
}

transform "update_in_place" telemetry_with_var_dot_location {
  for_each             = local.location_variable_exist && !local.local_dot_main_location_exist ? data.resource.modtm_telemetry.result.modtm_telemetry : {}
  target_block_address = each.value.mptf.block_address
  asstring {
    tags = strcontains(each.value.tags, "location = var.location") ? each.value.tags : try("merge(${each.value.tags}, { location = var.location })", "{ location = var.location }")
  }
}

transform "update_in_place" telemetry_with_local_dot_main_location {
  for_each             = local.local_dot_main_location_exist ? data.resource.modtm_telemetry.result.modtm_telemetry : {}
  target_block_address = each.value.mptf.block_address
  asstring {
    tags = strcontains(each.value.tags, "location = local.main_location") ? each.value.tags : try("merge(${each.value.tags}, { location = local.main_location })", "{ location = local.main_location }")
  }
}