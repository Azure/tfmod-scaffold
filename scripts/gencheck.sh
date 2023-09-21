#!/usr/bin/env bash

echo "==> Generating..."
cp README.md README-generated.md

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

echo "==> Comparing generated code to committed code..."
diff -q README.md README-generated.md || \
    		(echo; echo "Unexpected difference in generated document. Run 'make pre-commit' to update the generated document and commit."; exit 1)