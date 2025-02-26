#!/usr/bin/env bash

echo "==> Restoring terraform directories, state files and lock files..."
find -type d -name '.terraform.avmbackup' -print0 | while IFS= read -r -d '' dir; do
    original_dir="${dir%.avmbackup}"
    mv "$dir" "$original_dir"
    rm -rf "$dir"
done
find -type f -name '.terraform.lock.hcl.avmbackup' -print0 | while IFS= read -r -d '' file; do
    original_file="${file%.avmbackup}"
    mv "$file" "$original_file"
    rm -rf "$file"
done
find -type f -name 'terraform.tfstate*.avmbackup' -print0 | while IFS= read -r -d '' file; do
    original_file="${file%.avmbackup}"
    mv "$file" "$original_file"
    rm -rf "$file"
done
exit 0
