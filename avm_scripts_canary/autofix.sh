#!/usr/bin/env bash
avmfix -folder "$(pwd)"

examples=$(find ./examples -maxdepth 1 -mindepth 1 -type d)
for d in $examples; do
  echo "===> Autofix in $d" && avmfix -folder "$d"
done
exit 0
