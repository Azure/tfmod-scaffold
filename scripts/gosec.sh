#!/usr/bin/env bash

tests=$(find ./test -maxdepth 1 -mindepth 1 -type d)
for d in $tests; do
  echo "===> go get -d in " $d && cd $d && go get -d
done

cd /src
gosec -tests ./...