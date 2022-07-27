#!/usr/bin/env bash

find . -name '*.go' | grep -v vendor | while read f; do bash -c "scripts/goimport-file.sh $f" && git diff --exit-code -- $f || \
                                                                  (echo; echo "Unexpected difference in $f. Run 'make goimports' command or revert any go.mod/go.sum changes and commit."; exit 1); done