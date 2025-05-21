data "terraform" this {

}

locals {
  azapi_provider_version_valid = try(!semvercheck(data.terraform.this.required_providers.azapi.version, "2.3.999"), false)
}

transform "update_in_place" azapi_provider_version {
  for_each             = local.avm_headers_for_azapi_enabled && !local.azapi_provider_version_valid ? toset([1]) : toset([])
  target_block_address = "terraform"
  asraw {
    required_providers {
      azapi = {
        source  = "Azure/azapi"
        version = ">= 2.4.0, < 3.0"
      }
    }
  }
}