#!/usr/bin/env bash
echo "==> Fixing source code with Gofumpt..."
if [ ! -d "tests/upgrade" ]; then
  echo "No upgrade tests directory yet, skip Gofumpt"
  exit 0
fi
set -e
cd ./tests/upgrade
files=$(find . -name '*.go' | grep -v vendor); if [ -n "$files" ]; then echo "skip" | xargs gofumpt -w; fi