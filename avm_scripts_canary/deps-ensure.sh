#!/usr/bin/env bash
if [ ! -d "./tests/upgrade" ]; then
    echo "No tests/upgrade folder, skip deps-ensure"
    exit 0
fi
cd ./tests/upgrade || exit
rm -rf vendor
go mod tidy