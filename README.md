# Azure Verified Terraform Module Scaffold

This scaffold is a collection of scripts to facilitate Azure Verified Terraform Module CI pipeline. It's designed to work with CI such as GitHub Actions, and provides a Dockerfile to run these steps on your local machine.

## Dockerfile

We've provided a docker image at `mcr.microsoft.com/azterraform:latest`. This image is built by the [Dockerfile in this repo](Dockerfile). We'll build and push a new image when there's a new tag pushed into this repo.

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
