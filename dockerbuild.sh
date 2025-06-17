#!/usr/bin/env bash

set -e

CONTAINER_RUNTIME=${CONTAINER_RUNTIME:-docker}

if [ ! "$(command -v "$CONTAINER_RUNTIME")" ]; then
    echo "Error: $CONTAINER_RUNTIME is not installed. Please install $CONTAINER_RUNTIME first."
    exit 1
fi

cat Dockerfile.build Dockerfile.azterraform > Dockerfile_azterraform
cat Dockerfile.build Dockerfile.avm > Dockerfile_avm

$CONTAINER_RUNTIME build $(sh build-arg-helper.sh version.env) --build-arg TARGETARCH=amd64 -f Dockerfile_azterraform -t localrunner .
$CONTAINER_RUNTIME build $(sh build-arg-helper.sh version.env) --build-arg TARGETARCH=amd64 -f Dockerfile_avm -t localrunner_avm .
