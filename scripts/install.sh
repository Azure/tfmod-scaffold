#!/bin/bash
export BRANCH=${1:-main}
export GITHUB_REPO="https://github.com/lonegunmanb/tfmod-scaffold.git"

if [ -d "tfmod-scaffold" ]; then
  echo "Removing existing scaffold"
  rm -rf "tfmod-scaffold"
  rm -rf "scripts"
fi

echo "Cloning tfmod-scaffold"
git clone -q -c advice.detachedHead=false --depth=1 -b $BRANCH $GITHUB_REPO
ln -s tfmod-scaffold/scripts scripts
if [ -z "${SKIP_INSTALL_GH_ACTION_WORKFLOW}" ]; then
  mkdir -p .github/workflows
  cp tfmod-scaffold/workflows/acc-test.yaml .github/workflows/acc-test.yaml
  cp tfmod-scaffold/workflows/pr-check.yaml .github/workflows/pr-check.yaml
else
	echo "Skip workflow installation"
fi