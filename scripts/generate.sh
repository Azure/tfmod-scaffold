#!/usr/bin/env bash

echo "--> Generating doc"
rm -f .terraform.lock.hcl

if [ -f ".terraform-docs.yml" ]; then
	terraform-docs -c .terraform-docs.yml --output-file README.md ./
else
	terraform-docs markdown table --output-file README.md --output-mode inject ./
fi

markdown-table-formatter README.md