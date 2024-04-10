#!/usr/bin/env bash
echo "==> Fixing source code with Gofumpt..."
set -e
find . -name '*.go' | grep -v vendor | xargs gofumpt -w