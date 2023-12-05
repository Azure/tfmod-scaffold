#!/usr/bin/env bash
echo "==> Checking test go code against linters..."
cd ./tests/upgrade
go mod tidy
echo "run golangci-lint ..."
golangci-lint run --timeout 1h ./...