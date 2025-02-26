#!/usr/bin/env bash

export TF_VAR_msi_id=$MSI_ID

# if $AVM_MOD_PATH and $AVM_EXAMPLE are not set, exit
if [ -z "$AVM_MOD_PATH" ] || [ -z "$AVM_EXAMPLE" ]; then
    echo "AVM_MOD_PATH and AVM_EXAMPLE must be set"
    exit 1
fi

# change dir into $AVM_MOD_PATH/examples/$AVM_EXAMPLE
# then run pre.sh if it exists
cd "$AVM_MOD_PATH/examples/$AVM_EXAMPLE"
if [ -f pre.sh ]; then
    echo "==> Running pre.sh"
    chmod +x pre.sh
    ./pre.sh
fi

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

# change dir back into the example and run post.sh if it exists
cd "$AVM_MOD_PATH/examples/$AVM_EXAMPLE"
if [ -f post.sh ]; then
    echo "==> Running post.sh"
    chmod +x ./post.sh
    ./post.sh
fi
