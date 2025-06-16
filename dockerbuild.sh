#!/usr/bin/env bash

set -e

CONTAINER_RUNTIME=${CONTAINER_RUNTIME:-docker}

if [ ! "$(command -v "$CONTAINER_RUNTIME")" ]; then
    echo "Error: $CONTAINER_RUNTIME is not installed. Please install $CONTAINER_RUNTIME first."
    exit 1
fi

$CONTAINER_RUNTIME build $(sh build-arg-helper.sh version.env) -f Dockerfile_builder -t local_builder .
$CONTAINER_RUNTIME build $(sh build-arg-helper.sh version.env) -f Dockerfile -t localrunner .
$CONTAINER_RUNTIME build $(sh build-arg-helper.sh version.env) -f Dockerfile_avm -t localrunner_avm .