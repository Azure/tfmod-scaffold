#!/usr/bin/env bash
echo "==> Checking go code with gosec..."
if [ ! -d "tests/upgrade" ]; then
  echo "No upgrade tests directory yet, skip gosec"
  exit 0
fi
set -e
cd ./tests/upgrade
gosec -tests ./...