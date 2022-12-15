#!/bin/bash
export BRANCH=${1:-main}
export GITHUB_REPO="https://github.com/Azure/tfmod-scaffold.git"
echo "cleanup"
make cleanup
echo "Cloning tfmod-scaffold"
git clone -q -c advice.detachedHead=false --depth=1 -b $BRANCH $GITHUB_REPO
ln -s tfmod-scaffold/scripts scripts
cp -r tfmod-scaffold/.tflint.hcl .tflint.hcl
cp -r tfmod-scaffold/.tflint_example.hcl .tflint_example.hcl
echo "init"
make init