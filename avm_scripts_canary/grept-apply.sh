#!/usr/bin/env bash
echo "==> Checking code repository with grept against git::https://github.com/Azure/Azure-Verified-Modules-Grept.git//terraform ..."
grept apply -a git::https://github.com/Azure/Azure-Verified-Modules-Grept.git//terraform