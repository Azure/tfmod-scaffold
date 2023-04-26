#!/usr/bin/env bash

tracing_tags_enabled=$(hclgrep -x 'variable tracing_tags_enabled {@*_}')

if [ -z "$tracing_tags_enabled" ]; then
    echo "==> No tracing_tags_enabled variable found, skip tagging"
    exit 0
fi

error=false
yor tag -d "$(pwd)" --skip-dirs "$(pwd)/examples" --skip-tags git_last_modified_by,git_modifiers --tag-prefix avm_ --parsers Terraform || error=true
if ${error}; then
  echo "------------------------------------------------"
  echo ""
  echo "The preceding files contain terraform blocks that does not complies with yor requirements."
  echo ""
  exit 1
fi
yorbox -dir "$(pwd)" -tagsPrefix avm_ -toggleName tracing_tags_enabled