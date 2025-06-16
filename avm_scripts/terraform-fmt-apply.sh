#!/usr/bin/env bash
set -e

echo "==> Fixing Terraform code with terraform fmt..."
terraform fmt -recursive