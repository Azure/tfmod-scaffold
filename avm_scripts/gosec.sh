#!/usr/bin/env bash
@echo "==> Checking go code with gosec..."
if [ ! -d "test/upgrade" ]; then
  echo "No upgrade test directory yet, skip gosec"
  exit 0
fi
set -e
cd ./test/upgrade
gosec -tests ./...