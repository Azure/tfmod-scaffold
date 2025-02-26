#!/usr/bin/env bash

# if TESTTYPE or $1 is not set, exit
if [ -z "$TESTTYPE" ]; then
  if [ -z "$1" ]; then
    echo "Usage: $0 <test-directory-in-tests>"
    exit 1
  fi
  TESTTYPE="$1"
fi

TESTDIR="tests/$TESTTYPE"

# if testdir dir does not exist, exit
if [ ! -d "$TESTDIR" ]; then
    echo "tests/$1 directory does not exist"
    exit 1
fi

terraform init -test-directory="$TESTDIR"
terraform test -test-directory="$TESTDIR"
