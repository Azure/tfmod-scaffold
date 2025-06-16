echo "==> Fixing source code with gofmt..."
files=$(find . -name '*.go' | grep -v vendor); if [ -n "$files" ]; then echo $files | xargs gofmt -s -w; fi