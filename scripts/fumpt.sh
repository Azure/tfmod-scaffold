echo "==> Fixing source code with Gofumpt..."
find . -name '*.go' | grep -v vendor | xargs gofumpt -w