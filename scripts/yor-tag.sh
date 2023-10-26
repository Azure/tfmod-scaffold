#!/usr/bin/env bash

tracing_tags_enabled=$(hclgrep -x 'variable "tracing_tags_enabled" {@*_}' variables.tf)
tracing_tags_prefix=$(hclgrep -x 'variable "tracing_tags_prefix" {@*_}' variables.tf)

if [ -z "$tracing_tags_enabled" ] || [ -z "$tracing_tags_prefix" ]; then
    echo "==> No tracing_tags_enabled or tracing_tags_prefix variable found, skip tagging"
    exit 0
fi

if [ -f "module_telemetry.tf" ]; then
	cat module_telemetry.tf | hcledit attribute rm resource.modtm_telemetry.this.nonce | hcledit attribute append resource.modtm_telemetry.this.nonce $RANDOM | tee module_telemetry.tf.bak
	cat module_telemetry.tf.bak > module_telemetry.tf
	rm module_telemetry.tf.bak
	make autofix
	git add module_telemetry.tf
  git commit --author="github-actions[bot] <>" -m "Auto update for yor tags"
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
yorbox -dir "$(pwd)" -tagsPrefix avm_ -toggleName tracing_tags_enabled -ignoreResourceType modtm_telemetry --boxTemplate '/*<box>*/ (var.{{ .toggleName }} ? { for k,v in /*</box>*/ { yor_trace = 123 } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {} ) /*</box>*/'