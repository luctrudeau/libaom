#!/bin/bash
# ../findFails | grep -v VALGRIND | awk '{ print $2, $3;}' | \
#   xargs -n 2 -P 10 ../buildAndBisect.sh
console=$1
test=$2

run_path=$(realpath $(dirname $0))
dir=bisect.$console.${test//\//_}
mkdir $dir
cd $dir

$run_path/buildScriptFromLog ../$console $test run_test run_test.log
$run_path/bisectScript run_test ./res.log

