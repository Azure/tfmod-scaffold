#!/bin/bash
export BRANCH=${1:-main}
export GITHUB_REPO="https://github.com/lonegunmanb/tfmod-scaffold.git"

if [ -d "tfmod-scaffold" ]; then
  echo "Removing existing scaffold"
  rm -rf "tfmod-scaffold"
  rm -rf "scripts"
fi

echo "Cloning tfmod-scaffold"
git clone -c advice.detachedHead=false --depth=1 -b $BRANCH $GITHUB_REPO
ln -s tfmod-scaffold/scripts scripts
