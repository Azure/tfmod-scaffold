#!/bin/bash
docker run --rm -v $(pwd):/src -w /src -u $(id -u ${USER}):$(id -g ${USER}) mcr.microsoft.com/azterraform sh scripts/update-test-record.sh