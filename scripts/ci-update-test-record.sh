#!/bin/bash
cd .git
sudo chmod -R a+rwX .
sudo find . -type d -exec chmod g+s '{}' +
cd ..
git config --global --add safe.directory '*'
sudo sh scripts/update-test-record.sh