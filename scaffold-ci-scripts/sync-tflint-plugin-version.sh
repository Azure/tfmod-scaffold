#!/usr/bin/bash

export $(grep -v '^#' version.env | xargs)

cat .tflint.hcl | \
hcledit attribute set plugin.azurerm.version \"$TFLINT_AZURERM_VERSION\" | \
hcledit attribute set plugin.basic-ext.version \"$TFLINT_BASIC_EXT_VERSION\" | \
hcledit attribute set plugin.azurerm-ext.version \"$TFLINT_AZURERM_EXT_VERSION\" \
> .tflint.hcl.tmp && mv .tflint.hcl.tmp .tflint.hcl

cat .tflint_example.hcl | \
hcledit attribute set plugin.azurerm.version \"$TFLINT_AZURERM_VERSION\" | \
hcledit attribute set plugin.basic-ext.version \"$TFLINT_BASIC_EXT_VERSION\" | \
hcledit attribute set plugin.azurerm-ext.version \"$TFLINT_AZURERM_EXT_VERSION\" \
> .tflint_example.hcl.tmp && mv .tflint_example.hcl.tmp .tflint_example.hcl