#!/usr/bin/env bash

if [ -z "${TFLINT_CONFIG}" ]; then
	export TFLINT_CONFIG="./tflint.hcl"
fi

# Check gofmt
echo "==> Checking that code complies with tflint requirements..."
tflint --init --config=$TFLINT_CONFIG
files=$(find * -maxdepth 1 -type f -name "*.tf" | grep -v ".terraform")
error=false
for f in $files; do
  tflint  --config=$TFLINT_CONFIG "$f" || error=true
done
if ${error}; then
  echo "------------------------------------------------"
  echo ""
  echo "The preceding files contain terraform blocks that does not complies with tflint requirements."
  echo ""
  exit 1
fi

if [ ! -d "examples" ]; then
	echo "===> No examples folder, skip lint example code"
	exit 0
fi

cd examples
files=$(find * -type f -name "*.tf" | grep -v ".terraform")
error=false
for f in $files; do
  tflint --config=../$TFLINT_CONFIG --disable-rule=terraform_documented_outputs --disable-rule=terraform_documented_variables "$f" || error=true
done
if ${error}; then
  echo "------------------------------------------------"
  echo ""
  echo "The preceding files contain terraform blocks that does not complies with tflint requirements."
  echo ""
  exit 1
fi
exit 0