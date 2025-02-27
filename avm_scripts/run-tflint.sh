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

set_tflint_config "TFLINT_CONFIG" "avm.tflint.override.hcl" "https://raw.githubusercontent.com/Azure/tfmod-scaffold/main/avm.tflint.hcl" "avm.tflint.hcl" "avm.tflint.merged.hcl"
set_tflint_config "TFLINT_MODULE_CONFIG" "avm.tflint_module.override.hcl" "https://raw.githubusercontent.com/Azure/tfmod-scaffold/main/avm.tflint_module.hcl" "avm.tflint_module.hcl" "avm.tflint_module.merged.hcl"
set_tflint_config "TFLINT_EXAMPLE_CONFIG" "avm.tflint_example.override.hcl" "https://raw.githubusercontent.com/Azure/tfmod-scaffold/main/avm.tflint_example.hcl" "avm.tflint_example.hcl" "avm.tflint_example.merged.hcl"

configPathRoot=$(pwd)/$TFLINT_CONFIG
configPathModule=$(pwd)/$TFLINT_MODULE_CONFIG
configPathExample=$(pwd)/$TFLINT_EXAMPLE_CONFIG

run_tflint () {
  local dir=$1
  local config=$2
  local moduleType=$3
  local currentDir=$(pwd)

  cd $dir

  echo "==> Running tflint for $moduleType $dir"

  tflint --init --config=$config
  tflint --config=$config --minimum-failure-severity=warning
  local result=$?

  cd $currentDir

  if [ $result -ne 0 ]; then
    echo "------------------------------------------------"
    echo ""
    echo "The $moduleType $dir contains terraform blocks that do not comply with tflint requirements."
    echo ""
    return 1
  fi

  return 0
}

set -eo pipefail
echo "==> Copy module to temp dir..."
RND="$RANDOM"
TMPDIR="/tmp/avmtester$RND"
cp -r . "$TMPDIR"
cd "$TMPDIR"

# clean up terraform files
find -type d -name .terraform -print0 | xargs -0 rm -rf
find -type f -name .terraform.lock.hcl -print0 | xargs -0 rm -rf
find -type f -name 'terraform.tfstate*' -print0 | xargs -0 rm -rf
set +eo pipefail

has_error=false

echo "==> Checking that root module complies with tflint requirements..."
run_tflint . $configPathRoot "root module"
result=$?
if [ $result -ne 0 ]; then
  has_error=true
fi

echo "==> Checking that sub modules comply with tflint requirements..."
if [ ! -d "modules" ]; then
	echo "===> No modules folder, skip lint module code"
else
  cd modules
  dirs=$(find . -maxdepth 1 -mindepth 1 -type d)

  for d in $dirs; do
    run_tflint $d $configPathModule "sub module"
    result=$?
    if [ $result -ne 0 ]; then
      has_error=true
    fi
  done

  cd ..
fi

echo "==> Checking that examples comply with tflint requirements..."
if [ ! -d "examples" ]; then
	echo "===> No examples folder, skip lint example code"
else
  cd examples
  dirs=$(find . -maxdepth 1 -mindepth 1 -type d)

  for d in $dirs; do
    run_tflint $d $configPathExample "example"
    result=$?
    if [ $result -ne 0 ]; then
      has_error=true
    fi
  done

  cd ..
fi

if ${has_error}; then
  echo "------------------------------------------------"
  echo ""
  echo "The preceding files contain terraform blocks that do not comply with tflint requirements."
  echo ""
  exit 1
fi

exit 0
