#!/usr/bin/env bash

set_tflint_config() {
  local env_var=$1
  local override_file=$2
  local default_url=$3
  local download_file=$4
  local merged_file=$5

  # Always download the file from GitHub
  curl -H 'Cache-Control: no-cache, no-store' -sSL "$default_url" -o "$download_file"

  # Check if the override file exists
  if [ -f "$override_file" ]; then
    # If it does, merge the override file and the downloaded file
    hclmerge -1 "$override_file" -2 "$download_file" -d "$merged_file"
    # Set the environment variable to the path of the merged file
    export $env_var="$merged_file"
  else
    # If it doesn't, set the environment variable to the path of the downloaded file
    export $env_var="$download_file"
  fi
}

set_tflint_config "TFLINT_CONFIG" ".tflint.override.hcl" "https://raw.githubusercontent.com/Azure/tfmod-scaffold/main/.tflint.hcl" ".tflint.hcl" ".tflint.merged.hcl"
set_tflint_config "TFLINT_EXAMPLE_CONFIG" ".tflint_example.override.hcl" "https://raw.githubusercontent.com/Azure/tfmod-scaffold/main/.tflint_example.hcl" ".tflint_example.hcl" ".tflint_example.merged.hcl"


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