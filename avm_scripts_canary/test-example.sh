#!/usr/bin/env bash

export TF_VAR_msi_id=$MSI_ID

cd /tmp
testFolder="avmtester$AVM_EXAMPLE$RANDOM"

git clone https://github.com/Azure/avmtester.git $testFolder && cd $testFolder
go mod tidy
if [ -z "${TEST_TIMEOUT}" ]; then
    export TEST_TIMEOUT=720m
fi
echo "==> go test"
echo $TEST_TIMEOUT
terraform version
go test -v -timeout=$TEST_TIMEOUT -run TestExample --
