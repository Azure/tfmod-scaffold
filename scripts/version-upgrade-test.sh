#!/usr/bin/env bash
echo "==> Running Module Version Upgrade Tests..."
set -e
if [ -z "$PREVIOUS_MAJOR_VERSION" ]; then
    export PREVIOUS_MAJOR_VERSION=$(ls | grep CHANGELOG |  cut -d'-' -f 2 | cut -f 1 -d '.' |  grep v | sort -V -r | head -n 1)
fi
if [ ! -d "test/upgrade" ]; then
  echo "No version-upgrade test directory yet, skip test"
  exit 0
fi
cd ./test/upgrade
go mod tidy
go mod vendor
echo "==> Executing go test"
go test -v -p=1 -timeout=240m ./...