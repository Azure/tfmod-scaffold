#!/usr/bin/env bash
echo "==> Checking test go code against linters..."
if [ ! -d "tests/upgrade" ]; then
  echo "No upgrade tests directory yet, skip golangci-lint"
  exit 0
fi
cd ./tests/upgrade
go mod tidy
echo "run golangci-lint ..."
golangci-lint run --timeout 1h ./...