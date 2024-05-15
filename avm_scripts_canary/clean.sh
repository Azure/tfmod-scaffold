#!/usr/bin/env bash
echo "==> Cleaning terraform directories, state files and lock files..."
find -type d -name .terraform -print0 | xargs -0 rm -rf
find -type f -name .terraform.lock.hcl -print0 | xargs -0 rm -rf
find -type f -name 'terraform.tfstate*' -print0 | xargs -0 rm -rf
exit 0
