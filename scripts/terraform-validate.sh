#!/usr/bin/env bash
echo "==> Validating module terraform codes..."
error=false
(terraform init -upgrade && terraform validate -json | jq -e .valid) || error=true
echo "==> Checking examples terraform codes are validate..."
examples=$(find ./examples -maxdepth 1 -mindepth 1 -type d)
for d in $examples; do
  (echo "===> Terraform validating in " $d && cd $d && rm -f .terraform.lock.hcl && terraform init -upgrade && terraform validate -json | jq -e .valid) || error=true
done
if ${error}; then
  echo "------------------------------------------------"
  echo ""
  echo "Some Terraform codes contain errors."
  echo ""
  exit 1
fi
exit 0