#!/usr/bin/bash

set -e
sh scaffold-ci-scripts/sync-tflint-plugin-version.sh
git update-index --refresh