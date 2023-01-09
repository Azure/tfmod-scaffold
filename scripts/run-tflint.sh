#!/usr/bin/env bash

if [ -f ".tflint_alt.hcl" ]; then
	export TFLINT_CONFIG=".tflint_alt.hcl"
elif [ -z "${TFLINT_CONFIG}" ]; then
	export TFLINT_CONFIG=".tflint.hcl"
fi

if [ -f ".tflint_example_alt.hcl" ]; then
	export TFLINT_EXAMPLE_CONFIG=".tflint_example_alt.hcl"
elif [ -z "${TFLINT_EXAMPLE_CONFIG}" ]; then
	export TFLINT_EXAMPLE_CONFIG=".tflint_example.hcl"
fi

echo "==> Checking that code complies with tflint requirements..."
tflint --init --config=$TFLINT_CONFIG
files=$(find * -maxdepth 0 -type f -name "*.tf" | grep -v ".terraform")
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
tflint --init --config=../$TFLINT_EXAMPLE_CONFIG
for f in $files; do
  tflint --config=../$TFLINT_EXAMPLE_CONFIG "$f" || error=true
done
if ${error}; then
  echo "------------------------------------------------"
  echo ""
  echo "The preceding files contain terraform blocks that does not complies with tflint requirements."
  echo ""
  exit 1
fi
exit 0