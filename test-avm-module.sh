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

export WORKSPACE=$(pwd)
# Function to update the Makefile to use local version of avmmakefile
patch_makefile() {
    MAKEFILE="Makefile"
    # Check if file exists
    if [ ! -f "$MAKEFILE" ]; then
        echo "Error: $MAKEFILE not found"
        exit 1
    fi
    # Search pattern - escaping special characters for sed
    PATTERN="https:\/\/raw\.githubusercontent\.com\/Azure\/tfmod-scaffold\/main\/avmmakefile"

    # Comment out the line containing the pattern
    sed -i "/$PATTERN/s/^/#/" "$MAKEFILE"
    echo "Line downloading remote avmmakefile has been commented out"
    cp -vf $WORKSPACE/avmmakefile ./avmmakefile
    echo "avmmakefile replaced with pr version"
}

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
export SCAFFOLD=$(pwd)
export LOCAL_SCRIPT="$SCAFFOLD/avm_scripts"
export MPTF_DIR="$SCAFFOLD/avm_mapotf"
export AVM_IMAGE=$DOCKER_IMAGE
cd "$TEMP_DIR"

patch_makefile
# Run grept first in case `avm` file has been modified (changing avm script on the fly might cause transient errors, which could be ignored by simply rerun `./avm pre-commit` again)
make grept-precommit
patch_makefile
./avm pre-commit
patch_makefile
git add -A
git commit -am "test"
./avm pr-check
