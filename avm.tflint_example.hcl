plugin "terraform" {
  enabled = true
  version = "0.5.0"
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"
}

plugin "avm" {
  enabled     = true
  version     = "0.3.1"
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
  enabled = false
}

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
  enabled = false
}

rule "terraform_module_provider_declaration" {
  enabled = false
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
  enabled = false
}

rule "terraform_variable_nullable_false" {
  enabled = true
}

rule "terraform_variable_separate" {
  enabled = true
}

rule "azurerm_resource_tag" {
  enabled = false
}

rule "tfnfr26" {
  enabled = false
}