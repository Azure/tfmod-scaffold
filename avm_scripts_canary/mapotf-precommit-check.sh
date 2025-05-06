#!/usr/bin/env bash
set -e

# Ensure git working directory is clean
if [[ -n $(git status --porcelain) ]]; then
  echo "Error: Git working directory must be clean before running this check."
  exit 1
fi

make mapotf-precommit

# Check if any files changed
if [[ -n $(git status --porcelain) ]]; then
  echo "Error: Terraform code has not been transformed by mapotf. Please run 'make pre-commit' and commit the changes."
  git --no-pager diff
  exit 1
fi