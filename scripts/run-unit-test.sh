#!/usr/bin/env bash
echo "==> Running Unit Tests..."
if [ ! -d "test/unit" ]; then
  echo "No unit test directory yet, skip test"
  exit 0
fi
set -e
cd ./test/unit
go mod tidy
go mod vendor
echo "==> unit test"
go test -v -p=1 -timeout=1m ./...