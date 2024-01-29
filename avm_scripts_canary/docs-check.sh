#!/usr/bin/env bash

check_example_docs () {
  local dir=$1
  echo "===> Generating examples documentation in $dir"
	cp "$dir/README.md" "$dir/README-generated.md"
  rm -f "$dir/.terraform.lock.hcl"
  terraform-docs -c ".terraform-docs.yml" "$dir"
	echo "===> Comparing examples documentation in $dir"
	if [ ! -z "$(diff -q "$dir/README.md" "$dir/README-generated.md")" ]; then
		echo "==> examples/$dir/README.md is out of date. Run 'make pre-commit' to update the generated document and commit."
		rm -f "$dir/README-generated.md"
		exit 1
	fi
	rm -f "$dir/README-generated.md"
}

echo "==> Generating..."
cp README.md README-generated.md

rm -f .terraform.lock.hcl
terraform-docs -c .terraform-docs.yml .

echo "==> Comparing generated code to committed code..."
if [ ! -z "$(diff -q README.md README-generated.md)" ]; then
		echo "==> README.md is out of date. Run 'make pre-commit' to update the generated document and commit."
		rm -f README-generated.md
		exit 1
fi

cd examples
subexamples=$(find ./ -maxdepth 1 -mindepth 1 -type d)
for d in $subexamples; do
  check_example_docs $d
done
cd ..

rm -f README-generated.md
