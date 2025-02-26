#!/usr/bin/env bash

# if tests/unit dir does not exist, exit
if [ ! -d "tests/unit" ]; then
    echo "tests/unit directory does not exist"
    exit 1
fi

terraform init -test-directory=test/unit
terraform test -test-directory=test/unit
