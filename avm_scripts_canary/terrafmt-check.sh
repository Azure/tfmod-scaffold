#!/usr/bin/env bash
echo "==> Checking documentation terraform blocks are formatted..."
files=$(find . -type f -name "*.md" -o -name "*.go" | grep -v -e ".github" -e "-terraform" -e "vendor" -e ".terraform" -e "README.md")
error=false
for f in $files; do
  terrafmt diff -c -q "$f"
  retValue=$?
  if [ $retValue -ne 0 ] && [ $retValue -ne 2 ]; then
      error=true
  fi
done
if ${error}; then
  echo "------------------------------------------------"
  echo ""
  echo "The preceding files contain terraform blocks that are not correctly formatted or contain errors."
  echo "You can fix this by running make tools and then terrafmt on them."
  echo ""
  echo "to easily fix all terraform blocks:"
  echo "$ make terrafmt"
  echo ""
  exit 1
fi
exit 0