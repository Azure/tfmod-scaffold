#!/bin/bash
git config --global --add safe.directory '*'
docker run --rm -v $(pwd):/src -w /src mcr.microsoft.com/azterraform sh scripts/update-test-record.sh

cd .git
sudo chmod -R a+rwX .
sudo find . -type d -exec chmod g+s '{}' +