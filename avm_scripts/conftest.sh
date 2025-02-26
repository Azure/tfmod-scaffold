#!/usr/bin/env bash

set -e

has_error=false

if [ ! -d "examples" ]; then
  echo "No \`examples\` folder found."
  exit 0
fi

cd examples

for d in $(find . -maxdepth 1 -mindepth 1 -type d); do
  if ls "$d"/*.tf > /dev/null 2>&1; then
    cd "$d"
    echo "==> Checking $d"

    if [ -f ".e2eignore" ]; then
      echo "==> Skipping $d due to .e2eignore file"
      cd - >/dev/null 2>&1
      continue
    fi

    echo "==> Initializing Terraform..."
    terraform init -input=false
    echo "==> Running Terraform plan..."
    terraform plan -input=false -out=tfplan.binary
    echo "==> Converting Terraform plan to JSON..."
    terraform show -json tfplan.binary > tfplan.json

    if [ -d "exceptions" ]; then
      conftest test --all-namespaces --update git::https://github.com/lonegunmanb/policy-library-avmrego.git//policy/Azure-Proactive-Resiliency-Library-v2 -p policy -p exceptions tfplan.json || has_error=true
    else
      conftest test --all-namespaces --update git::https://github.com/lonegunmanb/policy-library-avmrego.git//policy/Azure-Proactive-Resiliency-Library-v2 tfplan.json || has_error=true
    fi

    cd - >/dev/null 2>&1
  fi
done

cd ..

if [ "$has_error" = true ]; then
  echo "At least one \`examples\` folder failed."
  exit 1
fi

echo "All \`examples\` folders passed."
exit 0