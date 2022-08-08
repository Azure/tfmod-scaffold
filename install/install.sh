#!/bin/bash
export OWNER=${1:-lonegunmanb}
export PROJECT=${2:-tfmod-scaffold}
export BRANCH=${3:-main}
export GITHUB_REPO="https://github.com/${OWNER}/${PROJECT}.git"

echo "Removing existing scaffold"
rm -rf "tfmod-scaffold"

echo "Cloning tfmod-scaffold..."
git clone -c advice.detachedHead=false --depth=1 -b $BRANCH $GITHUB_REPO