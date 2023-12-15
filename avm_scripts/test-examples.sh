#!/usr/bin/env bash

cd /tmp
testFolder="avmtester$RANDOM"

git clone git clone git@github.com:Azure/avmtester.git $testFolder && cd $testFolder
go mod tidy
if [ -z "${TEST_TIMEOUT}" ]; then
    export TEST_TIMEOUT=720m
fi
echo "==> go test"
echo $TEST_TIMEOUT
terraform version
go test -v -timeout=$TEST_TIMEOUT -run TestExamples --
