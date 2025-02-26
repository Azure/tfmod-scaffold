#!/usr/bin/env bash

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

terraform init -test-directory="$TESTDIR"
terraform test -test-directory="$TESTDIR"
