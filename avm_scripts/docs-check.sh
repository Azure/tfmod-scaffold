#!/usr/bin/env bash

check_docs () {
  local dir=$1
  echo "===> Generating documentation in $dir"
	cp "$dir/README.md" "$dir/README-generated.md"
  rm -f "$dir/.terraform.lock.hcl"
  terraform-docs -c ".terraform-docs.yml" "$dir"
	echo "===> Comparing documentation in $dir"
	if [ ! -z "$(diff -q "$dir/README.md" "$dir/README-generated.md")" ]; then
		echo "==> $dir/README.md is out of date. Run 'make pre-commit' to update the generated document and commit."
		mv -f "$dir/README-generated.md" "$dir/README.md"
		exit 1
	fi
	rm -f "$dir/README-generated.md"
}

echo "==> Checking root module documentation..."
check_docs .

echo "==> Checking examples documentation..."
if [ ! -d examples ]; then
  echo "==> Error - no examples directory found"
  exit 1
fi
cd examples
subfolders=$(find ./ -maxdepth 1 -mindepth 1 -type d)
for d in $subfolders; do
  check_docs $d
done
cd ..

echo "==> Checking sub modules documentation..."
if [ ! -d modules ]; then
  echo "==> Warning - no modules directory found"
else
	cd modules
	subfolders=$(find ./ -maxdepth 1 -mindepth 1 -type d)
	for d in $subfolders; do
	check_docs $d
	done
	cd ..
fi