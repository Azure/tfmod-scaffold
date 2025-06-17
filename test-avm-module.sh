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
docker run --rm -v "$(pwd):/scaffold" -e LOCAL_SCRIPT="/scaffold" -e MPTF_DIR="/scaffold/avm_mapotf" -v "$TEMP_DIR:/src" -w /src "$DOCKER_IMAGE" make pre-commit || { failed_tasks+=("commit check failed)"; exit 1; }

has_error=false
# Initialize array to collect failed tasks
failed_tasks=()
# Run PR check
echo "Running fmtcheck check"
docker run --rm -v "$(pwd):/scaffold" -e LOCAL_SCRIPT="/scaffold" -e MPTF_DIR="/scaffold/avm_mapotf" -v "$TEMP_DIR:/src" -w /src "$DOCKER_IMAGE" make fmtcheck || { failed_tasks+=("fmtcheck failed"); has_error=true; }

echo "Running docscheck check"
docker run --rm -v "$(pwd):/scaffold" -e LOCAL_SCRIPT="/scaffold" -e MPTF_DIR="/scaffold/avm_mapotf" -v "$TEMP_DIR:/src" -w /src "$DOCKER_IMAGE" make docscheck || { failed_tasks+=("docscheck failed"); has_error=true; }

echo "Running mapotf-precommit-check check"
docker run --rm -v "$(pwd):/scaffold" -e LOCAL_SCRIPT="/scaffold" -e MPTF_DIR="/scaffold/avm_mapotf" -v "$TEMP_DIR:/src" -w /src "$DOCKER_IMAGE" make mapotf-precommit-check || { failed_tasks+=("mapotf-precommit-check failed"); has_error=true; }

echo "Running grept-precommit-check check"
docker run --rm -v "$(pwd):/scaffold" -e LOCAL_SCRIPT="/scaffold" -e MPTF_DIR="/scaffold/avm_mapotf" -v "$TEMP_DIR:/src" -w /src "$DOCKER_IMAGE" make grept-precommit-check || { failed_tasks+=("grept-precommit-check failed"); has_error=true; }

echo "Running tfvalidatecheck check"
docker run --rm -v "$(pwd):/scaffold" -e LOCAL_SCRIPT="/scaffold" -e MPTF_DIR="/scaffold/avm_mapotf" -v "$TEMP_DIR:/src" -w /src "$DOCKER_IMAGE" make tfvalidatecheck || { failed_tasks+=("tfvalidatecheck failed"); has_error=true; }

echo "Running lint check"
docker run --rm -v "$(pwd):/scaffold" -e LOCAL_SCRIPT="/scaffold" -e MPTF_DIR="/scaffold/avm_mapotf" -v "$TEMP_DIR:/src" -w /src "$DOCKER_IMAGE" make lint || { failed_tasks+=("lint failed"); has_error=true; }

echo "Running unit-test check"
docker run --rm -v "$(pwd):/scaffold" -e LOCAL_SCRIPT="/scaffold" -e MPTF_DIR="/scaffold/avm_mapotf" -v "$TEMP_DIR:/src" -w /src "$DOCKER_IMAGE" make unit-test || { failed_tasks+=("unit-test failed"); has_error=true; }

echo "Running integration-test check"
docker run --rm -v "$(pwd):/scaffold" -e LOCAL_SCRIPT="/scaffold" -e MPTF_DIR="/scaffold/avm_mapotf" -v "$TEMP_DIR:/src" -w /src "$DOCKER_IMAGE" make integration-test || { failed_tasks+=("integration-test failed"); has_error=true; }

if [ "$has_error" = true ]; then
    echo "===== The following checks failed: ====="
    for task in "${failed_tasks[@]}"; do
        echo "- $task"
    done
    echo "Please review the output above for details."
    exit 1
fi

echo "===== Completed testing for $FOLDER_NAME ====="
exit 0