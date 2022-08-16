#!/usr/bin/env bash
echo "==> Validating module terraform codes..."
error=false
(terraform init -upgrade && terraform validate -json | jq -e .valid) || error=true
echo "==> Checking examples terraform codes are validate..."
examples=$(find ./examples -maxdepth 1 -mindepth 1 -type d)
for d in $examples; do
  (echo "===> Terraform validating in " $d && cd $d && rm -f .terraform.lock.hcl && terraform init -upgrade && terraform validate -json | jq -e .valid) || error=true
  if ${error}; then
     echo "------------------------------------------------"
     echo ""
     echo "Some Terraform codes contain errors."
     echo "$(cd $d && terraform validate -json)"
     echo ""
     exit 1
  fi
done
exit 0
