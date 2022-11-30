#!/usr/bin/env bash
echo "==> Build Test for CodeQL..."
cd ./test
rm -rf vendor
go mod tidy
go mod vendor
go build ./...