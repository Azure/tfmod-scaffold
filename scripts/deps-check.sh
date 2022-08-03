#!/usr/bin/env bash
if [ ! -d "./test" ]; then
    echo "No test folder, skip deps-ensure"
    exit 0
fi
cd ./test
echo "==> Checking source code with go mod tidy..."
cp go.mod go_mod
cp go.sum go_sum
go mod tidy
echo "==> Checking source code with go mod vendor..."
go mod vendor
diff -q go.mod go_mod || \
  (echo; echo "Unexpected difference in go.mod. Run 'make depsensure' to update the generated document and commit."; rm go_mod go_sum;exit 1)
diff -q go.sum go_sum || \
  (echo; echo "Unexpected difference in go.sum. Run 'make depsensure' to update the generated document and commit."; rm go_mod go_sum;exit 1)

rm go_mod go_sum