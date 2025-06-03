#!/usr/bin/env bash
set -e

# Ensure git working directory is clean
if [[ -n $(git status --porcelain) ]]; then
  echo "git status shows uncommitted changes. Please commit or stash them before running this script."
  exit 1
fi

make grept-precommit

# Check if any files changed
if [[ -n $(git status --porcelain) ]]; then
  echo "Error: Repository has not been synchronized. Please run 'make pre-commit' and commit the changes."
  git --no-pager diff
  exit 1
fi