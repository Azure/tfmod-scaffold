#!/usr/bin/env bash
echo "==> Checking test go code against linters..."
cd ./test
go mod tidy
go mod vendor
echo "run golangci-lint ..."
golangci-lint run --timeout 1h ./...