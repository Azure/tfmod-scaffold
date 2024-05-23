#!/usr/bin/env bash
avmfix -folder "$(pwd)"

examples=$(find ./examples -maxdepth 1 -mindepth 1 -type d)
for d in $examples; do
  echo "===> Autofix in $d" && avmfix -folder "$d"
done


if [ ! -d modules ]; then
  echo "==> Warning - no modules directory found"
else
  modules=$(find ./modules -maxdepth 1 -mindepth 1 -type d)
  for d in $modules; do
    echo "===> Autofix in $d" && avmfix -folder "$d"
  done
fi
exit 0
