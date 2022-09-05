#!/usr/bin/env bash
echo "==> Running E2E Tests..."
set -e
cd ./test/e2e
go mod tidy
go mod vendor
echo "==> go test"
go test -v -p=1 -timeout=240m ./...