#!/usr/bin/env bash

echo "==> Generating..."
cp README.md README-generated.md

if [ -f ".terraform-docs.yml" ]; then
	terraform-docs -c .terraform-docs.yml --output-file README-generated.md ./
else
	terraform-docs markdown table --output-file README-generated.md --output-mode inject ./
fi

markdown-table-formatter README-generated.md
echo "==> Comparing generated code to committed code..."
diff -q README.md README-generated.md || \
    		(echo; echo "Unexpected difference in generated document. Run 'make pre-commit' to update the generated document and commit."; exit 1)