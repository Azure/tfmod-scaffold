#!/usr/bin/env bash

echo "==> Generating module documentation..."
rm -f .terraform.lock.hcl
terraform-docs -c .terraform-docs.yml .
echo "==> Generating examples documentation..."
cd examples && for d in $$(ls -d */); do rm -f .terraform.lock.hcl && terraform-docs  $$d; done
