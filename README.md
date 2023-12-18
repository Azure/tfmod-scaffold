# Azure Verified Terraform Module Scaffold

This scaffold is a collection of scripts to facilitate Azure Verified Terraform Module CI pipeline. It's designed to
work with CI such as GitHub Actions, and provides a Dockerfile to run these steps on your local machine.

## Dockerfile

We've provided a docker image at `mcr.microsoft.com/azterraform:latest`. This image is built by
the [Dockerfile in this repo](Dockerfile). We'll build and push a new image when there's a new tag pushed into this
repo.

We maintain all versions of tools that we used in [version.env](version.env) file, if you'd like to build the docker image on your machine, please use the following command (need Linux and awk):

```shell
docker build $(sh build-arg-helper.sh version.env) -t localrunner .
```

## Before you commit

To sync versions between [version.env](version.env) and [.tflint.hcl](.tflint.hcl) and [.tflint_example.hcl](.tflint_example.hcl), we suggest you execute the following command before you commit changes:

```shell
docker run --rm -v $(pwd):/src -w /src localrunner sh scaffold-ci-scripts/sync-tflint-plugin-version.sh
```

On Windows:
```shell
docker run --rm -v ${pwd}:/src -w /src localrunner sh scaffold-ci-scripts/sync-tflint-plugin-version.sh
```

## Tools We're Using Now

| Name                                                                                      | Latest Version                                                                    |
|-------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------|
| [Go](https://github.com/golang/go)                			                            | ![](https://img.shields.io/github/v/tag/golang/go)			                    |
| [TFLint](https://github.com/terraform-linters/tflint)                                     | ![](https://img.shields.io/github/v/tag/terraform-linters/tflint)                 |
| [TFLint AzureRM Ruleset](https://github.com/terraform-linters/tflint-ruleset-azurerm)     | ![](https://img.shields.io/github/v/tag/terraform-linters/tflint-ruleset-azurerm) |
| [TFLint Basic Ruleset Extension](https://github.com/Azure/tflint-ruleset-basic-ext)       | ![](https://img.shields.io/github/v/tag/Azure/tflint-ruleset-basic-ext)           |
| [TFLint AzureRM Ruleset Extension](https://github.com/Azure/tflint-ruleset-azurerm-ext)   | ![](https://img.shields.io/github/v/tag/Azure/tflint-ruleset-azurerm-ext)         |
| [BridgeCrew Checkov](https://github.com/bridgecrewio/checkov)                             | ![](https://img.shields.io/github/v/tag/bridgecrewio/checkov)                     |
| [HashiCorp Terraform](https://github.com/hashicorp/terraform)                             | ![](https://img.shields.io/github/v/tag/hashicorp/terraform)                      |
| [GruntWork TerraGrunt](https://github.com/gruntwork-io/terragrunt)                        | ![](https://img.shields.io/github/v/tag/gruntwork-io/terragrunt)                  |
| [Terraform Docs](https://github.com/terraform-docs/terraform-docs)                        | ![](https://img.shields.io/github/v/tag/terraform-docs/terraform-docs)            |
| [Golangci-lint](https://github.com/golangci/golangci-lint)                                | ![](https://img.shields.io/github/v/tag/golangci/golangci-lint)                   |
| [Terraform Module Breaking Detect](https://github.com/Azure/terraform-module-test-helper) | ![](https://img.shields.io/github/v/tag/Azure/terraform-module-test-helper)       |
| [HCLEdit](https://github.com/minamijoyo/hcledit)                                          | ![](https://img.shields.io/github/v/tag/minamijoyo/hcledit)                       |
| [GoSec](https://github.com/securego/gosec)                                                | ![](https://img.shields.io/github/v/tag/securego/gosec)                           |
| [BridgeCrew Yor](https://github.com/securego/gosec)                                       | ![](https://img.shields.io/github/v/tag/bridgecrewio/yor)                         |
| [tfenv](https://github.com/tfutils/tfenv)                                       	 		| ![](https://img.shields.io/github/v/tag/tfutils/tfenv)                            |
| [hclgrep](https://github.com/magodo/hclgrep)												| ![](https://img.shields.io/github/v/tag/magodo/hclgrep)                           |
| [avmfix](https://github.com/lonegunmanb/avmfix)											| ![](https://img.shields.io/github/v/tag/lonegunmanb/avmfix)                       |
| [hclgrep](https://github.com/lonegunmanb/yorbox)											| ![](https://img.shields.io/github/v/tag/lonegunmanb/yorbox)                       |
| [tfsec](https://github.com/aquasecurity/tfsec)											| ![](https://img.shields.io/github/v/tag/aquasecurity/tfsec)                       |
| [grept](https://github.com/Azure/grept)	    											| ![](https://img.shields.io/github/v/tag/Azure/grept)                              |

## To Add CI Pipeline In New Azure Verified Terraform Module

Create a new `GNUMakefile` in your module's folder:

```makefile
SHELL := /bin/bash

-include $(shell curl -sSL "https://raw.githubusercontent.com/Azure/tfmod-scaffold/main/scripts/install.sh" | bash -s > /dev/null ; echo tfmod-scaffold/GNUmakefile)

init:
	@sh "$(CURDIR)/scripts/init.sh"

cleanup:
	@sh "$(CURDIR)/scripts/cleanup.sh"
```

To init Github Action CI yaml files in your module, run:

```shell
$ make init
```
