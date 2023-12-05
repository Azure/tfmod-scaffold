#!/usr/bin/env bash

echo "==> Generating..."
cp README.md README-generated.md

rm -f .terraform.lock.hcl
terraform-docs -c .terraform-docs.yml .

echo "==> Comparing generated code to committed code..."
diff -q README.md README-generated.md || \
    		(echo; echo "Unexpected difference in generated document. Run 'make pre-commit' to update the generated document and commit."; exit 1)