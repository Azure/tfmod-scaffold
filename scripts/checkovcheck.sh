#!/usr/bin/env bash
if [ ! -z "$SKIP_CHECKOV" ]; then
    echo "Skipping Checkov check."
    exit 0
fi

echo "==> Checking Terraform code with BridgeCrew Checkov"
if [ ! -z "$CHECKOV_CONFIG" ]; then
	checkov --config-file $CHECKOV_CONFIG
elif [ -f ".checkov_config.yaml" ]; then
	checkov --config-file .checkov_config.yaml
else
	checkov --skip-framework dockerfile kubernetes --skip-path test/vendor --skip-check CKV_GHA_3 --quiet -d ./
fi