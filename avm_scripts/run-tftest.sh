#!/usr/bin/env bash
set -e

echo "!!! WARNING !!!"
echo "Due to limitations in az cli's implementation on Windows vs Linux,"
echo "Terraform tests that require Azure authorization will not work."
echo "Please use Windows Subsystem for Linux (WSL) to run tests."
echo "!!! WARNING !!!"
echo

run_tests () {
  local dir=$1
  echo "==> Running tests in $dir"
  pushd $dir
  if [ ! -d tests ]; then
    echo "===> No tests directory found in $dir"
    popd
    return 0
  fi
  terraform init
  terraform test
  popd
}

run_tests .

echo "==> Running tests in submodules..."
if [ ! -d modules ]; then
  echo "==> No modules directory found - exiting"
  exit 0
fi
cd modules
subfolders=$(find ./ -maxdepth 1 -mindepth 1 -type d)
for d in $subfolders; do
  run_tests $d
done
cd ..
