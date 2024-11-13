#!/usr/bin/env bash
set -e

generate_docs () {
  local dir=$1
  if ! ls "$dir"/*.tf "$dir"/*.tf.json 1> /dev/null 2>&1; then
    echo "===> Skipping $dir as it contains no .tf or .tf.json files"
    return
  fi
  echo "===> Generating documentation in $dir"
  rm -f "$dir/.terraform.lock.hcl"
  terraform-docs -c ".terraform-docs.yml" "$dir"
}

echo "==> Generating root module documentation..."
generate_docs .

echo "==> Generating examples documentation..."
if [ ! -d examples ]; then
  echo "==> Error - no examples directory found"
  exit 1
fi
cd examples
subfolders=$(find ./ -maxdepth 1 -mindepth 1 -type d)
for d in $subfolders; do
  generate_docs $d
done
cd ..

echo "==> Generating sub modules documentation..."
if [ ! -d modules ]; then
  echo "==> Warning - no modules directory found"
else
  cd modules
  subfolders=$(find ./ -maxdepth 1 -mindepth 1 -type d)
  for d in $subfolders; do
    generate_docs $d
  done
  cd ..
fi