#!/usr/bin/env bash

echo "--> Generating doc"
rm -f .terraform.lock.hcl

if [ -f ".terraform-docs.yml" ]; then
	terraform-docs -c .terraform-docs.yml --output-file README.md ./
elif [ -d ".terraform-docs" ]; then
  configs=$(find .terraform-docs -maxdepth 1 -mindepth 1 -type f)
  for config in $configs; do
    terraform-docs -c $config ./
  done
else
	terraform-docs markdown table --output-file README.md --output-mode inject ./
fi
