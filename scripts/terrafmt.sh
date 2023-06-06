echo "==> Fixing test and document terraform blocks code with terrafmt..."

files=$(find . -type f -name "*.md" -o -name "*.go" | grep -v -e ".github" -e "-terraform" -e "vendor" -e ".terraform")
for f in $files; do
  terrafmt fmt -f "$f"
  retValue=$?
  if [ $retValue -ne 0 ] && [ $retValue -ne 2 ]; then
    echo "------------------------------------------------"
    echo ""
    echo "The preceding files contain terraform blocks that are not correctly formatted or contain errors."
    echo ""
    exit $retValue
  fi
done