#!/bin/bash
ROOT=$(mktemp -d --tmpdir electron-deb.XXXXXX)

cp -R platform/linux/* "$ROOT"
mkdir -p "$ROOT/opt/electron-example/"
cp -R "app/" "package.json" "$ROOT/opt/electron-example/"

mkdir -p "dist"
fpm -s dir -t ${1-deb} \
    -n "electron-example" \
    -v "1.0.0" \
    -a "noarch" \
    -d "electron (> 0.36)" \
    -p "dist" \
    -C $ROOT .
