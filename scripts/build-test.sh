#!/usr/bin/env bash
echo "==> Build Test for CodeQL..."
cd ./test
go mod tidy
go mod vendor
go build ./...