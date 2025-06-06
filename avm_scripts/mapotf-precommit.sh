#!/usr/bin/env bash
set -e

mapotf transform --mptf-dir git::https://github.com/Azure/tfmod-scaffold.git//avm_mapotf/pre_commit --tf-dir .
avmfix -folder .
mapotf clean-backup --tf-dir .