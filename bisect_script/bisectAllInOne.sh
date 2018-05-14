#!/bin/bash

toolsdir=$(readlink -e $(dirname "$0"))

mkdir -p bisectResults
rm -fr bisectResults/*
pushd bisectResults

# Get logs
$toolsdir/getNewestLogs
# Find Fails
$toolsdir/findFails > findFails.log
# buildAnd Bisect
cat findFails.log | awk  '{ print $2, $3;}' | xargs -n 2 -P 10 $toolsdir/buildAndBisect.sh

popd

