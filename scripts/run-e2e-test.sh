#!/usr/bin/env bash
echo "==> Running E2E Tests..."
set -e
cd ./test/e2e
go mod tidy
go mod vendor
if [ -z "${TEST_TIMEOUT}" ]; then
    export TEST_TIMEOUT=720m
fi
echo "==> go test"
echo $TEST_TIMEOUT
terraform version
go test -v -timeout=$TEST_TIMEOUT ./...