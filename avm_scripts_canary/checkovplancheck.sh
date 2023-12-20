#!/usr/bin/env bash
if [ ! -z "$SKIP_CHECKOV" ]; then
    echo "Skipping Checkov check."
    exit 0
fi

echo "==> Checking examples terraform plan by checkov..."
examples=$(find ./examples -maxdepth 1 -mindepth 1 -type d)
for d in $examples; do
  echo "===> Check tfplan in " $d
  (cd $d && rm -f .terraform.lock.hcl && terraform init -upgrade && terraform plan --out tfplan.binary && terraform show -json tfplan.binary > tfplan.json && checkov --quiet -f tfplan.json) || error=true
  if ${error}; then
     echo "------------------------------------------------"
     echo ""
     echo "Checkov found issues in " $d
     echo ""
     exit 1
  fi
done
exit 0