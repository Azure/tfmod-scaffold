#!/usr/bin/env bash
echo "==> Running Module Version Upgrade Tests..."
set -e
export PREVIOUS_MAJOR_VERSION=$(ls | grep CHANGELOG |  cut -d'-' -f 2 | cut -f 1 -d '.' |  grep v | sort -V -r | head -n 1)
cd ./test/upgrade
go mod tidy
echo "==> Executing go test"
go test -v -p=1 -timeout=120m ./...