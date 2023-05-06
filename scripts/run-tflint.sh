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
error=false
tflint --config=$TFLINT_CONFIG --chdir=$(pwd)/ || error=true
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
dirs=$(find . -maxdepth 1 -mindepth 1 -type d)
has_error=false
tflint --init --config=$(pwd)/../$TFLINT_EXAMPLE_CONFIG
for d in $dirs; do
  error=false
  tflint --config=$(pwd)/../$TFLINT_EXAMPLE_CONFIG --chdir=$(pwd)/./$d || error=true
  if ${error}; then
    has_error=true
    echo "------------------------------------------------"
    echo ""
    echo "The $d contain terraform blocks that does not complies with tflint requirements."
    echo ""
  fi
done
if ${has_error}; then
  exit 1
fi
exit 0