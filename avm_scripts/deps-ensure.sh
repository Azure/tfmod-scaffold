#!/usr/bin/env bash
if [ ! -d "./test/upgrade" ]; then
    echo "No test/upgrade folder, skip deps-ensure"
    exit 0
fi
cd ./test/upgrade
rm -rf vendor
go mod tidy