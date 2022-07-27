#!/usr/bin/env bash
# Check gofmt
echo "==> Checking that code complies with gofumpt requirements..."
# This filter should match the search filter in ../GNUMakefile
gofmt_files=$(find . -name '*.go' | grep -v vendor | xargs gofumpt -l)
if [ -n "${gofmt_files}" ]; then
    echo 'gofumpt needs running on the following files:'
    echo "${gofmt_files}"
    echo "You can use the command: \`make fumpt\` to reformat code."
    exit 1
fi
exit 0