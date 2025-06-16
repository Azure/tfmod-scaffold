#!/usr/bin/env bash
set -e

MPTF_DIR=${MPTF_DIR:-git::https://github.com/Azure/tfmod-scaffold.git//avm_mapotf/pre_commit}

mapotf transform --mptf-dir $MPTF_DIR --tf-dir .
avmfix -folder .
mapotf clean-backup --tf-dir .
