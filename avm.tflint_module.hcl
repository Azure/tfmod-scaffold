plugin "terraform" {
  enabled = true
  version = "0.10.0"
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"
}

plugin "avm" {
  enabled     = true
  version     = "0.13.0"
  source      = "github.com/Azure/tflint-ruleset-avm"
  signing_key = <<-KEY
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: BSN Pgp v1.1.0.0

mQENBF9hII8BCADEOCDl3/1tAZQp/1BCVJN+tqIRCd3ywzhOXTC38XWC0zVbFtiA
vbBFL1e78aoDIyUFDZcphCyYDqBkweXeYyYVCojZFVniyKklc2xZ15LDwlMBhneU
yEPSzDCltFn67wMPQMKa4+TujZJ3TIs1OUnUTsCPrjavGgmrfAdxAF/EjCDrnVp9
XmRWJii/9elAnMqWLDkMDfPaWkv3lWuyYCBHc7avOJE9oWypmWoEPOujwmtika/i
FhmvZbojZN6huf7pykXGRl1wEpu0MMEFvm4UsfEOv8JHVBZEu2w6glQugT6a+IZ6
atH3zyy+i1mmgsJPlMF1soHNEufeK1CabMklABEBAAG0Q1RlcnJhZm9ybSBBRE8g
cHJvdmlkZXIgcmVsZWFzZSA8dGVycmFmb3JtYWRvcHJvdmlkZXJAbWljcm9zb2Z0
LmNvbT6JATgEEwEIACIFAl9hII8CGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheA
AAoJEG8Lkb3phHjPT+YH/3aksw2yhoqVl+Dxkrpsq9LIsXBHmHfbk8/nwbZ7F6o6
fZetwozQzS/v5IriE42NFdk2omilDa/Iumk5soPrCamIIToYMbGvZJ9MJzCflXzp
H3crqEgoCwu/93FVot4hhNOGmS2ra538zDQ3JsSbsVSc2TyPeBCF08+qJrr9VSML
LceuEvCKUN8P8LH+PXN4kKM1xNlSVw4RfH6mNJKdUG1Klvh2nbq0kuw8jiHITn2F
ALGvKXPLwggdNA86RIQc9tc3z/uJrBGSA2n6UkJbV1gFZDETjHzVtgDqqEQwap7D
/i9e5KqIAEIf14OPm3h+e6kCdWXRG0RJWWVWeOHIEfQ=
=KwXd
-----END PGP PUBLIC KEY BLOCK-----
    KEY
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_deprecated_lookup" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_empty_list_equality" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = true
}

rule "terraform_module_version" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
}

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  enabled = false
}

rule "terraform_typed_variables" {
  enabled = true
}

# disable for `locals.version.tf.json for now
rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_unused_required_providers" {
  enabled = true
}

rule "terraform_workspace_remote" {
  enabled = true
}

rule "terraform_heredoc_usage" {
  enabled = true
}

rule "terraform_module_provider_declaration" {
  enabled = true
}

rule "terraform_output_separate" {
  enabled = true
}

rule "terraform_required_providers_declaration" {
  enabled = true
}

rule "terraform_required_version_declaration" {
  enabled = true
}

rule "terraform_sensitive_variable_no_default" {
  enabled = true
}

rule "terraform_variable_nullable_false" {
  enabled = true
}

rule "terraform_variable_separate" {
  enabled = true
}

rule "azurerm_resource_tag" {
  enabled = true
}

# AVM Provider Rules

rule "tfnfr26" {
  enabled = true
}

# AVM Module Rules

rule "required_module_source_tffr1" {
  enabled = true
}

# AVM Output Rules

rule "required_output_rmfr7" {
  enabled = true
}

# AVM Variable Interface Rules

rule "customer_managed_key" {
  enabled = true
}

rule "diagnostic_settings" {
  enabled = true
}

rule "location" {
  enabled = true
}

rule "lock" {
  enabled = true
}

rule "managed_identities" {
  enabled = true
}

rule "private_endpoints" {
  enabled = true
}

rule "role_assignments" {
  enabled = true
}

rule "tags" {
  enabled = true
}

rule "provider_modtm_version" {
  enabled = false
}

rule "valid_template_interpolation" {
  enabled = true
}