#!/usr/bin/env bash
if [ ! -d "./test" ]; then
    echo "No test folder, skip deps-ensure"
    exit 0
fi
cd ./test
rm -rf vendor
go mod tidy
go mod vendor