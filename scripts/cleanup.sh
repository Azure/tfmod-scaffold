#!/bin/bash

sh scripts/cleanup-actions.sh
rm -f .tflint.hcl
rm -f .tflint_example.hcl
rm -rf "tfmod-scaffold"
rm -rf "scripts"