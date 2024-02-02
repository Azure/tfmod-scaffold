#!/usr/bin/env bash
default_branch=$(curl -s "https://api.github.com/repos/$GITHUB_REPOSITORY" | jq -r '.default_branch')
git checkout https://avmbot:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY workspace
cd workspace
avm yor-tag
avm pre-commit
avm autofix
avm pr-check
git commit -am "Auto update"
git push -u origin $default_branch