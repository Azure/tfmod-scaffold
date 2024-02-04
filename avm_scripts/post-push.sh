#!/usr/bin/env bash
set -e

default_branch=$(curl -s "https://api.github.com/repos/$GITHUB_REPOSITORY" | jq -r '.default_branch')
git clone https://avmbot:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git workspace
cd workspace
make yor-tag
make pre-commit
make autofix
make pr-check

# Check if there are changes
if git diff --exit-code > /dev/null; then
    echo "No changes to commit"
    exit 0
fi

git commit -am "Auto update"
git push -u origin $default_branch