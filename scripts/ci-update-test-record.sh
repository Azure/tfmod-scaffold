#!/bin/bash
git config --global --add safe.directory '*'
docker run --rm -v $(pwd):/src -w /src mcr.microsoft.com/azterraform sh scripts/update-test-record.sh