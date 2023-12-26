#!/usr/bin/env bash

function generate_docs() {
  local dir=$1
  echo "===> Generating examples documentation in " $dir
  rm -f "$dir/.terraform.lock.hcl"
  if [ -f "$dir/../../.terraform-docs.yml" ]; then
    terraform-docs -c "$dir/../../.terraform-docs.yml" "$dir"
  else
    terraform-docs markdown table --output-file "$dir/README.md" --output-mode inject "$dir"
  fi
}

echo "==> Generating module documentation..."
rm -f .terraform.lock.hcl
terraform-docs -c .terraform-docs.yml .
echo "==> Generating examples documentation..."
examples=$(find ./examples -maxdepth 1 -mindepth 1 -type d)
for d in $examples; do
  generate_docs $d
done
