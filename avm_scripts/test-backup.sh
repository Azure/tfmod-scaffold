#!/usr/bin/env bash

echo "==> Cleaning terraform directories, state files and lock files..."
find -type d -name .terraform -print0 | while IFS= read -r -d '' dir; do
    cp -r "$dir" "$dir.avmbackup"
    rm -rf "$dir"
done
find -type f -name .terraform.lock.hcl -print0 | while IFS= read -r -d '' file; do
    cp "$file" "$file.avmbackup"
    rm -rf "$file"
done
find -type f -name 'terraform.tfstate*' -print0 | while IFS= read -r -d '' file; do
    cp "$file" "$file.avmbackup"
    rm -rf "$file"
done
exit 0
