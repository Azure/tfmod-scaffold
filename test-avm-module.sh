#!/bin/bash
set -e

# Script to test an AVM module
# Usage: bash test-avm.sh REPO_URL FOLDER_NAME [DOCKER_IMAGE]
# Example: bash test-avm.sh https://github.com/Azure/terraform-azurerm-avm-res-keyvault-vault.git terraform-azurerm-avm-res-keyvault-vault localrunner_avm
# If DOCKER_IMAGE is not provided, it defaults to localrunner_avm

# Check if required arguments are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 REPO_URL FOLDER_NAME [DOCKER_IMAGE]"
    exit 1
fi

REPO_URL="$1"
FOLDER_NAME="$2"
DOCKER_IMAGE="${3:-localrunner_avm}"  # Use third parameter if provided, otherwise default to localrunner_avm
TEMP_DIR="/tmp/${FOLDER_NAME}"

echo "===== Testing AVM module: $FOLDER_NAME ====="
echo "Using Docker image: $DOCKER_IMAGE"

# Remove existing directory if it exists
if [ -d "$TEMP_DIR" ]; then
    echo "Removing existing directory: $TEMP_DIR"
    rm -rf "$TEMP_DIR"
fi

# Clone repository
echo "Cloning $REPO_URL to $TEMP_DIR"
git clone "$REPO_URL" "$TEMP_DIR" || { echo "Failed to clone $REPO_URL"; exit 1; }

# Run pre-commit check
echo "Running pre-commit check"
docker run --rm -v "$(pwd):/scaffold" -e AVM_IN_CONTAINER=1 -e LOCAL_SCRIPT="/scaffold/avm_scripts" -e MPTF_DIR="/scaffold/avm_mapotf" -v "$TEMP_DIR:/src" -w /src "$DOCKER_IMAGE" bash -c 'make grept-precommit && ./avm pre-commit && git add -A && git commit -am "test" && ./avm pr-check' || { echo "pre-commit failed"; exit 1; }
