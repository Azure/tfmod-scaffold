#!/usr/bin/env bash
echo "==> Fixing source code with Gofumpt..."
set -e
files=$(find . -name '*.go' | grep -v vendor); if [ -n "$files" ]; then echo "skip" | xargs gofumpt -w; fi