#!/usr/bin/env bash

export TF_VAR_msi_id=$MSI_ID

if [ -z "$AVM_EXAMPLE" ]; then
  echo "AVM_EXAMPLE is not set"
  exit 1
fi

if [ -z "$AVM_MOD_PATH" ]; then
  export AVM_MOD_PATH="$(pwd)"
fi

if [ -z "${TEST_TIMEOUT}" ]; then
  export TEST_TIMEOUT=720m
fi

# If examples directory does not exist then quit
if [ ! -d "$AVM_MOD_PATH/examples/$AVM_EXAMPLE" ]; then
  echo "No $AVM_EXAMPLE directory found in $AVM_MOD_PATH/examples"
  exit 0
fi

echo "==> Running e2e tests for $example"
cd /tmp
testFolder="avmtester$AVM_EXAMPLE$RANDOM"
git clone https://github.com/Azure/avmtester.git $testFolder && cd $testFolder
go mod tidy
echo "==> go test"
echo "$TEST_TIMEOUT"
terraform version
go test -v -timeout="$TEST_TIMEOUT" -run TestExample --
cd /tmp
rm -rf "$testFolder"
