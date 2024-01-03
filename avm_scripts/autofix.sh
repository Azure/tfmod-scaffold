#!/usr/bin/env bash
avmfix -folder "$(pwd)"

examples=$(find ./examples -maxdepth 1 -mindepth 1 -type d)
for d in $examples; do
  echo "===> Autofix in " $d && cd $d && avmfix -folder "examples/$(pwd)"
done
exit 0
