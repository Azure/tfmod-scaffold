#!/usr/bin/env bash
if [ ! -z "$SKIP_CHECKOV" ]; then
    echo "Skipping Checkov check."
    exit 0
fi

echo "==> Checking Terraform code with BridgeCrew Checkov"
if [ ! -z "$CHECKOV_CONFIG" ]; then
	checkov --config-file $CHECKOV_CONFIG
else
	checkov --skip-framework dockerfile --skip-check CKV_GHA_3 --quiet -d ./
fi