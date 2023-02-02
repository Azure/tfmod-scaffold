#!/bin/bash
docker run --rm -v $(pwd):/src -w /src mcr.microsoft.com/azterraform sh scripts/update-test-record.sh