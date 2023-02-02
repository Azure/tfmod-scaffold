#!/usr/bin/env bash

if [ ! -d "TestRecord" ]; then
  echo "No TestRecord found, exit"
  exit 0
fi

cd TestRecord

folders=$(find ./ -maxdepth 1 -mindepth 1 -type d)
for f in $folders; do
  d=${f#"./"}

  if [ ! -f ../examples/$d/TestRecord.md ]; then
    touch ../examples/$d/TestRecord.md
  fi

  cat ../examples/$d/TestRecord.md >> $d/TestRecord.md.tmp
  cat $d/TestRecord.md.tmp > ../examples/$d/TestRecord.md
done

cd ..
git add **/TestRecord.md