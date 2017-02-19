#!/bin/bash
set -e

rootdir=$(dirname $0)
cd $rootdir

bindir=./node_modules/.bin

pulp build

$bindir/browserify index.js -s index | \
    $bindir/uglifyjs -  -c -m > handler.js

rm -f deploy.zip
zip deploy handler.js



