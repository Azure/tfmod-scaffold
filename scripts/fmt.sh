echo "==> Fixing source code with gofmt..."
find . -name '*.go' | grep -v vendor | xargs gofmt -s -w