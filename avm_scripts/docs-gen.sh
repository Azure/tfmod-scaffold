#!/usr/bin/env bash

echo "==> Generating module documentation..."
rm -f .terraform.lock.hcl
terraform-docs -c .terraform-docs.yml .
echo "==> Generating examples documentation..."
examples=$(find ./examples -maxdepth 1 -mindepth 1 -type d)
for d in $examples; do
  echo "===> Generating examples documentation in " $d && cd $d && rm -f .terraform.lock.hcl && terraform-docs .
done
