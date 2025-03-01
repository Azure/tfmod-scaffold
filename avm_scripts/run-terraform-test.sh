#!/usr/bin/env bash
set -euo pipefail

# if $1 is not set, exit
if [ -z "$1" ]; then
  echo "Usage: $0 <test-directory-in-tests>"
  exit 1
fi

TESTDIR="tests/$1"

# if testdir dir does not exist, exit
if [ ! -d "$TESTDIR" ]; then
    echo "tests/$1 directory does not exist"
    exit 0
fi

echo "==> Copy module to temp dir..."
RND="$RANDOM"
TMPDIR="/tmp/avmtester$RND"
cp -r "$(pwd)" "$TMPDIR"
cd "$TMPDIR"

# clean up terraform files
find -type d -name .terraform -print0 | xargs -0 rm -rf
find -type f -name .terraform.lock.hcl -print0 | xargs -0 rm -rf
find -type f -name 'terraform.tfstate*' -print0 | xargs -0 rm -rf

echo "==> Running terraform test in $TESTDIR..."

terraform init -test-directory="$TESTDIR"
terraform test -test-directory="$TESTDIR"
