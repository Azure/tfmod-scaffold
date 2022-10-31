#!/usr/bin/env bash

tests=$(find ./test -maxdepth 1 -mindepth 1 -type d)
for d in $tests; do
  echo "===> go get -d in " $d && cd $d && go get -d
  cd /src
done

gosec -tests ./...